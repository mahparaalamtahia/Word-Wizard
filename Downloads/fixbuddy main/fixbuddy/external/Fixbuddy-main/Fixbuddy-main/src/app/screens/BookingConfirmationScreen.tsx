import { useNavigate, useLocation } from 'react-router';
import { CheckCircle, Calendar, Clock, User } from 'lucide-react';

export default function BookingConfirmationScreen() {
  const navigate = useNavigate();
  const location = useLocation();
  const { workerId, date, time } = location.state || {};

  return (
    <div className="min-h-screen bg-white flex flex-col items-center justify-center px-6">
      <div className="flex flex-col items-center max-w-sm">
        <div className="mb-6">
          <CheckCircle className="w-24 h-24 text-green-500" strokeWidth={1.5} />
        </div>

        <h1 className="text-3xl mb-2 text-center">Booking Confirmed!</h1>
        <p className="text-muted-foreground text-center mb-8">
          Your booking request has been sent to the worker
        </p>

        <div className="w-full bg-secondary rounded-xl p-6 mb-8">
          <h3 className="mb-4 text-center">Booking Details</h3>
          <div className="space-y-4">
            <div className="flex items-center gap-3">
              <div className="p-2 bg-white rounded-lg">
                <User className="w-5 h-5 text-primary" />
              </div>
              <div>
                <p className="text-sm text-muted-foreground">Worker</p>
                <p>Kabir Hossain</p>
              </div>
            </div>
            <div className="flex items-center gap-3">
              <div className="p-2 bg-white rounded-lg">
                <Calendar className="w-5 h-5 text-primary" />
              </div>
              <div>
                <p className="text-sm text-muted-foreground">Date</p>
                <p>
                  {date
                    ? new Date(date).toLocaleDateString('en-US', {
                        weekday: 'long',
                        month: 'short',
                        day: 'numeric',
                      })
                    : 'Tomorrow'}
                </p>
              </div>
            </div>
            <div className="flex items-center gap-3">
              <div className="p-2 bg-white rounded-lg">
                <Clock className="w-5 h-5 text-primary" />
              </div>
              <div>
                <p className="text-sm text-muted-foreground">Time</p>
                <p>{time || '10:00 AM'}</p>
              </div>
            </div>
          </div>
        </div>

        <div className="w-full space-y-3">
          <button
            onClick={() => navigate('/bookings')}
            className="w-full py-4 bg-primary text-white rounded-xl shadow-sm"
          >
            View My Bookings
          </button>
          <button
            onClick={() => navigate('/home')}
            className="w-full py-4 bg-secondary text-foreground rounded-xl"
          >
            Back to Home
          </button>
        </div>
      </div>
    </div>
  );
}
