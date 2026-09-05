const express = require('express');

const app = express();
app.use(express.json());

const version = process.env.VERSION || process.env.npm_package_version || '1.0.0';

app.get('/health', (req, res) => {
  res.status(200).json({ status: 'ok' });
});

app.get('/version', (req, res) => {
  res.status(200).json({ version });
});

app.post('/echo', (req, res) => {
  res.status(200).json({ echo: req.body });
});

module.exports = app;
