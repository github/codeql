var duplicate = {
  "key": "value",      // NOT OK: duplicated on line 5
  " key": "value",
  "1": "value",        // NOT OK: duplicated on line 11
  "key": "value",      // NOT OK: duplicated on next line
  'key': "value",      // NOT OK: duplicated on next line
  key: "value",        // NOT OK: duplicated on next line
  \u006bey: "value",   // NOT OK: duplicated on next line
  "\u006bey": "value", // NOT OK: duplicated on next line
  "\x6bey": "value",
  1: "value"
};

var accessors = {
  get x() { return 23; },
  set x(v) { }
};

var clobbering = {
  x: 23,
  y: "hello",
  x: 42,
  x: 56,
  "y": "world"
}