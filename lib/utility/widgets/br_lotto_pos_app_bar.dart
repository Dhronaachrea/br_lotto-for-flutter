import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../login/models/response/GetLoginDataResponse.dart';
import '../auth_bloc/auth_bloc.dart';
import '../br_lotto_pos_color.dart';
import '../user_info.dart';
import '../utils.dart';

class BrLottoPosAppBar extends StatefulWidget
    implements PreferredSizeWidget {
  const BrLottoPosAppBar({
    this.myKey,
    Key? key,
    this.title = const Text(''),
    this.showBalance,
    this.showBell,
    this.showDrawer,
    this.backgroundColor,
    this.showBottomAppBar = false,
    this.centeredTitle = false,
    this.bottomTapvalue,
    this.bottomTapLoginValue,
    this.onBackButton,
    this.isHomeScreen,
  }) : super(key: key);

  final GlobalKey<ScaffoldState>? myKey;
  final Widget? title;
  final bool? bottomTapvalue;
  final bool? bottomTapLoginValue;
  final bool? showDrawer;
  final bool? showBalance;
  final bool? showBell;
  final Color? backgroundColor;
  final bool? showBottomAppBar;
  final bool? centeredTitle;
  final bool? isHomeScreen;
  final VoidCallback? onBackButton;

  @override
  State<BrLottoPosAppBar> createState() => _LongaLottoPosAppBarState();

  @override
  Size get preferredSize => showBottomAppBar == false
      ? const Size(double.infinity, kToolbarHeight + 10)
      : const Size(double.infinity, kToolbarHeight * 2);
}

class _LongaLottoPosAppBarState extends State<BrLottoPosAppBar> {
  bool? isUserLoggedIn;
  late Map<String, dynamic> prefs;

  Data? userInfo;

  @override
  void initState() {
    userInfo = Data?.fromJson(jsonDecode(UserInfo.getUserInfo));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("updating app bar");
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return AppBar(
          centerTitle: widget.centeredTitle,
          backgroundColor: BrLottoPosColor.golden_rod,
          elevation: 0,
          titleSpacing: 0,
          title: widget.isHomeScreen == true
              ? Image.asset("assets/images/splash_logo.webp",
                  width: 70, height: 70)
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /* const CircleAvatar(
                    backgroundImage: AssetImage('assets/icons/SCRATCH.png'),
                  ),
                  const SizedBox(width: 5),*/
                    widget.title ?? const Text(''),
                  ],
                ),
          leading: Visibility(
            visible: widget.showDrawer ?? true,
            child: widget.isHomeScreen ?? true
                ? MaterialButton(
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    child: SvgPicture.asset("assets/icons/drawer.png",
                        color: BrLottoPosColor.white),
                  )
                : MaterialButton(
                    onPressed: () {
                      widget.onBackButton != null
                          ? widget.onBackButton!()
                          : Navigator.of(context).pop();
                    },
                    child: SvgPicture.asset("assets/icons/back_icon.svg",
                        color: BrLottoPosColor.white,
                        width: 5,
                        height: 25,
                        fit: BoxFit.contain)),
          ),
          actions: [
            RichText(
              textAlign: TextAlign.right,
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  const TextSpan(
                      text: 'Balance\n',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: BrLottoPosColor.white_five)),
                  TextSpan(
                      text:
                          '${UserInfo.totalBalance ?? 0.0} ${getDefaultCurrency(getLanguage())}',
                      style: const TextStyle(color: BrLottoPosColor.white)),
                ],
              ),
            ).p(10)
          ],
        );
      },
    );
  }
}
