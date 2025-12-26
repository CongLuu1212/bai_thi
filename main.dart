import 'dart:convert';
import 'dart:io';

class Order {
  String item;
  String name;
  double price;
  String currency;
  int quantity;

  Order(this.item, this.name, this.price, this.currency, this.quantity);

  Order.fromJson(Map<String, dynamic> json)
    : item = json['Item'],
      name = json['ItemName'],
      price = json['Price'].toDouble(),
      currency = json['Currency'],
      quantity = json['Quantity'];

  Map<String, dynamic> toJson() {
    return {
      'Item': item,
      'ItemName': name,
      'Price': price,
      'Currency': currency,
      'Quantity': quantity,
    };
  }
}

void printOrders(List<Order> list) {
  print('\nDanh sách đơn hàng:');
  for (var i = 0; i < list.length; i++) {
    print(
      '${i + 1}. ${list[i].name} - ${list[i].price} ${list[i].currency} (SL: ${list[i].quantity})',
    );
  }
}

Order addOrderFromInput() {
  stdout.write('Nhập mã sản phẩm: ');
  String item = stdin.readLineSync()!;

  stdout.write('Nhập tên sản phẩm: ');
  String name = stdin.readLineSync()!;

  stdout.write('Nhập giá: ');
  double price = double.parse(stdin.readLineSync()!);

  stdout.write('Nhập tiền tệ: ');
  String currency = stdin.readLineSync()!;

  stdout.write('Nhập số lượng: ');
  int qty = int.parse(stdin.readLineSync()!);

  return Order(item, name, price, currency, qty);
}

void searchByName(List<Order> list, String key) {
  bool found = false;
  for (var o in list) {
    if (o.name.toLowerCase().contains(key.toLowerCase())) {
      print('${o.name} - ${o.price} ${o.currency}');
      found = true;
    }
  }
  if (!found) {
    print('Không tìm thấy sản phẩm.');
  }
}

void main() {
  String data =
      '[{"Item":"A1000","ItemName":"Iphone 15","Price":1200,"Currency":"USD","Quantity":1},'
      '{"Item":"A1001","ItemName":"Iphone 16","Price":1500,"Currency":"USD","Quantity":1}]';

  List jsonData = jsonDecode(data);
  List<Order> orders = [];

  for (var e in jsonData) {
    orders.add(Order.fromJson(e));
  }

  printOrders(orders);

  print('\nThêm đơn hàng mới');
  orders.add(addOrderFromInput());

  printOrders(orders);

  stdout.write('\nNhập tên sản phẩm cần tìm: ');
  String key = stdin.readLineSync()!;
  searchByName(orders, key);

  File(
    'order.json',
  ).writeAsStringSync(jsonEncode(orders.map((e) => e.toJson()).toList()));
}
