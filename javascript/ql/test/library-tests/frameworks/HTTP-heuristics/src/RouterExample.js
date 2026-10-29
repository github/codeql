import {Router} from 'express';

const authRouter = new Router();
authRouter.get(/^\/admin\/(login|init)$/, middleware.adminInit, (req, res, next) => {
  if (req.isAuthenticated()) {
    res.redirect('/admin');
  } else {
    routeHandler(routes, reducers, req, res, next);
  }
});
