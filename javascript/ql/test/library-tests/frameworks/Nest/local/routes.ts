import { Get, Post, All, Query, Param, Body, Redirect, Req, Res, UploadedFile, UploadedFiles } from '@nestjs/common';
import { SneakyQueryParam } from './customDecorator';

export class TestController {
  @Get('foo')
  getFoo() {
    return 'foo';
  } // $routeHandler

  @Post('foo')
  postFoo() {
    return 'foo';
  } // $routeHandler

  @Get()
  getRoot() {
    return 'foo';
  } // $routeHandler

  @All('bar')
  bar() {
    return 'bar';
  } // $routeHandler

  @Get('requestInputs/:x')
  requestInputs(
    @Param('x') x,
    @Query() queryObj,
    @Query('name') name,
    @Req() req // $requestSource
  ) {
    if (Math.random()) return x; // $responseSendArgument
    if (Math.random()) return queryObj; // $responseSendArgument
    if (Math.random()) return name; // $responseSendArgument
    if (Math.random()) return req.query.abc; // $responseSendArgument
    return;
  } // $routeHandler

  @Post('post')
  post(@Body() body) {
    return body.x; // $responseSendArgument
  } // $routeHandler

  @Get('redir')
  @Redirect('https://example.com')
  redir() {
    return {
      url: '//other.example.com' // $redirectSink
    };
  } // $routeHandler

  @Get('redir')
  @Redirect('https://example.com')
  redir2(@Query('redirect') target) {
    return {
      url: target // $redirectSink
    };
  } // $routeHandler

  @Get()
  explicitSend(@Req() req, @Res() res) { // $requestSource $responseSource
    res.send(req.query.x) // $responseSource $responseSendArgument
  } // $routeHandler

  @Post()
  upload(@UploadedFile() file) {
    return file.originalname; // $responseSendArgument
  } // $routeHandler

  @Post()
  uploadMany(@UploadedFiles() files) {
    return files[0].originalname; // $responseSendArgument
  } // $routeHandler
}
