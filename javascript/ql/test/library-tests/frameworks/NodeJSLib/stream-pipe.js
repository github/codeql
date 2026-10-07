const { Readable, Writable } = require("stream");

class DirectDestination extends Writable {
  write(chunk) {
    sink(chunk); // $ flow=direct
    return true;
  }
}

class PipedDestination extends Writable {
  write(chunk) {
    sink(chunk); // $ flow=piped flow=piped-second
    return true;
  }
}

new DirectDestination().write(source("direct"));
Readable.from([source("piped"), source("piped-second")]).pipe(new PipedDestination());


class SetDestination extends Writable {
  write(chunk) {
    sink(chunk); // $ flow=set
    return true;
  }
}

Readable.from(new Set([source("set")])).pipe(new SetDestination());

class GeneratorDestination extends Writable {
  write(chunk) {
    sink(chunk); // $ flow=generator
    return true;
  }
}

function* chunks() {
  yield source("generator");
}

Readable.from(chunks()).pipe(new GeneratorDestination());

class CleanDestination extends Writable {
  write(chunk) {
    sink(chunk);
    return true;
  }
}

const cleanReadable = Readable.from(["clean"]);
cleanReadable.metadata = source("metadata");
cleanReadable.pipe(new CleanDestination());

class ReceiverDestination extends Writable {
  constructor(value) {
    super();
    this.value = value;
  }

  write(chunk) {
    sink(this.value); // $ flow=receiver
    return true;
  }
}

const returnedDestination =
  Readable.from(["clean"]).pipe(new ReceiverDestination(source("receiver")));
sink(returnedDestination.value); // $ flow=receiver

class UncalledDestination extends Writable {
  constructor(value) {
    super();
    this.value = value;
  }

  write(chunk) {
    sink(this.value);
    return true;
  }
}

const unrelated = {
  pipe(destination) {
    return destination;
  }
};
unrelated.pipe(new UncalledDestination(source("unrelated")));

function directStringInput() {
  function source(label) {
    return "string chunk";
  }

  Readable.from(source("string")).pipe({
    write(chunk) {
      sink(chunk); // $ MISSING: flow=string
      return true;
    }
  });
}

function directBufferInput() {
  function source(label) {
    return Buffer.from("buffer chunk");
  }

  const buffer = source("buffer");
  const alias = buffer;
  Readable.from(alias).pipe({
    write(chunk) {
      sink(chunk); // $ MISSING: flow=buffer
      return true;
    }
  });
}


Readable.from(source("unknown-input")).pipe({
  write(chunk) {
    sink(chunk);
    return true;
  }
});

function importedBufferInput() {
  const { Buffer: ImportedBuffer } = require("node:buffer");
  const allocate = ImportedBuffer.alloc;

  function source(label) {
    return allocate(8);
  }

  Readable.from(source("imported-buffer")).pipe({
    write(chunk) {
      sink(chunk); // $ MISSING: flow=imported-buffer
      return true;
    }
  });
}
