export default function first(req, res, next) {
    req.tainted = source();
    req.safe = 'safe';
    next();
}

