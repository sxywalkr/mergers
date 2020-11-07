import 'package:flutter/material.dart';
import 'package:noteapp/app_localizations.dart';
import 'package:noteapp/models/penyedia_model.dart';
import 'package:noteapp/services/firestore_database.dart';
import 'package:provider/provider.dart';

class CreateEditPenyediaScreen extends StatefulWidget {
  @override
  _CreateEditPenyediaScreenState createState() =>
      _CreateEditPenyediaScreenState();
}

class _CreateEditPenyediaScreenState extends State<CreateEditPenyediaScreen> {
  TextEditingController _aNamaBadanUsahaController;
  TextEditingController _aStatusController;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  PenyediaModel _penyedia;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final PenyediaModel _penyediaModel =
        ModalRoute.of(context).settings.arguments;
    if (_penyediaModel != null) {
      _penyedia = _penyediaModel;
    }

    _aNamaBadanUsahaController = TextEditingController(
        text: _penyedia != null ? _penyedia.aNamaBadanUsaha : "");
    _aStatusController =
        TextEditingController(text: _penyedia != null ? _penyedia.aStatus : "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.cancel),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(_penyedia != null
            ? AppLocalizations.of(context)
                .translate("penyediasCreateEditAppBarTitleEditTxt")
            : AppLocalizations.of(context)
                .translate("penyediasCreateEditAppBarTitleNewTxt")),
        actions: <Widget>[
          FlatButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  FocusScope.of(context).unfocus();

                  final firestoreDatabase =
                      Provider.of<FirestoreDatabase>(context, listen: false);

                  firestoreDatabase.setPenyedia(PenyediaModel(
                    id: _penyedia != null
                        ? _penyedia.id
                        : documentIdFromCurrentDate(),
                    aNamaBadanUsaha: _aNamaBadanUsahaController.text,
                  ));

                  Navigator.of(context).pop();
                }
              },
              child: Text("Save"))
        ],
      ),
      body: Center(
        child: _buildForm(context),
      ),
    );
  }

  @override
  void dispose() {
    _aNamaBadanUsahaController.dispose();
    _aStatusController.dispose();
    super.dispose();
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _aNamaBadanUsahaController,
                style: Theme.of(context).textTheme.body1,
                validator: (value) => value.isEmpty
                    ? AppLocalizations.of(context)
                        .translate("penyediaCreateEditTaskNameValidatorMsg")
                    : null,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).iconTheme.color, width: 2)),
                  labelText: AppLocalizations.of(context)
                      .translate("penyediaCreateEditTaskNameTxt"),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(vertical: 16),
              //   child: TextFormField(
              //     controller: _extraNoteController,
              //     style: Theme.of(context).textTheme.body1,
              //     maxLines: 15,
              //     decoration: InputDecoration(
              //       enabledBorder: OutlineInputBorder(
              //           borderSide: BorderSide(
              //               color: Theme.of(context).iconTheme.color,
              //               width: 2)),
              //       labelText: AppLocalizations.of(context).translate("todosCreateEditNotesTxt"),
              //       alignLabelWithHint: true,
              //       contentPadding: new EdgeInsets.symmetric(
              //           vertical: 10.0, horizontal: 10.0),
              //     ),
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.only(left: 8),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: <Widget>[
              //       Text(AppLocalizations.of(context).translate("todosCreateEditCompletedTxt")),
              //       Checkbox(
              //           value: _checkboxCompleted,
              //           onChanged: (value) {
              //             setState(() {
              //               _checkboxCompleted = value;
              //             });
              //           })
              //     ],
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
