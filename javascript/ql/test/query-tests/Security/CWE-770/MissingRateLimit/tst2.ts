import express from 'express';
import rateLimiter from './rateLimit';

const app = express();
app.use(rateLimiter);
app.get('/', (req, res) => {
    res.sendFile('index.html'); // OK
});
