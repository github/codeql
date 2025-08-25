var s;
s = "this text" + // $ Alert
  "is missing a space";
s = "the class java.util.ArrayList" + // $ Alert
  "without a space";
s = "This isn't" + // $ Alert
  "right.";
s = "There's 1" + // $ Alert
  "thing wrong";
s = "There's A/B" + // $ Alert
  "and no space";
s = "Wait for it...." + // $ Alert
  "No space!";
s = "Is there a space?" + // $ Alert
  "No!";

("missing " + "a space") + "here"; // $ Alert

// syntactic variants:
s = "missing a space" + // $ Alert
    "here";
s = 'missing a space' + // $ Alert
    'here';
s = `missing a space` + // $ Alert
    "here";
s = "missing a space" + // $ Alert
    `here`;
s = `missing a space` + // $ Alert
    `here`;
s = (("missing space") + "here") // $ Alert

s = (("h. 0" + "h")) + "word" // $ Alert
