import { Get, Query } from '@nestjs/common';
import { IsIn } from 'class-validator';

export class Controller {
  @Get()
  route1(@Query('x') validatedObj: Struct, @Query('y') unvalidated: string) {
    if (Math.random()) return unvalidated; // NOT OK
    return validatedObj.key; // OK
  }
}

class Struct {
  @IsIn(['foo', 'bar'])
  key: string;
}
