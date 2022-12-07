part of 'device_info_cubit.dart';

abstract class DeviceInfoState extends Equatable {
  const DeviceInfoState(this.deviceInfo);
  final Map<String, dynamic> deviceInfo;
  @override
  List<Object> get props => [];
}

class DeviceInfoInitial extends DeviceInfoState {
  const DeviceInfoInitial(super.deviceInfo);
}

class DeviceInfoLoading extends DeviceInfoState {
  const DeviceInfoLoading(super.deviceInfo);
}

class DeviceInfoDone extends DeviceInfoState {
  const DeviceInfoDone(super.deviceInfo);
}
