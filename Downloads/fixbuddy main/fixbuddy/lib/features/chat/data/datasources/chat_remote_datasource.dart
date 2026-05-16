import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/message_model.dart';

class ChatRemoteDatasource {
  final SupabaseClient _client;

  ChatRemoteDatasource(this._client);

  Future<List<MessageModel>> getMessages(String bookingId) async {
    final data = await _client
        .from('messages')
        .select('*')
        .eq('booking_id', bookingId)
        .order('created_at', ascending: true);

    return (data as List)
        .whereType<Map<String, dynamic>>()
        .map(MessageModel.fromJson)
        .toList();
  }

  Future<MessageModel> sendMessage({
    required String bookingId,
    required String content,
  }) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      throw StateError('User must be authenticated to send message');
    }

    final data = await _client
        .from('messages')
        .insert({
          'booking_id': bookingId,
          'sender_id': userId,
          'content': content,
        })
        .select()
        .single();

    return MessageModel.fromJson(data as Map<String, dynamic>);
  }

  Stream<List<MessageModel>> messagesStream(String bookingId) {
    return _client
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('booking_id', bookingId)
        .order('created_at', ascending: true)
        .map((rows) => rows.map(MessageModel.fromJson).toList());
  }

  Future<void> markAsRead(String bookingId) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return;

    await _client
        .from('messages')
        .update({'is_read': true})
        .eq('booking_id', bookingId)
        .neq('sender_id', userId)
        .eq('is_read', false);
  }
}
