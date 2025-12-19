// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sandwich.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Sandwich _$SandwichFromJson(Map<String, dynamic> json) => Sandwich(
      type: $enumDecode(_$SandwichTypeEnumMap, json['type']),
      isFootlong: json['isFootlong'] as bool,
      breadType: $enumDecode(_$BreadTypeEnumMap, json['breadType']),
    );

Map<String, dynamic> _$SandwichToJson(Sandwich instance) => <String, dynamic>{
      'type': _$SandwichTypeEnumMap[instance.type]!,
      'isFootlong': instance.isFootlong,
      'breadType': _$BreadTypeEnumMap[instance.breadType]!,
    };

const _$SandwichTypeEnumMap = {
  SandwichType.veggieDelight: 'veggieDelight',
  SandwichType.chickenTeriyaki: 'chickenTeriyaki',
  SandwichType.tunaMelt: 'tunaMelt',
  SandwichType.meatballMarinara: 'meatballMarinara',
};

const _$BreadTypeEnumMap = {
  BreadType.white: 'white',
  BreadType.wheat: 'wheat',
  BreadType.wholemeal: 'wholemeal',
};
