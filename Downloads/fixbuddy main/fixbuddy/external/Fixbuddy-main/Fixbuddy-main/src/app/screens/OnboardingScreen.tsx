import { useState } from 'react';
import { useNavigate } from 'react-router';
import { Search, Calendar, Shield } from 'lucide-react';

interface OnboardingScreenProps {
  onComplete: () => void;
}

const slides = [
  {
    icon: Search,
    title: 'Discover Local Experts',
    description: 'Find trusted professionals in your area for any home service you need',
  },
  {
    icon: Calendar,
    title: 'Book Instantly',
    description: 'Schedule services at your convenience with just a few taps',
  },
  {
    icon: Shield,
    title: 'Trust & Safety',
    description: 'All service providers are verified and rated by the community',
  },
];

export default function OnboardingScreen({ onComplete }: OnboardingScreenProps) {
  const [currentSlide, setCurrentSlide] = useState(0);
  const navigate = useNavigate();

  const handleNext = () => {
    if (currentSlide < slides.length - 1) {
      setCurrentSlide(currentSlide + 1);
    } else {
      onComplete();
      navigate('/login');
    }
  };

  const handleSkip = () => {
    onComplete();
    navigate('/login');
  };

  const slide = slides[currentSlide];
  const Icon = slide.icon;

  return (
    <div className="flex flex-col min-h-screen bg-white">
      <div className="flex justify-end p-4">
        <button
          onClick={handleSkip}
          className="px-4 py-2 text-muted-foreground"
        >
          Skip
        </button>
      </div>

      <div className="flex-1 flex flex-col items-center justify-center px-8 pb-24">
        <div className="flex items-center justify-center w-32 h-32 mb-12 bg-secondary rounded-full">
          <Icon className="w-16 h-16 text-primary" strokeWidth={2} />
        </div>

        <h2 className="text-3xl text-center mb-4">{slide.title}</h2>
        <p className="text-muted-foreground text-center text-lg leading-relaxed max-w-sm">
          {slide.description}
        </p>
      </div>

      <div className="px-8 pb-12">
        <div className="flex justify-center gap-2 mb-8">
          {slides.map((_, index) => (
            <div
              key={index}
              className={`h-2 rounded-full transition-all ${
                index === currentSlide ? 'w-8 bg-primary' : 'w-2 bg-muted'
              }`}
            />
          ))}
        </div>

        <button
          onClick={handleNext}
          className="w-full py-4 bg-primary text-primary-foreground rounded-xl shadow-sm"
        >
          {currentSlide === slides.length - 1 ? 'Get Started' : 'Next'}
        </button>
      </div>
    </div>
  );
}
