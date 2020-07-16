import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:photo_view/photo_view.dart';


class MinistarRemedio extends StatefulWidget {
  final DocumentSnapshot remedio;

  MinistarRemedio({this.remedio});

  @override
  _MinistarRemedioState createState() =>
      _MinistarRemedioState(document: remedio);
}

class _MinistarRemedioState extends State<MinistarRemedio> {
  _MinistarRemedioState({this.document});

  DocumentSnapshot document;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[700],
        actions: <Widget>[
          InkWell(
              onTap: () {
                showCupertinoDialog(
                    context: context,
                    builder: (context) {
                      return CupertinoAlertDialog(
                        title: new Text("Ministrar Remédio"),
                        content: new Text("O remédio já foi ministrado?"),
                        actions: <Widget>[
                          CupertinoDialogAction(
                            isDefaultAction: true,
                            child: Text(
                              "NÃO",
                              style: TextStyle(color: Colors.red[700]),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          CupertinoDialogAction(
                              isDefaultAction: true,
                              child: Text(
                                "SIM",
                                style: TextStyle(color: Colors.red[700]),
                              ),
                              onPressed: () {
                                document.reference.updateData(
                                    {'ministrado': true}).then((val) {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                });
                              })
                        ],
                      );
                    });
              },
              child: (document['ministrado'] == false)
                  ? Center(
                      child: Text(
                      "Registrar Ministrado",
                      style: TextStyle(
                          letterSpacing: 1.5, fontWeight: FontWeight.w500),
                    ))
                  : Container())
        ],
      ),
      body: SingleChildScrollView(
        child: remediosdetalhes(
            document['horario'],
            document['ministrado'],
            document['userid'],
            document['medicamento'],
            document['posologia'],
            document['medico'],
            document['receita'],
            context),
      ),
    );
  }

  Widget remediosdetalhes(horario, ministrado, userid, remedio, posologia,
      medico, foto, context) {
    return Column(
      children: <Widget>[
        Container(
          color: (ministrado) ? Colors.green : Colors.redAccent,
          width: 500.0,
          height: 40.0,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  horario != null ? horario : "",
                  style: TextStyle(
                    fontSize: 11.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 1.0),
                child: Text(
                  "Ministrado",
                  style: TextStyle(fontSize: 11.0, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 50.0,
            height: 50.0,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: AssetImage("images/logo.png"), fit: BoxFit.cover)),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(remedio != null ? remedio : ""),
        ),
        Padding(
          padding: const EdgeInsets.all(1.0),
          child: Text(posologia != null ? posologia : ""),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text((medico != null) ? medico : ""),
        ),
        (foto != null && foto.isNotEmpty)
            ? SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.6,
          child: PhotoView(
            initialScale: PhotoViewComputedScale.contained,
            backgroundDecoration: BoxDecoration(color: Colors.white),
            imageProvider: NetworkImage(foto),
          ),
        )
            : Container()
      ],
    );
  }
}
