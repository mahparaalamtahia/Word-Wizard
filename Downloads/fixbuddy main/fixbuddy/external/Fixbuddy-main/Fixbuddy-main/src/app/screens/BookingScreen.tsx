import { useState } from 'react';
import { useNavigate, useParams } from 'react-router';
import { ArrowLeft, Calendar as CalendarIcon, Clock } from 'lucide-react';

const timeSlots = [
  '09:00 AM', '10:00 AM', '11:00 AM', '12:00 PM',
  '01:00 PM', '02:00 PM', '03:00 PM', '04:00 PM',
  '05:00 PM', '06:00 PM',
];

export default function BookingScreen() {
  const navigate = useNavigate();
  const { workerId } = useParams();
  const [selectedDate, setSelectedDate] = useState('');
  const [selectedTime, setSelectedTime] = useState('');

  const handleConfirmBooking = () => {
    if (selectedDate && selectedTime) {
      navigate('/booking-confirmation', {
        state: { workerId, date: selectedDate, time: selectedTime },
      });
    }
  };

  const today = new Date();
  const dates = Array.from({ length: 7 }, (_, i) => {
    const date = new Date(today);
    date.setDate(today.getDate() + i);
    return date;
  });

  return (
    <div className="min-h-screen bg-white pb-6">
      <div className="sticky top-0 bg-white border-b border-border px-6 py-4 flex items-center gap-4">
        <button onClick={() => navigate(-1)}>
          <ArrowLeft className="w-6 h-6" />
        </button>
        <h1 className="flex-1">Book Service</h1>
      </div>

      <div className="px-6 py-6">
        <div className="mb-8">
          <div className="flex items-center gap-3 mb-4">
            <CalendarIcon className="w-6 h-6 text-primary" />
            <h2>Select Date</h2>
          </div>

          <div className="flex gap-3 overflow-x-auto pb-2 scrollbar-hide">
            {dates.map((date) => {
              const dateStr = date.toISOString().split('T')[0];
              const isSelected = selectedDate === dateStr;
              const dayName = date.toLocaleDateString('en-US', { weekday: 'short' });
              const dayNum = date.getDate();

              return (
                <button
                  key={dateStr}
                  onClick={() => setSelectedDate(dateStr)}
                  className={`flex flex-col items-center gap-2 px-4 py-3 rounded-xl min-w-[80px] transition-colors ${
                    isSelected
                      ? 'bg-primary text-white'
                      : 'bg-secondary text-foreground'
                  }`}
                >
                  <span className="text-sm">{dayName}</span>
                  <span className="text-xl">{dayNum}</span>
                </button>
              );
            })}
          </div>
        </div>

        <div className="mb-8">
          <div className="flex items-center gap-3 mb-4">
            <Clock className="w-6 h-6 text-primary" />
            <h2>Select Time</h2>
          </div>

          <div className="grid grid-cols-3 gap-3">
            {timeSlots.map((time) => {
              const isSelected = selectedTime === time;
              return (
                <button
                  key={time}
                  onClick={() => setSelectedTime(time)}
                  className={`py-3 rounded-xl transition-colors ${
                    isSelected
                      ? 'bg-primary text-white'
                      : 'bg-secondary text-foreground'
                  }`}
                >
                  {time}
                </button>
              );
            })}
          </div>
        </div>

        {selectedDate && selectedTime && (
          <div className="bg-secondary rounded-xl p-4 mb-6">
            <h3 className="mb-2">Booking Summary</h3>
            <div className="space-y-1 text-sm">
              <p>
                <span className="text-muted-foreground">Date: </span>
                {new Date(selectedDate).toLocaleDateString('en-US', {
                  weekday: 'long',
                  year: 'numeric',
                  month: 'long',
                  day: 'numeric',
                })}
              </p>
              <p>
                <span className="text-muted-foreground">Time: </span>
                {selectedTime}
              </p>
            </div>
          </div>
        )}

        <button
          onClick={handleConfirmBooking}
          disabled={!selectedDate || !selectedTime}
          className="w-full py-4 bg-primary text-white rounded-xl shadow-sm disabled:opacity-50 disabled:cursor-not-allowed"
        >
          Confirm Booking
        </button>
      </div>
    </div>
  );
}
