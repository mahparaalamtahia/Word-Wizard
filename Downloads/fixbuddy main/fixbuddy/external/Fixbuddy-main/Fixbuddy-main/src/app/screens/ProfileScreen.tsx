import { useNavigate } from 'react-router';
import { User, Bell, Lock, HelpCircle, LogOut, ChevronRight, Briefcase } from 'lucide-react';
import BottomNav from '../components/BottomNav';

const menuItems = [
  {
    icon: User,
    label: 'Edit Profile',
    action: () => alert('Edit Profile'),
  },
  {
    icon: Briefcase,
    label: 'Worker Dashboard',
    action: '/worker-dashboard',
  },
  {
    icon: Bell,
    label: 'Notifications',
    action: '/notifications',
  },
  {
    icon: Lock,
    label: 'Privacy & Security',
    action: () => alert('Privacy & Security'),
  },
  {
    icon: HelpCircle,
    label: 'Help & Support',
    action: () => alert('Help & Support'),
  },
];

export default function ProfileScreen() {
  const navigate = useNavigate();

  const handleMenuClick = (action: string | (() => void)) => {
    if (typeof action === 'string') {
      navigate(action);
    } else {
      action();
    }
  };

  const handleLogout = () => {
    if (confirm('Are you sure you want to logout?')) {
      window.location.href = '/';
    }
  };

  return (
    <div className="min-h-screen bg-white pb-20">
      <div className="sticky top-0 bg-white border-b border-border px-6 py-4">
        <h1>Profile</h1>
      </div>

      <div className="px-6 py-8">
        <div className="flex flex-col items-center mb-8">
          <div className="w-24 h-24 bg-primary rounded-full flex items-center justify-center text-4xl mb-4">
            👤
          </div>
          <h2 className="text-2xl mb-1">Shakib Hasan</h2>
          <p className="text-muted-foreground">shakib.hasan@email.com</p>
          <p className="text-muted-foreground">+880 1712 345678</p>
        </div>

        <div className="bg-white border border-border rounded-xl overflow-hidden mb-6">
          {menuItems.map((item, index) => {
            const Icon = item.icon;
            return (
              <button
                key={index}
                onClick={() => handleMenuClick(item.action)}
                className={`w-full flex items-center gap-4 px-4 py-4 hover:bg-secondary transition-colors ${
                  index !== menuItems.length - 1 ? 'border-b border-border' : ''
                }`}
              >
                <Icon className="w-5 h-5 text-muted-foreground" />
                <span className="flex-1 text-left">{item.label}</span>
                <ChevronRight className="w-5 h-5 text-muted-foreground" />
              </button>
            );
          })}
        </div>

        <button
          onClick={handleLogout}
          className="w-full flex items-center justify-center gap-2 py-4 bg-red-50 text-red-600 rounded-xl"
        >
          <LogOut className="w-5 h-5" />
          <span>Logout</span>
        </button>

        <div className="text-center mt-8 text-sm text-muted-foreground">
          <p>FixBuddy v1.0.0</p>
          <p>© 2026 FixBuddy. All rights reserved.</p>
        </div>
      </div>

      <BottomNav />
    </div>
  );
}
