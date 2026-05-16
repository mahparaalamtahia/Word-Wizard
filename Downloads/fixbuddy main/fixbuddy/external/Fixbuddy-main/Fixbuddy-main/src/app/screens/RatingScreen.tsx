import { useState } from 'react';
import { useNavigate, useParams } from 'react-router';
import { ArrowLeft, Star } from 'lucide-react';

export default function RatingScreen() {
  const navigate = useNavigate();
  const { bookingId } = useParams();
  const [rating, setRating] = useState(0);
  const [hoveredRating, setHoveredRating] = useState(0);
  const [review, setReview] = useState('');

  const handleSubmit = () => {
    navigate('/bookings');
  };

  return (
    <div className="min-h-screen bg-white pb-6">
      <div className="sticky top-0 bg-white border-b border-border px-6 py-4 flex items-center gap-4">
        <button onClick={() => navigate(-1)}>
          <ArrowLeft className="w-6 h-6" />
        </button>
        <h1 className="flex-1">Rate Service</h1>
      </div>

      <div className="px-6 py-8">
        <div className="flex flex-col items-center mb-8">
          <div className="text-6xl mb-4">👨‍🔧</div>
          <h2 className="text-xl mb-2">Kabir Hossain</h2>
          <p className="text-muted-foreground">Plumber</p>
        </div>

        <div className="text-center mb-8">
          <h3 className="mb-2">How was your experience?</h3>
          <p className="text-sm text-muted-foreground mb-6">
            Your feedback helps us improve our services
          </p>

          <div className="flex justify-center gap-2">
            {[1, 2, 3, 4, 5].map((star) => (
              <button
                key={star}
                onClick={() => setRating(star)}
                onMouseEnter={() => setHoveredRating(star)}
                onMouseLeave={() => setHoveredRating(0)}
                className="p-2 transition-transform hover:scale-110"
              >
                <Star
                  className={`w-12 h-12 ${
                    star <= (hoveredRating || rating)
                      ? 'fill-yellow-400 text-yellow-400'
                      : 'text-gray-300'
                  }`}
                  strokeWidth={2}
                />
              </button>
            ))}
          </div>

          {rating > 0 && (
            <p className="mt-4 text-lg">
              {rating === 5 && '⭐ Excellent!'}
              {rating === 4 && '👍 Great!'}
              {rating === 3 && '😊 Good'}
              {rating === 2 && '😐 Fair'}
              {rating === 1 && '😞 Poor'}
            </p>
          )}
        </div>

        <div className="mb-8">
          <label className="block mb-2">
            Write a review <span className="text-muted-foreground">(Optional)</span>
          </label>
          <textarea
            value={review}
            onChange={(e) => setReview(e.target.value)}
            placeholder="Share your experience with others..."
            rows={5}
            className="w-full px-4 py-3 bg-input-background rounded-xl border border-border focus:outline-none focus:ring-2 focus:ring-primary resize-none"
          />
        </div>

        <button
          onClick={handleSubmit}
          disabled={rating === 0}
          className="w-full py-4 bg-primary text-white rounded-xl shadow-sm disabled:opacity-50 disabled:cursor-not-allowed"
        >
          Submit Review
        </button>
      </div>
    </div>
  );
}
