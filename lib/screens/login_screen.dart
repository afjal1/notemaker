import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notemaker/configs/config.dart';
import 'package:notemaker/screens/widgets.dart/my_button.dart';
import 'package:sms_autofill/sms_autofill.dart';

import 'home_screen.dart';
import 'widgets.dart/text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _phoneController = TextEditingController();
  final _phoneFocus = FocusNode();
  String? _errorPhone;
  String verificationIdHere = '';

  bool isOtpSent = false;
  AnimationController? _animationController;
  int levelClock = 2 * 60;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: Duration(seconds: levelClock));
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    _animationController!.dispose();
    super.dispose();
  }

  _listenSmsCode() async {
    await SmsAutoFill().listenForCode();
  }

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return isLoading
        ? Container(
            color: Colors.white,
            child: const Center(child: CircularProgressIndicator()))
        : Scaffold(
            resizeToAvoidBottomInset: false,
            body: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/bg.png'),
                  fit: BoxFit.fitHeight,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: size.height * 0.17),
                  Center(
                      child:
                          Image.asset('assets/Group 468@2x.png', scale: 1.5)),
                  SizedBox(height: size.height * 0.03),
                  titleWidget(Colors.black),
                  SizedBox(height: size.height * 0.06),
                  SizedBox(
                    width: size.width * 0.6,
                    child: MyTextField(
                      controller: _phoneController,
                      focusNode: _phoneFocus,
                      maxlen: 13,
                      errorText: _errorPhone,
                      inputAction: TextInputAction.send,
                      hintText: 'Enter Mobile Number',
                      inputType: TextInputType.number,
                      isEnabled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  !isOtpSent
                      ? SizedBox(
                          width: size.width * 0.6,
                          child: CustomButton(
                            text: 'Send OTP',
                            onPressed: () async {
                              _phoneFocus.unfocus();
                              if (_phoneController.text.length != 10) {
                                setState(() {
                                  _errorPhone = 'Enter a valid phone number';
                                });
                              } else {
                                setState(() {
                                  _errorPhone = null;
                                });

                                setState(() {
                                  isLoading = true;
                                });
                                _listenSmsCode();
                                await FirebaseAuth.instance.verifyPhoneNumber(
                                  phoneNumber: "+91${_phoneController.text}",
                                  verificationCompleted:
                                      (PhoneAuthCredential credential) async {
                                    final UserCredential cr = await FirebaseAuth
                                        .instance
                                        .signInWithCredential(credential);
                                    //   final String firebaseToken =
                                    //       await cr.user!.getIdToken();
                                  },
                                  verificationFailed:
                                      (FirebaseAuthException e) async {
                                    isLoading = false;
                                    setState(() {});
                                    if (e.message != null) {
                                      showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                                content: Text(e.message!),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text('Ok'))
                                                ],
                                              ));
                                    }
                                  },
                                  codeSent: (String verificationId,
                                      int? resendToken) {
                                    setState(() {
                                      isOtpSent = true;
                                      isLoading = false;
                                      verificationIdHere = verificationId;
                                    });
                                  },
                                  codeAutoRetrievalTimeout:
                                      (String verificationId) {
                                    setState(() {
                                      isLoading = false;
                                    });
                                  },
                                );
                              }
                            },
                          ),
                        )
                      : const SizedBox.shrink(),
                  SizedBox(height: size.height * 0.03),
                  isOtpSent
                      ? SizedBox(
                          width: size.width * 0.6,
                          child: PinFieldAutoFill(
                            codeLength: 6,
                            autoFocus: true,
                            cursor: Cursor(
                              width: 2,
                              color: Theme.of(context).primaryColor,
                              enabled: true,
                            ),
                            decoration: UnderlineDecoration(
                              lineHeight: 1,
                              lineStrokeCap: StrokeCap.square,
                              bgColorBuilder: PinListenColorBuilder(
                                  Theme.of(context).primaryColor, Colors.white),
                              colorBuilder:
                                  const FixedColorBuilder(Colors.white),
                            ),
                            onCodeChanged: (code) {
                              if (code!.length == 6) {
                                setState(() {
                                  isLoading = true;
                                });
                                login(code, verificationIdHere);
                              }
                            },
                          ),
                        )
                      : const SizedBox(),
                  SizedBox(height: size.height * 0.03),
                  // isOtpSent
                  //     ? SizedBox(
                  //         width: size.width * 0.6,
                  //         child: CustomButton(
                  //           text: 'Verify OTP',
                  //           onPressed: () {
                  //             _phoneFocus.unfocus();
                  //           },
                  //         ),
                  //       )
                  //     : const SizedBox(),
                ],
              ),
            ),
          );
  }

  void login(
    String code,
    String verificationId,
  ) async {
    try {
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: code);
      final UserCredential cr =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final String firebaseToken = await cr.user!.getIdToken();

      if (FirebaseAuth.instance.currentUser != null) {
        NoteMakerApp.auth = FirebaseAuth.instance;
        isLoading = false;
        setState(() {});
        Get.to(() => const HomeScreen());
      } else {
        Get.snackbar('Error', 'Invalid OTP');
      }
    } catch (e) {
      Get.snackbar(e.toString(), 'Invalid OTP');
    }
  }
}

Text titleWidget(Color color) {
  return Text('Welcome to NoteMaker',
      style:
          TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold));
}

class Countdown extends AnimatedWidget {
  Countdown({Key? key, required this.animation})
      : super(key: key, listenable: animation);
  Animation<int> animation;

  @override
  build(BuildContext context) {
    Duration clockTimer = Duration(seconds: animation.value);

    String timerText =
        '${clockTimer.inMinutes.remainder(60).toString()}:${clockTimer.inSeconds.remainder(60).toString().padLeft(2, '0')}';
    return Text(
      timerText,
      style: TextStyle(
        fontSize: 18,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
