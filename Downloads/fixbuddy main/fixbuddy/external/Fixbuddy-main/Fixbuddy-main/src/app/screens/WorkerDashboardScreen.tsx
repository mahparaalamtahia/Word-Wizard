import { useNavigate } from 'react-router';
import { ArrowLeft, CheckCircle, XCircle, User, Calendar, Clock } from 'lucide-react';

const bookingRequests = [
  {
    id: 1,
    customer: 'Ayesha Rahman',
    service: 'Fix leaking pipe',
    date: '2026-04-12',
    time: '10:00 AM',
    location: 'Dhanmondi',
  },
  {
    id: 2,
    customer: 'Farhan Chowdhury',
    service: 'Install water heater',
    date: '2026-04-13',
    time: '02:00 PM',
    location: 'Gulshan',
  },
  {
    id: 3,
    customer: 'Sultana Begum',
    service: 'Bathroom plumbing',
    date: '2026-04-14',
    time: '11:00 AM',
    location: 'Uttara',
  },
];

export default function WorkerDashboardScreen() {
  const navigate = useNavigate();

  const handleAccept = (id: number) => {
    alert(`Accepted booking request #${id}`);
  };

  const handleReject = (id: number) => {
    alert(`Rejected booking request #${id}`);
  };

  return (
    <div className="min-h-screen bg-white pb-6">
      <div className="sticky top-0 bg-white border-b border-border px-6 py-4 flex items-center gap-4">
        <button onClick={() => navigate('/home')}>
          <ArrowLeft className="w-6 h-6" />
        </button>
        <h1 className="flex-1">Worker Dashboard</h1>
      </div>

      <div className="px-6 py-6">
        <div className="bg-primary rounded-xl p-6 mb-6 text-white">
          <div className="flex items-center gap-4 mb-4">
            <div className="text-5xl">👨‍🔧</div>
            <div>
              <h2 className="text-xl mb-1">Kabir Hossain</h2>
              <p className="text-white/80">Plumber</p>
            </div>
          </div>
          <div className="grid grid-cols-3 gap-4 text-center">
            <div>
              <p className="text-2xl mb-1">124</p>
              <p className="text-sm text-white/80">Jobs Done</p>
            </div>
            <div>
              <p className="text-2xl mb-1">4.8</p>
              <p className="text-sm text-white/80">Rating</p>
            </div>
            <div>
              <p className="text-2xl mb-1">3</p>
              <p className="text-sm text-white/80">Pending</p>
            </div>
          </div>
        </div>

        <div className="mb-4">
          <h2>Booking Requests</h2>
        </div>

        {bookingRequests.length === 0 ? (
          <div className="flex flex-col items-center justify-center py-16">
            <div className="text-6xl mb-4">📋</div>
            <p className="text-muted-foreground">No pending requests</p>
          </div>
        ) : (
          <div className="space-y-4">
            {bookingRequests.map((request) => (
              <div
                key={request.id}
                className="bg-white border border-border rounded-xl p-4 shadow-sm"
              >
                <div className="flex items-start gap-3 mb-4">
                  <div className="p-2 bg-secondary rounded-full">
                    <User className="w-5 h-5 text-primary" />
                  </div>
                  <div className="flex-1">
                    <h3 className="mb-1">{request.customer}</h3>
                    <p className="text-sm text-muted-foreground mb-3">
                      {request.service}
                    </p>
                    <div className="space-y-1 text-sm">
                      <div className="flex items-center gap-2 text-muted-foreground">
                        <Calendar className="w-4 h-4" />
                        <span>
                          {new Date(request.date).toLocaleDateString('en-US', {
                            month: 'short',
                            day: 'numeric',
                            year: 'numeric',
                          })}
                        </span>
                      </div>
                      <div className="flex items-center gap-2 text-muted-foreground">
                        <Clock className="w-4 h-4" />
                        <span>{request.time}</span>
                      </div>
                    </div>
                  </div>
                </div>

                <div className="grid grid-cols-2 gap-3">
                  <button
                    onClick={() => handleAccept(request.id)}
                    className="flex items-center justify-center gap-2 py-2 bg-green-500 text-white rounded-lg"
                  >
                    <CheckCircle className="w-4 h-4" />
                    <span>Accept</span>
                  </button>
                  <button
                    onClick={() => handleReject(request.id)}
                    className="flex items-center justify-center gap-2 py-2 bg-red-500 text-white rounded-lg"
                  >
                    <XCircle className="w-4 h-4" />
                    <span>Reject</span>
                  </button>
                </div>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}
