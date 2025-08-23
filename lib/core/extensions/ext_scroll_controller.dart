import 'package:flutter/material.dart';

extension ExtScrollController on ScrollController {
  void onEndReached(VoidCallback call) {
    addListener(() {
      if (position.pixels >= position.maxScrollExtent - 200) {
        call();
      }
    });
  }
}
