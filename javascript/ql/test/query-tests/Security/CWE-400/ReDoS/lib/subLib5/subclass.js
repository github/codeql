class Subclass {
  constructor() {}

  define(name) {
    /a*b/.test(name); // NOT OK
  }
}

module.exports = Subclass;
