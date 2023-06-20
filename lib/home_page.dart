// ignore_for_file: prefer_const_constructors, depend_on_referenced_packages, deprecated_member_use

import 'dart:convert';
import 'package:chat/classes.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:chat/chat_screen.dart';
import 'package:chat/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}







List<ChatRoom> chatRooms = [];


class _HomePageState extends State<HomePage> {



  @override
  void initState() {
    super.initState();
    fetchChatRooms();
  }

  

  //fetches the chatrooms list from the online api
 Future fetchChatRooms() async{
    
  try{
  
    String apiurl = "${url}chat_room";

    var response = await http.get(
      Uri.parse(apiurl),
      headers: headers
    );

     if(response.statusCode == 200){
         
      var res = json.decode(response.body);

      List rooms = res['data']; 

      for(int i = 0; i<rooms.length; i++){

        var chatRoomData = rooms[i];

        List <ChatMessage> messageList = await fetchChats(chatRoomData['id']);

        String date = DateFormat.yMMMd().format(DateTime.fromMicrosecondsSinceEpoch(chatRoomData['modified_at']));
          
        if (date == DateFormat.yMMMd().format(DateTime.now())){
          date = 'Today';
        }

        messageList.add(
          ChatMessage(
            messageContent: chatRoomData["last_message"], 
            sender: chatRoomData["members"][0], 
            timePost: DateFormat.jm().format(DateTime.fromMicrosecondsSinceEpoch(chatRoomData['modified_at'])),
            datePost: date
          )
        );
        
        chatRooms.add(
          ChatRoom(
            id: chatRoomData['id'], 
            topic: chatRoomData["topic"]?? "No Topic", 
            lastMessage: chatRoomData["last_message"], 
            modifiedAt: chatRoomData["modified_at"],
            messages: messageList,
            members: chatRoomData["members"],
            lastSender: chatRoomData["members"][0]
          )
        );
      }
      
      setState(() {  });
    }

     else{
      noInternetSnackBar();
     }

  }

    catch(e){
      noInternetSnackBar();
    }
  }



//fetches the chats for a particular chatroom from the online api
Future<List<ChatMessage>> fetchChats(int chatId) async{
    
  try{
  
    String apiurl = "${url}chat_room/$chatId";

    var response = await http.get(Uri.parse(apiurl));

     if(response.statusCode == 200){
         
        var jsondata = json.decode(response.body);
        
        var chat = jsondata["data"];
        
        String date = DateFormat.yMMMd().format(DateTime.fromMicrosecondsSinceEpoch(chat['modified_at']));

        if (date == DateFormat.yMMMd().format(DateTime.now())){
          date = 'Today';
        }

        List<ChatMessage> messages = [];

        messages.add(
          ChatMessage(
            messageContent: chat['message'], 
            sender: chat['sender'], 
            datePost: date,
            timePost: DateFormat.jm().format(DateTime.fromMicrosecondsSinceEpoch(chat['modified_at']))
          )
        );

       return messages;
      }
     
     else{
        noInternetSnackBar();
     }

    return [];
  }

    catch(e){
      noInternetSnackBar();
    }

    return [];
  }



  var searchController = TextEditingController();

  bool _isSearching = false;
  List<ChatRoom> searchresult = [];



  _HomePageState() {

   searchController.addListener(() {
    setState(() {
      if (searchController.text.isEmpty) {
          _isSearching = false;
      } 
      else {
        _isSearching = true;
        searchOperation();
      }
    });
  });
  }

  //performs the search operation on the list of chatrooms.
  void searchOperation() {
    searchresult.clear();
    if (_isSearching == true) {
      for (int i = 0; i < chatRooms.length; i++) {
        String data = chatRooms[i].topic.toString();
        if (data.toLowerCase().contains(searchController.text.toLowerCase())) {
          searchresult.add(chatRooms[i]);
        }
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        toolbarHeight: 70,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Text('Chat Rooms', style: ptstyle(size: 18, weight: 600, color: black),),
            hspacer(8),
            SvgPicture.asset('assets/svgs/group.svg',)
          ],
        ),
      ),
      
