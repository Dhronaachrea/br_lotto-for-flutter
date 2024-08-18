import 'package:br_lotto/l10n/l10n.dart';
import 'package:br_lotto/utility/app_constant.dart';
import 'package:br_lotto/utility/br_lotto_pos_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../login/bloc/login_bloc.dart';
import '../../login/login_screen.dart';
import '../../utility/auth_bloc/auth_bloc.dart';
import '../../utility/user_info.dart';
import '../../utility/utils.dart';
import '../../utility/widgets/primary_button.dart';

class BrLottoAppBar extends StatefulWidget implements PreferredSizeWidget {
  const BrLottoAppBar({
    this.myKey,
    Key? key,
    this.title,
    this.showBalance,
    this.showBell,
    this.showDrawer,
    this.appBackGroundColor,
    this.showBottomAppBar = false,
    this.showLoginBtnOnAppBar = true,
    this.centeredTitle = false,
    this.bottomTapvalue,
    this.bottomTapLoginValue,
    this.onBackButton,
    this.mAppBarBalanceChipVisible,
    this.isHomeScreen
  }) : super(key: key);

  final GlobalKey<ScaffoldState>? myKey;
  final String? title;
  final bool? bottomTapvalue;
  final bool? bottomTapLoginValue;
  final bool? showDrawer;
  final bool? showBalance;
  final bool? showBell;
  final Color? appBackGroundColor;
  final bool? showBottomAppBar;
  final bool? showLoginBtnOnAppBar;
  final bool? centeredTitle;
  final VoidCallback? onBackButton;
  final bool? mAppBarBalanceChipVisible;
  final bool? isHomeScreen;

  // final bool? signin;
  @override
  State<BrLottoAppBar> createState() => _LongaAppBarState();

  @override
  Size get preferredSize => showBottomAppBar == false
      ? const Size(double.infinity, kToolbarHeight)
      : const Size(double.infinity, kToolbarHeight * 2);
}

class _LongaAppBarState extends State<BrLottoAppBar> {
  bool? isUserLoggedIn;
  late Map<String, dynamic> prefs;

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance!.addPostFrameCallback((_) {
    //   var currentPage = ModalRoute.of(context)?.settings.name;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      /*String? cashBalance =(context.watch<AuthBloc>().cashBalance ?? UserInfo.cashBalance).toString();*/

      return AppBar(
        titleSpacing: 0,
        backgroundColor: widget.appBackGroundColor ?? (widget.isHomeScreen == true ?  Colors.transparent : BrLottoPosColor.light_navy),
        elevation: 0,
        title: Container(
          alignment: Alignment.centerLeft,
          width: MediaQuery.of(context).size.width,
          height: 50,
          child: Row(
            children: [
              widget.isHomeScreen == true
                  ? const CircleAvatar(
                  backgroundImage: AssetImage('assets/icons/scratch.png'),
                )
                  : const SizedBox(),
              widget.isHomeScreen == true ? const SizedBox(width: 5) : const SizedBox(),
              Expanded(
                child: Text(
                  widget.isHomeScreen == true ? context.l10n.scratch ?? "Scratch": widget.title != null ? widget.title! : '',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: widget.isHomeScreen == true ? BrLottoPosColor.black: BrLottoPosColor.white,
                      fontWeight: widget.isHomeScreen == true ? FontWeight.w700 : FontWeight.w300,
                      fontStyle: FontStyle.normal,
                      fontFamily: bauhousFont,
                      fontSize:  widget.isHomeScreen == true? 23.0 : 14 ),
                ),
              ),
            ],
          ),
        ),
        leading: Visibility(
          visible: widget.showDrawer ?? true,
          child: widget.title == null
              ? MaterialButton(
                  padding: const EdgeInsets.all(10),
                  minWidth: 0,
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  child: Image.asset("assets/icons/drawer.png",width: 30, height : 30,),
                )
              : MaterialButton(
                  onPressed: () {
                    widget.onBackButton != null ? widget.onBackButton!() : Navigator.of(context).pop();
                  },
                  child: SvgPicture.asset("assets/icons/back_icon.svg",
                      color: BrLottoPosColor.white),
                ),
        ),
        actions: [
          widget.mAppBarBalanceChipVisible != null && widget.mAppBarBalanceChipVisible!
            ? Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            margin: const EdgeInsets.all(6),
            decoration: widget.isHomeScreen == true ? BoxDecoration(
              color: BrLottoPosColor.light_navy_blue.withOpacity(0.7),
              border: Border.all(color: BrLottoPosColor.white),
              borderRadius: const BorderRadius.all(Radius.circular(30))
            ) : null,
            child: Center(
              child: RichText(
                textAlign: TextAlign.right,
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
                    TextSpan(
                        text: '${UserInfo.userName.toUpperCase()}\n',
                        style:  const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: BrLottoPosColor.white, //widget.isHomeScreen == true ? BrLottoPosColor.brownish_grey: BrLottoPosColor.white,
                        )),
                    TextSpan(
                        text:
                            '${UserInfo.totalBalance}${getDefaultCurrency(getLanguage())}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: BrLottoPosColor.marigold,
                        ))
                  ],
                ),
              ),
            ),
          )
            : Container()
        ],
      );
    });
  }

  Future _loginOrSignUp() {
    return showDialog(
        context: context,
        builder: (context) => BlocProvider<LoginBloc>(
              create: (context) => LoginBloc(),
              child: const LoginScreen(),
            )
        // builder: (context) => const SignUp(),
        // builder: (context) => const OtpScreen(),
        );
  }
}
