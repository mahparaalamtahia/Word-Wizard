import { useState } from 'react';
import { useNavigate, useSearchParams } from 'react-router';
import { ArrowLeft, Star, MapPin, SlidersHorizontal } from 'lucide-react';

const workers = [
  {
    id: 1,
    name: 'Kabir Hossain',
    category: 'Plumber',
    rating: 4.8,
    reviews: 124,
    distance: '2.3 km',
    area: 'Dhanmondi',
    hourlyRate: 800,
    image: '👨‍🔧',
  },
  {
    id: 2,
    name: 'Nasrin Akter',
    category: 'Electrician',
    rating: 4.9,
    reviews: 98,
    distance: '1.5 km',
    area: 'Gulshan',
    hourlyRate: 900,
    image: '👩‍🔧',
  },
  {
    id: 3,
    name: 'Rahim Rahman',
    category: 'Tutor',
    rating: 4.7,
    reviews: 156,
    distance: '3.1 km',
    area: 'Uttara',
    hourlyRate: 1200,
    image: '👨‍🏫',
  },
  {
    id: 4,
    name: 'Jamal Uddin',
    category: 'Painter',
    rating: 4.6,
    reviews: 87,
    distance: '4.2 km',
    area: 'Mirpur',
    hourlyRate: 700,
    image: '👨‍🎨',
  },
  {
    id: 5,
    name: 'Rupa Begum',
    category: 'Tutor',
    rating: 4.9,
    reviews: 142,
    distance: '1.8 km',
    area: 'Banani',
    hourlyRate: 1400,
    image: '👩‍🏫',
  },
];

const categories = ['All', 'Plumber', 'Electrician', 'Tutor', 'Painter', 'Mechanic', 'Handyman'];
const areas = ['All Areas', 'Dhanmondi', 'Gulshan', 'Uttara', 'Mirpur', 'Banani', 'Mohammadpur'];

export default function WorkerListingScreen() {
  const navigate = useNavigate();
  const [searchParams] = useSearchParams();
  const categoryParam = searchParams.get('category');

  const [selectedCategory, setSelectedCategory] = useState(categoryParam || 'All');
  const [selectedArea, setSelectedArea] = useState('All Areas');
  const [sortBy, setSortBy] = useState('rating');
  const [showFilters, setShowFilters] = useState(false);

  const filteredWorkers = workers
    .filter(w => selectedCategory === 'All' || w.category.toLowerCase() === selectedCategory)
    .filter(w => selectedArea === 'All Areas' || w.area === selectedArea)
    .sort((a, b) => {
      if (sortBy === 'rating') return b.rating - a.rating;
      if (sortBy === 'distance') return parseFloat(a.distance) - parseFloat(b.distance);
      return 0;
    });

  return (
    <div className="min-h-screen bg-white pb-6">
      <div className="sticky top-0 bg-white border-b border-border px-6 py-4">
        <div className="flex items-center gap-4 mb-4">
          <button onClick={() => navigate('/home')}>
            <ArrowLeft className="w-6 h-6" />
          </button>
          <h1 className="flex-1">Find Workers</h1>
          <button onClick={() => setShowFilters(!showFilters)}>
            <SlidersHorizontal className="w-6 h-6" />
          </button>
        </div>

        <div className="flex gap-2 overflow-x-auto pb-2 scrollbar-hide">
          {categories.map((cat) => (
            <button
              key={cat}
              onClick={() => setSelectedCategory(cat)}
              className={`px-4 py-2 rounded-full whitespace-nowrap transition-colors ${
                selectedCategory === cat
                  ? 'bg-primary text-white'
                  : 'bg-secondary text-foreground'
              }`}
            >
              {cat}
            </button>
          ))}
        </div>
      </div>

      {showFilters && (
        <div className="px-6 py-4 bg-secondary">
          <div className="mb-4">
            <label className="block text-sm mb-2">Area</label>
            <select
              value={selectedArea}
              onChange={(e) => setSelectedArea(e.target.value)}
              className="w-full px-4 py-2 bg-white rounded-lg border border-border"
            >
              {areas.map((area) => (
                <option key={area} value={area}>{area}</option>
              ))}
            </select>
          </div>

          <div>
            <label className="block text-sm mb-2">Sort By</label>
            <select
              value={sortBy}
              onChange={(e) => setSortBy(e.target.value)}
              className="w-full px-4 py-2 bg-white rounded-lg border border-border"
            >
              <option value="rating">Highest Rating</option>
              <option value="distance">Nearest</option>
            </select>
          </div>
        </div>
      )}

      <div className="px-6 pt-4">
        <p className="text-sm text-muted-foreground mb-4">
          {filteredWorkers.length} workers found
        </p>

        <div className="space-y-4">
          {filteredWorkers.map((worker) => (
            <button
              key={worker.id}
              onClick={() => navigate(`/worker/${worker.id}`)}
              className="w-full bg-white border border-border rounded-xl p-4 shadow-sm hover:shadow-md transition-shadow"
            >
              <div className="flex gap-4">
                <div className="text-5xl">{worker.image}</div>
                <div className="flex-1 text-left">
                  <h3 className="mb-1">{worker.name}</h3>
                  <p className="text-sm text-muted-foreground mb-2">
                    {worker.category} • {worker.area}
                  </p>
                  <div className="flex items-center gap-3 text-sm mb-2">
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
                  <p className="text-primary">
                    ৳{worker.hourlyRate}/hour
                  </p>
                </div>
              </div>
            </button>
          ))}
        </div>
      </div>
    </div>
  );
}
