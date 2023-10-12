// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spell.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SpellImpl _$$SpellImplFromJson(Map<String, dynamic> json) => _$SpellImpl(
      id: json['id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      spellName: json['spell_name'] as String,
      description: json['description'] as String,
      spellType: json['spell_type'] as int,
      availableCampaigns: (json['available_campaigns'] as List<dynamic>)
          .map((e) => e as int)
          .toList(),
    );

Map<String, dynamic> _$$SpellImplToJson(_$SpellImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt.toIso8601String(),
      'spell_name': instance.spellName,
      'description': instance.description,
      'spell_type': instance.spellType,
      'available_campaigns': instance.availableCampaigns,
    };
