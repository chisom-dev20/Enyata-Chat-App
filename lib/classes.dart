
class ChatRoom{
  int id;
  String topic, lastMessage, lastSender;
  int modifiedAt;
  List<ChatMessage> messages = [];
  List members = [];

  ChatRoom({required this.id, required this.topic, required this.lastMessage, required this.modifiedAt, required this.messages, required this.members, required this.lastSender});
}



class ChatMessage{
  String messageContent, sender;
  String timePost;
  String datePost;
  ChatMessage({required this.messageContent, required this.sender, required this.timePost, required this.datePost});
}


