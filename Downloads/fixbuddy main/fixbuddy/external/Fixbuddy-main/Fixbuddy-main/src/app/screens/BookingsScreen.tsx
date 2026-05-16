import { useState } from 'react';
import { useNavigate } from 'react-router';
import { Calendar, Clock, MapPin } from 'lucide-react';
import BottomNav from '../components/BottomNav';

const ongoingBookings = [
  {
    id: 1,
    worker: 'Kabir Hossain',
    category: 'Plumber',
    date: '2026-04-12',
    time: '10:00 AM',
    status: 'Confirmed',
    image: '👨‍🔧',
  },
  {
    id: 2,
    worker: 'Rahim Rahman',
    category: 'Tutor',
    date: '2026-04-15',
    time: '02:00 PM',
    status: 'Pending',
    image: '👨‍🏫',
  },
];

const completedBookings = [
  {
    id: 3,
    worker: 'Jamal Uddin',
    category: 'Painter',
    date: '2026-04-08',
    time: '11:00 AM',
    status: 'Completed',
    rated: false,
    image: '👨‍🎨',
  },
  {
    id: 4,
    worker: 'Nasrin Akter',
    category: 'Electrician',
    date: '2026-04-05',
    time: '09:00 AM',
    status: 'Completed',
    rated: true,
    image: '👩‍🔧',
  },
];

export default function BookingsScreen() {
  const navigate = useNavigate();
  const [activeTab, setActiveTab] = useState<'ongoing' | 'completed'>('ongoing');

  const bookings = activeTab === 'ongoing' ? ongoingBookings : completedBookings;

  return (
    <div className="min-h-screen bg-white pb-20">
      <div className="sticky top-0 bg-white border-b border-border px-6 py-4">
        <h1 className="mb-4">My Bookings</h1>

        <div className="flex gap-2">
          <button
            onClick={() => setActiveTab('ongoing')}
            className={`flex-1 py-2 rounded-lg transition-colors ${
              activeTab === 'ongoing'
                ? 'bg-primary text-white'
                : 'bg-secondary text-foreground'
            }`}
          >
            Ongoing
          </button>
          <button
            onClick={() => setActiveTab('completed')}
            className={`flex-1 py-2 rounded-lg transition-colors ${
              activeTab === 'completed'
                ? 'bg-primary text-white'
                : 'bg-secondary text-foreground'
            }`}
          >
            Completed
          </button>
        </div>
      </div>

      <div className="px-6 py-4">
        {bookings.length === 0 ? (
          <div className="flex flex-col items-center justify-center py-16">
            <div className="text-6xl mb-4">📋</div>
            <p className="text-muted-foreground">No bookings yet</p>
          </div>
        ) : (
          <div className="space-y-4">
            {bookings.map((booking) => (
              <div
                key={booking.id}
                className="bg-white border border-border rounded-xl p-4 shadow-sm"
              >
                <div className="flex gap-4 mb-4">
                  <div className="text-4xl">{booking.image}</div>
                  <div className="flex-1">
                    <h3 className="mb-1">{booking.worker}</h3>
                    <p className="text-sm text-muted-foreground">
                      {booking.category}
                    </p>
                  </div>
                  <div>
                    <span
                      className={`px-3 py-1 rounded-full text-xs ${
                        booking.status === 'Confirmed'
                          ? 'bg-green-100 text-green-700'
                          : booking.status === 'Pending'
                          ? 'bg-yellow-100 text-yellow-700'
                          : 'bg-gray-100 text-gray-700'
                      }`}
                    >
                      {booking.status}
                    </span>
                  </div>
                </div>

                <div className="flex items-center gap-4 text-sm text-muted-foreground mb-4">
                  <div className="flex items-center gap-1">
                    <Calendar className="w-4 h-4" />
                    <span>
                      {new Date(booking.date).toLocaleDateString('en-US', {
                        month: 'short',
                        day: 'numeric',
                      })}
                    </span>
                  </div>
                  <div className="flex items-center gap-1">
                    <Clock className="w-4 h-4" />
                    <span>{booking.time}</span>
                  </div>
                </div>

                {activeTab === 'ongoing' && (
                  <button
                    onClick={() => navigate(`/chat/${booking.id}`)}
                    className="w-full py-2 bg-primary text-white rounded-lg"
                  >
                    Chat with Worker
                  </button>
                )}

                {activeTab === 'completed' && !(booking as any).rated && (
                  <button
                    onClick={() => navigate(`/rating/${booking.id}`)}
                    className="w-full py-2 bg-primary text-white rounded-lg"
                  >
                    Rate Service
                  </button>
                )}
              </div>
            ))}
          </div>
        )}
      </div>

      <BottomNav />
    </div>
  );
}
