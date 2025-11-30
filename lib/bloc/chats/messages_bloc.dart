import 'package:flutter_bloc/flutter_bloc.dart';

class Message {
  final String id;
  final String chatId;
  final String text;
  final bool isMe;

  Message({
    required this.id,
    required this.chatId,
    required this.text,
    required this.isMe,
  });
}

//
//  EVENTS
//

abstract class MessagesEvent {}

class LoadMessages extends MessagesEvent {
  final String chatId;
  LoadMessages(this.chatId);
}

class SendMessage extends MessagesEvent {
  final String chatId;
  final String text;
  SendMessage(this.chatId, this.text);
}

//
//  STATES
//

abstract class MessagesState {}

class MessagesLoading extends MessagesState {}

class MessagesLoaded extends MessagesState {
  final List<Message> messages;
  MessagesLoaded(this.messages);
}

//
//  BLOC
//

class MessagesBloc extends Bloc<MessagesEvent, MessagesState> {
  // локальная база сообщений
  final Map<String, List<Message>> _messages = {
    "1": [Message(id: "1", chatId: "1", text: "Привет!", isMe: false)],
    "2": [],
    "3": [],
  };

  MessagesBloc() : super(MessagesLoading()) {
    on<LoadMessages>((event, emit) {
      emit(MessagesLoaded(_messages[event.chatId] ?? []));
    });

    on<SendMessage>((event, emit) {
      final list = _messages[event.chatId] ?? [];

      final msg = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        chatId: event.chatId,
        text: event.text,
        isMe: true,
      );

      list.add(msg);
      _messages[event.chatId] = list;

      emit(MessagesLoaded(List.from(list))); // копия, чтобы UI обновился
    });
  }
}