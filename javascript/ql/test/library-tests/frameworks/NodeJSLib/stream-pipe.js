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
      sink(chunk); // $ flow=string
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
      sink(chunk); // $ flow=buffer
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
      sink(chunk); // $ flow=imported-buffer
      return true;
    }
  });
}

class HookDestination extends Writable {
  constructor(value) {
    super();
    this.value = value;
  }

  _write(chunk, encoding, callback) {
    sink(chunk); // $ flow=write-hook flow=inherited-write-hook
    sink(this.value); // $ flow=hook-receiver
    sink(encoding);
    sink(callback);
    callback();
  }
}

Readable.from([source("write-hook")]).pipe(new HookDestination(source("hook-receiver")));

class InheritedHookDestination extends HookDestination {}

const DestinationAlias = InheritedHookDestination;
const inheritedDestination = new DestinationAlias();
const inheritedAlias = inheritedDestination;
Readable.from([source("inherited-write-hook")]).pipe(inheritedAlias);

const { Transform, Duplex } = require("stream");

class HookTransform extends Transform {
  _transform(chunk, encoding, callback) {
    sink(chunk); // $ flow=transform-hook
    callback(null, chunk);
  }
}

Readable.from([source("transform-hook")]).pipe(new HookTransform()).pipe({
  write(chunk) {
    sink(chunk); // $ MISSING: flow=transform-hook
    return true;
  }
});

class OverriddenWriteDestination extends Writable {
  write(chunk) {
    sink(chunk); // $ flow=overridden-write flow=inherited-overridden-write
    return true;
  }

  _write(chunk, encoding, callback) {
    sink(chunk);
    callback();
  }
}

Readable.from([source("overridden-write")]).pipe(new OverriddenWriteDestination());

class IntermediateWriteDestination extends OverriddenWriteDestination {}
class InheritedWriteDestination extends IntermediateWriteDestination {}

Readable.from([source("inherited-overridden-write")]).pipe(new InheritedWriteDestination());

class HookDuplex extends Duplex {
  _read() {}

  _write(chunk, encoding, callback) {
    sink(chunk); // $ flow=duplex-hook
    callback();
  }
}

Readable.from([source("duplex-hook")]).pipe(new HookDuplex());

class OverriddenTransform extends Transform {
  _write(chunk, encoding, callback) {
    sink(chunk); // $ flow=transform-write-hook flow=inherited-transform-write-hook
    callback();
  }

  _transform(chunk, encoding, callback) {
    sink(chunk);
    callback(null, chunk);
  }
}

Readable.from([source("transform-write-hook")]).pipe(new OverriddenTransform());

class IntermediateTransform extends OverriddenTransform {}
class InheritedTransform extends IntermediateTransform {}

Readable.from([source("inherited-transform-write-hook")]).pipe(new InheritedTransform());

class InstanceOverrideDestination extends Writable {
  _write(chunk, encoding, callback) {
    sink(chunk); // $ SPURIOUS: flow=instance-override
    callback();
  }
}

const instanceOverride = new InstanceOverrideDestination();
instanceOverride.write = function(chunk) {
  sink(chunk); // $ flow=instance-override
  return true;
};
Readable.from([source("instance-override")]).pipe(instanceOverride);

function conditionalPublicWriteOverride(condition) {
  class Destination extends Writable {
    _write(chunk, encoding, callback) {
      sink(chunk); // $ flow=conditional-public-write
      callback();
    }
  }

  const destination = new Destination();
  if (condition) {
    destination.write = function(chunk) {
      sink(chunk); // $ flow=conditional-public-write
      return true;
    };
  }
  Readable.from([source("conditional-public-write")]).pipe(destination);
}

async function latePublicWriteOverride() {
  const destination = new Writable({
    objectMode: true,
    write(chunk, encoding, callback) {
      sink(chunk); // $ flow=late-public-write
      callback();
    }
  });

  Readable.from([source("late-public-write")]).pipe(destination);
  await new Promise(resolve => destination.on("finish", resolve));
  destination.write = function() { return true; };
}

function conditionalSubclassWriteHook(condition) {
  class Destination extends Transform {
    _transform(chunk, encoding, callback) {
      sink(chunk); // $ flow=conditional-subclass-hook
      callback(null, chunk);
    }
  }

  const destination = new Destination();
  if (condition) {
    destination._write = function(chunk, encoding, callback) {
      sink(chunk); // $ flow=conditional-subclass-hook
      callback();
    };
  }
  Readable.from([source("conditional-subclass-hook")]).pipe(destination);
}

