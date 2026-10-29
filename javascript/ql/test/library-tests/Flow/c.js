module.exports = {};

function f(p) {
  module[p] = "le sneaky export";
}
f("exports");
