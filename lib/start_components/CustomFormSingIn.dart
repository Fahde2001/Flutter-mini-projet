import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'Form.dart';

class FormWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Your FormWidegt implementation here...
    // ...

    return Form(
      child: Column(
          // Your form UI elements...
          ),
    );
  }
}

Future<void> customFormSignIn(BuildContext context,
    {required ValueChanged onClosed}) {
  return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Sing In",
      transitionDuration: const Duration(milliseconds: 400),
      transitionBuilder: (_, anim, __, child) {
        Tween<Offset> tween;
        tween = Tween(begin: const Offset(0, -1), end: Offset.zero);
        return SlideTransition(
          position: tween.animate(
            CurvedAnimation(parent: anim, curve: Curves.easeInOut),
          ),
          child: child,
        );
      },
      pageBuilder: (context, _, __) => Center(
            child: Container(
              height: 580,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
              decoration: const BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 0.9333333333333333),
                borderRadius: BorderRadius.all(Radius.circular(40)),
              ),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: SingleChildScrollView(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Column(
                        children: [
                          const Text(
                            "Sing In",
                            style:
                                TextStyle(fontSize: 34, fontFamily: "Poppins"),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Text(
                              "Hello! Welcome back to TaskFlow. Let's continue your productivity journey.",
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const FormWidegt(),
                          const Row(
                            children: [
                              Expanded(child: Divider()),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  "OR",
                                  style: TextStyle(
                                    color: Colors.black26,
                                  ),
                                ),
                              ),
                              Expanded(child: Divider()),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Text(
                              "Sing  up with Email or Google",
                              style: TextStyle(color: Colors.black54),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: IconButton(
                                  //padding: EdgeInsets.zero,
                                  onPressed: () {},
                                  icon: SvgPicture.asset(
                                    "assets/icons/google_box.svg",
                                    height: 50,
                                    width: 50,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      const Positioned(
                          left: 0,
                          right: 0,
                          bottom: -48,
                          child: CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.close,
                              color: Colors.black,
                            ),
                          ))
                    ],
                  ),
                ),
              ),
            ),
          )).then(onClosed);
}