      body: WillPopScope(
        onWillPop: (){
          SystemNavigator.pop();
          return Future(() => false);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            children: [
              
              spacer(20),
      
            chatRooms.isNotEmpty?
              Container(
                height: 39,
                width: double.infinity,
                color: Color.fromRGBO(247, 247, 252, 1),
                child: TextField(
                  controller: searchController,
                  textInputAction: TextInputAction.search,
                  style: ptstyle(size: 13, weight: 500, color: black),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(top: 4),
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search, color: grey,),
                    suffixIcon: _isSearching? InkWell(
                        onTap: (){
                          setState(() {
                            searchController.clear();
                          });
                        },
                        child: const Icon(
                          Icons.clear,
                          size: 14,
                          color: Colors.black,
                        ),
                      )
                      : null,
                    hintText: 'Search',
                    hintStyle: ptstyle(size: 13, weight: 600, color: grey)
                  ),
                ),
              )
              :
              spacer(40),
        
              spacer(15),
      
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async{
                    setState(() { });
                  },
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: chatRooms.isEmpty?
                      Padding(
                        padding: const EdgeInsets.only(top: 80.0),
                        child: Center(child: CircularProgressIndicator(),),
                      )
                      :
                      _isSearching?
                      
                      searchresult.isEmpty?
                       Padding(
                        padding: const EdgeInsets.only(top: 80.0),
                        child: Center(child: Text('No results found', style: ptstyle(size: 15, weight: 500, color: grey),)),
                      )
                      :
                    showGroups(searchresult)
                      :
                     showGroups(chatRooms),
                  ),
                ),
              )
        
            ],
          ),
        ),
      ),
    );
  }


  //show the chat rooms widgets
  showGroups(List<ChatRoom> dataList){
    List<Widget> list = [];

    for(int i = 0; i<dataList.length; i++){
      list.add(singleChatRoom(dataList[i], i));
    }

    return Column(
      children: list,
    );
  }
  
  
  //single chat room widget
  singleChatRoom(ChatRoom data, int index){
    return InkWell(
      onTap: () async{
        await customNavigation(context, ChatScreen(data: data, index: index,));
        setState(() { });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(
                  height: 48,
                  width: 60,
                  child: Stack(
                    children: [

                      Positioned(
                         right: 8,
                         child: Container(
                          height: 48,
                          width: 48,
                          decoration: boxDeco(radius: 16, color: Color.fromRGBO(194, 211, 197, 1)),
                        ),
                       ),

                      Container(
                        height: 48,
                        width: 48,
                        decoration: boxDeco(radius: 16, color: Color.fromRGBO(154, 181, 158, 1)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset('assets/svgs/group.svg', color: white,),
                        ),
                      ),
                    ],
                  ),
                ),
      
                hspacer(9),
      
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data.topic, style: ptstyle(size: 14, weight: 500),),
                    spacer(2),
                    Row(
                      children: [
                        Text('${data.lastSender}: ', style: ptstyle(size: 12, weight: 500, color: Color.fromRGBO(77, 82, 86, 1)),),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: Text(
                            data.lastMessage, 
                            maxLines: 1, 
                            overflow: TextOverflow.ellipsis,
                            style: ptstyle(size: 12, weight: 500, color: Color.fromRGBO(77, 82, 86, 1).withOpacity(0.5)),
                          )
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
      
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  DateFormat.Md().format(DateTime.now()) == DateFormat.Md().format(DateTime.fromMicrosecondsSinceEpoch(data.modifiedAt))?
                 DateFormat.jm().format(DateTime.fromMicrosecondsSinceEpoch(data.modifiedAt))
                  :
                 DateFormat.yMd().format(DateTime.fromMicrosecondsSinceEpoch(data.modifiedAt)), 
                style: ptstyle(size: 10, weight: 500, color: Color.fromRGBO(164, 164, 164, 1)),),
                spacer(10),
                Icon(Icons.check, color: green, size: 14,)
              ],
            )
          ],
        ),
      ),
    );
  }

}