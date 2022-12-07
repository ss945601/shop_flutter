import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getwidget/getwidget.dart';
import 'package:lottie/lottie.dart';

import '../cubit/scan_cubit.dart';

class Scan extends StatefulWidget {
  const Scan({super.key});

  @override
  State<Scan> createState() => _ScanState();
}

class _ScanState extends State<Scan> {
  @override
  Widget build(BuildContext context) {
    context.read<ScanCubit>().GetData();
    return BlocBuilder<ScanCubit, ScanState>(
      builder: (context, state) {
        return Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.all(30),
          width: double.infinity,
          height: MediaQuery.of(context).size.height / 1.3,
          child: SingleChildScrollView(
              controller: ScrollController(),
              child: Column(
                children: [
                  for (var item in state.scanModel.appList)
                    Card(
                      child: GFCard(
                        margin: EdgeInsets.all(6),
                        padding:
                            EdgeInsets.symmetric(vertical: 3, horizontal: 3),
                        elevation: 9.0,
                        color: Colors.white.withAlpha(180),
                        content: ListTile(
                          textColor: Colors.black,
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Lottie.asset(
                                'assets/lottie/circle.json',
                                width: MediaQuery.of(context).size.width / 20,
                                fit: BoxFit.fill,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 45,
                              ),
                              Expanded(
                                child: AutoSizeText(
                                  item.packageName,
                                  minFontSize: 5,
                                  maxLines: 1,
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 9, 58, 99),
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Wrap(runSpacing: 10, spacing: 5, children: [
                              for (var val in item.connections.urlList)
                                OutlinedButton(
                                  onPressed: () {},
                                  child: Text(val.type.name.toString() +
                                      " " +
                                      val.port),
                                ),
                            ]),
                          ),
                        ),
                      ),
                    ),
                ],
              )),
        );
      },
    );
  }
}
