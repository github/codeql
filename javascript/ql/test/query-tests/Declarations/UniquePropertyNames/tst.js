var duplicate = {
  "key": "value",
  " key": "value",
  "1": "value",
  "key": "value",
  'key': "value",
  key: "value",
  \u006bey: "value",
  "\u006bey": "value",
  "\x6bey": "value",
  1: "value"
};

var accessors = {
  get x() { return 23; },
  set x(v) { }
};

var clobbering = {
  x: 23,       // NOT OK: clobbered by `x: 56`
  y: "hello",  // NOT OK: clobbered by `"y": "world"`
  x: 42,       // NOT OK: clobbered by `x: 56`
  x: 56,
  "y": "world"
}