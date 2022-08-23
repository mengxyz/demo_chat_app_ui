// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
      json['uid'] as String,
      json['content'] as String,
      json['created_at'] as String,
      json['read'] as bool,
      json['room_id'] as String,
      json['sender_id'] as String,
      json['is_me'] as bool,
    );
