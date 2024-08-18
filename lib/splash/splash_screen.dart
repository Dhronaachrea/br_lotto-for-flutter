import 'dart:developer';
import 'dart:io';

import 'package:br_lotto/l10n/l10n.dart';
import 'package:br_lotto/utility/widgets/version_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:velocity_x/velocity_x.dart';

import '../utility/br_lotto_pos_color.dart';
import '../utility/br_lotto_pos_screens.dart';
import '../utility/user_info.dart';
import '../utility/widgets/br_lotto_pos_scaffold.dart';
import '../utility/widgets/show_snackbar.dart';
import 'bloc/splash_bloc.dart';
import 'bloc/splash_event.dart';
import 'bloc/splash_state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  static const Channel = MethodChannel('com.brlotto.br_lotto/loader_inner_bg');
  PackageInfo? packageInfo;
  late final AnimationController _blinker1AnimationController;
  late final Animation<double> _blinker1Animation;

  late final AnimationController _blinker2AnimationController;
  late final Animation<double> _blinker2Animation;

  late final AnimationController _blinker3AnimationController;
  late final Animation<double> _blinker3Animation;

  late final AnimationController _blinker4AnimationController;
  late final Animation<double> _blinker4Animation;

  late final AnimationController _blinker5AnimationController;
  late final Animation<double> _blinker5Animation;

  ValueNotifier<bool> myVariable = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    /*SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack, overlays: [SystemUiOverlay.top]);*/
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    _blinker1AnimationController = AnimationController(
        duration: const Duration(milliseconds: 100), vsync: this);
    _blinker1Animation =
        Tween<double>(begin: 1, end: 0).animate(_blinker1AnimationController)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _blinker1AnimationController.reset();
              // print("AnimationStatus.completed");
            } else if (status == AnimationStatus.dismissed) {
              _blinker2AnimationController.forward();
              // print("AnimationStatus.dismissed BLINKER 1");
            }
          });

    _blinker2AnimationController = AnimationController(
        duration: const Duration(milliseconds: 100), vsync: this);
    _blinker2Animation =
        Tween<double>(begin: 1, end: 0).animate(_blinker2AnimationController)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _blinker2AnimationController.reset();
              // print("AnimationStatus.completed");
            } else if (status == AnimationStatus.dismissed) {
              _blinker3AnimationController.forward();
              // print("AnimationStatus.dismissed  BLINKER 2");
            }
          });

    _blinker3AnimationController = AnimationController(
        duration: const Duration(milliseconds: 100), vsync: this);
    _blinker3Animation =
        Tween<double>(begin: 1, end: 0).animate(_blinker3AnimationController)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _blinker3AnimationController.reset();
              // print("AnimationStatus.completed");
            } else if (status == AnimationStatus.dismissed) {
              _blinker4AnimationController.forward();
              // print("AnimationStatus.dismissed  BLINKER 3");
            }
          });

    _blinker4AnimationController = AnimationController(
        duration: const Duration(milliseconds: 100), vsync: this);
    _blinker4Animation =
        Tween<double>(begin: 1, end: 0).animate(_blinker4AnimationController)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _blinker4AnimationController.reset();
              // print("AnimationStatus.completed");
            } else if (status == AnimationStatus.dismissed) {
              _blinker5AnimationController.forward();
              // print("AnimationStatus.dismissed  BLINKER 4");
            }
          });

    _blinker5AnimationController = AnimationController(
        duration: const Duration(milliseconds: 100), vsync: this);
    _blinker5Animation =
        Tween<double>(begin: 1, end: 0).animate(_blinker5AnimationController)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _blinker5AnimationController.reset();
              // print("AnimationStatus.completed");
            } else if (status == AnimationStatus.dismissed) {
              _blinker1AnimationController.forward();
              // print("AnimationStatus.dismissed  BLINKER 5");
            }
          });

    Future.delayed(const Duration(seconds: 1), () {
      _blinker1AnimationController.forward();
    });
    //initPlatform();
    BlocProvider.of<SplashBloc>(context)
        .add(VersionControlApi(context: context));
   /* Future.delayed(const Duration(seconds: 2), () {
      UserInfo.isLoggedIn()
          ? Navigator.pushReplacementNamed(context, BrLottoPosScreen.homeScreen)
          : Navigator.pushReplacementNamed(
              context, BrLottoPosScreen.loginScreen);
    });*/
  }
  @override
  void dispose() {
    _blinker1AnimationController.dispose();
    _blinker2AnimationController.dispose();
    _blinker3AnimationController.dispose();
    _blinker4AnimationController.dispose();
    _blinker5AnimationController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashBloc, SplashState>(
      listener: (context, state) {
        if (state is VersionControlLoading) {
          myVariable.value = true;
          log("Platform.version: -------------- VersionControlLoading");
        } else if (state is VersionControlSuccess) {
          myVariable.value = false;
          final upcomingVersion = int.parse(state
                  .response?.responseData?.data?.version
                  ?.replaceAll(".", "") ??
              "0");
          final currentVersion =
              int.parse(packageInfo?.version.replaceAll(".", "") ?? "0");
          if (upcomingVersion > currentVersion) {
            String message = context.l10n.version_num_is_available(state.response?.responseData?.data?.version as Object);
                //"Version ${state.response?.responseData?.data?.version} is available.";
            if (state.response?.responseData?.data?.downloadUrl?.isNotEmpty ==
                true) {
              VersionAlert.show(
                context: context,
                type: state.response?.responseData?.data?.isMandatory == "YES"
                    ? VersionAlertType.mandatory
                    : VersionAlertType.optional,
                message: message,
                onCancel: () {
                  //BlocProvider.of<SplashBloc>(context).add(GetConfigData(context: context));
                  _moveToNextScreen();
                },
                onUpdate: () async {
                  if (Platform.isAndroid) {
                    _downloadUpdatedAPK(
                      //"https://smartelist4u.pythonanywhere.com/media/br_lotto_27Sep2023_v2_Rg5ATjQ.apk",
                         state.response?.responseData?.data?.downloadUrl ?? "",
                        context);
                  } else {
                    _moveToNextScreen();
                  }
                },
              );
            }
          } else {
            //BlocProvider.of<SplashBloc>(context).add(GetConfigData(context: context));
            _moveToNextScreen();
          }
        } else if (state is VersionControlError) {
          myVariable.value = true;
          ShowToast.showToast(context, state.errorMsg, type: ToastType.ERROR);
          _moveToNextScreen();
        }
      },
      child: FutureBuilder<void>(
        future: initPlatform(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/splash_bg.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return BrLottoPosScaffold(
                  body: Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/splash_bg.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: MediaQuery.of(context).size.height / 3.5,
                        left: MediaQuery.of(context).size.width / 4,
                        child: ValueListenableBuilder<bool>(
                          valueListenable: myVariable,
                          builder: (context, value, child) {
                            return Visibility(
                              visible: value,
                              child: SizedBox(
                                height: 50,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Stack(
                                      children: [
                                        Container(
                                          width: 18,
                                          height: 18,
                                          decoration: BoxDecoration(
                                            color: BrLottoPosColor
                                                .navy_blue,
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(
                                                20,
                                              ),
                                            ),
                                            border: Border.all(
                                                color:
                                                    BrLottoPosColor.game_color_blue,
                                                width: 2),
                                            boxShadow: const [
                                              BoxShadow(
                                                  color: BrLottoPosColor
                                                      .navy_blue,
                                                  blurRadius: 10.0)
                                            ],
                                          ),
                                        ).p(8),
                                        FadeTransition(
                                          opacity: _blinker1Animation,
                                          child: Container(
                                            width: 18,
                                            height: 18,
                                            decoration: BoxDecoration(
                                              color: BrLottoPosColor.white,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(20),
                                              ),
                                              border: Border.all(
                                                  color:
                                                      BrLottoPosColor.game_color_blue,
                                                  width: 2),
                                              boxShadow: const [
                                                BoxShadow(
                                                    color: BrLottoPosColor
                                                        .navy_blue,
                                                    blurRadius: 10.0)
                                              ],
                                            ),
                                          ).p(8),
                                        ),
                                      ],
                                    ),
                                    Stack(
                                      children: [
                                        Container(
                                          width: 18,
                                          height: 18,
                                          decoration: BoxDecoration(
                                            color: BrLottoPosColor
                                                .navy_blue,
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(20),
                                            ),
                                            border: Border.all(
                                                color:
                                                    BrLottoPosColor.game_color_blue,
                                                width: 2),
                                            boxShadow: const [
                                              BoxShadow(
                                                  color: BrLottoPosColor
                                                      .navy_blue,
                                                  blurRadius: 10.0)
                                            ],
                                          ),
                                        ).p(8),
                                        FadeTransition(
                                          opacity: _blinker2Animation,
                                          child: Container(
                                            width: 18,
                                            height: 18,
                                            decoration: BoxDecoration(
                                              color: BrLottoPosColor.white,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(20),
                                              ),
                                              border: Border.all(
                                                  color:
                                                      BrLottoPosColor.game_color_blue,
                                                  width: 2),
                                              boxShadow: const [
                                                BoxShadow(
                                                    color: BrLottoPosColor
                                                        .navy_blue,
                                                    blurRadius: 10.0)
                                              ],
                                            ),
                                          ).p(8),
                                        ),
                                      ],
                                    ),
                                    Stack(children: [
                                      Container(
                                          width: 18,
                                          height: 18,
                                          decoration: BoxDecoration(
                                              color: BrLottoPosColor
                                                  .navy_blue,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(20)),
                                              border: Border.all(
                                                  color:
                                                      BrLottoPosColor.game_color_blue,
                                                  width: 2),
                                              boxShadow: const [
                                                BoxShadow(
                                                    color: BrLottoPosColor
                                                        .navy_blue,
                                                    blurRadius: 10.0)
                                              ])).p(8),
                                      FadeTransition(
                                        opacity: _blinker3Animation,
                                        child: Container(
                                            width: 18,
                                            height: 18,
                                            decoration: BoxDecoration(
                                                color: BrLottoPosColor.white,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(20)),
                                                border: Border.all(
                                                    color: BrLottoPosColor
                                                        .game_color_blue,
                                                    width: 2),
                                                boxShadow: const [
                                                  BoxShadow(
                                                      color: BrLottoPosColor
                                                          .navy_blue,
                                                      blurRadius: 10.0)
                                                ])).p(8),
                                      ),
                                    ]),
                                    Stack(children: [
                                      Container(
                                        width: 18,
                                        height: 18,
                                        decoration: BoxDecoration(
                                          color: BrLottoPosColor
                                              .navy_blue,
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(20),
                                          ),
                                          border: Border.all(
                                              color: BrLottoPosColor.game_color_blue,
                                              width: 2),
                                          boxShadow: const [
                                            BoxShadow(
                                                color: BrLottoPosColor
                                                    .navy_blue,
                                                blurRadius: 10.0)
                                          ],
                                        ),
                                      ).p(8),
                                      FadeTransition(
                                        opacity: _blinker4Animation,
                                        child: Container(
                                          width: 18,
                                          height: 18,
                                          decoration: BoxDecoration(
                                            color: BrLottoPosColor.white,
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(20),
                                            ),
                                            border: Border.all(
                                                color:
                                                    BrLottoPosColor.game_color_blue,
                                                width: 2),
                                            boxShadow: const [
                                              BoxShadow(
                                                  color: BrLottoPosColor
                                                      .navy_blue,
                                                  blurRadius: 10.0)
                                            ],
                                          ),
                                        ).p(8),
                                      ),
                                    ]),
                                    Stack(children: [
                                      Container(
                                        width: 18,
                                        height: 18,
                                        decoration: BoxDecoration(
                                          color: BrLottoPosColor
                                              .navy_blue,
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(20),
                                          ),
                                          border: Border.all(
                                              color: BrLottoPosColor.game_color_blue,
                                              width: 2),
                                          boxShadow: const [
                                            BoxShadow(
                                                color: BrLottoPosColor
                                                    .navy_blue,
                                                blurRadius: 10.0)
                                          ],
                                        ),
                                      ).p(8),
                                      FadeTransition(
                                        opacity: _blinker5Animation,
                                        child: Container(
                                          width: 18,
                                          height: 18,
                                          decoration: BoxDecoration(
                                            color: BrLottoPosColor.white,
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(20),
                                            ),
                                            border: Border.all(
                                                color:
                                                    BrLottoPosColor.game_color_blue,
                                                width: 2),
                                            boxShadow: const [
                                              BoxShadow(
                                                  color: BrLottoPosColor
                                                      .navy_blue,
                                                  blurRadius: 10.0)
                                            ],
                                          ),
                                        ).p(8),
                                      ),
                                    ]),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                );
              }
            case ConnectionState.none:
              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/splash_bg.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            case ConnectionState.active:
              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/splash_bg.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            default:
              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/splash_bg.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              );
          }
        },
      ),
      /*BrLottoPosScaffold(
          body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/splash_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        // child: Center(
        //   child: Center(
        //     child: Image.asset(
        //       width : 300,
        //       height: 300,
        //       "assets/images/splash_logo.png",
        //     ),
        //   ),
        // )
      )),*/
    );
  }

  Future<void> initPlatform() async {
    packageInfo = await PackageInfo.fromPlatform();
    print("packageInfo: ${packageInfo?.version}");
  }

  _moveToNextScreen() {
    UserInfo.isLoggedIn()
        ? Navigator.pushReplacementNamed(context, BrLottoPosScreen.homeScreen)
        : Navigator.pushReplacementNamed(context, BrLottoPosScreen.loginScreen);
  }

  Future<void> _downloadUpdatedAPK(String url, BuildContext context) async {
    try {
      Map<String, String> arg = {
        "url": url,
      };

      final dynamic receivedResponse =
          await Channel.invokeMethod('_downloadUpdatedAPK', arg);
      print("receivedResponse --> $receivedResponse");
    } on PlatformException catch (e) {
      //Navigator.of(context).pop();
      ShowToast.showToast(context, "${e.message}", type: ToastType.ERROR);
      print("-------- $e");
    }
  }
}
