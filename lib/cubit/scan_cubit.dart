import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:get/get_connect.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
part 'scan_state.dart';

class ScanCubit extends Cubit<ScanState> {
  ScanCubit()
      : super(ScanInitial(ScanModel(adb: '', appList: [], updateDate: '')));
  Future<String> GetData() async {
    try {
      // var url = Uri.parse(
      //     "https://cmota.s3.ap-northeast-1.amazonaws.com/BenQSuggestMaterial/whiteList_windows.json");
      // var response = await http.get(url);
      var data =
          await rootBundle.loadString("assets/other/whiteList_windows.json");
      final scanModel = scanModelFromJson(data);
      emit(ScanDone(scanModel));
      // final scanModel = scanModelFromJson(response.body);
      // emit(ScanDone(scanModel));
      return data;
    } catch (e) {
      return "";
    }
  }
}
// To parse this JSON data, do
//
//     final scanModel = scanModelFromJson(jsonString);
