import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger/bloc/chats/chats_bloc.dart';
import 'package:messenger/data/app_theme.dart';
import 'package:messenger/modules/chat_widget.dart';
import 'package:messenger/modules/custom_bottom_bar.dart';
import 'package:messenger/modules/chat_search.dart';

ValueNotifier<int> currentPageIndex = ValueNotifier(0);

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<ChatsBloc>().add(LoadChats()); // Временное решение
    return Scaffold(appBar: PreferredSize(
      preferredSize: Size.fromHeight(70),
      child: ValueListenableBuilder(
        valueListenable: currentPageIndex,
        builder: (context, pageIndex, child) {
          return AppBar(actions: [pageIndex  == 0 ? Padding(
            padding: EdgeInsets.only(right: 15),
            child: IconButton(onPressed: (){}, icon: Icon(Icons.search), iconSize: 30, color: AppTheme.mainYellowColor,),
          ) : SizedBox()],
            title: pageIndex == 0 ? ChatSearch() : Text("Профиль", style: TextStyle(fontWeight: FontWeight.w200, fontSize: 20),),
            centerTitle: true,
            toolbarHeight: 70,
            leading: Builder(
              builder: (context) {
                return Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: IconButton(onPressed: (){Scaffold.of(context).openDrawer();}, padding: EdgeInsets.zero, icon: Icon(Icons.menu), iconSize: 30,),
                );
              }
            ),
          );
        }
      ),
    ),
      drawer: Drawer(),

      bottomNavigationBar: CustomBottomBar(),

      body: ValueListenableBuilder(
        valueListenable: currentPageIndex,
        builder: (context, pageIndex, child) {
          return pageIndex == 0 ? BlocBuilder<ChatsBloc, ChatsState>(builder: (context, state) {
            if(state is ChatsLoaded)
            {
              return ListView.builder(itemCount: state.chats.length, itemBuilder: (context, index) {
                final  chat = state.chats[index];
          
                return ChatWidget(title: chat.title, avatarUrl: chat.avatarUrl, lastMessage: chat.lastMessage);
              },);
            }
            return Text("Ошибка");
          },) : Text("Profile");
        }
      )
    );
  }
}
