import { useNavigate, useParams } from 'react-router';
import { ArrowLeft, Star, MapPin, Phone, MessageCircle, Calendar } from 'lucide-react';

const workerData: Record<string, any> = {
  '1': {
    name: 'Kabir Hossain',
    category: 'Plumber',
    rating: 4.8,
    reviews: 124,
    area: 'Dhanmondi',
    hourlyRate: 800,
    image: '👨‍🔧',
    about: 'Professional plumber with 8+ years of experience. Specializing in residential and commercial plumbing repairs, installations, and maintenance.',
    skills: ['Pipe Repair', 'Leak Detection', 'Water Heater', 'Drain Cleaning'],
  },
  '2': {
    name: 'Nasrin Akter',
    category: 'Electrician',
    rating: 4.9,
    reviews: 98,
    area: 'Gulshan',
    hourlyRate: 900,
    image: '👩‍🔧',
    about: 'Certified electrician providing reliable electrical services. Expert in home wiring, repairs, and electrical installations.',
    skills: ['Wiring', 'Circuit Repair', 'Light Installation', 'Panel Upgrade'],
  },
  '3': {
    name: 'Rahim Rahman',
    category: 'Tutor',
    rating: 4.7,
    reviews: 156,
    area: 'Uttara',
    hourlyRate: 1200,
    image: '👨‍🏫',
    about: 'Experienced tutor specializing in Math and Science for grades 6-12. Patient teaching approach with proven results.',
    skills: ['Mathematics', 'Physics', 'Chemistry', 'Test Prep'],
  },
};

export default function WorkerProfileScreen() {
  const navigate = useNavigate();
  const { id } = useParams();
  const worker = workerData[id || '1'] || workerData['1'];

  return (
    <div className="min-h-screen bg-white pb-6">
      <div className="sticky top-0 bg-white border-b border-border px-6 py-4 flex items-center gap-4">
        <button onClick={() => navigate(-1)}>
          <ArrowLeft className="w-6 h-6" />
        </button>
        <h1 className="flex-1">Worker Profile</h1>
      </div>

      <div className="px-6 py-6">
        <div className="flex flex-col items-center mb-6">
          <div className="text-7xl mb-4">{worker.image}</div>
          <h2 className="text-2xl mb-1">{worker.name}</h2>
          <p className="text-muted-foreground mb-3">{worker.category}</p>
          <div className="flex items-center gap-2 mb-2">
            <Star className="w-5 h-5 fill-yellow-400 text-yellow-400" />
            <span className="text-lg">{worker.rating}</span>
            <span className="text-muted-foreground">({worker.reviews} reviews)</span>
          </div>
          <div className="flex items-center gap-1 text-muted-foreground">
            <MapPin className="w-4 h-4" />
            <span>{worker.area}</span>
          </div>
        </div>

        <div className="bg-secondary rounded-xl p-4 mb-6">
          <div className="flex items-center justify-between">
            <span className="text-muted-foreground">Hourly Rate</span>
            <span className="text-2xl text-primary">৳{worker.hourlyRate}</span>
          </div>
        </div>

        <div className="mb-6">
          <h3 className="mb-3">About</h3>
          <p className="text-muted-foreground leading-relaxed">{worker.about}</p>
        </div>

        <div className="mb-8">
          <h3 className="mb-3">Skills</h3>
          <div className="flex flex-wrap gap-2">
            {worker.skills.map((skill: string) => (
              <span
                key={skill}
                className="px-4 py-2 bg-secondary text-foreground rounded-full text-sm"
              >
                {skill}
              </span>
            ))}
          </div>
        </div>

        <div className="grid grid-cols-3 gap-3 mb-6">
          <button
            onClick={() => navigate(`/booking/${id}`)}
            className="col-span-3 flex items-center justify-center gap-2 py-4 bg-primary text-white rounded-xl shadow-sm"
          >
            <Calendar className="w-5 h-5" />
            <span>Book Now</span>
          </button>
          <button
            onClick={() => navigate(`/chat/${id}`)}
            className="flex items-center justify-center gap-2 py-3 bg-secondary text-foreground rounded-xl"
          >
            <MessageCircle className="w-5 h-5" />
            <span>Chat</span>
          </button>
          <button
            className="flex items-center justify-center gap-2 py-3 bg-secondary text-foreground rounded-xl col-span-2"
          >
            <Phone className="w-5 h-5" />
            <span>Call</span>
          </button>
        </div>
      </div>
    </div>
  );
}
