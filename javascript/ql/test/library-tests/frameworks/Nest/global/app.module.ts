import { Module } from '@nestjs/common';
import { Controller } from './validation';
import { Foo } from './foo.interface';
import { FooImpl } from './foo.impl';

@Module({
    controllers: [Controller],
    providers: [{
        provide: Foo, useClass: FooImpl
    }],
})
export class AppModule { }
