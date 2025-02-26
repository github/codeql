var totallyHarmlessString = '636f6e736f6c652e6c6f672827636f646520696e6a656374696f6e2729'; // $ Source
eval(Buffer.from(totallyHarmlessString, 'hex').toString()); // $ Alert - eval("console.log('code injection')")
eval(totallyHarmlessString);                                // OK - throws parse error

var test = "0123456789"; // $ Source
try {
  eval(test+"n"); // $ SPURIOUS: Alert
  console.log("Bigints supported.");
} catch(e) {
  console.log("Bigints not supported.");
}

require('babeface');