function conditionalOptionsWriteHook(condition) {
  const destination = new Transform({
    transform(chunk, encoding, callback) {
      sink(chunk); // $ flow=conditional-options-hook
      callback(null, chunk);
    }
  });

  if (condition) {
    destination._write = function(chunk, encoding, callback) {
      sink(chunk); // $ flow=conditional-options-hook
      callback();
    };
  }
  Readable.from([source("conditional-options-hook")]).pipe(destination);
}

function unreachablePublicWriteOverride() {
  const destination = new Writable({
    write(chunk, encoding, callback) {
      sink(chunk); // $ flow=unreachable-public-write
      callback();
    }
  });

  if (false) {
    destination.write = function() { return true; };
  }
  Readable.from([source("unreachable-public-write")]).pipe(destination);
}

function ambiguousPublicWriteOverride(condition, otherDestination) {
  const destination = new Writable({
    write(chunk, encoding, callback) {
      sink(chunk); // $ flow=ambiguous-public-write
      callback();
    }
  });

  const alias = condition ? destination : otherDestination;
  alias.write = function(chunk) {
    sink(chunk); // $ flow=ambiguous-public-write
    return true;
  };
  Readable.from([source("ambiguous-public-write")]).pipe(destination);
}

function definiteWriteHookOverride() {
  const destination = new Transform({
    transform(chunk, encoding, callback) {
      sink(chunk); // $ SPURIOUS: flow=definite-write-hook
      callback(null, chunk);
    }
  });

  const alias = destination;
  alias._write = function(chunk, encoding, callback) {
    sink(chunk); // $ flow=definite-write-hook
    callback();
  };
  Readable.from([source("definite-write-hook")]).pipe(destination);
}


const writableOptions = {
  objectMode: true,
  write(chunk, encoding, callback) {
    sink(chunk); // $ flow=options-write
    sink(this.value); // $ flow=options-receiver
    sink(encoding);
    sink(callback);
    callback();
  }
};
const optionsDestination = new Writable(writableOptions);
optionsDestination.value = source("options-receiver");
Readable.from([source("options-write")]).pipe(optionsDestination);

const transformOptions = {
  transform(chunk, encoding, callback) {
    sink(chunk); // $ flow=options-transform flow=options-transform-2
    sink(encoding);
    sink(callback);
    callback(null, chunk);
  }
};
const transformOptionsAlias = transformOptions;
const { Transform: ImportedTransform } = require("node:stream");
const optionsTransform = new ImportedTransform(transformOptionsAlias);
Readable.from([source("options-transform")]).pipe(optionsTransform).pipe({
  write(chunk) {
    sink(chunk); // $ MISSING: flow=options-transform flow=options-transform-2
    return true;
  }
});

Readable.from([source("options-transform-2")]).pipe(optionsTransform);

const optionsDuplex = new Duplex({
  read() {},
  write(chunk, encoding, callback) {
    sink(chunk); // $ flow=options-duplex
    callback();
  }
});
Readable.from([source("options-duplex")]).pipe(optionsDuplex);

function writeTransformOption(chunk, encoding, callback) {
  sink(chunk); // $ flow=options-transform-write
  callback();
}
const writeTransformAlias = writeTransformOption;
const optionsTransformWrite = new Transform({
  write: writeTransformAlias,
  transform(chunk, encoding, callback) {
    sink(chunk);
    callback(null, chunk);
  }
});
Readable.from([source("options-transform-write")]).pipe(optionsTransformWrite);

const overriddenOptionsDestination = new Writable({
  write(chunk, encoding, callback) {
    sink(chunk); // $ SPURIOUS: flow=options-public-write
    callback();
  }
});
overriddenOptionsDestination.write = function(chunk) {
  sink(chunk); // $ flow=options-public-write
  return true;
};
Readable.from([source("options-public-write")]).pipe(overriddenOptionsDestination);

class PushingTransform extends Transform {
  _transform(chunk, encoding, callback) {
    this.push(chunk);
    callback();
  }
}
Readable.from([source("transform-push")]).pipe(new PushingTransform()).pipe({
  write(chunk) {
    sink(chunk); // $ MISSING: flow=transform-push
    return true;
  }
});

Readable.from([source("dropped-transform-input")]).pipe(new Transform({
  transform(chunk, encoding, callback) {
    callback();
  }
})).pipe({
  write(chunk) {
    sink(chunk);
    return true;
  }
});

Readable.from([source("replaced-transform-input")]).pipe(new Transform({
  transform(chunk, encoding, callback) {
    callback(null, source("replacement-output"));
  }
})).pipe({
  write(chunk) {
    sink(chunk); // $ MISSING: flow=replacement-output
    return true;
  }
});
