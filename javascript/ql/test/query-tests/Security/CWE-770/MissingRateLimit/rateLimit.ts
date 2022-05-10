import rateLimit from 'express-rate-limit';

const rateLimitMiddleware = rateLimit();

export default rateLimitMiddleware;
