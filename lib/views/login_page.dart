import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:messenger/bloc/auth/auth_bloc.dart';
import 'package:messenger/bloc/chats/chats_bloc.dart';
import 'package:messenger/data/app_theme.dart';
import 'package:messenger/views/main_page.dart';

enum AuthPage {
  EmailPage,
  PasswordPage,
  CodePage
}


class LoginPage extends StatelessWidget {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController codeController = TextEditingController();

  LoginPage({super.key});

  TextField AuthInputField({String text = "", required TextEditingController controller, bool isPassword = false})
  {
    return TextField(obscureText: isPassword, controller: controller, decoration: 
      InputDecoration(labelText: text, labelStyle: TextStyle(color: AppTheme.mainTextColor), focusColor: AppTheme.mainYellowColor, 
      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.mainYellowColor), 
      borderRadius: BorderRadius.all(Radius.circular(10)),), 
      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)))),
    );
  }

  Widget AuthWidget(BuildContext context, AuthPage authPage)
  {
    late final String widgetLabel;
    late final String inputText;
    late final String buttonText;
    late final TextEditingController controller;
    late void Function() buttonFunction;

    switch(authPage)
    {
      case AuthPage.EmailPage:
        widgetLabel = "Вход / Регистрация";
        inputText = "Почта";
        buttonText = "Далее";
        controller = emailController;
        buttonFunction = () {
          context.read<AuthBloc>().add(EnterEmail(controller.text));
        };
      break;

      case AuthPage.PasswordPage:
        widgetLabel = "Введите пароль";
        inputText = "Пароль";
        buttonText = "Вход";
        controller = passwordController;
        buttonFunction = () {
          context.read<AuthBloc>().add(EnterPassword(emailController.text, controller.text));
        };
      break;

      case AuthPage.CodePage:
        widgetLabel = "Введите код";
        inputText = "Код";
        buttonText = "Регистрироваться";
        controller = codeController;
        buttonFunction = () {
          context.read<AuthBloc>().add(EnterCode(emailController.text, controller.text));
        };
      break;
    }

    return Container(width: MediaQuery.of(context).size.width*0.8, constraints: BoxConstraints(maxWidth: 700), decoration: 
      BoxDecoration(
        color: AppTheme.bottomNavigationColor,
        borderRadius: BorderRadius.all(Radius.circular(30)),
        boxShadow: [BoxShadow(color: Colors.black, blurRadius: 20)]
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(widgetLabel, style: TextStyle(fontSize: 20),),
          SizedBox(height: 10,),
          AuthInputField(text: inputText, controller: controller),
          SizedBox(height: 10,),
          ElevatedButton(onPressed: (){buttonFunction();}, child: Text(buttonText,))
        ],),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        AnimatedBackground(),
        BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
          if(state is NewEmailState || state is EmailExistsState)
          {
            return SafeArea(
              top: true,
              child: Positioned(top: 10, left: 10, child: IconButton(onPressed: (){
                context.read<AuthBloc>().add(BackToEmail());
              }, icon: Icon(Icons.arrow_back_outlined))),
            );
          }

          return SizedBox();
        },),
        BlocListener<AuthBloc, AuthState>(listener: (context, state){
          if(state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage!), duration: Duration(milliseconds: 2000),));
          }
          else if(state is Authenticated)
          {
            Navigator.pushReplacement(context, MaterialPageRoute<void>(builder: (context) => BlocProvider(create: (context) => ChatsBloc(), child: MainPage()),));
          }
        },
        child: Center(
          child: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
              if(state is EmailExistsState)
              {
                return AuthWidget(context, AuthPage.PasswordPage);
              }
              else if(state is NewEmailState)
              {
                return AuthWidget(context, AuthPage.CodePage);
              }

              return AuthWidget(context, AuthPage.EmailPage);
            }
          )
        ))
      ],
      ),
    );
  }
}

class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({super.key});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackground();
}

class _AnimatedBackground extends State<AnimatedBackground> {
  @override
  Widget build(BuildContext context) {
    return Lottie.asset("assets/animations/bckg.json", height: MediaQuery.of(context).size.height, animate: true, repeat: true, fit: BoxFit.cover);
  }
}