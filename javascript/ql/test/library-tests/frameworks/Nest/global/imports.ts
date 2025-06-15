import { DynamicModule } from '@nestjs/common';
import { Foo4Impl } from './foo.impl';
import { Foo4 } from './foo.interface';

export class Imports {
  static forRoot(): DynamicModule {
    return {
      providers: [
        {
          provide: Foo4,
          useClass: Foo4Impl,
        },
      ],
    };
  }
}
