class ChatModel {
  final String chatId;
  final List<String> participants; // [clientUid, vendorUid]
  final String? lastMessage;
  final DateTime? lastMessageAt;
  final Map<String, int> unreadCount; // uid -> unread count

  const ChatModel({
    required this.chatId,
    required this.participants,
    this.lastMessage,
    this.lastMessageAt,
    this.unreadCount = const {},
  });

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      chatId: map['chatID'] as String,
      participants: List<String>.from(map['participants'] as List),
      lastMessage: map['lastMessage'] as String?,
      lastMessageAt: map['timestamp'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int)
          : null,
      unreadCount: Map<String, int>.from(map['unreadCount'] as Map? ?? {}),
    );
  }

  Map<String, dynamic> toMap() => {
        'chatID': chatId,
        'participants': participants,
        if (lastMessage != null) 'lastMessage': lastMessage,
        if (lastMessageAt != null)
          'timestamp': lastMessageAt!.millisecondsSinceEpoch,
        'unreadCount': unreadCount,
      };
}

class ChatMessage {
  final String messageId;
  final String chatId;
  final String senderId;
  final String text;
  final DateTime sentAt;
  final bool isRead;

  const ChatMessage({
    required this.messageId,
    required this.chatId,
    required this.senderId,
    required this.text,
    required this.sentAt,
    this.isRead = false,
  });

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      messageId: map['messageID'] as String,
      chatId: map['chatID'] as String,
      senderId: map['senderID'] as String,
      text: map['text'] as String,
      sentAt: DateTime.fromMillisecondsSinceEpoch(map['sentAt'] as int),
      isRead: map['isRead'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() => {
        'messageID': messageId,
        'chatID': chatId,
        'senderID': senderId,
        'text': text,
        'sentAt': sentAt.millisecondsSinceEpoch,
        'isRead': isRead,
      };
}
