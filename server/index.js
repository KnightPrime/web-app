const express = require('express');
const path = require('path');
const app = express();
const PORT = process.env.PORT || 5000;

// Sample API Endpoint
app.get('/api/message', (req, res) => {
  res.json({ message: "Hello from the Node.js backend running on EC2!" });
});

// Serve static React production build assets
app.use(express.static(path.join(__dirname, '../client/dist')));

// Wildcard route to handle React Router client-side routing
app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, '../client/dist', 'index.html'));
});

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});

