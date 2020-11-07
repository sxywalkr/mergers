import 'dart:io';

import 'package:flutter/material.dart';
import 'package:noteapp/app_localizations.dart';

import 'package:noteapp/models/user_model.dart';
import 'package:noteapp/providers/auth_provider.dart';
import 'package:noteapp/routes.dart';
import 'package:noteapp/services/firestore_database.dart';
import 'package:provider/provider.dart';

import 'package:noteapp/models/penyedia_model.dart';
import 'package:noteapp/ui/home2/empty_content.dart';

import 'package:docx_template/docx_template.dart';
// import 'package:file_picker/file_picker.dart';

// import 'package:docx_template/src/template.dart';
// import 'package:docx_template/src/model.dart';

class Home2Screen extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void genDocx() async {
    final f = File("template.docx");
    final docx = await DocxTemplate.fromBytes(await f.readAsBytes());

    Content c = Content();
    c
      ..add(TextContent("docname", "Simple docname"))
      ..add(TextContent("passport", "Passport NE0323 4456673"))
      ..add(TableContent("table", [
        RowContent()
          ..add(TextContent("key1", "Paul"))
          ..add(TextContent("key2", "Viberg"))
          ..add(TextContent("key3", "Engineer")),
        RowContent()
          ..add(TextContent("key1", "Alex"))
          ..add(TextContent("key2", "Houser"))
          ..add(TextContent("key3", "CEO & Founder"))
          ..add(ListContent("tablelist", [
            TextContent("value", "Mercedes-Benz C-Class S205"),
            TextContent("value", "Lexus LX 570")
          ]))
      ]))
      ..add(ListContent("list", [
        TextContent("value", "Engine")
          ..add(ListContent("listnested", [
            TextContent("value", "BMW M30"),
            TextContent("value", "2GZ GE")
          ])),
        TextContent("value", "Gearbox"),
        TextContent("value", "Chassis")
      ]))
      ..add(ListContent("plainlist", [
        PlainContent("plainview")
          ..add(TableContent("table", [
            RowContent()
              ..add(TextContent("key1", "Paul"))
              ..add(TextContent("key2", "Viberg"))
              ..add(TextContent("key3", "Engineer")),
            RowContent()
              ..add(TextContent("key1", "Alex"))
              ..add(TextContent("key2", "Houser"))
              ..add(TextContent("key3", "CEO & Founder"))
              ..add(ListContent("tablelist", [
                TextContent("value", "Mercedes-Benz C-Class S205"),
                TextContent("value", "Lexus LX 570")
              ]))
          ])),
        PlainContent("plainview")
          ..add(TableContent("table", [
            RowContent()
              ..add(TextContent("key1", "Nathan"))
              ..add(TextContent("key2", "Anceaux"))
              ..add(TextContent("key3", "Music artist"))
              ..add(ListContent(
                  "tablelist", [TextContent("value", "Peugeot 508")])),
            RowContent()
              ..add(TextContent("key1", "Louis"))
              ..add(TextContent("key2", "Houplain"))
              ..add(TextContent("key3", "Music artist"))
              ..add(ListContent("tablelist", [
                TextContent("value", "Range Rover Velar"),
                TextContent("value", "Lada Vesta SW Sport")
              ]))
          ])),
      ]));

    final d = await docx.generate(c);
    final of = File('generated.docx');
    await of.writeAsBytes(d);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final firestoreDatabase =
        Provider.of<FirestoreDatabase>(context, listen: false);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: StreamBuilder(
            stream: authProvider.user,
            builder: (context, snapshot) {
              final UserModel user = snapshot.data;
              return Text(user != null
                  ? user.email +
                      " - " +
                      AppLocalizations.of(context)
                          .translate("penyediaAppBarTitle")
                  : AppLocalizations.of(context)
                      .translate("penyediaAppBarTitle"));
            }),
        actions: <Widget>[
          StreamBuilder(
              stream: firestoreDatabase.penyediasStream(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<PenyediaModel> penyedias = snapshot.data;
                  return Visibility(
                      visible: penyedias.isNotEmpty ? true : false,
                      child: Text('--')); //TodosExtraActions());
                } else {
                  return Container(
                    width: 0,
                    height: 0,
                  );
                }
              }),
          IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.of(context).pushNamed(Routes.setting);
              }),
          IconButton(
              icon: Icon(Icons.work),
              onPressed: () {
                genDocx();
              }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed(
            Routes.create_edit_penyedia,
          );
        },
      ),
      body:
          // Center(
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: <Widget>[
          //       Text('title'),
          //       Text('message'),
          //     ],
          //   ),
          // )
          WillPopScope(
              onWillPop: () async => false, child: _buildBodySection(context)),
    );
  }

  Widget _buildBodySection(BuildContext context) {
    final firestoreDatabase =
        Provider.of<FirestoreDatabase>(context, listen: false);

    return StreamBuilder(
        stream: firestoreDatabase.penyediasStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<PenyediaModel> penyedias = snapshot.data;
            if (penyedias.isNotEmpty) {
              return ListView.separated(
                itemCount: penyedias.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    background: Container(
                      color: Colors.red,
                      child: Center(
                          child: Text(
                        AppLocalizations.of(context)
                            .translate("todosDismissibleMsgTxt"),
                        style: TextStyle(color: Theme.of(context).canvasColor),
                      )),
                    ),
                    key: Key(penyedias[index].id),
                    // onDismissed: (direction) {
                    //   firestoreDatabase.deleteTodo(penyedias[index]);

                    //   _scaffoldKey.currentState.showSnackBar(SnackBar(
                    //     backgroundColor: Theme.of(context).appBarTheme.color,
                    //     content: Text(
                    //       AppLocalizations.of(context)
                    //               .translate("todosSnackBarContent") +
                    //           todos[index].task,
                    //       style:
                    //           TextStyle(color: Theme.of(context).canvasColor),
                    //     ),
                    //     duration: Duration(seconds: 3),
                    //     action: SnackBarAction(
                    //       label: AppLocalizations.of(context)
                    //           .translate("todosSnackBarActionLbl"),
                    //       textColor: Theme.of(context).canvasColor,
                    //       onPressed: () {
                    //         firestoreDatabase.setTodo(todos[index]);
                    //       },
                    //     ),
                    //   ));
                    // },
                    child: ListTile(
                      // leading: Checkbox(
                      //     value: penyedias[index].aNamaBadanUsaha,
                      //     onChanged: (value) {
                      //       TodoModel todo = TodoModel(
                      //           id: penyedias[index].id,
                      //           task: penyedias[index].task,
                      //           extraNote: penyedias[index].extraNote,
                      //           complete: value);
                      //       firestoreDatabase.setTodo(todo);
                      //     }),
                      title: Text(penyedias[index].aNamaBadanUsaha),
                      onTap: () {
                        Navigator.of(context).pushNamed(
                            Routes.create_edit_penyedia,
                            arguments: penyedias[index]);
                      },
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider(height: 0.5);
                },
              );
            } else {
              return EmptyContentWidget(
                title: AppLocalizations.of(context)
                    .translate("penyediasEmptyTopMsgDefaultTxt"),
                message: AppLocalizations.of(context)
                    .translate("penyediasEmptyBottomDefaultMsgTxt"),
              );
            }
          } else if (snapshot.hasError) {
            return EmptyContentWidget(
              title: AppLocalizations.of(context)
                  .translate("penyediasErrorTopMsgTxt"),
              message: AppLocalizations.of(context)
                  .translate("penyediasErrorBottomMsgTxt"),
            );
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}
