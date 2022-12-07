part of 'shop_cubit.dart';

abstract class ShopState extends Equatable {
  const ShopState(this.items);
  final List<ShopItem> items;
  @override
  List<Object> get props => [items];
}

class ShopInitial extends ShopState {
  ShopInitial(super.items);
}

class ShopSuccess extends ShopState {
  ShopSuccess(super.items);
}
