import '../../data/models/message_model.dart';

abstract class ChatRepository {
  Future<List<MessageModel>> getMessages(String bookingId);
  Stream<List<MessageModel>> messagesStream(String bookingId);
  Future<MessageModel> sendMessage({
    required String bookingId,
    required String content,
  });
  Future<void> markAsRead(String bookingId);
}
