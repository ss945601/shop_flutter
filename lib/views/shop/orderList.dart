import 'package:auto_size_text/auto_size_text.dart';
import 'package:apps/cubit/order_cubit.dart';
import 'package:apps/cubit/shop_cubit.dart';
import 'package:apps/util.dart';
import 'package:apps/views/shop/shop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getwidget/getwidget.dart';

class OrderList extends StatefulWidget {
  OrderList(this.switchPage, {super.key});
  Function switchPage;

  @override
  State<OrderList> createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    context.read<OrderCubit>().readList();
    Util.instance.eventBus.on<EventsWithParam>().listen((ret) {
      // Print the runtime type. Such a set up could be used for logging.
      if (ret.evt == Events.saveList) {
        context.read<OrderCubit>().saveList(_textController.text);
      } else if (ret.evt == Events.removeBookedList) {
        context.read<OrderCubit>().removeFromList(ret.param);
      }
    });
    return BlocBuilder<OrderCubit, OrderState>(
      builder: (context, state) {
        return state.orderList.length == 0 && state.savedList.length == 0
            ? const Center(
                child: Text(
                    style: TextStyle(color: Colors.white, fontSize: 30),
                    "查無訂單"))
            : Container(
                margin: const EdgeInsets.all(30),
                child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      children: [
                        state.orderList.length != 0
                            ? OrderCard(
                                child: orderMenu(orderList: state.orderList),
                                color: Colors.white.withAlpha(200))
                            : SizedBox.shrink(),
                        SizedBox(
                          height: 10,
                        ),
                        Divider(
                          thickness: 3,
                          color: Colors.white,
                        ),
                        for (var key in state.savedList.keys)
                          OrderCard(
                              child: orderMenu(
                                  orderList: state.savedList[key] ?? [],
                                  orderName: key),
                              color: Color.fromARGB(255, 226, 228, 218)
                                  .withAlpha(200))
                      ],
                    )),
              );
      },
    );
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return int.tryParse(s) != null;
  }

  Widget orderMenu({required List<String> orderList, String orderName = ""}) {
    var categoryList = context.read<OrderCubit>().getCategoryList(orderList);
    Map<String, TextEditingController> controllers = {};
    for (var key in categoryList.keys) {
      controllers[key] = TextEditingController();
      controllers[key]?.text = categoryList[key].toString();
    }
    return Column(children: [
      if (orderName != "" || context.read<OrderCubit>().editName != "")
        AutoSizeText(
          "${orderName != "" ? orderName : context.read<OrderCubit>().editName}'s order list ${orderName == "" ? "Editing..." : ""}",
          minFontSize: 5,
          maxLines: 3,
          style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 9, 58, 99)),
        ),
      for (var key in categoryList.keys)
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: AutoSizeText(key, minFontSize: 8, maxLines: 6),
              ),
              if (orderName == "")
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      Spacer(),
                      GFIconButton(
                        size: GFSize.SMALL,
                        iconSize: 12,
                        shape: GFIconButtonShape.pills,
                        onPressed: () {
                          context.read<OrderCubit>().remove(key);
                          controllers[key]?.text = categoryList[key].toString();
                        },
                        icon: Icon(Icons.remove),
                      ),
                      Expanded(
                        flex: 10,
                        child: TextField(
                          textAlign: TextAlign.center,
                          controller: controllers[key],
                          onChanged: (text) {
                            if (isNumeric(text)) {
                              context
                                  .read<OrderCubit>()
                                  .set(key, int.parse(text));
                            }
                          },
                        ),
                      ),
                      GFIconButton(
                        size: GFSize.SMALL,
                        iconSize: 12,
                        shape: GFIconButtonShape.circle,
                        onPressed: () {
                          context.read<OrderCubit>().add(key);
                          controllers[key]?.text = categoryList[key].toString();
                        },
                        icon: Icon(Icons.add),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
              Text(
                  "${orderName != "" ? categoryList[key].toString() : ""} * ${context.read<ShopCubit>().getShopItemByName(key).price!}")
            ],
          ),
        ),
      const SizedBox(
        height: 20,
      ),
      const Divider(
        color: Colors.black,
        thickness: 1,
      ),
      const SizedBox(
        height: 20,
      ),
      Row(
        children: [
          const Text("Total"),
          Expanded(
              child: Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                      "：  ${context.read<ShopCubit>().getTotalPayment(orderList)}"))),
        ],
      ),
      const SizedBox(
        height: 20,
      ),
      if (orderName == "")
        Row(children: [
          Expanded(
            child: OutlinedButton(
                onPressed: () {
                  context.read<OrderCubit>().clearAll();
                },
                child: Text(
                  context.read<OrderCubit>().editName == "" ? "清除選購" : "取消",
                  style: TextStyle(color: Colors.red),
                )),
          ),
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: OutlinedButton(
                onPressed: () {
                  context.read<ShopCubit>().processCsv(context);
                  widget.switchPage(Container(
                      margin: EdgeInsets.all(30),
                      child: Shop(widget.switchPage)));
                },
                child:
                    const Text("增加項目", style: TextStyle(color: Colors.green))),
          ),
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: OutlinedButton(
                onPressed: () {
                  if (context.read<OrderCubit>().editName == "") {
                    Util.instance.showMyDialog(
                        context,
                        "輸入訂單名稱",
                        TextField(
                          controller: _textController,
                          decoration:
                              InputDecoration(hintText: 'Input here...'),
                        ),
                        EventsWithParam(Events.saveList));
                  } else {
                    context
                        .read<OrderCubit>()
                        .saveList(context.read<OrderCubit>().editName);
                  }
                },
                child: const Text("儲存訂單",
                    style: TextStyle(color: Colors.blueGrey))),
          )
        ])
      else
        Row(
          children: [
            Spacer(),
            OutlinedButton(
                onPressed: () {
                  Util.instance.showMyDialog(context, "提示", Text("是否清除訂單"),
                      EventsWithParam(Events.removeBookedList, orderName));
                },
                child: const Text(
                  "清除訂單",
                  style: TextStyle(color: Colors.red),
                )),
            Spacer(),
            OutlinedButton(
                onPressed: () {
                  context.read<OrderCubit>().editName = orderName;
                  context.read<OrderCubit>().edit(orderList);
                  _scrollController.animateTo(
                      //go to top of scroll
                      0, //scroll offset to go
                      duration:
                          Duration(milliseconds: 500), //duration of scroll
                      curve: Curves.fastOutSlowIn //scroll type
                      );
                },
                child: const Text(
                  "修改訂單",
                  style: TextStyle(color: Colors.green),
                )),
            Spacer(),
          ],
        ),
    ]);
  }
}

class OrderCard extends StatelessWidget {
  OrderCard({
    Key? key,
    required this.child,
    required this.color,
  }) : super(key: key);
  final Widget child;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: color.withAlpha(128),
      child: GFCard(
          margin: const EdgeInsets.all(6),
          padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 3),
          elevation: 9.0,
          color: color,
          content: child),
    );
  }
}
