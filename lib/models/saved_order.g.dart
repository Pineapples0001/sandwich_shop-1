// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SavedOrder _$SavedOrderFromJson(Map<String, dynamic> json) => SavedOrder(
      id: (json['id'] as num).toInt(),
      orderId: json['orderId'] as String,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      itemCount: (json['itemCount'] as num).toInt(),
      orderDate: _dateTimeFromMilliseconds((json['orderDate'] as num).toInt()),
    );

Map<String, dynamic> _$SavedOrderToJson(SavedOrder instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orderId': instance.orderId,
      'totalAmount': instance.totalAmount,
      'itemCount': instance.itemCount,
      'orderDate': _dateTimeToMilliseconds(instance.orderDate),
    };
