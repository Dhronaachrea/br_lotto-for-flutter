import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen_l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr')
  ];

  /// No description provided for @helloWorld.
  ///
  /// In en, this message translates to:
  /// **'Hello World!'**
  String get helloWorld;

  /// No description provided for @login_title.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login_title;

  /// No description provided for @submit_btn.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit_btn;

  /// No description provided for @select_language.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get select_language;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @please_enter_your_username.
  ///
  /// In en, this message translates to:
  /// **'Please Enter Your Username.'**
  String get please_enter_your_username;

  /// No description provided for @please_enter_your_password.
  ///
  /// In en, this message translates to:
  /// **'Please Enter Your Password.'**
  String get please_enter_your_password;

  /// No description provided for @password_should_be_in_range_min_8.
  ///
  /// In en, this message translates to:
  /// **'Password should be in range(min 8)'**
  String get password_should_be_in_range_min_8;

  /// No description provided for @password_has_been_changed_successFully.
  ///
  /// In en, this message translates to:
  /// **'Password has been Changed SuccessFully.'**
  String get password_has_been_changed_successFully;

  /// No description provided for @change_pin.
  ///
  /// In en, this message translates to:
  /// **'Change Pin'**
  String get change_pin;

  /// No description provided for @new_password.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get new_password;

  /// No description provided for @old_password.
  ///
  /// In en, this message translates to:
  /// **'Old Password'**
  String get old_password;

  /// No description provided for @confirm_password.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirm_password;

  /// No description provided for @proceed.
  ///
  /// In en, this message translates to:
  /// **'PROCEED'**
  String get proceed;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// No description provided for @total_sale.
  ///
  /// In en, this message translates to:
  /// **'Total\nSale'**
  String get total_sale;

  /// No description provided for @total_winning.
  ///
  /// In en, this message translates to:
  /// **'Total\nWinning'**
  String get total_winning;

  /// No description provided for @net_amount.
  ///
  /// In en, this message translates to:
  /// **'Net\nAmount'**
  String get net_amount;

  /// No description provided for @total_comm.
  ///
  /// In en, this message translates to:
  /// **'Total\nCommission'**
  String get total_comm;

  /// No description provided for @user_id.
  ///
  /// In en, this message translates to:
  /// **'User id'**
  String get user_id;

  /// No description provided for @transaction_id.
  ///
  /// In en, this message translates to:
  /// **'Transaction id'**
  String get transaction_id;

  /// No description provided for @comm_amt.
  ///
  /// In en, this message translates to:
  /// **'Comm Amt'**
  String get comm_amt;

  /// No description provided for @bal_amt.
  ///
  /// In en, this message translates to:
  /// **'Bal Amt'**
  String get bal_amt;

  /// No description provided for @no_data_available.
  ///
  /// In en, this message translates to:
  /// **'No Data Available'**
  String get no_data_available;

  /// No description provided for @sale_win_txn_report.
  ///
  /// In en, this message translates to:
  /// **'Sale Win Txn. Report'**
  String get sale_win_txn_report;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @net_amount_label.
  ///
  /// In en, this message translates to:
  /// **'Net Amount'**
  String get net_amount_label;

  /// No description provided for @commission.
  ///
  /// In en, this message translates to:
  /// **'Commission'**
  String get commission;

  /// No description provided for @gross.
  ///
  /// In en, this message translates to:
  /// **'Gross'**
  String get gross;

  /// No description provided for @sale.
  ///
  /// In en, this message translates to:
  /// **'Sale'**
  String get sale;

  /// No description provided for @payment_report.
  ///
  /// In en, this message translates to:
  /// **'Payment Report'**
  String get payment_report;

  /// No description provided for @winning.
  ///
  /// In en, this message translates to:
  /// **'Winning'**
  String get winning;

  /// No description provided for @opening_balance.
  ///
  /// In en, this message translates to:
  /// **'Opening Balance'**
  String get opening_balance;

  /// No description provided for @closing_balance.
  ///
  /// In en, this message translates to:
  /// **'Closing Balance'**
  String get closing_balance;

  /// No description provided for @ledger_report.
  ///
  /// In en, this message translates to:
  /// **'Ledger Report'**
  String get ledger_report;

  /// No description provided for @default_tab.
  ///
  /// In en, this message translates to:
  /// **'default'**
  String get default_tab;

  /// No description provided for @date_wise_tab.
  ///
  /// In en, this message translates to:
  /// **'Date Wise'**
  String get date_wise_tab;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @summarize_ledger_report.
  ///
  /// In en, this message translates to:
  /// **'Summarize Ledger Report'**
  String get summarize_ledger_report;

  /// No description provided for @scratch.
  ///
  /// In en, this message translates to:
  /// **'Scratch'**
  String get scratch;

  /// No description provided for @last_payment_date_is.
  ///
  /// In en, this message translates to:
  /// **'Last payment date is'**
  String get last_payment_date_is;

  /// No description provided for @ticket_number.
  ///
  /// In en, this message translates to:
  /// **'Ticket Number'**
  String get ticket_number;

  /// No description provided for @please_enter_ticket_number.
  ///
  /// In en, this message translates to:
  /// **'Please Enter Ticket Number.'**
  String get please_enter_ticket_number;

  /// No description provided for @printing_started.
  ///
  /// In en, this message translates to:
  /// **'Printing started'**
  String get printing_started;

  /// No description provided for @books.
  ///
  /// In en, this message translates to:
  /// **'Books'**
  String get books;

  /// No description provided for @tickets.
  ///
  /// In en, this message translates to:
  /// **'Tickets'**
  String get tickets;

  /// No description provided for @open_balance.
  ///
  /// In en, this message translates to:
  /// **'Open Balance'**
  String get open_balance;

  /// No description provided for @inventory_flow_report.
  ///
  /// In en, this message translates to:
  /// **'Inventory Flow Report'**
  String get inventory_flow_report;

  /// No description provided for @received.
  ///
  /// In en, this message translates to:
  /// **'Received'**
  String get received;

  /// No description provided for @returned.
  ///
  /// In en, this message translates to:
  /// **'Returned'**
  String get returned;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @close_balance_total_balance.
  ///
  /// In en, this message translates to:
  /// **'Close Balance, Total Balance'**
  String get close_balance_total_balance;

  /// No description provided for @sales.
  ///
  /// In en, this message translates to:
  /// **'Sales'**
  String get sales;

  /// No description provided for @print_cap.
  ///
  /// In en, this message translates to:
  /// **'PRINT'**
  String get print_cap;

  /// No description provided for @printing_success.
  ///
  /// In en, this message translates to:
  /// **'Printing Success'**
  String get printing_success;

  /// No description provided for @printing_failed.
  ///
  /// In en, this message translates to:
  /// **'Printing Failed'**
  String get printing_failed;

  /// No description provided for @you_print_successfully.
  ///
  /// In en, this message translates to:
  /// **'You Print successfully.'**
  String get you_print_successfully;

  /// No description provided for @pack_activation.
  ///
  /// In en, this message translates to:
  /// **'Pack Activation'**
  String get pack_activation;

  /// No description provided for @book_number.
  ///
  /// In en, this message translates to:
  /// **'Book Number'**
  String get book_number;

  /// No description provided for @in_transit.
  ///
  /// In en, this message translates to:
  /// **'In-Transit'**
  String get in_transit;

  /// No description provided for @activated.
  ///
  /// In en, this message translates to:
  /// **'Activated'**
  String get activated;

  /// No description provided for @in_voice.
  ///
  /// In en, this message translates to:
  /// **'In-Voice'**
  String get in_voice;

  /// No description provided for @game_number.
  ///
  /// In en, this message translates to:
  /// **'Game Number'**
  String get game_number;

  /// No description provided for @game_name.
  ///
  /// In en, this message translates to:
  /// **'Game Name'**
  String get game_name;

  /// No description provided for @no_data_available_to_preview.
  ///
  /// In en, this message translates to:
  /// **'No Data Available To Preview'**
  String get no_data_available_to_preview;

  /// No description provided for @pack_return.
  ///
  /// In en, this message translates to:
  /// **'Pack Return'**
  String get pack_return;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success!'**
  String get success;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error!'**
  String get error;

  /// No description provided for @return_note.
  ///
  /// In en, this message translates to:
  /// **'Return Note'**
  String get return_note;

  /// No description provided for @pack_order.
  ///
  /// In en, this message translates to:
  /// **'  Pack Order'**
  String get pack_order;

  /// No description provided for @order_is_successfully_placed_order_number.
  ///
  /// In en, this message translates to:
  /// **'Order is successfully placed.\n Order Number:'**
  String get order_is_successfully_placed_order_number;

  /// No description provided for @select_game_pack_quantity_from_below_list.
  ///
  /// In en, this message translates to:
  /// **'Select game pack quantity from below list'**
  String get select_game_pack_quantity_from_below_list;

  /// No description provided for @price_with_colon.
  ///
  /// In en, this message translates to:
  /// **'Price: '**
  String get price_with_colon;

  /// No description provided for @commission_with_colon.
  ///
  /// In en, this message translates to:
  /// **'Commission: '**
  String get commission_with_colon;

  /// No description provided for @total_pack.
  ///
  /// In en, this message translates to:
  /// **'Total Pack '**
  String get total_pack;

  /// No description provided for @total_amount_symbol.
  ///
  /// In en, this message translates to:
  /// **'Total Amount :'**
  String get total_amount_symbol;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @pack_received.
  ///
  /// In en, this message translates to:
  /// **'Pack Received'**
  String get pack_received;

  /// No description provided for @printingStarted.
  ///
  /// In en, this message translates to:
  /// **'Printing started'**
  String get printingStarted;

  /// No description provided for @inv_flow_report.
  ///
  /// In en, this message translates to:
  /// **'Inventory Flow Report'**
  String get inv_flow_report;

  /// No description provided for @print.
  ///
  /// In en, this message translates to:
  /// **'PRINT'**
  String get print;

  /// No description provided for @price_symbol.
  ///
  /// In en, this message translates to:
  /// **'Price:'**
  String get price_symbol;

  /// No description provided for @commission_symbol.
  ///
  /// In en, this message translates to:
  /// **'Commission:'**
  String get commission_symbol;

  /// No description provided for @total_amount_with_colon.
  ///
  /// In en, this message translates to:
  /// **'Total Amount :'**
  String get total_amount_with_colon;

  /// No description provided for @pack_receive.
  ///
  /// In en, this message translates to:
  /// **'Pack Receive'**
  String get pack_receive;

  /// No description provided for @challan_number.
  ///
  /// In en, this message translates to:
  /// **'Challan Number'**
  String get challan_number;

  /// No description provided for @sale_ticket.
  ///
  /// In en, this message translates to:
  /// **'Sale Ticket'**
  String get sale_ticket;

  /// No description provided for @ticket_validation_and_claim.
  ///
  /// In en, this message translates to:
  /// **'Ticket Validation & Claim'**
  String get ticket_validation_and_claim;

  /// No description provided for @report_error.
  ///
  /// In en, this message translates to:
  /// **'Report Error'**
  String get report_error;

  /// No description provided for @no_data_found.
  ///
  /// In en, this message translates to:
  /// **'No Data Found'**
  String get no_data_found;

  /// No description provided for @barcode_number.
  ///
  /// In en, this message translates to:
  /// **'Barcode Number'**
  String get barcode_number;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @ticket_price.
  ///
  /// In en, this message translates to:
  /// **'Ticket Price'**
  String get ticket_price;

  /// No description provided for @invoice_number.
  ///
  /// In en, this message translates to:
  /// **'Invoice Number'**
  String get invoice_number;

  /// No description provided for @invoice_date.
  ///
  /// In en, this message translates to:
  /// **'Invoice Date'**
  String get invoice_date;

  /// No description provided for @winning_amount.
  ///
  /// In en, this message translates to:
  /// **'Winning Amount'**
  String get winning_amount;

  /// No description provided for @tax_amount.
  ///
  /// In en, this message translates to:
  /// **'Tax Amount'**
  String get tax_amount;

  /// No description provided for @claim_ticket.
  ///
  /// In en, this message translates to:
  /// **'Claim Ticket'**
  String get claim_ticket;

  /// No description provided for @net_winning_amount.
  ///
  /// In en, this message translates to:
  /// **'Net Winning Amount'**
  String get net_winning_amount;

  /// No description provided for @book_activated_successfully.
  ///
  /// In en, this message translates to:
  /// **'Book Activated Successfully'**
  String get book_activated_successfully;

  /// No description provided for @plz_select_valid_date.
  ///
  /// In en, this message translates to:
  /// **'Please select valid date'**
  String get plz_select_valid_date;

  /// No description provided for @claim.
  ///
  /// In en, this message translates to:
  /// **'claim'**
  String get claim;

  /// No description provided for @book_returned_successfully.
  ///
  /// In en, this message translates to:
  /// **'Book Returned Successfully'**
  String get book_returned_successfully;

  /// No description provided for @view_books.
  ///
  /// In en, this message translates to:
  /// **'View Books'**
  String get view_books;

  /// No description provided for @return_book.
  ///
  /// In en, this message translates to:
  /// **'Return'**
  String get return_book;

  /// No description provided for @book_to_return.
  ///
  /// In en, this message translates to:
  /// **'Books to Return'**
  String get book_to_return;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @book_selected_out_of.
  ///
  /// In en, this message translates to:
  /// **'book selected out of'**
  String get book_selected_out_of;

  /// No description provided for @this_week.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get this_week;

  /// No description provided for @last_week.
  ///
  /// In en, this message translates to:
  /// **'Last Week'**
  String get last_week;

  /// No description provided for @last_month.
  ///
  /// In en, this message translates to:
  /// **'Last Month'**
  String get last_month;

  /// No description provided for @retail_payment.
  ///
  /// In en, this message translates to:
  /// **'Retail Payment'**
  String get retail_payment;

  /// No description provided for @organisation.
  ///
  /// In en, this message translates to:
  /// **'organisation'**
  String get organisation;

  /// No description provided for @user_id_colon.
  ///
  /// In en, this message translates to:
  /// **'User Id :'**
  String get user_id_colon;

  /// No description provided for @balance_colon.
  ///
  /// In en, this message translates to:
  /// **'Balance:'**
  String get balance_colon;

  /// No description provided for @reload.
  ///
  /// In en, this message translates to:
  /// **'Reload'**
  String get reload;

  /// No description provided for @need_camera_permission.
  ///
  /// In en, this message translates to:
  /// **'Need camera permission to capture image. Please provide permission to access your camera.'**
  String get need_camera_permission;

  /// No description provided for @please_enter_book_number.
  ///
  /// In en, this message translates to:
  /// **'Please enter book number'**
  String get please_enter_book_number;

  /// No description provided for @book_is_marked_as_sold.
  ///
  /// In en, this message translates to:
  /// **'Book is marked as sold'**
  String get book_is_marked_as_sold;

  /// No description provided for @please_enter_barCode_number.
  ///
  /// In en, this message translates to:
  /// **'Please enter barcode number'**
  String get please_enter_barCode_number;

  /// No description provided for @please_enter_challan_number.
  ///
  /// In en, this message translates to:
  /// **'Please enter challan number'**
  String get please_enter_challan_number;

  /// No description provided for @please_enter_return_note.
  ///
  /// In en, this message translates to:
  /// **'Please enter return note'**
  String get please_enter_return_note;

  /// No description provided for @no_internet_connection.
  ///
  /// In en, this message translates to:
  /// **'No Internet Connection'**
  String get no_internet_connection;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @version_num_is_available.
  ///
  /// In en, this message translates to:
  /// **'Version {num} is available.'**
  String version_num_is_available(Object num);

  /// No description provided for @bill_no.
  ///
  /// In en, this message translates to:
  /// **'Bill no. -'**
  String get bill_no;

  /// No description provided for @is_overdue_for_payment.
  ///
  /// In en, this message translates to:
  /// **'is overdue for payment'**
  String get is_overdue_for_payment;

  /// No description provided for @sale_will_impacted_by.
  ///
  /// In en, this message translates to:
  /// **'Sale will impacted by'**
  String get sale_will_impacted_by;

  /// No description provided for @please_pay_immediately.
  ///
  /// In en, this message translates to:
  /// **'Please pay immediately'**
  String get please_pay_immediately;

  /// No description provided for @has_been_generated_and_payment_due_date_is.
  ///
  /// In en, this message translates to:
  /// **'has been generated and payment due date is'**
  String get has_been_generated_and_payment_due_date_is;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'fr': return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
