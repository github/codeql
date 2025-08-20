import { Injectable, NestMiddleware } from '@nestjs/common';
import { Response, NextFunction } from 'express';
import { CustomRequest } from '@randomPackage/request';

@Injectable()
export class LoggerMiddleware implements NestMiddleware {
  // The request can be a custom type that extends the express Request
  use(req: CustomRequest, res: Response, next: NextFunction) {
    console.log(req.query.abc);
    next();
  }
}