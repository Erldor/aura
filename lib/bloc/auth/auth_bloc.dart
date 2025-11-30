import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger/repository/user_repository.dart';

//
//  EVENTS
//

abstract class AuthEvent {}

class EnterEmail extends AuthEvent
{
  final String email;
  EnterEmail(this.email);
}

class EnterPasswordEvent extends AuthEvent {
  final String email;
  final String password;
  EnterPasswordEvent(this.email, this.password);
}

class SendCodeEvent extends AuthEvent {
  final String email;
  SendCodeEvent(this.email);
}

class RegistrationEvent extends AuthEvent {
  final String email;
  final String password;
  final String username;
  RegistrationEvent(this.email, this.username, this.password);
}

class EnterCodeEvent extends AuthEvent {
  final String email;
  final String code;
  EnterCodeEvent(this.email, this.code);
}

class BackToEmail extends AuthEvent {
  BackToEmail();
}
//
//  STATES
//

abstract class AuthState {
  String? errorMessage;

  AuthState({this.errorMessage});
}

class AuthInitial extends AuthState {
  AuthInitial({String? errorMessage}) : super(errorMessage: errorMessage);
}

class EmailExistsState extends AuthState {
  EmailExistsState({String? errorMessage}) : super(errorMessage: errorMessage);
}

class NewEmailState extends AuthState {
  final bool isVerifiedCode;
  NewEmailState({this.isVerifiedCode = false, String? errorMessage}) : super(errorMessage: errorMessage);
}

class Authenticated extends AuthState{}


//
//  BLOC
//

bool isValidEmail(String email) {
  return RegExp(
    r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"
  ).hasMatch(email);
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final String baseUrl;

  AuthBloc({required this.baseUrl}) : super(AuthInitial())
  {
    UserRepository userRepository = UserRepository(baseUrl: baseUrl);

    // Registration code send function
    Future<void> _sendCode(String email) async
    {
      bool isSended = await userRepository.sendCodeStatus(email);
      if (!isSended) {
        emit(AuthInitial(errorMessage: "Не удалось отправить код, попробуйте попозже"));
      }
      else
      {
        emit(NewEmailState(errorMessage: "Код был отправлен на адрес $email"));
      }
    }

    //  Email enter
    on<EnterEmail>((event, emit) async {
      if(event.email.isEmpty || !isValidEmail(event.email))
      {
        emit(AuthInitial(errorMessage: "Укажите правильную почту"));
        return;
      }

      final bool exists = await userRepository.getUser(event.email);

      if (exists) {
        emit(EmailExistsState());
      } else {
        emit(NewEmailState());
        await _sendCode(event.email);
      }

    });

    //  Back to Email enter
    on<BackToEmail>((event, emit) {
      emit(AuthInitial());
      return;
    },);

    on<RegistrationEvent>((event, emit) async {
      if(event.password.length < 8)
      {
        emit(NewEmailState(isVerifiedCode: true, errorMessage: "Пароль должен содержать минимум 8 символов"));
      }

      if(event.username.length < 2)
      {
        emit(NewEmailState(isVerifiedCode: true, errorMessage: "Имя должно быть длиной минимум 2 букв"));
        return;
      }
      

      RegisterResult result = await userRepository.register(email: event.email, username: event.username, password: event.password);

      if(result.success == true)
      {
        emit(Authenticated());
      }
      else
      {
        emit(NewEmailState(isVerifiedCode: true, errorMessage: result.error));
      }
    
    },);

    //  Password Enter (authentication)
    on<EnterPasswordEvent>((event, emit) async {

      if(event.password.isEmpty) {
        emit(EmailExistsState(errorMessage: "Введите корректный пароль"));
        return;
      }

      final LoginResult result = await userRepository.login(event.email, event.password);

      if(result.success)
      {
        emit(Authenticated());
      }
      else
      {
        emit(EmailExistsState(errorMessage: result.error));
      }

    });


    //  Code enter (registration)
    on<EnterCodeEvent>((event, emit) async {
      bool isVerified = await userRepository.verifyCode(event.email, event.code);

      if (isVerified) {
        emit(NewEmailState(isVerifiedCode: true));
      } else {
        emit(NewEmailState(errorMessage: "Неверный код"));
      }
    },);
  }
}