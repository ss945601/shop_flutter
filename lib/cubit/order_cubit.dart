import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit() : super(OrderInitial([], {}));

  String editName = "";

  void add(String name) {
    emit(OrderSuccess(
        [...state.orderList]
          ..add(name)
          ..sort(),
        state.savedList));
  }

  void remove(String name) {
    emit(OrderSuccess(
        [...state.orderList]
          ..remove(name)
          ..sort(),
        state.savedList));
  }

  void edit(List<String> editOrderList) {
    emit(OrderSuccess([...editOrderList], state.savedList));
  }

  void set(String name, int num) {
    var tmp = [...state.orderList];
    tmp.removeWhere(((element) => element == name));
    for (var i = 0; i < num; i++) tmp.insert(0, name);
    emit(OrderSuccess(tmp..sort(), state.savedList));
  }

  void clearAll() {
    emit(OrderSuccess([], state.savedList));
  }

  Future<void> saveList(String name) async {
    try {
      if (name != "") {
        if (editName != "") {
          name = editName;
          editName = "";
        } else {
          name += "(" + DateTime.now().toString().split(".")[0] + ")";
        }
        final prefs = await SharedPreferences.getInstance();
        final List<String> items = prefs.getStringList('orderLists') ?? [];
        await prefs.setStringList(name, <String>[...state.orderList]);
        if (prefs.getStringList('orderLists') == null) {
          await prefs.setStringList('orderLists', <String>[]..add(name));
        } else if (!prefs.getStringList('orderLists')!.contains(name)) {
          await prefs.setStringList('orderLists',
              <String>[...?prefs.getStringList('orderLists')]..add(name));
        }
        await readList();
        clearAll();
      }
    } catch (ex) {
      print(ex);
    }
  }

  Future<void> readList() async {
    emit(OrderLoading(state.orderList, {}));
    final prefs = await SharedPreferences.getInstance();
    final List<String> names = prefs.getStringList('orderLists') ?? [];
    Map<String, List<String>> tmp = {};
    for (var name in names) {
      tmp[name] = prefs.getStringList(name) ?? [];
    }
    emit(OrderSuccess(state.orderList, tmp));
  }

  Future<void> removeFromList(String name) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(name);
    await prefs.setStringList('orderLists',
        <String>[...?prefs.getStringList('orderLists')]..remove(name));
    await readList();
  }

  int getNumOfOrderByName(String name) {
    return state.orderList.where((element) => element == name).length;
  }

  Map<String, int> getCategoryList(List<String> list) {
    Map<String, int> tmp = new Map<String, int>();
    for (var item in list) {
      if (!tmp.containsKey(item)) {
        tmp[item] = 1;
      } else {
        tmp[item] = tmp[item]! + 1;
      }
    }
    return tmp;
  }
}
