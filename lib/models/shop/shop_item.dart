class ShopItem {
  int? id;
  String? name;
  String? price;
  String? sold;
  String? href;
  String? discount;

  ShopItem({
    this.id,
    this.name,
    this.price,
    this.sold,
    this.href,
    this.discount,
  });

  factory ShopItem.fromJson(Map<String, dynamic> json) => ShopItem(
        id: json['id'] as int?,
        name: json['name'] as String?,
        price: json['price'] as String?,
        sold: json['sold'] as String?,
        href: json['href'] as String?,
        discount: json['discount'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'price': price,
        'sold': sold,
        'href': href,
        'discount': discount,
      };
}
