import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';

class HomeScreen extends StatefulWidget{
  final OAuthCredential? oAuthCredential;

  const HomeScreen(
      {Key? key, OAuthCredential? this.oAuthCredential})
      : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: widget.oAuthCredential != null ? GoogleSignWidget(oAuthCredential: widget.oAuthCredential!) : const Text("Login witch SMS"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          await _auth.signOut();
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
        },
        child: Icon(Icons.logout),
      ),
    );
  }
}

class GoogleSignWidget extends StatelessWidget{
  final OAuthCredential oAuthCredential;
  GoogleSignWidget({Key? key, required this.oAuthCredential}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserCredential>(
        future: FirebaseAuth.instance.signInWithCredential(oAuthCredential),
        builder: (BuildContext context, AsyncSnapshot<UserCredential> snapshot){
          return Container(
            //Text(snapshot.data!.user!.email.toString())
            child: snapshot.data == null ? Text("Load") : Text(snapshot.data!.user!.email.toString()),
          );
        },
    );
  }
}