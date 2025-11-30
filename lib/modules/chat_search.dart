import 'package:flutter/material.dart';
import 'package:messenger/data/app_theme.dart';

class ChatSearch extends StatelessWidget {

  TextEditingController searchController = TextEditingController();

  ChatSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(controller: searchController, decoration: 
      InputDecoration(contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 15), labelText: "Поиск", labelStyle: TextStyle(color: AppTheme.mainTextColor), focusColor: AppTheme.mainYellowColor, 
      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.mainYellowColor), 
      borderRadius: BorderRadius.all(Radius.circular(10)),), 
      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)))),
    );
  }
}
