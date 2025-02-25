class Subclass {
  constructor() {}

  define(name) {
    /a*b/.test(name); // $ Alert[js/polynomial-redos]
  }
}

module.exports = Subclass;
