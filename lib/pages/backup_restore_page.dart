import 'dart:io';

import 'package:bonfry_wallet/data/database_manager.dart';
import 'package:bonfry_wallet/data/external_io.dart';
import 'package:bonfry_wallet/data/settings_costraints.dart';
import 'package:bonfry_wallet/widgets/option_element_list.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:folder_picker/folder_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BackupRestorePage extends StatefulWidget {
  @override
  BackupRestorePageState createState() => BackupRestorePageState();
}

class BackupRestorePageState extends State<BackupRestorePage> {
  SharedPreferences settingsPreferences;
  Directory _externalDir;
  Directory _saveDirectory;

  @override
  void initState() {
    getExternalIOPermission()
        .then((_) => getExternalStorageDirectory())
        .then((externalDir) async {
      _externalDir = externalDir;
      settingsPreferences = await SharedPreferences.getInstance();
      String backupPath =
          settingsPreferences.getString(SettingConstraints.BACKUP_SETTING_NAME);

      if (backupPath == null) {
        backupPath = '${externalDir.path}/BonfryWalletBackup';
        await settingsPreferences.setString(
            SettingConstraints.BACKUP_SETTING_NAME, backupPath);
      }

      var saveDir = Directory(backupPath);

      if (!await saveDir.exists()) {
        await saveDir.create();
      }

      setState(() {
        _saveDirectory = saveDir;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Backup e Ripristino"),
      ),
      body: OptionElementList(
        children: <OptionElement>[
          OptionElement("Cartella backup",
              subText: _saveDirectory != null ? _saveDirectory.path : '',
              callback: (context) async {
            Navigator.of(context).push<FolderPickerPage>(
                MaterialPageRoute(builder: (BuildContext context) {
              return FolderPickerPage(
                  rootDirectory: _externalDir,
                  action: (BuildContext context, Directory newDir) async {
                    await settingsPreferences.setString(
                        SettingConstraints.BACKUP_SETTING_NAME, newDir.path);
                    setState(() => _saveDirectory = newDir);
                    Navigator.of(context).pop();
                  });
            }));
          }),
          OptionElement("Seleziona formato", subText: "testo JSON (unico)"),
          OptionElement("Esegui backup",
              subText: "Esegui il backuo nel formato selezionato",
              callback: (context) {
            File backupFile = File("${_saveDirectory.path}/backup.json");
            DataBackupManager.backupDatabaseToJson()
                .then((jsonText) => backupFile.writeAsString(jsonText))
                .then((_) => Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text("Backup creato"),
                    )));
          }),
          OptionElement("Esegui ripristino",
              subText: "Perderai tutti i dati attuali",
              callback: (context) => FilePicker.getFile(
                    fileExtension: ".json",
                  )
                      .then((File file) => file.readAsString())
                      .then((String text) =>
                          DataBackupManager.restoreDatabaseFromJson(text))
                      .then((_) {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text("Backup ripristinato"),
                    ));
                  })),
        ],
      ),
    );
  }
}
