import 'package:br_lotto/routes/app_routes.dart';
import 'package:br_lotto/utility/auth_bloc/auth_bloc.dart';
import 'package:br_lotto/utility/logging.dart';
import 'package:br_lotto/utility/shared_pref.dart';
import 'package:br_lotto/utility/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'login/bloc/login_bloc.dart';

void main() async {
  setupLogging();
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefUtils.init();
  initializeModelCode();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) => AuthBloc(),
      ),
      BlocProvider(
        create: (context) => LoginBloc(),
      ),
    ],
    child: const BrLottoRetailApp(),
  ));
}

class BrLottoRetailApp extends StatefulWidget {
  const BrLottoRetailApp({Key? key}) : super(key: key);

  static BrLottoRetailAppState of(BuildContext context) =>
      context.findAncestorStateOfType<BrLottoRetailAppState>()!;

  @override
  State<BrLottoRetailApp> createState() => BrLottoRetailAppState();
}

class BrLottoRetailAppState extends State<BrLottoRetailApp> {
  final AppRoute mWlsPosRoute = AppRoute();


  Locale _locale = const Locale('en', 'UK');

  Locale get locale => _locale;

  void setLocale(Locale value) {
    setState(() {
      _locale = value;
    });
  }

  Locale getLocale() {
    return _locale;
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<AuthBloc>(context).add(AppStarted());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        scaffoldMessengerKey: SnackbarGlobal.key,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: _locale,
        theme: ThemeData(fontFamily: 'noir'),
        debugShowCheckedModeBanner: false,
        onGenerateRoute: (setting) => mWlsPosRoute.router(setting),
        navigatorKey: navigatorKey);
  }
}
