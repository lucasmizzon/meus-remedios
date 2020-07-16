import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'login.dart';
import 'ministrarremedio.dart';
import 'remedioadd.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meus Remédios',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.red,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Meus Remédios'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String data, userid;

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      data = hoje();
    });
    getCurrentUser().then((user) async {
      if (user == null) {
        await Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(builder: (_) => Login()),
        );
        return;
      } else {
        setState(() {
          userid = user.uid;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Meus Remédios"),
      ),
      body: Column(
        children: <Widget>[
          (data != null) ?  Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    print(alterardata(-1, data));
                    setState(() {
                      data = alterardata(-1, data);
                    });
                  },
                ),
                Text(
                  data,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward_ios),
                  onPressed: () {
                    setState(() {
                      data = alterardata(1, data);
                    });
                  },
                ),
              ],
            ),
          ): Container(),
          (data != null) ? Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance
                    .collection('Remedios')
                    .where("data", isEqualTo: data)
                    .where("userid", isEqualTo: userid)
                    .orderBy("horario")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError)
                    return new Text('Error: ${snapshot.error}');
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return new Container();
                    default:
                      return ListView(
                        children: snapshot.data.documents.map((doc) {
                          return itemremedio(doc, context);
                        }).toList(),
                      );
                  }
                }),
          ): Container()
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => RemedioAdd(userid)));
        },
        tooltip: 'Adicionar',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  String alterardata(int i, data) {
    String date = data;
    var dataseparada = date.split("/");
    var datadolabel = DateTime.parse(
        '${dataseparada[2]}-${dataseparada[1]}-${dataseparada[0]} 00:00:00.000');
    var alterardia = datadolabel.add(new Duration(days: i));
    String dataalterada = DateFormat('dd/MM/yyyy').format(alterardia);
    return dataalterada;
  }

  Widget itemremedio(document, context) {
    return GestureDetector(
        onTap: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MinistarRemedio(
                        remedio: document,
                      )));
        },
        onLongPress: () {
          deletar(document, context);
        },
        child: Card(
          elevation: 2.0,
          child: Row(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                      color: (document['ministrado'] == false)
                          ? Colors.redAccent
                          : Colors.lightGreen,
                      child: Column(
                        children: <Widget>[
                          Text(
                            (document['horario'] != null)
                                ? document['horario']
                                : "",
                            style: TextStyle(
                                fontSize: 15.0, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            (document['ministrado'] == true)
                                ? "MINISTRADO"
                                : "NÃO MINISTRADO",
                            style: TextStyle(
                                fontSize: 10.0, fontWeight: FontWeight.bold),
                          ),
                        ],
                      )),
                ],
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Center(
                        child: Text(
                      (document['aluno'] != null) ? document['aluno'] : "",
                      style: TextStyle(
                          fontStyle: FontStyle.italic, fontSize: 16.0),
                    )),
                    Center(
                        child: Text(
                      (document['medicamento'] != null)
                          ? document['medicamento']
                          : "",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                    Center(
                        child: Text(
                            " ${(document['posologia'] != null) ? document['posologia'] : ""}")),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  Widget deletar(document, context) {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: new Text("Deletar Publicação"),
            content: new Text("Deseja deletar esta publicação?"),
            actions: <Widget>[
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text(
                  "Cancelar",
                  style: TextStyle(color: Colors.red[700]),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text(
                    "DELETAR",
                    style: TextStyle(color: Colors.red[700]),
                  ),
                  onPressed: () {
                    document.reference.delete().then((val) {
                      Navigator.pop(context);
                    });
                  }),
            ],
          );
        });
  }
  String hoje() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd/MM/yyyy').format(now);
    return formattedDate;
  }
}
