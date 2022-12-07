import 'package:auto_size_text/auto_size_text.dart';
import 'package:apps/cubit/device_info_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getwidget/getwidget.dart';
import 'package:lottie/lottie.dart';

class DeviceInfo extends StatefulWidget {
  const DeviceInfo({super.key});

  @override
  State<DeviceInfo> createState() => _DeviceInfoState();
}

class _DeviceInfoState extends State<DeviceInfo> {
  @override
  Widget build(BuildContext context) {
    context.read<DeviceInfoCubit>().getPlatformState();
    return BlocBuilder<DeviceInfoCubit, DeviceInfoState>(
      builder: (context, state) {
        if (state is DeviceInfoDone) {
          return Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 1.5,
              height: MediaQuery.of(context).size.height / 1.3,
              child: SingleChildScrollView(
                controller: ScrollController(),
                child: Column(
                  children: [
                    for (var _key in state.deviceInfo.keys)
                      GFCard(
                        margin: EdgeInsets.all(6),
                        padding:
                            EdgeInsets.symmetric(vertical: 3, horizontal: 3),
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
                          leading: Lottie.asset("assets/lottie/circle.json",
                              width: MediaQuery.of(context).size.width / 10),
                          textColor: Colors.black,
                          title: AutoSizeText(
                            _key,
                            minFontSize: 5,
                            maxLines: 1,
                            style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 9, 58, 99)),
                          ),
                          subtitle: AutoSizeText(
                            state.deviceInfo[_key].toString(),
                            minFontSize: 5,
                            maxLines: 2,
                            style: const TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 39, 37, 37)),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        } else if (state is DeviceInfoLoading) {
          return Container(
            child: GFLoader(
              type: GFLoaderType.square,
            ),
          );
        } else
          return Container();
      },
    );
  }
}
