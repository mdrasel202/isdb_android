import 'package:flutter/cupertino.dart';

class UiHelper{
  static CustomImage({required String img}){
    return Image.asset("assets/image/$img");
  }
}