// import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;

class SharedModule extends Module {
  final firebase.FirebaseAuth? authFirebase;

  SharedModule({this.authFirebase});

  @override
  void binds(i) {
    i.addInstance<FirebaseAuth>(authFirebase ?? FirebaseAuth.instance);
  }
}
