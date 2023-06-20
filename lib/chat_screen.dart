// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, prefer_typing_uninitialized_variables, deprecated_member_use, must_be_immutable

import 'dart:async';
import 'package:chat/classes.dart';
import 'package:chat/global_variables.dart';
import 'package:chat/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';


class ChatScreen extends StatefulWidget {
  
  ChatScreen({super.key, required this.data, required this.index});

  var data; 
  int index;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}




class _ChatScreenState extends State<ChatScreen> {

  
  List<ChatMessage> messages = [];
  
  late ChatRoom chatRoomData;
  
  final _text = TextEditingController();

  bool hasText = false;


   @override
   void initState(){
    super.initState();
    chatRoomData = widget.data;
    messages = chatRoomData.messages;
    listMembersAsString();
    scrollToBottom();
  }

  
  _ChatScreenState(){

    //to listen to the controller used for new messages 
    _text.addListener(() {
       if (_text.text.isEmpty) {
        setState(() {
          hasText = false;    
        });
      } else {
        setState(() {
          hasText = true;
       });
      }
    });
  }

  
  var scrollController = ScrollController();


  //called when user sends a message
  void sendMessage(){
    
    messages.add(
      ChatMessage(
        messageContent: _text.text, 
        sender: "You", 
        datePost: "Today",
        timePost: DateFormat.jm().format(DateTime.now())
      )
    );

    chatRooms[widget.index].lastMessage = _text.text;
    chatRooms[widget.index].modifiedAt = DateTime.now().microsecondsSinceEpoch;
    chatRooms[widget.index].lastSender = "You";

    _text.clear();

    scrollToBottom();

    setState(() { });
    

  //waits for 2 seconds then a message is added
  Timer(Duration(seconds: 2), () async{
      
    messages.add(
      ChatMessage(
        messageContent: "Message Recieved. \n This is my reply", 
        sender: chatRoomData.members[0], 
        datePost: "Today",
        timePost: DateFormat.jm().format(DateTime.now())
      )
    );

    chatRooms[widget.index].lastMessage = "Message Recieved. \n This is my reply";
    chatRooms[widget.index].modifiedAt = DateTime.now().microsecondsSinceEpoch;
    chatRooms[widget.index].lastSender = chatRoomData.members[0];

    scrollToBottom();

    setState(() { });

    });
  }

  
  String members = '';

  //converts the list of members to a string
  void listMembersAsString(){
    members = "You";

    for (int i = 0; i< chatRoomData.members.length; i++){
      members = members + ', ' + chatRoomData.members[i];
    }
  }
  

  //Used to scroll to the bottom of the screen
  void scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    } else {
      Timer(Duration(milliseconds: 1), () => scrollToBottom());
    }
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        toolbarHeight: 90,
        centerTitle: false,
        leadingWidth: 40,
        leading: InkWell(
          onTap: (){
            Navigator.pop(context);
          },
          child: Icon(Icons.keyboard_arrow_left, color: black, size: 28,)
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Color.fromRGBO(154, 181, 158, 1),
              child: SvgPicture.asset('assets/svgs/group.svg', color: white,),
            ),
            hspacer(13),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(chatRoomData.topic, style: ptstyle(size: 18, weight: 600, color: black),),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Text(members, style: ptstyle(size: 13, weight: 400, color: black),)
                ),
              ],
            )
          ],
        ),
      ),

    body: Stack(
        children: [
         
         chatRoomData.messages.isEmpty?
          Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          )
          :
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: SingleChildScrollView(
            controller: scrollController,
            child: ListView.builder(
              itemCount: messages.length,
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 10, bottom: 20),
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index){
                return Padding(
                  padding: EdgeInsets.only(bottom: index == messages.length - 1? 120 : 0),
                  child: Container(
                      padding: EdgeInsets.only(bottom:5.0, left: 10, right: 10, top: 5.0),
                      child: Column(
                        crossAxisAlignment: messages[index].sender == "You"? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                        messages[index].datePost == '' || (index > 0 && messages[index - 1].datePost == messages[index].datePost)?
                        SizedBox()
                          :
                         Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(15),),
                                color: Color.fromRGBO(154, 181, 158, 1)
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                              child: Text(messages[index].datePost, style: ptstyle(color: Colors.white, size: 12, weight: 500,))
                            ),
                          ),
                        ),
                      
                      Text(messages[index].sender, style: ptstyle(size: 12, weight: 500, color: black),),
                
                      spacer(6),
                
                      Padding(
                        padding: messages[index].sender == "You"? EdgeInsets.only(left: 70.0) : EdgeInsets.only(right:70),
                        child: Material(
                          borderRadius: messages[index].sender == "You"? BorderRadius.only(
                          topLeft:Radius.circular(30),
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                          )
                        : 
                        BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                          topRight: Radius.circular(30)
                        ),
                      elevation: 1.0,
                      color: messages[index].sender == "You"? Color.fromRGBO(233, 233, 235, 1) : green,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                        child: Text(
                          messages[index].messageContent,
                          style: ptstyle(size: 15.0, weight: 500, color: messages[index].sender != "You"? Colors.white : Colors.black,),
                        ),
                      ),
                      ),
                     ),
                        
                     Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(messages[index].timePost, style: ptstyle(size: 12, weight: 500, color: Color.fromRGBO(138, 144, 153, 1))),
                      ),
                    ],
                  ),
                ),
              );   
            },
          ),
        ),
      ),

          Padding(
            padding: const EdgeInsets.only(top: 300.0),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                padding: EdgeInsets.only(left: 10,bottom: 0,top: 0, right: 10),
                width: double.infinity,
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    
                    Icon(Icons.add, color: green, size: 20),
                    
                    hspacer(15),
                      
                    Expanded(
                     child: TextField(
                      autocorrect: true,
                      maxLines: null,
                      minLines: null,
                      expands: false,
                      onTap: (){
                        scrollToBottom();
                      },
                      style: ptstyle(size: 14, weight: 500),
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        hintText: "Write message...",
                        hintStyle: ptstyle(color: grey, size: 13, weight: 400),
                        border: InputBorder.none,
                       ),
                        controller: _text,
                      ),
                     ),
                    
                    SizedBox(width: 15,),
                    
                    hasText == true?
                    
                      InkWell(
                        onTap: (){
                          sendMessage();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 3.0),
                          child: Icon(Icons.send, color: green, size: 20,),
                        ),
                      ) 
                      :
                    SizedBox(width: 10),
                  ],
                ),
              ),
             ),
            ),
        ],
      ),
    );
  }
}