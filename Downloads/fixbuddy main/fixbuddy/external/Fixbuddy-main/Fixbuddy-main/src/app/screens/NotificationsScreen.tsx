import { useNavigate } from 'react-router';
import { ArrowLeft, CheckCircle, XCircle, Clock, Star } from 'lucide-react';
import BottomNav from '../components/BottomNav';

const notifications = [
  {
    id: 1,
    type: 'accepted',
    icon: CheckCircle,
    iconColor: 'text-green-500',
    title: 'Booking Accepted',
    message: 'Kabir Hossain accepted your booking request',
    time: '5 min ago',
  },
  {
    id: 2,
    type: 'rejected',
    icon: XCircle,
    iconColor: 'text-red-500',
    title: 'Booking Declined',
    message: 'Nasrin Akter declined your booking request',
    time: '1 hour ago',
  },
  {
    id: 3,
    type: 'reminder',
    icon: Clock,
    iconColor: 'text-primary',
    title: 'Upcoming Service',
    message: 'Your service with Rahim Rahman is tomorrow at 10:00 AM',
    time: '3 hours ago',
  },
  {
    id: 4,
    type: 'review',
    icon: Star,
    iconColor: 'text-yellow-500',
    title: 'Rate Your Experience',
    message: 'How was your service with Jamal Uddin?',
    time: '1 day ago',
  },
  {
    id: 5,
    type: 'accepted',
    icon: CheckCircle,
    iconColor: 'text-green-500',
    title: 'Booking Confirmed',
    message: 'Rupa Begum confirmed your booking',
    time: '2 days ago',
  },
];

export default function NotificationsScreen() {
  const navigate = useNavigate();

  return (
    <div className="min-h-screen bg-white pb-20">
      <div className="sticky top-0 bg-white border-b border-border px-6 py-4 flex items-center gap-4">
        <h1 className="flex-1">Notifications</h1>
      </div>

      <div className="px-6 py-4">
        {notifications.length === 0 ? (
          <div className="flex flex-col items-center justify-center py-16">
            <div className="text-6xl mb-4">🔔</div>
            <p className="text-muted-foreground">No notifications yet</p>
          </div>
        ) : (
          <div className="space-y-3">
            {notifications.map((notification) => {
              const Icon = notification.icon;
              return (
                <div
                  key={notification.id}
                  className="bg-white border border-border rounded-xl p-4 hover:shadow-sm transition-shadow"
                >
                  <div className="flex gap-4">
                    <div className="flex-shrink-0">
                      <Icon className={`w-6 h-6 ${notification.iconColor}`} />
                    </div>
                    <div className="flex-1">
                      <h3 className="mb-1">{notification.title}</h3>
                      <p className="text-sm text-muted-foreground mb-2">
                        {notification.message}
                      </p>
                      <p className="text-xs text-muted-foreground">
                        {notification.time}
                      </p>
                    </div>
                  </div>
                </div>
              );
            })}
          </div>
        )}
      </div>

      <BottomNav />
    </div>
  );
}
