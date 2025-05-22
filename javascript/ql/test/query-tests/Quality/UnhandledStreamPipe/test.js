function test() {
  {
    const stream = getStream();
    stream.pipe(destination); // $Alert
  }
  {
    const stream = getStream();
    stream.pipe(destination);
    stream.on('error', handleError);
  }
  {
    const stream = getStream();
    stream.on('error', handleError);
    stream.pipe(destination);
  }
  {
    const stream = getStream();
    const s2 = stream;
    s2.pipe(dest); // $Alert
  }
  {
    const stream = getStream();
    stream.on('error', handleError);
    const s2 = stream;
    s2.pipe(dest);
  }
  {
    const stream = getStream();
    const s2 = stream;
    s2.on('error', handleError);
    s2.pipe(dest);
  }
  {
    const s = getStream().on('error', handler);
    const d = getDest();
    s.pipe(d); 
  }
  {
    getStream().on('error', handler).pipe(dest);
  }
  {
    const stream = getStream();
    stream.on('error', handleError);
    const stream2 = stream.pipe(destination);
    stream2.pipe(destination2); // $Alert
  }
  {
    const stream = getStream();
    stream.on('error', handleError);
    const destination  = getDest();
    destination.on('error', handleError);
    const stream2 = stream.pipe(destination);
    const s3 = stream2;
    s = s3.pipe(destination2);
  }
  {
    const stream = getStream();
    stream.on('error', handleError);
    const stream2 = stream.pipe(destination);
    stream2.pipe(destination2); // $Alert
  }
  { // Error handler on destination instead of source
    const stream = getStream();
    const dest = getDest();
    dest.on('error', handler);
    stream.pipe(dest); // $Alert
  }
  { // Multiple aliases, error handler on one
    const stream = getStream();
    const alias1 = stream;
    const alias2 = alias1;
    alias2.on('error', handleError);
    alias1.pipe(dest);
  }
  { // Multiple pipes, handler after first pipe
    const stream = getStream();
    const s2 = stream.pipe(destination1);
    stream.on('error', handleError);
    s2.pipe(destination2); // $Alert
  }
  { // Handler registered via .once
    const stream = getStream();
    stream.once('error', handleError);
    stream.pipe(dest);
  }
  { // Handler registered with arrow function
    const stream = getStream();
    stream.on('error', (err) => handleError(err));
    stream.pipe(dest);
  }
  { // Handler registered for unrelated event
    const stream = getStream();
    stream.on('close', handleClose);
    stream.pipe(dest); // $Alert
  }
  { // Error handler registered after pipe, but before error
    const stream = getStream();
    stream.pipe(dest);
    setTimeout(() => stream.on('error', handleError), 8000); // $MISSING:Alert
  }
  { // Pipe in a function, error handler outside
    const stream = getStream();
    function doPipe(s) { s.pipe(dest); } 
    stream.on('error', handleError);
    doPipe(stream);
  }
  { // Pipe in a function, error handler not set
    const stream = getStream();
    function doPipe(s) { s.pipe(dest); } // $Alert
    doPipe(stream);
  }
  { // Dynamic event assignment
    const stream = getStream();
    const event = 'error';
    stream.on(event, handleError);
    stream.pipe(dest);  // $SPURIOUS:Alert
  }
  { // Handler assigned via variable property
    const stream = getStream();
    const handler = handleError;
    stream.on('error', handler);
    stream.pipe(dest);
  }
  { // Pipe with no intermediate variable, no error handler
    getStream().pipe(dest); // $Alert
  }
  { // Handler set via .addListener synonym
    const stream = getStream();
    stream.addListener('error', handleError);
    stream.pipe(dest);
  }
  { // Handler set via .once after .pipe
    const stream = getStream();
    stream.pipe(dest);
    stream.once('error', handleError);
  }
  { // Long chained pipe with error handler
    const stream = getStream();
    stream.pause().on('error', handleError).setEncoding('utf8').resume().pipe(writable);
  }
  { // Long chained pipe without error handler
    const stream = getStream();
    stream.pause().setEncoding('utf8').resume().pipe(writable); // $Alert
  }
  { // Non-stream with pipe method that returns subscribable object (Streams do not have subscribe method)
    const notStream = getNotAStream();
    notStream.pipe(writable).subscribe();
  }
  { // Non-stream with pipe method that returns subscribable object (Streams do not have subscribe method)
    const notStream = getNotAStream();
    const result = notStream.pipe(writable);
    const dealWithResult = (result) => { result.subscribe(); };
    dealWithResult(result); 
  }
  { // Non-stream with pipe method that returns subscribable object (Streams do not have subscribe method)
    const notStream = getNotAStream();
    const pipeIt = (someVariable) => { return someVariable.pipe(something); };
    let x = pipeIt(notStream);
    x.subscribe(); 
  }
  { // Calling custom pipe method with no arguments
    const notStream = getNotAStream();
    notStream.pipe();
  }
  { // Calling custom pipe method with more then 2 arguments
    const notStream = getNotAStream();
    notStream.pipe(arg1, arg2, arg3);
  }
  { // Member access on a non-stream after pipe
    const notStream = getNotAStream();
    const val = notStream.pipe(writable).someMember;
  }
  { // Member access on a stream after pipe
    const notStream = getNotAStream();
    const val = notStream.pipe(writable).readable; // $Alert
  }
  { // Method access on a non-stream after pipe
    const notStream = getNotAStream();
    const val = notStream.pipe(writable).someMethod();
  }
  { // Pipe on fs readStream
    const fs = require('fs');
    const stream = fs.createReadStream('file.txt');
    const copyStream = stream;
    copyStream.pipe(destination); // $Alert
  }
  {
    const notStream = getNotAStream();
    const something = notStream.someNotStreamPropertyAccess;
    const val = notStream.pipe(writable);
  }
  { 
    const notStream = getNotAStream();
    const something = notStream.someNotStreamPropertyAccess();
    const val = notStream.pipe(writable);
  }
  {
    const notStream = getNotAStream();
    notStream.pipe({});
  }
  {
    const notStream = getNotAStream();
    notStream.pipe(()=>{});
  }
  {
    const plumber = require('gulp-plumber');
    getStream().pipe(plumber()).pipe(dest).pipe(dest).pipe(dest);
  }
  {
    const plumber = require('gulp-plumber');
    const p = plumber();
    getStream().pipe(p).pipe(dest).pipe(dest).pipe(dest);
  }
  {
    const notStream = getNotAStream();
    notStream.pipe(getStream(),()=>{});
  }
}
