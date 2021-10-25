var totallyHarmlessString = '636f6e736f6c652e6c6f672827636f646520696e6a656374696f6e2729';
eval(Buffer.from(totallyHarmlessString, 'hex').toString()); // NOT OK: eval("console.log('code injection')")
eval(totallyHarmlessString);                                // OK: throws parse error

var test = "0123456789";
try {
  eval(test+"n"); // OK, but currently flagged [INCONSISTENCY]
  console.log("Bigints supported.");
} catch(e) {
  console.log("Bigints not supported.");
}

require('babeface'); // OK
