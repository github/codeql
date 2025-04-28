import 'dummy';

class Foo {
    constructor() {
        this.size = 1024 * 1024 * 4;
        this.buffer = null;
    }

    someSink() {
        sink(this.buffer); // $ MISSING: hasTaintFlow=h1.1
    }

    setData2(data) {
        this.buffer = Buffer.from(data);
    }

    setData() {
        this.setData2(source("h1.1"));
    }

    allocate_buffers () {
        this.buffer = new Buffer(this.size);
    }
}

// Tests pass without allocate_buffers function present in the class
class Baz {
    constructor() {
        this.size = 1024 * 1024 * 4;
        this.buffer = null;
    }

    someSink() {
        sink(this.buffer); // $ hasTaintFlow=h1.2
    }

    setData2(data) {
        this.buffer = Buffer.from(data);
    }

    setData() {
        this.setData2(source("h1.2"));
    }
}

// Tests pass with single setData instead of setData -> setData2
class Baz {
    constructor() {
        this.size = 1024 * 1024 * 4;
        this.buffer = null;
    }

    someSink() {
        sink(this.buffer); // $ hasTaintFlow=h1.3
    }

    setData() {
        this.buffer = Buffer.from(source("h1.3"));
    }

    allocate_buffers () {
        this.buffer = new Buffer(this.size);
    }
}

// Tests pass taking hardcoded value instead of class member
class Foz {
    constructor() {
        this.buffer = null;
    }

    someSink() {
        sink(this.buffer); // $ hasTaintFlow=h1.1
    }

    setData2(data) {
        this.buffer = Buffer.from(data);
    }

    setData() {
        this.setData2(source("h1.1"));
    }

    allocate_buffers () {
        this.buffer = new Buffer(1024 * 1024 * 4);
    }
}
