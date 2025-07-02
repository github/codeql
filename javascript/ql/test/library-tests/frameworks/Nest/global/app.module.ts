import { Module } from '@nestjs/common';
import { Controller } from './validation';
import { Imports } from './imports';
import { Foo, Foo2, Foo3 } from './foo.interface';
import { FooImpl, Foo2Impl, Foo3Impl } from './foo.impl';

const foo3 = new Foo3Impl()

@Module({
  controllers: [Controller],
  imports: [Imports.forRoot()],
  providers: [
    {
      provide: Foo,
      useClass: FooImpl
    },
    {
      provide: Foo2,
      useFactory: () => new Foo2Impl()
    },
    {
      provide: Foo3,
      useValue: foo3
    }
  ],
})
export class AppModule { }
