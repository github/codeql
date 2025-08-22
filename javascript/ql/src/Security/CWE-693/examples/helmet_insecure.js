const helmet = require('helmet');

app.use(helmet({
    frameguard: false,
    contentSecurityPolicy: false
}));