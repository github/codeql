class C extends Q {
  constructor(arg) {
    /**
     * Something.
     * @type {string | undefined}
     */
    this.x = this.x; // OK - documentation

    this.y = this.y; // $ Alert

    this.arg = this.arg; // $ Alert
  }
}
