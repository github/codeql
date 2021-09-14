function foo() {
  let source = source();
  let taint = source();

  sink(JSON.stringify(source)); // NOT OK

  var jsonStringifySafe = require("json-stringify-safe");
  sink(jsonStringifySafe(taint)); // NOT OK
  sink(require("json-stable-stringify")(source)); // NOT OK
  sink(require("stringify-object")(source)); // NOT OK
  sink(require("json3").stringify(source)); // NOT OK
  sink(require("fast-json-stable-stringify")(source)); // NOT OK
  sink(require("fast-safe-stringify")(source)); // NOT OK
  sink(require("javascript-stringify")(source)); // NOT OK
  sink(require("js-stringify")(source)); // NOT OK
  sink(require("util").inspect(source)); // NOT OK
  sink(require("pretty-format")(source)); // NOT OK
  sink(require("object-inspect")(source)); // NOT OK
  
  const json2csv = require('json2csv');
  sink(new json2csv.Parser(opts).parse(source)); // NOT OK

  const json5 = require('json5');
  sink(json5.stringify(json5.parse(source))); // NOT OK

  const flatted = require('flatted');
  sink(flatted.stringify(flatted.parse(source))); // NOT OK

  const teleport = require('teleport-javascript');
  sink(teleport.stringify(teleport.parse(source))); // NOT OK

  const Replicator = require('replicator');
  const replicator = new Replicator();
  sink(replicator.encode(replicator.decode(source))); // NOT OK

  sink(require("safe-stable-stringify")(source)); // NOT OK

  const jc = require('json-cycle');
  sink(jc.stringify(jc.parse(source))); // NOT OK

  const stripper = require("strip-json-comments");
  sink(JSON.stringify(JSON.parse(stripper(source)))); // NOT OK

  const fastJson = require('fast-json-stringify');
  sink(fastJson(source)); // NOT OK
}
