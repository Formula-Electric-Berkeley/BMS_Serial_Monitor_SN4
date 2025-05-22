import 'package:flutter/material.dart';

enum PageOptions { home, charging }

class PageSelector with ChangeNotifier {
  PageOptions _currPage = PageOptions.home;

  PageOptions get currPage => _currPage;
  set currPage(PageOptions page) {
    _currPage = page;
    notifyListeners();
  }
}
