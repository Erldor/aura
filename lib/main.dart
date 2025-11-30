import 'package:flutter/material.dart';
import 'package:messenger/bloc/auth/auth_bloc.dart';
import 'package:messenger/bloc/chats/chats_bloc.dart';
import 'package:messenger/data/app_theme.dart';
import 'package:messenger/views/main_page.dart';
import 'package:messenger/views/login_page.dart';
import "package:flutter_bloc/flutter_bloc.dart";

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: AppTheme.darkTheme(),
    home: BlocProvider(create: (context) => AuthBloc(baseUrl: "http://10.122.235.51:5235"), child: LoginPage())
  ));
}
