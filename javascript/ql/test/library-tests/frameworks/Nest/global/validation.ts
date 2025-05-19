import { Get, Query } from '@nestjs/common';
import { IsIn } from 'class-validator';
import { Foo } from './foo.interface';

export class Controller {
  constructor(
    private readonly foo: Foo
  ) { }

  @Get()
  route1(@Query('x') validatedObj: Struct, @Query('y') unvalidated: string) { 
    if (Math.random()) return unvalidated; // $responseSendArgument
    return validatedObj.key; // $responseSendArgument
  } // $routeHandler

  @Get()
  route2(@Query('x') x: string) {
    this.foo.fooMethod(x);
  } // $routeHandler
}

class Struct {
  @IsIn(['foo', 'bar'])
  key: string;
}
