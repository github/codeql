const fs = require('fs');
const zlib = require('zlib');

function foo(){
    const source = fs.createReadStream('input.txt');
    const gzip = zlib.createGzip();
    const destination = fs.createWriteStream('output.txt.gz');
    source.pipe(gzip).pipe(destination); // $Alert    
    gzip.on('error', e);
}
class StreamWrapper {
    constructor() {
        this.outputStream = getStream();
    }
}

function zip() {
    const zipStream = createWriteStream(zipPath);
    let wrapper = new StreamWrapper();
    let stream = wrapper.outputStream;
    stream.on('error', e);
    stream.pipe(zipStream);
    zipStream.on('error', e);
}

function zip1() {
    const zipStream = createWriteStream(zipPath);
    let wrapper = new StreamWrapper();
    wrapper.outputStream.pipe(zipStream); // $SPURIOUS:Alert
    wrapper.outputStream.on('error', e);
    zipStream.on('error', e);
}

function zip2() {
    const zipStream = createWriteStream(zipPath);
    let wrapper = new StreamWrapper();
    let outStream = wrapper.outputStream.pipe(zipStream); // $Alert
    outStream.on('error', e);
}

function zip3() {
    const zipStream = createWriteStream(zipPath);
    let wrapper = new StreamWrapper();
    wrapper.outputStream.pipe(zipStream); // $Alert
    zipStream.on('error', e);
}

function zip3() {
    const zipStream = createWriteStream(zipPath);
    let wrapper = new StreamWrapper();
    let source = getStream();
    source.pipe(wrapper.outputStream); // $MISSING:Alert
    wrapper.outputStream.on('error', e);
}

function zip4() {
    const zipStream = createWriteStream(zipPath);
    let stream = getStream();
    let output = stream.pipe(zipStream); // $Alert
    output.on('error', e);
}

class StreamWrapper2 {
    constructor() {
        this.outputStream = getStream();
        this.outputStream.on('error', e);
    }

}
function zip5() {
    const zipStream = createWriteStream(zipPath);
    let wrapper = new StreamWrapper2();
    wrapper.outputStream.pipe(zipStream); // $SPURIOUS:Alert
    zipStream.on('error', e);
}

class StreamWrapper3 {
    constructor() {
        this.stream = getStream();
    }
    pipeIt(dest) {
        return this.stream.pipe(dest);
    }
    register_error_handler(listener) {
        return this.stream.on('error', listener);
    }
}

function zip5() {
    const zipStream = createWriteStream(zipPath);
    let wrapper = new StreamWrapper3();
    wrapper.pipeIt(zipStream); // $MISSING:Alert
    zipStream.on('error', e);
}
function zip6() {
    const zipStream = createWriteStream(zipPath);
    let wrapper = new StreamWrapper3();
    wrapper.pipeIt(zipStream);
    wrapper.register_error_handler(e);
    zipStream.on('error', e);
}

function registerErr(stream, listerner) {
    stream.on('error', listerner);
}

function zip7() {
    const zipStream = createWriteStream(zipPath);
    let stream = getStream();
    registerErr(stream, e);
    stream.pipe(zipStream); // $SPURIOUS:Alert
    zipStream.on('error', e);
}
