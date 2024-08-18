import 'dart:async';
import 'package:br_lotto/home/bloc/home_bloc.dart';
import 'package:br_lotto/home/home_screen.dart';
import 'package:br_lotto/l10n/l10n.dart';
import 'package:br_lotto/utility/FadeRoute.dart';
import 'package:br_lotto/utility/app_constant.dart';
import 'package:br_lotto/utility/br_lotto_text_field.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velocity_x/velocity_x.dart';

import '../main.dart';
import '../utility/br_lotto_pos_color.dart';
import '../utility/br_lotto_pos_screens.dart';
import '../utility/user_info.dart';
import '../utility/utils.dart';
import '../utility/widgets/shake_animation.dart';
import '../utility/widgets/show_snackbar.dart';
import 'bloc/login_bloc.dart';
import 'bloc/login_event.dart';
import 'bloc/login_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  late FlipCardController controller;
  late AnimationController scaleController;
  late Animation<double> scaleAnimation;

  //bool isEnLang                             = true;
  TextEditingController userController      = TextEditingController();
  TextEditingController passController      = TextEditingController();
  ShakeController usernameShakeController   = ShakeController();
  ShakeController passShakeController       = ShakeController();
  bool obscurePass                          = true;
  bool isGenerateOtpButtonPressed           = false;
  bool isLoggingIn                          = false;
  bool isLoggingInDone                      = false;
  final _loginForm                          = GlobalKey<FormState>();
  var autoValidate                          = AutovalidateMode.disabled;
  double mAnimatedButtonWidth               = 280.0;
  double mAnimatedButtonHeight              = 50.0;
  double bannerHeight                       = 0.0;
  bool mButtonTextVisibility                = true;
  ButtonShrinkStatus mButtonShrinkStatus    = ButtonShrinkStatus.notStarted;
  FocusNode usernameFocusNode               = FocusNode();
  FocusNode passwordFocusNode               = FocusNode();

  @override
  void initState() {
    controller = FlipCardController();
    scaleController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Navigator.pushAndRemoveUntil(context, FadeRoute(
              page: MultiBlocProvider(
                  providers: [
                    BlocProvider<HomeBloc>(
                      create: (BuildContext context) => HomeBloc(),
                    )
                  ],
                  child: const HomeScreen()
              )), (Route<dynamic> route) => false);
        }
      });
    scaleAnimation = Tween<double>(begin: 1.0, end: 30.0).animate(scaleController);
    usernameFocusNode.requestFocus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String selectedLang = BrLottoRetailApp.of(context).locale.languageCode;
    return BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {

          if (state is LoginTokenLoading) {
            setState(() {
              isLoggingIn = true;
              isLoggingInDone = false;
            });
          }
          if (state is LoginTokenSuccess) {
            BlocProvider.of<LoginBloc>(context)
                .add(GetLoginDataApi(context: context));
          }
          else if (state is LoginTokenError) {
            resetLoader();
            setState(() {
              isLoggingIn = false;
            });
            ShowToast.showToast(context, state.errorMessage.toString(),
                type: ToastType.ERROR);
          }
          else if (state is GetLoginDataError) {
            resetLoader();
            setState(() {
              isLoggingIn = false;
            });
            UserInfo.setPlayerToken("");
            UserInfo.setPlayerId("");
            ShowToast.showToast(context, state.errorMessage.toString(),
                type: ToastType.ERROR);
          }
          else if (state is GetLoginDataSuccess) {
            setState(() {
              isLoggingInDone = true;
            });
            scaleController.forward();
          }
          else if (state is VerifyPosSuccess) {
            Navigator.of(context).pushNamedAndRemoveUntil(
                BrLottoPosScreen.homeScreen, (Route<dynamic> route) => false);
          }
          else if (state is VerifyPosError) {
            resetLoader();
            setState(() {
              isLoggingIn = false;
            });
            ShowToast.showToast(context, state.errorMessage,
                type: ToastType.ERROR);
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body:SafeArea(
            child: Form(
              key: _loginForm,
              autovalidateMode: autoValidate,
              child: Stack(children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/login_header.png"),
                            fit: BoxFit.fill,
                          ),
                        ),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 2.5,
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 50),
                              child: Center(
                                child: Image.asset(
                                  width: 200,
                                  height: 140,
                                  "assets/images/login_logo.png",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            child: Center(
                                child: Text(
                                  context.l10n.login_title,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontFamily: bauhousFont,
                                      fontSize: 30),
                                  textAlign: TextAlign.center,
                                )),
                          ),
                          _userTextField(),
                          _passTextField(),
                          _submitButton()
                        ],
                      ).pOnly(left: 30, right: 30)
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    width: 100,
                    height: 25,
                    decoration: BoxDecoration(
                        color: BrLottoPosColor.white,
                        border: Border.all(color: BrLottoPosColor.light_grey, width: 1),
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                BrLottoRetailApp.of(context)
                                    .setLocale(const Locale('en', 'UK'));
                              });
                            },
                            child: Container(
                              height: 25,
                              decoration: BoxDecoration(
                                  color: selectedLang == 'en'
                                      ? BrLottoPosColor.shamrock_green
                                      : BrLottoPosColor.white,
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      bottomLeft: Radius.circular(20))),
                              child: Center(
                                child: Text(
                                  "En",
                                  style: TextStyle(
                                      color: selectedLang == 'en'
                                          ? BrLottoPosColor.white
                                          : BrLottoPosColor.game_color_grey,
                                      fontSize: selectedLang == 'en' ? 14 : 10,
                                      fontFamily: noirFont,
                                      fontWeight: selectedLang == 'en'
                                          ? FontWeight.w300
                                          : null),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 0.5,
                          color: BrLottoPosColor.light_grey,
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                BrLottoRetailApp.of(context)
                                    .setLocale(const Locale('fr','FR'));
                              });
                            },
                            child: Container(
                              height: 25,
                              decoration: BoxDecoration(
                                  color: selectedLang == 'en'
                                      ? BrLottoPosColor.white
                                      : BrLottoPosColor.shamrock_green,
                                  borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(20),
                                      bottomRight: Radius.circular(20))),
                              child: Center(
                                child: Text(
                                  "Pt",
                                  style: TextStyle(
                                      color: selectedLang == 'en'
                                          ? BrLottoPosColor.game_color_grey
                                          : BrLottoPosColor.white,
                                      fontSize: selectedLang == 'en' ? 10 : 14,
                                      fontFamily: noirFont,
                                      fontWeight: selectedLang == 'en'
                                          ? null
                                          : FontWeight.w300),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ).pOnly(left: 10, right: 10)
                ).pOnly(top: MediaQuery.of(context).size.height * 0.02, right: 10),
              ]),
            ),
          ),
        )
        );
  }

  _userTextField() {
    return ShakeWidget(
      controller: usernameShakeController,
      child: BrLottoTextField(
        maxLength: 22,
        inputType: TextInputType.text,
        hintText: context.l10n.username,
        controller: userController,
        focusNode: usernameFocusNode,
        textStyle: const TextStyle(
          fontFamily: noirFont
        ),
        onEditingComplete: () {
          if(userController.text.isNotEmpty && passController.text.isEmpty) {
            passwordFocusNode.requestFocus();
          } else {
            proceedToLogin();
          }
        },
        validator: (value) {
          if (validateInput(TotalTextFields.userName).isNotEmpty) {
            if (isGenerateOtpButtonPressed) {
              usernameShakeController.shake();
            }
            return validateInput(TotalTextFields.userName);
          } else {
            return null;
          }
        },
        // isDarkThemeOn: isDarkThemeOn,
      ).pSymmetric(v: 8),
    );
  }

  _passTextField() {
    return ShakeWidget(
      controller: passShakeController,
      child: BrLottoTextField(
        hintText: context.l10n.password,
        controller: passController,
        maxLength: 16,
        focusNode: passwordFocusNode,
        inputType: TextInputType.text,
        obscureText: obscurePass,
        textStyle: const TextStyle(
            fontFamily: noirFont
        ),
        onEditingComplete: () {
          proceedToLogin();
        },
        validator: (value) {
          if (validateInput(TotalTextFields.password).isNotEmpty) {
            if (isGenerateOtpButtonPressed) {
              passShakeController.shake();
            }
            return validateInput(TotalTextFields.password);
          } else {
            return null;
          }
        },
        suffixIcon: IconButton(
          icon: Icon(
            obscurePass ? Icons.visibility_off : Icons.remove_red_eye_rounded,
            color: BrLottoPosColor.black_four,
          ),
          onPressed: () {
            setState(() {
              obscurePass = !obscurePass;
            });
          },
        ),
        // isDarkThemeOn: isDarkThemeOn,
      ).pSymmetric(v: 8),
    );
  }

  _submitButton() {
    return AbsorbPointer(
      absorbing: isLoggingIn,
      child: InkWell(
        onTap: () {
          proceedToLogin();
        },
        child: AnimatedBuilder(
          animation: scaleAnimation,
          builder: (context, child) => Transform.scale(scale: scaleAnimation.value,
          child: Container(
              decoration: BoxDecoration(
                  color: BrLottoPosColor.br_lotto_green,
                  borderRadius: isLoggingIn ? BorderRadius.circular(60) : BorderRadius.circular(10)),
              child: AnimatedContainer(
                width: mAnimatedButtonWidth,
                height: 50,
                onEnd: () {
                  setState(() {
                    if (mButtonShrinkStatus != ButtonShrinkStatus.over) {
                      mButtonShrinkStatus = ButtonShrinkStatus.started;
                    } else {
                      mButtonShrinkStatus = ButtonShrinkStatus.notStarted;
                    }
                  });
                },
                curve: Curves.easeIn,
                duration: const Duration(milliseconds: 200),
                child: SizedBox(
                    width: mAnimatedButtonWidth,
                    height: mAnimatedButtonHeight,
                    child: mButtonShrinkStatus == ButtonShrinkStatus.started
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: isLoggingInDone
                                  ? Container()
                                  : const CircularProgressIndicator(
                                      color: BrLottoPosColor.white)
                          )
                        : Center(
                            child: Visibility(
                            visible: mButtonTextVisibility,
                            child: Text(
                              context.l10n.login_title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontFamily: 'noir',
                                color: BrLottoPosColor.white,
                              ),
                            ),
                          ))),
              )),
      ),
        ),
    ).pOnly(top: 30)
    );
  }

  String validateInput(TotalTextFields textField) {
    switch (textField) {
      case TotalTextFields.userName:
        var mobText = userController.text.trim();
        if (mobText.isEmpty) {
          return context.l10n.please_enter_your_username;
        }
        break;

      case TotalTextFields.password:
        var passText = passController.text.trim();
        if (passText.isEmpty) {
          return context.l10n.please_enter_your_password;
        } else if (passText.length <= 7) {
          return context.l10n.password_should_be_in_range_min_8;
        }
        break;
    }
    return "";
  }

  resetLoader() {
    mAnimatedButtonWidth = 280.0;
    mButtonTextVisibility = true;
    mButtonShrinkStatus = ButtonShrinkStatus.over;
  }

  void proceedToLogin() {
    FocusScope.of(context).unfocus();
    setState(() {
      isGenerateOtpButtonPressed = true;
    });
    Timer(const Duration(milliseconds: 500), () {
      setState(() {
        isGenerateOtpButtonPressed = false;
      });
    });
    if (_loginForm.currentState!.validate()) {
      var userName = userController.text.trim();
      var password = passController.text.trim();

      setState(() {
        mAnimatedButtonWidth = 50.0;
        mButtonTextVisibility = false;
        mButtonShrinkStatus = ButtonShrinkStatus.notStarted;
      });
      BlocProvider.of<LoginBloc>(context).add(LoginTokenApi(
          context: context, userName: userName, password: password));
    } else {
      setState(() {
        autoValidate = AutovalidateMode.onUserInteraction;
      });
    }
  }
}

class CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    int curveHeight = 70;
    Offset controlPoint = Offset(size.width / 2, size.height + curveHeight);
    Offset endPoint = Offset(size.width, size.height - curveHeight);

    Path path = Path()
      ..lineTo(0, size.height - curveHeight)
      ..quadraticBezierTo(
          controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy)
      ..lineTo(size.width, 0)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
