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
  TextEditingController usernameController = TextEditingController();

  LoginPage({super.key});

  void controllersReset()
  {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    codeController = TextEditingController();
    usernameController = TextEditingController();
  }

  Widget AuthInputField({String text = "", required TextEditingController controller, bool isPassword = false})
  {
    if(!isPassword)
    {
      return TextField(obscureText: false, controller: controller, decoration: 
        InputDecoration(labelText: text, labelStyle: TextStyle(color: AppTheme.mainTextColor), focusColor: AppTheme.mainYellowColor,
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.mainYellowColor), 
        borderRadius: BorderRadius.all(Radius.circular(10)),), 
        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)))),
      );
    }
    else
    {
      return PasswordTextField(controller: controller);
    }
  }

  Widget AuthWidget(BuildContext context, AuthPage authPage)
  {
    late final bool isObscured;
    late final String widgetLabel;
    late final String inputText;
    late final String buttonText;
    late final TextEditingController controller;
    late void Function() buttonFunction;

    switch(authPage)
    {
      case AuthPage.EmailPage:
        isObscured = false;
        widgetLabel = "Вход / Регистрация";
        inputText = "Почта";
        buttonText = "Далее";
        controller = emailController;
        buttonFunction = () {
          context.read<AuthBloc>().add(EnterEmail(controller.text));
        };
      break;

      case AuthPage.PasswordPage:
        isObscured = true;
        widgetLabel = "Введите пароль";
        inputText = "Пароль";
        buttonText = "Вход";
        controller = passwordController;
        buttonFunction = () {
          context.read<AuthBloc>().add(EnterPasswordEvent(emailController.text, controller.text));
        };
      break;

      case AuthPage.CodePage:
        isObscured = false;
        widgetLabel = "Введите код";
        inputText = "Код";
        buttonText = "Регистрироваться";
        controller = codeController;
        buttonFunction = () {
          context.read<AuthBloc>().add(EnterCodeEvent(emailController.text, controller.text));
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
          AuthInputField(text: inputText, controller: controller, isPassword: isObscured),
          SizedBox(height: 10,),
          ElevatedButton(onPressed: (){
            FocusScope.of(context).unfocus();
            buttonFunction();
            }, child: Text(buttonText,))
        ],),
      )
    );
  }

  Widget InitializationWidget(BuildContext context)
  {
    return Container(width: MediaQuery.of(context).size.width*0.8, constraints: BoxConstraints(maxWidth: 700), decoration: 
      BoxDecoration(
        color: AppTheme.bottomNavigationColor,
        borderRadius: BorderRadius.all(Radius.circular(30)),
        boxShadow: [BoxShadow(color: Colors.black, blurRadius: 20)]
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text("Регистрация", style: TextStyle(fontSize: 20),),
          SizedBox(height: 10,),
          AuthInputField(text: "Имя", controller: usernameController),
          SizedBox(height: 10,),
          AuthInputField(text: "Пароль", controller: passwordController, isPassword: true),
          SizedBox(height: 10,),
          ElevatedButton(onPressed: (){context.read<AuthBloc>().add(RegistrationEvent(emailController.text, usernameController.text, passwordController.text));}, child: Text("Завершить"))
        ],),
      )
    );
  }

  Widget OverlayWidget(BuildContext context, OverlayEntry? entry)
  {
    return Align(
      alignment: Alignment.center,
      child: Container(width: MediaQuery.of(context).size.width*0.8, constraints: BoxConstraints(maxWidth: 700), decoration: 
        BoxDecoration(
          color: AppTheme.bottomNavigationColor,
          borderRadius: BorderRadius.all(Radius.circular(30)),
          boxShadow: [BoxShadow(color: Colors.black, blurRadius: 20)]
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 20, height: 20,),
                Expanded(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Хотите отменить регистрацию?", textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontFamily: "Montserrat", fontWeight: FontWeight.normal, color: AppTheme.mainTextColor, decoration: TextDecoration.none),),
                )),
                IconButton(onPressed: (){
                    entry?.remove();
                    entry = null;
                  },  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  style: ButtonStyle(
                    padding: WidgetStateProperty.all(EdgeInsets.all(5)),
                    minimumSize: WidgetStateProperty.all(Size.zero),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  iconSize: 20,
                  icon: Icon(Icons.close)
                )
              ],
            ),
            SizedBox(height: 10,),
            ElevatedButton(onPressed: (){
              FocusScope.of(context).unfocus();
              controllersReset();
              entry?.remove();
              entry = null;
              context.read<AuthBloc>().add(BackToEmail());
            }, child: Text("Отменить",)),
            SizedBox(height: 8,),
          ],),
        )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        AnimatedBackground(),
        BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
          if(state is NewEmailState)
          {
            return SafeArea(
              top: true,
              child: Positioned(top: 10, left: 10, child: IconButton(onPressed: (){
                FocusScope.of(context).unfocus();
                OverlayEntry? entry;
                entry = OverlayEntry(builder: (overlayContext) => Stack(
                  children: [GestureDetector(onTap: () {
                    entry?.remove();
                    entry = null;
                  }, child: Positioned.fill(child: Container(color: const Color.fromARGB(182, 0, 0, 0),))), OverlayWidget(context, entry)],
                ),);
                Overlay.of(context).insert(entry!);

              //  context.read<AuthBloc>().add(BackToEmail());
              }, icon: Icon(Icons.arrow_back_outlined))),
            );
          }
          else if(state is EmailExistsState)
          {
            return SafeArea(
              top: true,
              child: Positioned(top: 10, left: 10, child: IconButton(onPressed: (){
                FocusScope.of(context).unfocus();
                controllersReset();
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
                return state.isVerifiedCode ? InitializationWidget(context) : AuthWidget(context, AuthPage.CodePage);
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

class PasswordTextField extends StatefulWidget {
  final TextEditingController controller;
  PasswordTextField({super.key, required this.controller});

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _isObscured = true;
  @override
  Widget build(BuildContext context) {
    return TextField(obscureText: _isObscured, controller: widget.controller, decoration: 
      InputDecoration(labelText: "Пароль", labelStyle: TextStyle(color: AppTheme.mainTextColor), focusColor: AppTheme.mainYellowColor,
      suffixIcon: IconButton(onPressed: () {
        setState(() {
          _isObscured = !_isObscured;
        });
      }, icon: Icon(_isObscured ? Icons.visibility : Icons.visibility_off)), 
      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.mainYellowColor), 
      borderRadius: BorderRadius.all(Radius.circular(10)),), 
      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)))),
    );
  }
}