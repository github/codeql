import { Get, Query } from '@nestjs/common';
import { IsIn } from 'class-validator';
import { Foo, Foo2, Foo3, Foo4 } from './foo.interface';

export class Controller {
  constructor(
    private readonly foo: Foo, private readonly foo2: Foo2, private readonly foo3: Foo3, private readonly foo4: Foo4
  ) { }

  @Get()
  route1(@Query('x') validatedObj: Struct, @Query('y') unvalidated: string) {
    if (Math.random()) return unvalidated; // NOT OK
    return validatedObj.key; // OK
  }

  @Get()
  route2(@Query('x') x: string) {
    this.foo.fooMethod(x);
    this.foo2.fooMethod(x);
    this.foo3.fooMethod(x);
    this.foo4.fooMethod(x);
  }
}

class Struct {
  @IsIn(['foo', 'bar'])
  key: string;
}
