var s;
s = "this text" + // $ TODO-SPURIOUS: Alert
  "is missing a space";
s = "the class java.util.ArrayList" + // $ TODO-SPURIOUS: Alert
  "without a space";
s = "This isn't" + // $ TODO-SPURIOUS: Alert
  "right.";
s = "There's 1" + // $ TODO-SPURIOUS: Alert
  "thing wrong";
s = "There's A/B" + // $ TODO-SPURIOUS: Alert
  "and no space";
s = "Wait for it...." + // $ TODO-SPURIOUS: Alert
  "No space!";
s = "Is there a space?" + // $ TODO-SPURIOUS: Alert
  "No!";

("missing " + "a space") + "here"; // $ TODO-SPURIOUS: Alert

// syntactic variants:
s = "missing a space" + // $ TODO-SPURIOUS: Alert
    "here";
s = 'missing a space' + // $ TODO-SPURIOUS: Alert
    'here';
s = `missing a space` + // $ TODO-SPURIOUS: Alert
    "here";
s = "missing a space" + // $ TODO-SPURIOUS: Alert
    `here`;
s = `missing a space` + // $ TODO-SPURIOUS: Alert
    `here`;
s = (("missing space") + "here") // $ TODO-SPURIOUS: Alert

s = (("h. 0" + "h")) + "word" // $ TODO-SPURIOUS: Alert
