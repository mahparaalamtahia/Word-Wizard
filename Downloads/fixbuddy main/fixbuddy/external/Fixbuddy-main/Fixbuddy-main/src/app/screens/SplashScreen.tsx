import { Wrench } from 'lucide-react';

export default function SplashScreen() {
  return (
    <div className="flex flex-col items-center justify-center min-h-screen bg-primary">
      <div className="flex flex-col items-center gap-4">
        <div className="p-6 bg-white rounded-full shadow-lg">
          <Wrench className="w-16 h-16 text-primary" strokeWidth={2.5} />
        </div>
        <h1 className="text-4xl text-white">FixBuddy</h1>
        <p className="text-white/80">Your Friendly Local Service Helper</p>
      </div>
    </div>
  );
}
