import 'package:flutter/material.dart';
import 'package:messenger/data/app_theme.dart';

class ChatWidget extends StatelessWidget {
  String title = "";
  String lastMessage = "";
  String? avatarUrl;

  ChatWidget({super.key, required this.title, this.lastMessage = "", this.avatarUrl});

  Widget ChatFront()
  {
    if(avatarUrl == null)
    {
      return Center(child: Text(title[0], style: TextStyle(color: AppTheme.mainYellowColor, fontSize: 35, fontFamily: "Montserrat"),));
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.only(topRight: Radius.circular(17), bottomRight: Radius.circular(17), bottomLeft: Radius.circular(17), topLeft: Radius.circular(5)),
        child: Image.network(avatarUrl!),
      ),
    );
    
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(width: 100, height: 100, decoration: BoxDecoration(color: AppTheme.appBarColor,
                borderRadius: BorderRadius.only(topRight: Radius.circular(25), bottomRight: Radius.circular(25)),
              ),
                child: ChatFront(),
              ),
              Expanded(
                child: Column(mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Align(alignment: Alignment.topRight, child: Padding(
                      padding: const EdgeInsets.only(right: 15, bottom: 15),
                      child: Text(title, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 21), maxLines: 1, overflow: TextOverflow.ellipsis,),
                    )),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15, right: 40),
                        child: Text(lastMessage, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w200, color: AppTheme.chatGreyColor), textAlign: TextAlign.left, maxLines: 2, overflow: TextOverflow.ellipsis,),
                      ),
                    ),
                  ],
                ),
              )
              
            ],),
          ),
          Container(height: 1, width: MediaQuery.of(context).size.width - 30, color: AppTheme.bottomNavigationColor,)
        ],
      ),
    );
  }
}
