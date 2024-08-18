import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:br_lotto/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

import '../../../date_format.dart';
import '../../../utils.dart';

part 'select_date_event.dart';

part 'select_date_state.dart';

class SelectDateBloc extends Bloc<SelectDateEvent, SelectDateState> {
  SelectDateBloc() : super(SelectDateInitial()) {
    on<PickFromDate>(_onPickFromDate);
    on<PickToDate>(_onPickToDate);
    on<SetDate>(_onSetDate);
  }

  String fromDate = formatDate(
    date: DateTime.now().subtract(const Duration(days: 30)).toString(),
    inputFormat: Format.apiDateFormat2,
    outputFormat: Format.dateFormat9,
  );

  String toGameDate = formatDate(
    date: DateTime.now().toString(),
    inputFormat: Format.apiDateFormat2,
    outputFormat: Format.apiDateFormat3,
  );

  String fromGameDate = formatDate(
    date: DateTime.now().subtract(const Duration(days: 30)).toString(),
    inputFormat: Format.apiDateFormat2,
    outputFormat: Format.apiDateFormat3,
  );

  String toDate = formatDate(
    date: DateTime.now().toString(),
    inputFormat: Format.apiDateFormat2,
    outputFormat: Format.dateFormat9,
  );

  FutureOr<void> _onPickFromDate(
      PickFromDate event, Emitter<SelectDateState> emit) async {
    BuildContext context = event.context;
    DateTime? pickedDate = await showCalendar(
        context,
        DateFormat(Format.dateFormat9).parse(fromDate),
        null,
        DateTime.now());
    if (pickedDate != null  && fromDateValid(pickedDate)) {
      fromDate = formatDate(
        date: DateFormat(Format.calendarFormat).format(pickedDate),
        inputFormat: Format.calendarFormat,
        outputFormat: Format.dateFormat9,
      );

      String fromGameDate = formatDate(
        date: DateFormat(Format.calendarFormat).format(pickedDate), //DateTime.now().subtract(const Duration(days: 30)).toString(),
        inputFormat: Format.calendarFormat,
        outputFormat: Format.apiDateFormat3,
      );

      emit(DateUpdated(toDate: toGameDate, fromDate: fromGameDate));
    } else if(pickedDate != null) {
      SnackbarGlobal.show(context.l10n.plz_select_valid_date);
    }
  }

  FutureOr<void> _onPickToDate(
      PickToDate event, Emitter<SelectDateState> emit) async {
    BuildContext context = event.context;
    DateTime? pickedDate =
        await showCalendar(context,  DateTime.now(), null, DateTime.now());
    if (pickedDate != null && toDateValid(pickedDate)) {
      String formattedPickedDate = DateFormat(Format.calendarFormat).format(pickedDate);
      toDate = formatDate(
        date: formattedPickedDate,
        inputFormat: Format.calendarFormat,
        outputFormat: Format.dateFormat9,
      );

      String toGameDate = formatDate(
        date: formattedPickedDate,
        inputFormat: Format.calendarFormat,
        outputFormat: Format.apiDateFormat3,
      );

      emit(DateUpdated(toDate: toGameDate, fromDate: fromGameDate));
    } else if(pickedDate != null ) {
      SnackbarGlobal.show(context.l10n.plz_select_valid_date);
    }
  }

  bool fromDateValid(DateTime pickedDate) {
    // String newPickedDate = formatDate(
    //   date: toDate,
    //   inputFormat: Format.calendarFormat,
    //   outputFormat: Format.dateFormat9,
    // );
    // return DateTime.parse(newPickedDate).isBefore(DateTime.parse(fromDate));
    DateTime formattedToDate = DateFormat(Format.dateFormat9).parse(toDate);
    String newPickedDate = formatDate(
      date: DateFormat(Format.calendarFormat).format(pickedDate),
      inputFormat: Format.calendarFormat,
      outputFormat: Format.dateFormat9,
    );
    DateTime formattedNewPickedDate = DateFormat(Format.dateFormat9).parse(newPickedDate);
    bool valueToReturn = formattedNewPickedDate.isBefore(formattedToDate) || formattedNewPickedDate.isAtSameMomentAs(formattedToDate);
    return valueToReturn;
  }

  bool toDateValid(DateTime pickedDate) {
    DateTime formattedFromDate = DateFormat(Format.dateFormat9).parse(fromDate);
    String newPickedDate = formatDate(
      date: DateFormat(Format.calendarFormat).format(pickedDate),
      inputFormat: Format.calendarFormat,
      outputFormat: Format.dateFormat9,
    );
    DateTime formattedNewPickedDate = DateFormat(Format.dateFormat9).parse(newPickedDate);
    bool valueToReturn = formattedNewPickedDate.isAfter(formattedFromDate) || formattedNewPickedDate.isAtSameMomentAs(formattedFromDate);
    return valueToReturn;
  }


  FutureOr<void> _onSetDate(SetDate event, Emitter<SelectDateState> emit) {
    fromDate = formatDate(
      date: event.fromDate,
      inputFormat: Format.apiDateFormat3,
      outputFormat: Format.dateFormat9,
    );
    toDate = formatDate(
      date: event.toDate,
      inputFormat: Format.apiDateFormat3,
      outputFormat: Format.dateFormat9,
    );
    emit(DateUpdated(toDate: toDate, fromDate: fromDate));
  }
}
