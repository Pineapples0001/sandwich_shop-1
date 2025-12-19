import 'package:json_annotation/json_annotation.dart';

part 'saved_order.g.dart';

@JsonSerializable()
class SavedOrder {
  final int id;
  final String orderId;
  final double totalAmount;
  final int itemCount;
  @JsonKey(fromJson: _dateTimeFromMilliseconds, toJson: _dateTimeToMilliseconds)
  final DateTime orderDate;

  SavedOrder({
    required this.id,
    required this.orderId,
    required this.totalAmount,
    required this.itemCount,
    required this.orderDate,
  });

  factory SavedOrder.fromJson(Map<String, dynamic> json) =>
      _$SavedOrderFromJson(json);

  Map<String, dynamic> toJson() => _$SavedOrderToJson(this);

  // Keep the old methods for database compatibility
  Map<String, Object?> toMap() {
    return {
      'orderId': orderId,
      'totalAmount': totalAmount,
      'itemCount': itemCount,
      'orderDate': orderDate.millisecondsSinceEpoch,
    };
  }

  SavedOrder.fromMap(Map<String, Object?> map)
      : id = map['id'] as int,
        orderId = map['orderId'] as String,
        totalAmount = map['totalAmount'] as double,
        itemCount = map['itemCount'] as int,
        orderDate =
            DateTime.fromMillisecondsSinceEpoch(map['orderDate'] as int);
}

// Helper functions for DateTime serialization
DateTime _dateTimeFromMilliseconds(int milliseconds) =>
    DateTime.fromMillisecondsSinceEpoch(milliseconds);

int _dateTimeToMilliseconds(DateTime dateTime) =>
    dateTime.millisecondsSinceEpoch;
