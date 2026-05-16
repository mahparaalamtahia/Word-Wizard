import { BrowserRouter, Routes, Route, Navigate } from 'react-router';
import { useState, useEffect } from 'react';

// Screens
import SplashScreen from './screens/SplashScreen';
import OnboardingScreen from './screens/OnboardingScreen';
import LoginScreen from './screens/LoginScreen';
import RegisterScreen from './screens/RegisterScreen';
import HomeScreen from './screens/HomeScreen';
import WorkerListingScreen from './screens/WorkerListingScreen';
import WorkerProfileScreen from './screens/WorkerProfileScreen';
import BookingScreen from './screens/BookingScreen';
import BookingConfirmationScreen from './screens/BookingConfirmationScreen';
import ChatScreen from './screens/ChatScreen';
import RatingScreen from './screens/RatingScreen';
import NotificationsScreen from './screens/NotificationsScreen';
import BookingsScreen from './screens/BookingsScreen';
import WorkerDashboardScreen from './screens/WorkerDashboardScreen';
import ProfileScreen from './screens/ProfileScreen';

export default function App() {
  const [showSplash, setShowSplash] = useState(true);
  const [isAuthenticated, setIsAuthenticated] = useState(false);
  const [hasSeenOnboarding, setHasSeenOnboarding] = useState(false);

  useEffect(() => {
    const timer = setTimeout(() => {
      setShowSplash(false);
    }, 2000);
    return () => clearTimeout(timer);
  }, []);

  if (showSplash) {
    return <SplashScreen />;
  }

  return (
    <BrowserRouter>
      <div className="mx-auto max-w-md min-h-screen bg-background">
        <Routes>
          <Route
            path="/"
            element={
              !hasSeenOnboarding ? (
                <Navigate to="/onboarding" replace />
              ) : !isAuthenticated ? (
                <Navigate to="/login" replace />
              ) : (
                <Navigate to="/home" replace />
              )
            }
          />
          <Route
            path="/onboarding"
            element={<OnboardingScreen onComplete={() => setHasSeenOnboarding(true)} />}
          />
          <Route
            path="/login"
            element={<LoginScreen onLogin={() => setIsAuthenticated(true)} />}
          />
          <Route
            path="/register"
            element={<RegisterScreen onRegister={() => setIsAuthenticated(true)} />}
          />
          <Route path="/home" element={<HomeScreen />} />
          <Route path="/workers" element={<WorkerListingScreen />} />
          <Route path="/worker/:id" element={<WorkerProfileScreen />} />
          <Route path="/booking/:workerId" element={<BookingScreen />} />
          <Route path="/booking-confirmation" element={<BookingConfirmationScreen />} />
          <Route path="/chat/:workerId" element={<ChatScreen />} />
          <Route path="/rating/:bookingId" element={<RatingScreen />} />
          <Route path="/notifications" element={<NotificationsScreen />} />
          <Route path="/bookings" element={<BookingsScreen />} />
          <Route path="/worker-dashboard" element={<WorkerDashboardScreen />} />
          <Route path="/profile" element={<ProfileScreen />} />
        </Routes>
      </div>
    </BrowserRouter>
  );
}
