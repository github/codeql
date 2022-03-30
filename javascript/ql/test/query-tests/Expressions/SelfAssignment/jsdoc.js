class C extends Q {
  constructor(arg) {
    /**
     * Something.
     * @type {string | undefined}
     */
    this.x = this.x; // OK - documentation

    this.y = this.y; // NOT OK

    this.arg = this.arg; // NOT OK
  }
}
