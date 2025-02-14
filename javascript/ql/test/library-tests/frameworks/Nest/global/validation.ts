import { Get, Query } from '@nestjs/common';
import { IsIn } from 'class-validator';
import { Foo } from './foo.interface';

export class Controller {
  constructor(
    private readonly foo: Foo
  ) { }

  @Get()
  route1(@Query('x') validatedObj: Struct, @Query('y') unvalidated: string) {
    if (Math.random()) return unvalidated; // NOT OK
    return validatedObj.key; // OK
  }

  @Get()
  route2(@Query('x') x: string) {
    this.foo.fooMethod(x);
  }
}

class Struct {
  @IsIn(['foo', 'bar'])
  key: string;
}
