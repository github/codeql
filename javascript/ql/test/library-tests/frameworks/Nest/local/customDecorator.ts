import { Get, createParamDecorator, ExecutionContext } from '@nestjs/common';

export const SneakyQueryParam = createParamDecorator(
  (data: unknown, ctx: ExecutionContext) => {
    const request = ctx.switchToHttp().getRequest(); // $requestSource
    return request.query.sneakyQueryParam;
  },
);

export const SafeParam = createParamDecorator(
  (data: unknown, ctx: ExecutionContext) => {
    return 'Safe';
  },
);

export class Controller {
  @Get()
  sneaky(@SneakyQueryParam() value) {
    return value; // $responseSendArgument
  } // $routeHandler

  @Get()
  safe(@SafeParam() value) {
    return value; // $responseSendArgument
  } // $routeHandler
}
