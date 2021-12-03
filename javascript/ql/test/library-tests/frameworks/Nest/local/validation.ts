import { Get, Query, UsePipes, ValidationPipe } from '@nestjs/common';
import { IsIn } from 'class-validator';

export class Controller {
  @Get()
  route1(@Query('x', new ValidationPipe()) validatedObj: Struct) {
    return validatedObj.key; // OK
  }

  @Get()
  route2(@Query('x', ValidationPipe) validatedObj: Struct) {
    return validatedObj.key; // OK
  }

  @Get()
  @UsePipes(new ValidationPipe())
  route3(@Query('x') validatedObj: Struct, @Query('y') unvalidated: string) {
    if (Math.random()) return validatedObj.key; // OK
    return unvalidated; // NOT OK
  }

  @Get()
  @UsePipes(ValidationPipe)
  route4(@Query('x') validatedObj: Struct, @Query('y') unvalidated: string) {
    if (Math.random()) return validatedObj.key; // OK
    return unvalidated; // NOT OK
  }
}

@UsePipes(new ValidationPipe())
export class Controller2 {
  @Get()
  route5(@Query('x') validatedObj: Struct, @Query('y') unvalidated: string) {
    if (Math.random()) return validatedObj.key; // OK
    return unvalidated; // NOT OK
  }
}

@UsePipes(ValidationPipe)
export class Controller3 {
  @Get()
  route6(@Query('x') validatedObj: Struct, @Query('y') unvalidated: string) {
    if (Math.random()) return validatedObj.key; // OK
    return unvalidated; // NOT OK
  }
}

class Struct {
  @IsIn(['foo', 'bar'])
  key: string;
}
