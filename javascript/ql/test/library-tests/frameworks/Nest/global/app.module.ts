import { Module } from '@nestjs/common';
import { Controller } from './validation';
import { Foo, Foo2 } from './foo.interface';
import { FooImpl, Foo2Impl } from './foo.impl';

@Module({
  controllers: [Controller],
  providers: [
    {
      provide: Foo,
      useClass: FooImpl
    },
    {
      provide: Foo2,
      useFactory: () => new Foo2Impl()
    }
  ],
})
export class AppModule { }
