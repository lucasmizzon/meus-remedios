import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  AnimationController controller, controller1;
  Animation<double> fade;
  Animation<double> buttonSqueeze;
  Animation<double> textOpacity;
  Animation<double> offset;
  FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController csenha = TextEditingController();
  TextEditingController cemail = TextEditingController();
  TextEditingController cnome = TextEditingController();
  Map<int, Widget> opcoes = const <int, Widget>{
    0: Text("Cadastre-se"),
    1: Text("Já sou Usuário"),
  };
  int opcao = 0;

  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 4));
    controller1 =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    controller.addStatusListener((status) {});
    controller1.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (opcao == 1) {
          loginUser();
        } else {
          createuser();
        }
      }
    });
    controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    controller1.dispose();
    cemail.dispose();
    csenha.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    offset = Tween(begin: MediaQuery.of(context).size.width, end: 0.0).animate(
        CurvedAnimation(
            parent: controller,
            curve: Interval(0.0, 0.85, curve: Curves.easeInOutQuad)));
    fade = Tween(begin: 0.0, end: MediaQuery.of(context).size.width * 0.5)
        .animate(CurvedAnimation(
            parent: controller, curve: Interval(0.0, 0.7, curve: Curves.ease)));
    buttonSqueeze =
        Tween(begin: MediaQuery.of(context).size.width / 2, end: 60.0).animate(
            CurvedAnimation(parent: controller1, curve: Interval(0.0, 0.5)));
    textOpacity = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: controller,
        curve: Interval(0.0, 1.0, curve: Curves.easeInCirc)));
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: segmented(opcoes, opcao, mudardosegmento, context),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: AnimatedBuilder(
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(offset.value, 0.0),
                          child:
                              Image.asset("images/logo.png", width: fade.value),
                        );
                      },
                      animation: controller,
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      (opcao == 0)
                          ? AnimatedBuilder(
                              builder: (context, child) {
                                return Opacity(
                                    opacity: textOpacity.value,
                                    child: caixadetexto(
                                        1,
                                        1,
                                        TextInputType.text,
                                        cnome,
                                        "Nome",
                                        TextCapitalization.words));
                              },
                              animation: controller,
                            )
                          : Container(),
                      AnimatedBuilder(
                        builder: (context, child) {
                          return Opacity(
                              opacity: textOpacity.value,
                              child: caixadetexto(
                                  1,
                                  1,
                                  TextInputType.emailAddress,
                                  cemail,
                                  "e-mail",
                                  TextCapitalization.none));
                        },
                        animation: controller,
                      ),
                      AnimatedBuilder(
                        builder: (context, child) {
                          return Opacity(
                            opacity: textOpacity.value,
                            child: caixadetexto(
                                1,
                                1,
                                TextInputType.visiblePassword,
                                csenha,
                                "Defina sua senha",
                                TextCapitalization.none),
                          );
                        },
                        animation: controller,
                      ),
                      AnimatedBuilder(
                        builder: (context, child) {
                          return Opacity(
                              opacity: textOpacity.value,
                              child: loginAnimation());
                        },
                        animation: controller,
                      ),
                      (opcao == 1)
                          ? Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: AnimatedBuilder(
                                builder: (context, child) {
                                  return Opacity(
                                    opacity: textOpacity.value,
                                    child: GestureDetector(
                                      onTap: () {
                                        if (cemail.text.isNotEmpty) {
                                          dialog1botao(
                                              context,
                                              "Recuperação de senha",
                                              "Um e-mail foi enviado!");
                                          _auth.sendPasswordResetEmail(
                                              email: cemail.text
                                                  .toLowerCase()
                                                  .trim());
                                        } else {
                                          dialog1botao(
                                              context,
                                              "Escreva seu e-mail",
                                              "Primeiro escreva seu e-mail no campo acima\ne clique aqui novamente.");
                                        }
                                      },
                                      child: AutoSizeText(
                                        "Redefinir a senha",
                                        style: TextStyle(
                                            color: Colors.red[700]),
                                      ),
                                    ),
                                  );
                                },
                                animation: controller,
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget loginAnimation() {
    return AnimatedBuilder(
        animation: controller1,
        builder: (context, child) {
          return Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Container(
              width: buttonSqueeze.value,
              height: MediaQuery.of(context).size.height * 0.1,
              child: Card(
                color: Colors.red[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                margin: EdgeInsets.all(10.0),
                elevation: 5.0,
                child: InkWell(
                  borderRadius: BorderRadius.circular(15.0),
                  splashColor: Colors.grey.withAlpha(30),
                  onTap: () {
                    if (csenha.text.isNotEmpty && cemail.text.isNotEmpty) {
                      controller1.forward();
                    } else {
                      return dialog1botao(context, "E-mail e senha",
                          "Preencha dados válidos.\nCaso tenha esquecido a senha, escreva o e-mail e clique em Recuperar Senha");
                    }
                  },
                  child: buttonSqueeze.value >= 125
                      ? Center(
                          child: Text(
                          "LOGIN",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              letterSpacing: 1.5,
                              color: Colors.white,
                              fontWeight: FontWeight.w400),
                        ))
                      : Container(
                          alignment: Alignment.center,
                          width: buttonSqueeze.value,
                          height: 45.0,
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                            strokeWidth: 1.0,
                          )),
                ),
              ),
            ),
          );
        });
  }

  void mudardosegmento(val) {
    setState(() {
      opcao = val;
    });
  }

  createuser() async {
    try {
      AuthResult result;
      result = await _auth.createUserWithEmailAndPassword(
          email: cemail.text.toLowerCase().trim(),
          password: csenha.text.trim());
      FirebaseUser user = result.user;

      Map<String, dynamic> map = Map();
      map['nome'] = cnome.text;
      map['email'] = cemail.text;
      map['createdAt'] = DateTime.now().toIso8601String();

      Firestore.instance
          .collection('Users')
          .document(user.uid)
          .setData(map)
          .then((document) {
        controller1.reset();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MyHomePage()));
      });
    } on Exception catch (e) {
      print(e.toString());
      controller1.reset();
      return dialog1botao(context, "Ups",
          "Suas credenciais estão incorretas. \n Tente novamente.");
    }
  }

  loginUser() async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: cemail.text.toLowerCase().trim(),
          password: csenha.text.trim());
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MyHomePage()));
      controller1.reset();
    } on Exception catch (e) {
      print(e.toString());
      controller1.reset();
      return dialog1botao(context, "Ups",
          "Suas credenciais estão incorretas. \n Tente novamente.");
    }
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
  
  
  Widget segmented(opcoes, opcao, funcao, context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: CupertinoSegmentedControl<int>(
            selectedColor: Colors.red[700],
            borderColor: Colors.red[700],
            children: opcoes,
            onValueChanged: (val) {
              funcao(val);
            },
            groupValue: opcao),
      ),
    );
  }



}

