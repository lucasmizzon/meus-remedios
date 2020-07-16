import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'salvar.dart';


class RemedioAdd extends StatefulWidget {
 final String userid;
  RemedioAdd(this.userid);
  @override
  _RemedioAddState createState() => _RemedioAddState();
}

class _RemedioAddState extends State<RemedioAdd> {
  File fotoreceita;
  List<String> listaHorarios = [];
  List<String> listaDias = [];

  TextEditingController cremedio = TextEditingController();
  TextEditingController cposologia = TextEditingController();
  TextEditingController cmedico = TextEditingController();
  final picker = ImagePicker();

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[700],
        actions: <Widget>[
          FlatButton(
            textColor: Colors.white,
            onPressed: () {
              if (cremedio.text.isEmpty || cposologia.text.isEmpty || listaDias.length == 0 || listaHorarios.length == 0 ) {
              dialog1botao(context, "Nome, Posologia e Horários", "Nome, Posologia e Horários são itens obrigatórios");
              } else {
             Salvar().salvarremediogeral(fotoreceita, listaDias, listaHorarios, widget.userid, cremedio.text, cposologia.text, cmedico.text);
              dialog1botaofechar(context, "Salvando", "Os remédios poderão ser visualizados na tela principal.");



              }
            },
            child: Text(
              "Salvar",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
            ),
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          ),
        ],
        title: Text("Novo Medicamento"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            titulo("Medicamento"),
            caixadetexto(1, 3, TextInputType.multiline, cremedio,
                "Nome do Medicamento - Exemplo: Alivium",TextCapitalization.words,),
            titulo("Posologia"),
            caixadetexto(
                1,
                8, TextInputType.multiline,
                cposologia,
                "Explique como ministrar o medicamento e quantidade - Exemplo: 5 ml, 15 gotas",TextCapitalization.sentences,),
            titulo("Qual horário deve ser ministrado?"),
            InkWell(
              onTap: () {
                Future<TimeOfDay> selectedDate = showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(DateTime.now()),
                  builder: (BuildContext context, Widget child) {
                    return Theme(
                      data: ThemeData.light(),
                      child: child,
                    );
                  },
                );
                selectedDate.then((time) {
                  if (time != null) {
                    setState(() {
                      listaHorarios.add(formatHora(hour: time.hour, minute: time.minute));
                    });
                  }
                });
              },
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 50.0, bottom: 8.0, top: 8.0),
                    child: Container(
                      width: 20.0,
                      height: 20.0,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: AssetImage("images/logo.png"),
                              fit: BoxFit.cover)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      "Adicionar Horários",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                ],
              ),
            ),
            (listaHorarios.isNotEmpty)
                ? Column(
                    children: _createTimeList(),
                  )
                : Container(),
            titulo("Quais dias deve ser minstrado?"),
            InkWell(
              onTap: () {
                Future<DateTime> selectedDate = showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2018),
                  lastDate: DateTime(2030),
                  builder: (BuildContext context, Widget child) {
                    return Theme(
                      data: ThemeData.light(),
                      child: child,
                    );
                  },
                );
                selectedDate.then((time) {
                  if (time != null) {
                    setState(() {
                      listaDias.add(formatData(
                          year: time.year, month: time.month, day: time.day));
                    });
                  }
                });
              },
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 50.0, bottom: 8.0, top: 8.0),
                    child: Container(
                      width: 20.0,
                      height: 20.0,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: AssetImage("images/logo.png"),
                              fit: BoxFit.cover)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      "Adicionar Dias",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                ],
              ),
            ),
            Column(
              children: _createDateList(),
            ),
            titulo(
                "Nome e telefone do médico que prescreveu este medicamento:"),
            caixadetexto(1, 1, TextInputType.text, cmedico,
                "Exemplo: Dr. Sandro - 3232-3232",TextCapitalization.words,),
            titulo("Adicione uma foto da prescrição médica"),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: 500.0,
                child: Card(
                  elevation: 8.0,
                  color: Colors.white,
                  child: InkWell(
                    onTap: () {
                      getImage();
                    },
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Adicionar Imagem",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                              color: Colors.red[700]),
                        ),
                        (fotoreceita != null)
                            ? ClipRRect(
                                borderRadius: new BorderRadius.circular(4.0),
                                child: Image.file(
                                  fotoreceita,
                                  scale: 0.5,
                                  fit: BoxFit.cover,
                                  height: 450.0,

                                  width: MediaQuery.of(context).size.width,
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      fotoreceita = File(pickedFile.path);
    });
  }


  String formatHora({int hour, int minute}) {
    DateTime data = DateTime(0, 1, 1, hour, minute);
    String formattedDate = DateFormat('HH:mm').format(data);
    return formattedDate;
  }

  String formatData({int year, int month, int day}) {
    DateTime data = DateTime(year, month, day);
    String formattedDate = DateFormat('dd/MM/yyyy').format(data);
    return formattedDate;
  }


  Widget caixadetexto(
      min, max, textinputtype, controller, placeholder, capitalization,
      {bool obs: false}) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        minLines: min,
        maxLines: max,
        keyboardType: textinputtype,
        controller: controller,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red[700], width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[300], width: 1.5),
          ),
          labelText: placeholder,
          labelStyle: TextStyle(
              letterSpacing: 1.0, fontSize: 12.0, fontWeight: FontWeight.w400),
        ),
        textCapitalization: capitalization,
        autofocus: false,
        obscureText: obs,
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
      ),
    );
  }

  dialog1botao(context, titulo, texto, {destino}) {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: new Text(titulo),
            content: new Text(texto),
            actions: <Widget>[
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text(
                  "OK",
                  style: TextStyle(color: Colors.red[700]),
                ),
                onPressed: () {
                  if (destino == null) {
                    Navigator.pop(context);
                  } else {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => destino),
                            (Route<dynamic> route) => false);
                  }
                },
              ),
            ],
          );
        });
  }

  List<Widget> _createTimeList() {
    return new List<Widget>.generate(listaHorarios.length, (int index) {
      return Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              listaHorarios[index],
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.5,
                  color: Colors.red),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  listaHorarios.removeAt(index);
                });
              },
              icon: Icon(
                Icons.delete,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      );
    });
  }

  List<Widget> _createDateList() {
    return new List<Widget>.generate(listaDias.length, (int index) {
      return Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              listaDias[index],
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.5,
                  color: Colors.red),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  listaDias.removeAt(index);
                });
              },
              icon: Icon(
                Icons.delete,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      );
    });
  }



  dialog1botaofechar(context, titulo, texto) {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: new Text(titulo),
            content: new Text(texto),
            actions: <Widget>[
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text(
                  "OK",
                  style: TextStyle(color: Colors.red[700]),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  Widget titulo(texto) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        (texto.toString().isNotEmpty) ? texto : "Selecione a data",
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: texto.toString().isNotEmpty ? Colors.black : Colors.grey),
      ),
    );
  }
}
