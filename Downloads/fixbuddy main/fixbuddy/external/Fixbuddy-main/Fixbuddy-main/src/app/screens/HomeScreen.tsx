import { useNavigate } from 'react-router';
import {
  Search,
  Wrench,
  Zap,
  GraduationCap,
  Paintbrush,
  Droplet,
  Car,
  MapPin,
  Star,
} from 'lucide-react';
import BottomNav from '../components/BottomNav';

const categories = [
  { id: 'plumber', name: 'Plumber', icon: Droplet, color: 'bg-blue-100 text-blue-600' },
  { id: 'electrician', name: 'Electrician', icon: Zap, color: 'bg-yellow-100 text-yellow-600' },
  { id: 'tutor', name: 'Tutor', icon: GraduationCap, color: 'bg-green-100 text-green-600' },
  { id: 'painter', name: 'Painter', icon: Paintbrush, color: 'bg-purple-100 text-purple-600' },
  { id: 'mechanic', name: 'Mechanic', icon: Car, color: 'bg-red-100 text-red-600' },
  { id: 'handyman', name: 'Handyman', icon: Wrench, color: 'bg-orange-100 text-orange-600' },
];

const featuredWorkers = [
  {
    id: 1,
    name: 'Kabir Hossain',
    category: 'Plumber',
    rating: 4.8,
    reviews: 124,
    distance: '2.3 km',
    image: '👨‍🔧',
  },
  {
    id: 2,
    name: 'Nasrin Akter',
    category: 'Electrician',
    rating: 4.9,
    reviews: 98,
    distance: '1.5 km',
    image: '👩‍🔧',
  },
  {
    id: 3,
    name: 'Rahim Rahman',
    category: 'Tutor',
    rating: 4.7,
    reviews: 156,
    distance: '3.1 km',
    image: '👨‍🏫',
  },
];

export default function HomeScreen() {
  const navigate = useNavigate();

  return (
    <div className="min-h-screen bg-white pb-20">
      <div className="bg-primary px-6 pt-8 pb-24 rounded-b-3xl">
        <div className="flex items-center justify-between mb-6">
          <div>
            <p className="text-white/80 mb-1">Good Morning</p>
            <h1 className="text-2xl text-white">Hi, User 👋</h1>
          </div>
        </div>

        <button
          onClick={() => navigate('/workers')}
          className="w-full flex items-center gap-3 px-4 py-3 bg-white rounded-xl shadow-sm"
        >
          <Search className="w-5 h-5 text-muted-foreground" />
          <span className="text-muted-foreground">Search for services...</span>
        </button>
      </div>

      <div className="px-6 -mt-16">
        <div className="bg-white rounded-2xl shadow-lg p-6 mb-6">
          <h2 className="mb-4">Categories</h2>
          <div className="grid grid-cols-3 gap-4">
            {categories.map((category) => {
              const Icon = category.icon;
              return (
                <button
                  key={category.id}
                  onClick={() => navigate(`/workers?category=${category.id}`)}
                  className="flex flex-col items-center gap-2"
                >
                  <div className={`p-4 rounded-xl ${category.color}`}>
                    <Icon className="w-6 h-6" strokeWidth={2} />
                  </div>
                  <span className="text-sm text-center">{category.name}</span>
                </button>
              );
            })}
          </div>
        </div>

        <div className="mb-6">
          <div className="flex items-center justify-between mb-4">
            <h2>Featured Workers</h2>
            <button
              onClick={() => navigate('/workers')}
              className="text-sm text-primary"
            >
              See All
            </button>
          </div>

          <div className="space-y-3">
            {featuredWorkers.map((worker) => (
              <button
                key={worker.id}
                onClick={() => navigate(`/worker/${worker.id}`)}
                className="w-full bg-white border border-border rounded-xl p-4 flex items-center gap-4 shadow-sm hover:shadow-md transition-shadow"
              >
                <div className="text-4xl">{worker.image}</div>
                <div className="flex-1 text-left">
                  <h3 className="mb-1">{worker.name}</h3>
                  <p className="text-sm text-muted-foreground mb-2">
                    {worker.category}
                  </p>
                  <div className="flex items-center gap-3 text-sm">
                    <div className="flex items-center gap-1">
                      <Star className="w-4 h-4 fill-yellow-400 text-yellow-400" />
                      <span>{worker.rating}</span>
                      <span className="text-muted-foreground">
                        ({worker.reviews})
                      </span>
                    </div>
                    <div className="flex items-center gap-1 text-muted-foreground">
                      <MapPin className="w-4 h-4" />
                      <span>{worker.distance}</span>
                    </div>
                  </div>
                </div>
              </button>
            ))}
          </div>
        </div>

        <div className="mb-6">
          <h2 className="mb-4">Nearby Workers</h2>
          <div className="grid grid-cols-2 gap-3">
            {[
              { id: 4, name: 'Jamal Uddin', category: 'Painter', rating: 4.6, image: '👨‍🎨' },
              { id: 5, name: 'Rupa Begum', category: 'Tutor', rating: 4.9, image: '👩‍🏫' },
            ].map((worker) => (
              <button
                key={worker.id}
                onClick={() => navigate(`/worker/${worker.id}`)}
                className="bg-white border border-border rounded-xl p-4 text-center shadow-sm hover:shadow-md transition-shadow"
              >
                <div className="text-4xl mb-2">{worker.image}</div>
                <h4 className="text-sm mb-1">{worker.name}</h4>
                <p className="text-xs text-muted-foreground mb-2">
                  {worker.category}
                </p>
                <div className="flex items-center justify-center gap-1">
                  <Star className="w-3 h-3 fill-yellow-400 text-yellow-400" />
                  <span className="text-xs">{worker.rating}</span>
                </div>
              </button>
            ))}
          </div>
        </div>
      </div>

      <BottomNav />
    </div>
  );
}
