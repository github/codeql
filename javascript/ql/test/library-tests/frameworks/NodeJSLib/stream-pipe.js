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