import { useState } from 'react';
import { useNavigate } from 'react-router';
import { Wrench } from 'lucide-react';

interface LoginScreenProps {
  onLogin: () => void;
}

export default function LoginScreen({ onLogin }: LoginScreenProps) {
  const navigate = useNavigate();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');

  const handleLogin = (e: React.FormEvent) => {
    e.preventDefault();
    onLogin();
    navigate('/home');
  };

  return (
    <div className="flex flex-col min-h-screen bg-white p-6">
      <div className="flex flex-col items-center mt-16 mb-12">
        <div className="p-4 bg-primary rounded-full mb-4">
          <Wrench className="w-12 h-12 text-white" strokeWidth={2.5} />
        </div>
        <h1 className="text-3xl mb-2">Welcome Back</h1>
        <p className="text-muted-foreground">Login to continue</p>
      </div>

      <form onSubmit={handleLogin} className="flex-1 flex flex-col">
        <div className="mb-4">
          <label className="block mb-2 text-sm">Email</label>
          <input
            type="email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            placeholder="Enter your email"
            className="w-full px-4 py-3 bg-input-background rounded-xl border border-border focus:outline-none focus:ring-2 focus:ring-primary"
          />
        </div>

        <div className="mb-6">
          <label className="block mb-2 text-sm">Password</label>
          <input
            type="password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            placeholder="Enter your password"
            className="w-full px-4 py-3 bg-input-background rounded-xl border border-border focus:outline-none focus:ring-2 focus:ring-primary"
          />
        </div>

        <button
          type="submit"
          className="w-full py-4 bg-primary text-primary-foreground rounded-xl shadow-sm mb-4"
        >
          Login
        </button>

        <div className="text-center">
          <span className="text-muted-foreground">Don't have an account? </span>
          <button
            type="button"
            onClick={() => navigate('/register')}
            className="text-primary"
          >
            Sign Up
          </button>
        </div>
      </form>
    </div>
  );
}
