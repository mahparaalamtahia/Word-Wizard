import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_datasource.dart';
import '../models/message_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDatasource remote;

  ChatRepositoryImpl(this.remote);

  @override
  Future<List<MessageModel>> getMessages(String bookingId) {
    return remote.getMessages(bookingId);
  }

  @override
  Stream<List<MessageModel>> messagesStream(String bookingId) {
    return remote.messagesStream(bookingId);
  }

  @override
  Future<MessageModel> sendMessage({
    required String bookingId,
    required String content,
  }) {
    return remote.sendMessage(bookingId: bookingId, content: content);
  }

  @override
  Future<void> markAsRead(String bookingId) {
    return remote.markAsRead(bookingId);
  }
}
