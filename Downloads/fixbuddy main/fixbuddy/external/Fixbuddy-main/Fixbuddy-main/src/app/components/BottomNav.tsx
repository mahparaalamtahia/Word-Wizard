import { useNavigate, useLocation } from 'react-router';
import { Home, Calendar, Bell, User } from 'lucide-react';

export default function BottomNav() {
  const navigate = useNavigate();
  const location = useLocation();

  const isActive = (path: string) => location.pathname === path;

  const navItems = [
    { path: '/home', icon: Home, label: 'Home' },
    { path: '/bookings', icon: Calendar, label: 'Bookings' },
    { path: '/notifications', icon: Bell, label: 'Alerts' },
    { path: '/profile', icon: User, label: 'Profile' },
  ];

  return (
    <div className="fixed bottom-0 left-0 right-0 bg-white border-t border-border">
      <div className="mx-auto max-w-md flex items-center justify-around py-2">
        {navItems.map(({ path, icon: Icon, label }) => (
          <button
            key={path}
            onClick={() => navigate(path)}
            className={`flex flex-col items-center gap-1 px-6 py-2 rounded-lg transition-colors ${
              isActive(path)
                ? 'text-primary'
                : 'text-muted-foreground'
            }`}
          >
            <Icon className="w-6 h-6" strokeWidth={2} />
            <span className="text-xs">{label}</span>
          </button>
        ))}
      </div>
    </div>
  );
}
