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
    e.attr('class', 'foo');
    e.attr({
      color: 'red',
      size: '12pt',
    });
  }
}

new C($('#foo'));
