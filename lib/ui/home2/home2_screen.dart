import 'package:flutter/material.dart';
import 'package:noteapp/app_localizations.dart';

import 'package:noteapp/models/user_model.dart';
import 'package:noteapp/providers/auth_provider.dart';
import 'package:noteapp/routes.dart';
import 'package:noteapp/services/firestore_database.dart';
import 'package:provider/provider.dart';

import 'package:noteapp/models/penyedia_model.dart';
import 'package:noteapp/ui/home2/empty_content.dart';

// import 'package:noteapp/ui/todo/todos_extra_actions.dart';
// import 'package:noteapp/models/todo_model.dart';

class Home2Screen extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

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
