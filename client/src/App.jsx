import { useEffect, useState } from 'react';

function App() {
  const [message, setMessage] = useState('Loading message from server...');

  useEffect(() => {
    fetch('/api/message')
      .then((res) => res.json())
      .then((data) => setMessage(data.message))
      .catch((err) => setMessage('Failed to connect to backend api.'));
  }, []);

  return (
    <div style={{ textAlign: 'center', marginTop: '50px', fontFamily: 'Arial' }}>
      <h1>Node.js + React EC2 Deployment</h1>
      <p style={{ fontSize: '1.2rem', color: '#0070f3' }}>{message}</p>
    </div>
  );
}

export default App;

