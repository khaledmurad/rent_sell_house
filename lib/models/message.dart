import 'package:flutter/material.dart';

@immutable
class Message{
  final String message;
  final String title;

  Message({
    @required this.message,
    @required this.title
});
}