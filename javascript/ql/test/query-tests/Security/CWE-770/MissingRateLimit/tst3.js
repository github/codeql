import express from "express";
import { rateLimit } from "express-rate-limit";

const app = express();

const limiter = rateLimit();
app.use(limiter)

function expensiveHandler(req, res) { login(); }
app.get('/:path', expensiveHandler);  // OK