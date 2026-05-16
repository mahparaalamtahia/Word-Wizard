import { useState } from 'react';
import { useNavigate } from 'react-router';
import { Wrench } from 'lucide-react';

interface RegisterScreenProps {
  onRegister: () => void;
}

export default function RegisterScreen({ onRegister }: RegisterScreenProps) {
  const navigate = useNavigate();
  const [name, setName] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [phone, setPhone] = useState('');

  const handleRegister = (e: React.FormEvent) => {
    e.preventDefault();
    onRegister();
    navigate('/home');
  };

  return (
    <div className="flex flex-col min-h-screen bg-white p-6">
      <div className="flex flex-col items-center mt-12 mb-8">
        <div className="p-4 bg-primary rounded-full mb-4">
          <Wrench className="w-12 h-12 text-white" strokeWidth={2.5} />
        </div>
        <h1 className="text-3xl mb-2">Create Account</h1>
        <p className="text-muted-foreground">Sign up to get started</p>
      </div>

      <form onSubmit={handleRegister} className="flex-1 flex flex-col">
        <div className="mb-4">
          <label className="block mb-2 text-sm">Full Name</label>
          <input
            type="text"
            value={name}
            onChange={(e) => setName(e.target.value)}
            placeholder="Enter your full name"
            className="w-full px-4 py-3 bg-input-background rounded-xl border border-border focus:outline-none focus:ring-2 focus:ring-primary"
          />
        </div>

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

        <div className="mb-4">
          <label className="block mb-2 text-sm">Phone Number</label>
          <input
            type="tel"
            value={phone}
            onChange={(e) => setPhone(e.target.value)}
            placeholder="Enter your phone number"
            className="w-full px-4 py-3 bg-input-background rounded-xl border border-border focus:outline-none focus:ring-2 focus:ring-primary"
          />
        </div>

        <div className="mb-6">
          <label className="block mb-2 text-sm">Password</label>
          <input
            type="password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            placeholder="Create a password"
            className="w-full px-4 py-3 bg-input-background rounded-xl border border-border focus:outline-none focus:ring-2 focus:ring-primary"
          />
        </div>

        <button
          type="submit"
          className="w-full py-4 bg-primary text-primary-foreground rounded-xl shadow-sm mb-4"
        >
          Sign Up
        </button>

        <div className="text-center">
          <span className="text-muted-foreground">Already have an account? </span>
          <button
            type="button"
            onClick={() => navigate('/login')}
            className="text-primary"
          >
            Login
          </button>
        </div>
      </form>
    </div>
  );
}
