const express = require('express');
const app = express();

app.use('/public', express.static('public'));
app.use('/image-assets', express.static('image-assets'));

app.get('/', (req, res) => {
  res.send('<h1>Test</h1><img src="/public/ShotokanRoars.png">');
});

app.listen(3000, () => console.log('Server running'));
