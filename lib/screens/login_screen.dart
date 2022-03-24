import 'package:flutter/material.dart';

enum MobileVerificationState {
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FORM_STATE,
}

class LoginScreen extends StatefulWidget{
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final currentState = MobileVerificationState.SHOW_MOBILE_FORM_STATE;

  final phoneController = TextEditingController();
  final otpController = TextEditingController();

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
            onPressed: (){

            },
            child: Text("Send"),
          color: Colors.lightBlue,
          textColor: Colors.white,
        ),
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
          onPressed: (){

          },
          child: Text("VERIFTY"),
          color: Colors.lightBlue,
          textColor: Colors.white,
        ),
        Spacer()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: currentState == MobileVerificationState.SHOW_MOBILE_FORM_STATE
              ? getMobileFromWidget(context)
              : getOtpFromWidget(context),
        padding: const EdgeInsets.all(16),
      ),
    );
  }
}