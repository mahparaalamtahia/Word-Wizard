import { useState } from 'react';
import { useNavigate, useParams } from 'react-router';
import { ArrowLeft, Send } from 'lucide-react';

const initialMessages = [
  { id: 1, text: 'Hi! I saw your booking request.', sender: 'worker', time: '10:30 AM' },
  { id: 2, text: 'Yes, I need help with a leaking pipe.', sender: 'user', time: '10:31 AM' },
  { id: 3, text: 'I can help with that. Can you send me a photo?', sender: 'worker', time: '10:32 AM' },
  { id: 4, text: 'Sure, I will send it shortly.', sender: 'user', time: '10:33 AM' },
];

export default function ChatScreen() {
  const navigate = useNavigate();
  const { workerId } = useParams();
  const [messages, setMessages] = useState(initialMessages);
  const [inputText, setInputText] = useState('');

  const handleSend = () => {
    if (inputText.trim()) {
      setMessages([
        ...messages,
        {
          id: messages.length + 1,
          text: inputText,
          sender: 'user',
          time: new Date().toLocaleTimeString('en-US', {
            hour: '2-digit',
            minute: '2-digit',
          }),
        },
      ]);
      setInputText('');
    }
  };

  return (
    <div className="flex flex-col h-screen bg-white">
      <div className="sticky top-0 bg-white border-b border-border px-6 py-4 flex items-center gap-4">
        <button onClick={() => navigate(-1)}>
          <ArrowLeft className="w-6 h-6" />
        </button>
        <div className="flex items-center gap-3 flex-1">
          <div className="text-3xl">👨‍🔧</div>
          <div>
            <h2 className="text-lg">Kabir Hossain</h2>
            <p className="text-xs text-muted-foreground">Plumber</p>
          </div>
        </div>
      </div>

      <div className="flex-1 overflow-y-auto px-6 py-4 space-y-4">
        {messages.map((message) => (
          <div
            key={message.id}
            className={`flex ${message.sender === 'user' ? 'justify-end' : 'justify-start'}`}
          >
            <div
              className={`max-w-[75%] px-4 py-3 rounded-2xl ${
                message.sender === 'user'
                  ? 'bg-primary text-white rounded-br-sm'
                  : 'bg-secondary text-foreground rounded-bl-sm'
              }`}
            >
              <p className="mb-1">{message.text}</p>
              <p
                className={`text-xs ${
                  message.sender === 'user' ? 'text-white/70' : 'text-muted-foreground'
                }`}
              >
                {message.time}
              </p>
            </div>
          </div>
        ))}
      </div>

      <div className="border-t border-border px-6 py-4">
        <div className="flex items-center gap-3">
          <input
            type="text"
            value={inputText}
            onChange={(e) => setInputText(e.target.value)}
            onKeyPress={(e) => e.key === 'Enter' && handleSend()}
            placeholder="Type a message..."
            className="flex-1 px-4 py-3 bg-input-background rounded-full border border-border focus:outline-none focus:ring-2 focus:ring-primary"
          />
          <button
            onClick={handleSend}
            className="p-3 bg-primary text-white rounded-full shadow-sm"
          >
            <Send className="w-5 h-5" />
          </button>
        </div>
      </div>
    </div>
  );
}
