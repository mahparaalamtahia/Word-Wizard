import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../features/auth/presentation/providers/auth_providers.dart';
import '../../../../features/auth/presentation/providers/auth_state_provider.dart';
import '../../data/datasources/chat_remote_datasource.dart';
import '../../data/models/message_model.dart';
import '../../data/repositories/chat_repository_impl.dart';
import '../../domain/repositories/chat_repository.dart';

final chatRemoteDatasourceProvider = Provider<ChatRemoteDatasource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return ChatRemoteDatasource(client);
});

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final remote = ref.watch(chatRemoteDatasourceProvider);
  return ChatRepositoryImpl(remote);
});

final messagesStreamProvider =
    StreamProvider.autoDispose.family<List<MessageModel>, String>((ref, bookingId) {
  if (bookingId.isEmpty) {
    return Stream.value(const <MessageModel>[]);
  }
  final repository = ref.watch(chatRepositoryProvider);
  return repository.messagesStream(bookingId);
});

final markMessagesReadProvider = FutureProvider.autoDispose.family<void, String>((ref, bookingId) async {
  if (bookingId.isEmpty) {
    return;
  }
  final repository = ref.watch(chatRepositoryProvider);
  await repository.markAsRead(bookingId);
});

/// List all conversations for current user
final listConversationsProvider = FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  final authState = ref.watch(authStateProvider);
  final userId = authState.user?.id;
  final client = ref.watch(supabaseClientProvider);
  
  if (userId == null) return [];
  
  try {
    // Get all bookings for the current user (as either user or worker)
    final bookings = await client
        .from('bookings')
        .select('''
          id,
          user_id,
          worker_id,
          status,
          created_at,
          updated_at
        ''')
        .or('user_id.eq.$userId,worker_id.eq.$userId')
        .order('updated_at', ascending: false);

    // Get latest messages and participant info for each booking
    final conversations = <Map<String, dynamic>>[];
    for (final booking in bookings) {
      final bookingId = booking['id'];
      
      // Get latest message
      final latestMessage = await client
          .from('messages')
          .select('content, created_at, sender_id')
          .eq('booking_id', bookingId)
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();

      // Determine the other participant
      final isUserInitiator = booking['user_id'] == userId;
      final participantId = isUserInitiator ? booking['worker_id'] : booking['user_id'];
      
      // Get participant info
      final participant = await client
          .from('profiles')
          .select('id, full_name, photo_url')
          .eq('id', participantId)
          .maybeSingle();

      // Check unread count - get messages not read by current user
      final unreadMessages = await client
          .from('messages')
          .select('id')
          .eq('booking_id', bookingId)
          .eq('is_read', false)
          .not('sender_id', 'eq', userId);

      conversations.add({
        'bookingId': bookingId,
        'workerId': isUserInitiator ? booking['worker_id'] : booking['user_id'],
        'participantName': participant?['full_name'] ?? 'Unknown',
        'participantPhoto': participant?['photo_url'],
        'lastMessage': latestMessage?['content'] ?? 'No messages yet',
        'timestamp': latestMessage != null 
            ? DateTime.parse(latestMessage['created_at'])
            : DateTime.parse(booking['updated_at']),
        'unread': (unreadMessages as List).isNotEmpty,
        'status': booking['status'],
      });
    }
    
    return conversations;
  } catch (e) {
    throw Exception('Failed to fetch conversations: $e');
  }
});
