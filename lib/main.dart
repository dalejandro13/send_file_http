import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:send_file_http/showDialog.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SendFile(),
    )
  );
}

class SendFile extends StatefulWidget {
  const SendFile({ Key? key }) : super(key: key);

  @override
  State<SendFile> createState() => _SendFileState();
}

class _SendFileState extends State<SendFile> {
  TextEditingController ctrl = TextEditingController();
  //String url = "http://192.168.2.1/fupload"; //"http://192.168.2.1/update";
  var client = Dio();
  double val = 0.0;
  int _start = 10;

  Future<void> sendFile(File file, String url) async {
    try{
      FormData formData = FormData.fromMap({
        "file":
        await MultipartFile.fromFile(file.path),
      });
      var response = await client.post(
        url,
        data: formData,
        onSendProgress: (int sent, int total) async {
          setState((){
            val = sent / total;
            log('progress: $val ($sent/$total)');
          });
        },
      ).timeout(const Duration(seconds: 7));

      if(response.statusCode == 200){
        //log("termino muy bien: ${response.statusMessage}");
        String rs = response.data.toString();
        if(rs.contains("File was successfully uploaded")){
          log("el archivo ha sido cargado exitosamente");
        }
      }
    }
    catch(e){
      log("Error: $e");
    }
  }

  // Future<void> runTimer() async {
  //   Timer.periodic(
  //     const Duration(seconds: 1),
  //     (Timer timer) {
  //       setState((){
  //         val = _start / 10;
  //         log("value: $val");
  //       });
  //       if (_start == 0) {
  //         _start = 10;
  //         val = 0.0;
  //       } else {
  //         _start--;
  //       }
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children:[ 
            SizedBox(
              width: 200.0,
              height: 20.0,
              child: TextField(
                controller: ctrl,
                decoration: const InputDecoration(
                  hintText: "ingresa la URL"
                ),
              ),
            ),

            const Padding(padding: EdgeInsets.all(20.0)),

            ElevatedButton(
              onPressed: () async {
                String url;
                url = "";
                if(ctrl.text.isNotEmpty){
                  val = 0.0;
                  if(!ctrl.text.contains("http://")){
                    url = "http://${ctrl.text}";
                  }
                  FilePickerResult? result = await FilePicker.platform.pickFiles();
                  if (result != null) {
                    File file = File(result.files.single.path.toString());
                    await sendFile(file, url);
                    //await runTimer();
                  } 
                  else {
                    // User canceled the picker
                    log("cancelado por el usuario");
                  }
                }
                else{
                  await messageBox(context);
                }
              }, 
              child: const Text("selecciona el archivo"),
            ),

            const Padding(padding: EdgeInsets.only(top:50.0)),
          ]
        ),
      ),
    );
  }
}