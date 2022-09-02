const dispatch = {
  GET: require("./bla"),
  POST: require("./subsub"),
};

module.exports.foo = function (name, type) {
  dispatch[type](name);
};
