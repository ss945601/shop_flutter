import 'package:apps/models/shop/shop_item.dart';
import 'package:bloc/bloc.dart';
import 'package:csv/csv.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'shop_state.dart';

class ShopCubit extends Cubit<ShopState> {
  ShopCubit() : super(ShopInitial([]));

  List<ShopItem> allItems = [];
  List<String> names = [];
  Future<List<List<dynamic>>> processCsv(BuildContext ctx) async {
    allItems = [];
    emit(ShopInitial(const []));
    var result = await DefaultAssetBundle.of(ctx).loadString(
      "assets/other/shopee.csv",
    );
    var data = const CsvToListConverter().convert(result, eol: "\n");
    List<ShopItem> items = [];
    names = [];
    int idx = 0;
    for (var item in data) {
      if (item[0] != '' && item[0] != "Name" && !names.contains(item[0])) {
        names.add(item[0]);
        ShopItem shopItem = ShopItem();
        shopItem.id = idx;
        shopItem.name = item[0];
        shopItem.discount = item[1];
        shopItem.price = item[2];
        shopItem.sold = item[3].toString();
        shopItem.href = item[4];
        idx += 1;
        items.add(shopItem);
        allItems.add(shopItem);
      }
    }
    emit(ShopSuccess([...items]));
    return data;
  }

  void filterKeyword(String keyword) {
    emit(ShopInitial([...allItems]));
    List<ShopItem> items = [];
    try {
      for (var item in state.items) {
        if (item.name!.contains(keyword) || item.price!.contains(keyword)) {
          items.add(item);
        }
      }
      emit(ShopSuccess(items));
    } catch (ex) {
      print("error");
    }
  }

  List<String> getAllItemsName() {
    List<String> ret = [];
    for (ShopItem item in allItems) {
      ret.add(item.name ?? "");
    }
    return ret;
  }

  ShopItem getShopItemByName(String name) {
    return allItems.where((element) => element.name == name).first;
  }

  int getTotalPayment(List<String> items) {
    int sum = 0;
    for (var item in items) {
      sum += int.parse(
          getShopItemByName(item).price.toString().replaceAll('\$', ""));
    }
    return sum;
  }
}
