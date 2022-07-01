// ignore_for_file: file_names
import'package:flutter/material.dart';

Future<void> messageBox(BuildContext context) async {
  return showDialog(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Advertencia'),
        content: SingleChildScrollView(
          child: ListBody(
            children: const <Widget>[
              Text('Debes ingresar una URL'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}