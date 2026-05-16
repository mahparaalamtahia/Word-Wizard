import '../../../../core/services/supabase_service.dart';

class MessageModel {
  final String id;
  final String bookingId;
  final String senderId;
  final String content;
  final bool isRead;
  final DateTime createdAt;

  const MessageModel({
    required this.id,
    required this.bookingId,
    required this.senderId,
    required this.content,
    required this.isRead,
    required this.createdAt,
  });

  bool get isMe => senderId == SupabaseService.client.auth.currentUser?.id;

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: (json['id'] ?? '').toString(),
      bookingId: (json['booking_id'] ?? '').toString(),
      senderId: (json['sender_id'] ?? '').toString(),
      content: (json['content'] ?? '').toString(),
      isRead: json['is_read'] as bool? ?? false,
      createdAt: DateTime.tryParse((json['created_at'] ?? '').toString()) ?? DateTime.now(),
    );
  }
}
