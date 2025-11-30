import 'package:flutter_bloc/flutter_bloc.dart';

class Chat {
  final String id;
  final String title;
  final String lastMessage;
  final String? avatarUrl;

  Chat({
    required this.id,
    required this.title,
    required this.lastMessage,
    this.avatarUrl
  });
}

//
//  EVENTS
//

abstract class ChatsEvent {}

class LoadChats extends ChatsEvent {}

class OpenChat extends ChatsEvent {
  final String chatId;
  OpenChat(this.chatId);
}

//
//  STATES
//

abstract class ChatsState {}

class ChatsLoading extends ChatsState {}

class ChatsLoaded extends ChatsState {
  final List<Chat> chats;
  ChatsLoaded(this.chats);
}

class ChatOpened extends ChatsState {
  final String chatId;
  ChatOpened(this.chatId);
}

class ChatsError extends ChatsState {
  final String message;
  ChatsError(this.message);
}

//
//  BLOC
//

class ChatsBloc extends Bloc<ChatsEvent, ChatsState> {
  ChatsBloc() : super(ChatsLoading()) {
    on<LoadChats>((event, emit) {
      final chats = [
        Chat(id: "1", title: "Подруга", lastMessage: "Пошли гулять", avatarUrl:  "https://randomuser.me/api/portraits/women/5.jpg"),
        Chat(id: "2", title: "Друг", lastMessage: "Скинь лабы"),
        Chat(id: "3", title: "Работа", lastMessage: "Завтра в 9 утра нужно быть на работе, экстренно", avatarUrl:  "https://randomuser.me/api/portraits/women/68.jpg"),
      ];

      emit(ChatsLoaded(chats));
    });

    on<OpenChat>((event, emit) {
      emit(ChatOpened(event.chatId));
    });
  }
}