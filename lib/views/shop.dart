import 'package:auto_size_text/auto_size_text.dart';
import 'package:apps/cubit/order_cubit.dart';
import 'package:apps/cubit/shop_cubit.dart';
import 'package:apps/util.dart';
import 'package:apps/views/orderList.dart';
import 'package:easy_autocomplete/easy_autocomplete.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:getwidget/getwidget.dart';

class Shop extends StatefulWidget {
  Shop(
    this.switchPage, {
    Key? key,
  }) : super(key: key);
  Function switchPage;
  @override
  State<Shop> createState() => _SearchState();
}

class _SearchState extends State<Shop> {
  late TextEditingController _textcontroller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _textcontroller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              height: 54,
              child: Row(
                children: [
                  Expanded(
                      child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        border: Border.all(width: 3, color: Colors.amber),
                        color: Colors.white),
                    child: EasyAutocomplete(
                      suggestions: context.read<ShopCubit>().getAllItemsName(),
                      onChanged: (value) {
                        EasyDebounce.debounce(
                            'shop', // <-- An ID for this particular debouncer
                            const Duration(
                                milliseconds:
                                    1000), // <-- The debounce duration
                            () => {
                                  setState(() {
                                    context
                                        .read<ShopCubit>()
                                        .filterKeyword(_textcontroller.text);
                                  })
                                });
                      },
                      controller: _textcontroller,
                      decoration: const InputDecoration(
                          hintText: "輸入 商品名稱 或 價格 篩選",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.fromLTRB(
                              12, 0, 12, 0 // HERE THE IMPORTANT PART
                              )),
                    ),
                  )),
                  Container(
                    height: double.infinity,
                    width: 56,
                    color: _textcontroller.text.isNotEmpty
                        ? Colors.amber
                        : const Color(0xffd8d8d8),
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.black),
                      onPressed: () {
                        setState(() {
                          _textcontroller.clear();
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
            BlocBuilder<ShopCubit, ShopState>(
              builder: (context, state) {
                return Expanded(
                    child: SingleChildScrollView(
                  controller: ScrollController(),
                  child: Column(
                    children: [
                      for (var item in state.items)
                        ConstrainedBox(
                          constraints: new BoxConstraints(
                            minHeight: 110.0,
                          ),
                          child: GFCard(
                            margin: const EdgeInsets.all(6),
                            padding: const EdgeInsets.symmetric(
                                vertical: 3, horizontal: 3),
                            elevation: 9.0,
                            gradient: const LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Colors.white,
                                  Color.fromARGB(199, 171, 204, 230),
                                  Color.fromARGB(199, 88, 135, 172)
                                ],
                                stops: [
                                  0.1,
                                  0.6,
                                  1.0
                                ]),
                            content: ListTile(
                              textColor: Colors.black,
                              title: AutoSizeText(
                                item.name.toString(),
                                minFontSize: 5,
                                maxLines: 3,
                                style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 9, 58, 99)),
                              ),
                              subtitle: AutoSizeText(
                                "價格 : ${item.price.toString()}, 已售出 : ${item.sold.toString()}, ${item.discount.toString()}",
                                minFontSize: 5,
                                maxLines: 2,
                                style: const TextStyle(
                                    fontSize: 18,
                                    color: Color.fromARGB(255, 39, 37, 37)),
                              ),
                              trailing: BlocBuilder<OrderCubit, OrderState>(
                                builder: (context, state) {
                                  var orderCubit = context.read<OrderCubit>();
                                  return Wrap(
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            HttpService.openUrl(Uri.parse(
                                                item.href.toString()));
                                          },
                                          icon: const Icon(Icons.web)),
                                      PortalTarget(
                                        visible: true,
                                        anchor: const Aligned(
                                          follower: Alignment.topCenter,
                                          target: Alignment.center,
                                        ),
                                        portalFollower: IntrinsicWidth(
                                          child: context
                                                      .read<OrderCubit>()
                                                      .getNumOfOrderByName(
                                                          item.name!) >
                                                  0
                                              ? Row(
                                                  children: [
                                                    TextButton(
                                                        style: TextButton
                                                            .styleFrom(
                                                          minimumSize:
                                                              Size.zero,
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10),
                                                        ),
                                                        onPressed: () {
                                                          orderCubit.remove(
                                                              item.name!);
                                                        },
                                                        child: const Text("－",
                                                            style: TextStyle(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        214,
                                                                        100,
                                                                        92),
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold))),
                                                    TextButton(
                                                        style: TextButton
                                                            .styleFrom(
                                                          minimumSize:
                                                              Size.zero,
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10),
                                                        ),
                                                        onPressed: () {
                                                          orderCubit
                                                              .add(item.name!);
                                                        },
                                                        child: const Text("＋",
                                                            style: TextStyle(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        122,
                                                                        212,
                                                                        140),
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold))),
                                                  ],
                                                )
                                              : const SizedBox.shrink(),
                                        ),
                                        child: GFIconBadge(
                                          // ignore: sort_child_properties_last
                                          child: Stack(
                                            children: [
                                              IconButton(
                                                  onPressed: () {
                                                    orderCubit.add(
                                                        item.name.toString());
                                                  },
                                                  icon: const Icon(
                                                      Icons.shopping_cart)),
                                            ],
                                          ),
                                          counterChild: orderCubit
                                                      .getNumOfOrderByName(
                                                          item.name!) >
                                                  0
                                              ? GFBadge(
                                                  color: const Color.fromARGB(
                                                      255, 29, 88, 197),
                                                  child: Text(orderCubit
                                                      .getNumOfOrderByName(
                                                          item.name!)
                                                      .toString()),
                                                )
                                              : const SizedBox.shrink(),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ));
              },
            )
          ],
        ),
        BlocBuilder<OrderCubit, OrderState>(
          builder: (context, state) {
            return state.orderList.length > 0
                ? Positioned(
                    right: 30,
                    bottom: 30,
                    child: PortalTarget(
                      visible: true,
                      anchor: const Aligned(
                        follower: Alignment.centerRight,
                        target: Alignment.topRight,
                      ),
                      portalFollower: IntrinsicHeight(
                          child: GFBadge(
                        color: Color.fromARGB(255, 177, 20, 20),
                        child: Text(context
                            .read<OrderCubit>()
                            .getCategoryList(state.orderList)
                            .keys
                            .length
                            .toString()),
                      )),
                      child: FloatingActionButton(
                        backgroundColor: Colors.white.withAlpha(128),
                        foregroundColor: Colors.black,
                        child: Icon(Icons.shopping_cart_checkout_rounded),
                        onPressed: () {
                          widget.switchPage(OrderList(widget.switchPage));
                        },
                      ),
                    ),
                  )
                : SizedBox.shrink();
          },
        )
      ],
    );
  }
}
