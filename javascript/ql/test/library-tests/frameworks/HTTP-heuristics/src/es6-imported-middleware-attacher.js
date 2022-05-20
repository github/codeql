import express from 'express';

var app = express();

import attacher from './exported-middleware-attacher-2';

attacher(app);
