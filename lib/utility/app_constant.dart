import 'package:br_lotto/utility/utils.dart';

import '../main.dart';

const lotteryModuleCode       = "DRAW_GAME";
const scratchModuleCode       = "SCRATCH";
const scanAndPlay       = "ScanAndPlay";
const sportsModuleCode        = "SLE";
const reportModuleCode        = "REPORTS";
const organizationModuleCode  = "USERS";
const clientId                = "RMS";
const scratchClientId         = "SCRATCH";
const merchantCode            = "INFINITI";
const purchaseChannel         = "RETAIL";
const merchantPwd             = "ph2Nj5knd4IjWBVLc4mhmYHo1hQDEdS3FlIC2KskHpeHFhsqxD";// clientSecret
const scratchClientSecret     = "9zqCUcnFxrFBPeqLwkO92DJcDZVnL1"; //"13f1JiFyWSZ0XI/3Plxr3mv7gbNObpU2";
const loginToken              = "duneZvJEQi5slDeevoVUEZOmE6pvVcl9MWVFED4lWaA";
const rmsMerchantId           = 1;
const orgTypeCode           = "RET";
const appType               = "Android_Mobile";
const deviceType              = "ANDROID";
const terminal              = "TERMINAL";
const aliasName              = "www.longagames.com";
const responseType              = "QR_CODE";
const serviceCode              = "RMS_COUPON";
const gameCode                = "ALL_GAMES";



const homeModuleCodesList     = {lotteryModuleCode, scratchModuleCode, sportsModuleCode,scanAndPlay};
const drawerModuleCodesList   = {reportModuleCode, organizationModuleCode};
const gamesCode               = ["DailyLotto2", "FiveByFortyNineLottoWeekly"];

//drawer ICONS constant
const PAYMENT_REPORT           = "M_PAYMENT_REPORT";
const OLA_REPORT               = "M_OLA_REPORT";
const CHANGE_PASSWORD          = "M_CHANGE_PASS";
const DEVICE_REGISTRATION      = "M_DEVICE_REGISTRATION";
const LOGOUT                   = "M_LOGOUT";
const BILL_REPORT              = "M_BILL_REPORT";
const M_LEDGER                 = "M_LEDGER";
const USER_REGISTRATION        = "M_USER_REG";
const USER_SEARCH              = "M_USER_SEARCH";
const ACCOUNT_SETTLEMENT       = "M_INTRA_ORG_SETTLEMENT";
const SETTLEMENT_REPORT        = "M_SETTLEMENT_REPORT";
const SALE_WINNING_REPORT      = "M_SALE_REPORT";
const INTRA_ORG_CASH_MGMT      = "M_INTRA_ORG_CASH_MGMT";
const M_SUMMARIZE_LEDGER       = "M_SUMMARIZE_LEDGER";
const COLLECTION_REPORT        = "FIELDEX_COLLECTION";
const ALL_RETAILERS            = "ALL_RETAILERS";
const QR_CODE_REGISTRATION     = "M_QRCODE_REGISTRATION";
const NATIVE_DISPLAY_QR        = "NATIVE_DISPLAY_QR";
const BALANCE_REPORT           = "M_BALANCE_INVOICE_REPORT";
const OPERATIONAL_REPORT       = "M_OPERATIONAL_CASH_REPORT";

//enum
enum GameType {
  game,
  toss,
}

enum ReportType {
  scratch,
  retail,
}

const int totalPriceOption        = 5;
const int numOfBingoCards         =  15;
const double customKeyboardTopPadding = 60;
const int scratchResponseCode = 1000;
const double buttonBorder = 10;
//TicketClaim verifyWinning error responseCodes, where show in success
const List<int> verifyWinSuccessErrorCodes = [1401, 1402, 1431];

const bauhousFont = "bauhaus";
const noirFont    = "noir";