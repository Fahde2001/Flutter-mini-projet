import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:testflutter/start_components/CustomFormSingIn.dart';
import 'package:testflutter/start_components/SingUp.dart';
import 'package:testflutter/start_components/animated_btn.dart';

class OnbodingScreen extends StatefulWidget {
  const OnbodingScreen({super.key});

  @override
  State<OnbodingScreen> createState() => _OnbodingScreenState();
}

class _OnbodingScreenState extends State<OnbodingScreen> {
  bool isSingInDialogShow = false;
  late RiveAnimationController _btnAnimationController;
  final whiteColorWithOpacity = Colors.white.withOpacity(0.94);

  @override
  void initState() {
    _btnAnimationController = OneShotAnimation(
      "active",
      autoplay: false,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            width: MediaQuery.of(context).size.width * 1.7,
            bottom: 200,
            left: 100,
            child: Image.asset("assets/Backgrounds/Spline.png"),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 10),
              child: const SizedBox(),
            ),
          ),
          const RiveAnimation.asset("assets/RiveAssets/shapes.riv"),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: const SizedBox(),
            ),
          ),
          AnimatedPositioned(
            top: isSingInDialogShow ? -50 : 0,
            duration: const Duration(milliseconds: 240),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),
                    const SizedBox(
                      width: 260,
                      child: Column(
                        children: [
                          Text(
                            "TaskFlow Master&Tasks",
                            style: TextStyle(
                              fontSize: 53,
                              fontFamily: "Poppins",
                              height: 1.2,
                            ),
                          ),
                          Text(
                            "TaskFlow your streamlined solution for daily tasks. Elevate your workflow with intuitive features and a user-friendly interface. Prioritize, manage, and conquer your to-dos efficiently. TaskFlow brings seamless organization to boost your productivity—an ultimate task management companion.",
                          ),
                        ],
                      ),
                    ),
                    const Spacer(
                      flex: 2,
                    ),
                    AnimatedBtn(
                      btnAnimationController: _btnAnimationController,
                      press: () {
                        _btnAnimationController.isActive = true;
                        Future.delayed(Duration(milliseconds: 800), () {
                          setState(() {
                            isSingInDialogShow = true;
                          });

                          customFormSignIn(context, onClosed: (_) {
                            setState(() {
                              isSingInDialogShow = false;
                            });
                          });
                        });
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Row(
                        children: [
                          Text(
                            "Create accounte? ",
                            style: TextStyle(fontSize: 12, color: Colors.black),
                          ),
                          InkWell(
                            onTap: () {
                              _showSignUpBottomSheet(context);
                            },
                            child: Container(
                              padding: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(0),
                              ),
                              child: Text(
                                'Sing up',
                                style:
                                    TextStyle(fontSize: 12, color: Colors.blue),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> _showSignUpBottomSheet(BuildContext context) async {
  await showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) => SignUpBottomSheet(),
  );
}
