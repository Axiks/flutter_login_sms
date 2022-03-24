import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sms_login_flutter_app/screens/home_screen.dart';

enum MobileVerificationState {
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FORM_STATE,
}

class LoginScreen extends StatefulWidget{
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  MobileVerificationState currentState = MobileVerificationState.SHOW_MOBILE_FORM_STATE;

  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  
  FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSingIn  = GoogleSignIn(scopes: ['email']);

  late String verificationId;

  bool showLoading = false;

  getMobileFromWidget(BuildContext context) {
    return Column(
      children: [
        Spacer(),
        TextField(
          controller: phoneController,
          decoration: InputDecoration(
            hintText: "Phone Number",
          ),
        ),
        SizedBox(height: 16,),
        FlatButton(
            onPressed: () async {
              setState(() {
                showLoading = true;
              });

              await _auth.verifyPhoneNumber(
                  phoneNumber: phoneController.text,
                  verificationCompleted: (phoneAuthCredential) async{
                    setState(() {
                      showLoading = false;
                    });
                    //signInWithPhoneAuthCredential(phoneAuthCredential);
                  },

                  verificationFailed: (verificationFailed) async{
                    setState(() {
                      showLoading = false;
                    });
                    _scaffoldKey.currentState!.showSnackBar(
                      SnackBar(
                          content: Text(verificationFailed.message!)
                      )
                    );
                  },

                  codeSent: (verificationId, resendingToken) async{
                    setState(() {
                      showLoading = false;
                      currentState = MobileVerificationState.SHOW_OTP_FORM_STATE;
                      this.verificationId = verificationId;
                    });
                  },
                  codeAutoRetrievalTimeout: (verificationId) async{

                  }
              );
            },
            child: Text("Send"),
          color: Colors.lightBlue,
          textColor: Colors.white,
        ),
        SizedBox(height: 16,),
        FlatButton(onPressed: () async {
          setState(() {
            showLoading = true;
          });
          final GoogleSignInAccount? googleUser = await _googleSingIn.signIn();
          if(googleUser == null) {
            setState(() {
              showLoading = false;
            });
            _scaffoldKey.currentState!.showSnackBar(SnackBar(content: Text("Error sign in")));
            return;
          }
          else{
            setState(() {
              showLoading = false;
            });

            // Obtain the auth details from the request
            final GoogleSignInAuthentication? googleAuth = await googleUser.authentication;

            // Create a new credential
            final OAuthCredential credential = GoogleAuthProvider.credential(
              accessToken: googleAuth?.accessToken,
              idToken: googleAuth?.idToken,
            );

            _scaffoldKey.currentState!.showSnackBar(SnackBar(content: Text("Sign in")));
            Navigator.push(context, MaterialPageRoute(builder: (context)=> HomeScreen(oAuthCredential: credential)));
          }
        },child: Text("Sign in Google")),
        Spacer()
      ],
    );
  }

  getOtpFromWidget(BuildContext context) {
    return Column(
      children: [
        Spacer(),
        TextField(
          controller: otpController,
          decoration: InputDecoration(
            hintText: "Enter OTP",
          ),
        ),
        SizedBox(height: 16,),
        FlatButton(
          onPressed: () async{
              PhoneAuthCredential phoneAuthCredential =
                PhoneAuthProvider.credential(
                  verificationId: verificationId,
                  smsCode: otpController.text
              );

              signInWithPhoneAuthCredential(phoneAuthCredential); 
          },
          child: Text("VERIFTY"),
          color: Colors.lightBlue,
          textColor: Colors.white,
        ),
        Spacer()
      ],
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
          child: showLoading ? Center(child: CircularProgressIndicator(),) : currentState == MobileVerificationState.SHOW_MOBILE_FORM_STATE
              ? getMobileFromWidget(context)
              : getOtpFromWidget(context),
        padding: const EdgeInsets.all(16),
      ),
    );
  }

  void signInWithPhoneAuthCredential(PhoneAuthCredential phoneAuthCredential) async{
    setState(() {
      showLoading = true;
    });

    try {
      final authCredential = await _auth.signInWithCredential(phoneAuthCredential);
      setState(() {
        showLoading = false;
      });

      if(authCredential.user != null){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> HomeScreen()));
      }

    } on FirebaseAuthException catch (e) {
      setState(() {
        showLoading = false;
      });
      
      _scaffoldKey.currentState!.showSnackBar(SnackBar(content: Text(e.message!)));
    }
  }
}