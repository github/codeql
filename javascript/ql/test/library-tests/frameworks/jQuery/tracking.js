class C {
  constructor(elm) {
    this.elm = elm;
  }

  doSomething() {
    this.elm.html('foo');
  }

  /**
   * @param {JQuery} e
   */
  doSomethingWithTypes(e) {
    e.html('foo');
  }
}

new C($('#foo'));
