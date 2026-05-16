import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final conversationsProvider = FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  final userId = Supabase.instance.client.auth.currentUser?.id;
  if (userId == null) return [];

  try {
    final response = await Supabase.instance.client
        .from('messages')
        .select('''
          id,
          booking_id,
          sender_id,
          receiver_id,
          content,
          created_at,
          read_at
        ''')
        .or('sender_id.eq.$userId,receiver_id.eq.$userId')
        .order('created_at', ascending: false)
        .limit(100);

    // Group messages by conversation partner
    final Map<String, Map<String, dynamic>> conversations = {};

    for (final msg in response as List) {
      final otherUserId = msg['sender_id'] == userId ? msg['receiver_id'] : msg['sender_id'];
      final bookingId = (msg['booking_id'] ?? '').toString();
      
      if (!conversations.containsKey(otherUserId)) {
        conversations[otherUserId] = {
          'id': otherUserId,
          'bookingId': bookingId,
          'last_message': msg['content'] ?? '',
          'last_message_time': _formatTime(msg['created_at']),
          'unread_count': msg['read_at'] == null && msg['receiver_id'] == userId ? 1 : 0,
          'other_user_name': 'User ${otherUserId.substring(0, 8)}',
        };
      } else {
        if (bookingId.isNotEmpty) {
          conversations[otherUserId]!['bookingId'] = bookingId;
        }
        // Count unread messages
        if (msg['read_at'] == null && msg['receiver_id'] == userId) {
          conversations[otherUserId]!['unread_count'] = 
              (conversations[otherUserId]!['unread_count'] as int) + 1;
        }
      }
    }

    return conversations.values.toList();
  } catch (e) {
    return [];
  }
});

String _formatTime(String timestamp) {
  try {
    final dt = DateTime.parse(timestamp);
    final now = DateTime.now();
    final diff = now.difference(dt);

    if (diff.inMinutes < 1) return 'Now';
    if (diff.inHours < 1) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}d';
    
    return '${dt.month}/${dt.day}';
  } catch (e) {
    return '';
  }
}
