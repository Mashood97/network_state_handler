// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_user_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListUserResponse _$ListUserResponseFromJson(Map<String, dynamic> json) =>
    ListUserResponse()
      ..user = (json['data'] as List<dynamic>?)
          ?.map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$ListUserResponseToJson(ListUserResponse instance) =>
    <String, dynamic>{
      'data': instance.user,
    };
