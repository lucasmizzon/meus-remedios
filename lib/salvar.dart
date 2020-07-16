

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Salvar{


  salvarremediogeral( image, listaDias, listaHorarios,
      userid, remedio, posologia, medico) {
    if (image != null) {
      String nomeImagem =
          "Remedios/" +
          DateTime.now().toIso8601String() +
          ".jpg";
      StorageReference storageReference =
      FirebaseStorage.instance.ref().child(nomeImagem);
      StorageUploadTask uploadTask = storageReference.putFile(image);
      uploadTask.onComplete.then((value) {
        value.ref.getDownloadURL().then((value) {
          for (int i = 0; i < listaDias.length; i++) {
            for (int j = 0; j < listaHorarios.length; j++) {
              salvarmedicamentos(
                value.toString(),

                userid,

                remedio,
                posologia,
                medico,
                listaHorarios[j],
                listaDias[i],
              );
            }
          }
        });
      });
    } else {
      for (int i = 0; i < listaDias.length; i++) {
        for (int j = 0; j < listaHorarios.length; j++) {
          salvarmedicamentos(
            "",

            userid,

            remedio,
            posologia,
            medico,
            listaHorarios[j],
            listaDias[i],
          );
        }
      }
    }
  }




  salvarmedicamentos(imagem,  userid,  medicamento, posologia,
      medico, horario, dia) {
    if (imagem != null) {
      Map<String, dynamic> map = Map();
      map['userid'] = userid;
      map['medicamento'] = medicamento;
      map['posologia'] = posologia;
      map['medico'] = medico;
      map['data'] = dia;
      map['horario'] = horario;
      map['receita'] = imagem;
      map['ministrado'] = false;
      map['createdAt'] = DateTime.now().toIso8601String();
      map['datacomparar'] = DateTime.now();
      Firestore.instance.collection('Remedios').add(map);
    } else {
      Map<String, dynamic> map = Map();
      map['userid'] = userid;
      map['medicamento'] = medicamento;
      map['posologia'] = posologia;
      map['medico'] = medico;
      map['data'] = dia;
      map['horario'] = horario;
      map['ministrado'] = false;
      map['createdAt'] = DateTime.now().toIso8601String();
      map['datacomparar'] = DateTime.now();
      Firestore.instance.collection('Remedios').add(map);
    }
  }



}