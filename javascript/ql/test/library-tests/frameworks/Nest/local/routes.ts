import { Get, Post, All, Query, Param, Body, Redirect, Req, Res, UploadedFile, UploadedFiles } from '@nestjs/common';
import { SneakyQueryParam } from './customDecorator';

export class TestController {
  @Get('foo')
  getFoo() {
    return 'foo';
  }

  @Post('foo')
  postFoo() {
    return 'foo';
  }

  @Get()
  getRoot() {
    return 'foo';
  }

  @All('bar')
  bar() {
    return 'bar';
  }

  @Get('requestInputs/:x')
  requestInputs(
    @Param('x') x,
    @Query() queryObj,
    @Query('name') name,
    @Req() req
  ) {
    if (Math.random()) return x; // NOT OK
    if (Math.random()) return queryObj; // NOT OK
    if (Math.random()) return name; // NOT OK
    if (Math.random()) return req.query.abc; // NOT OK
    return;
  }

  @Post('post')
  post(@Body() body) {
    return body.x; // NOT OK
  }

  @Get('redir')
  @Redirect('https://example.com')
  redir() {
    return {
      url: '//other.example.com' // OK
    };
  }

  @Get('redir')
  @Redirect('https://example.com')
  redir2(@Query('redirect') target) {
    return {
      url: target // NOT OK
    };
  }

  @Get()
  explicitSend(@Req() req, @Res() res) {
    res.send(req.query.x) // NOT OK
  }

  @Post()
  upload(@UploadedFile() file) {
    return file.originalname; // NOT OK
  }

  @Post()
  uploadMany(@UploadedFiles() files) {
    return files[0].originalname; // NOT OK
  }
}
