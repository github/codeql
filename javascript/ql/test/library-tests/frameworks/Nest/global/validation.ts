import { Get, Query } from '@nestjs/common';
import { IsIn } from 'class-validator';

export class Controller {
  @Get()
  route1(@Query('x') validatedObj: Struct, @Query('y') unvalidated: string) {
    if (Math.random()) return unvalidated; // $ Alert responseSendArgument
    return validatedObj.key;  // $ responseSendArgument
  } // $ routeHandler
}

class Struct {
  @IsIn(['foo', 'bar'])
  key: string;
}
