part of 'order_cubit.dart';

abstract class OrderState extends Equatable {
  const OrderState(this.orderList, this.savedList);
  final List<String> orderList;
  final Map<String, List<String>> savedList;
  @override
  List<Object> get props => [orderList, savedList];
}

class OrderInitial extends OrderState {
  OrderInitial(super.orderList, super.savedList);
}

class OrderLoading extends OrderState {
  OrderLoading(super.orderList, super.savedList);
}

class OrderSuccess extends OrderState {
  OrderSuccess(super.orderList, super.savedList);
}
