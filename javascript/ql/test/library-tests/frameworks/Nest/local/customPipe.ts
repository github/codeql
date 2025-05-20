import { Get, Injectable, PipeTransform, Query, UsePipes } from '@nestjs/common';
  
@Injectable()
export class CustomSanitizingPipe implements PipeTransform {
    transform(value: string): number | undefined {
        if (value == null) return undefined;
        return Number(value);
    }
}

@Injectable()
export class CustomPropagatingPipe implements PipeTransform {
    transform(value: string): string {
        return value.toUpperCase() + '!';
    }
}

export class Controller {
    @Get()
    sanitizingPipe1(@Query('x', CustomSanitizingPipe) sanitized: number): string {
        return '' + sanitized; // $responseSendArgument
    } // $routeHandler

    @Get()
    sanitizingPipe2(@Query('x', new CustomSanitizingPipe()) sanitized: number): string {
        return '' + sanitized; // $responseSendArgument
    } // $routeHandler

    @Get()
    @UsePipes(CustomSanitizingPipe)
    sanitizingPipe3(@Query('x') sanitized: number): string {
        return '' + sanitized; // $responseSendArgument
    } // $routeHandler

    @Get()
    propagatingPipe1(@Query('x', CustomPropagatingPipe) unsanitized: string): string {
        return '' + unsanitized; // $responseSendArgument
    } // $routeHandler

    @Get()
    propagatingPipe2(@Query('x', new CustomPropagatingPipe()) unsanitized: string): string {
        return '' + unsanitized; // $responseSendArgument
    } // $routeHandler

    @Get()
    @UsePipes(CustomPropagatingPipe)
    propagatingPipe3(@Query('x') unsanitized: string): string {
        return '' + unsanitized; // $responseSendArgument
    } // $routeHandler
}
