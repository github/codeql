(function() {
  let otherAttrs = { target: "_blank" };
  let a = $("<a/>", otherAttrs).attr("href", "https://semmle.com");
  a.attr("rel", "noopener");
  a.attr({
    "data-bind": "stuff"
  });
  a.prop("rel", "noreferrer");
  a.prop({
    "data-bind": "otherstuff"
  });
  $.attr(a, "rel", "noopener noreferrer");
  $.prop(a, "data-bind", "");

  localStorage.foo = "value";
  localStorage.setItem("bar", "value");
  sessionStorage.foo = "value";
  sessionStorage.setItem("bar", "value");
})();


(function react() {
    React.createElement('div');
    React.createElement('div', {toWhat: 'World'}, null)

    var factory1 = React.createFactory('div');
    factory1();

    class Hello extends React.Component {
        render() {
            return <div>Hello {this.props.toWhat}</div>;
        }
    }


    React.createElement(Hello, {toWhat: 'World'}, null)
    var factory2 = React.createFactory(Hello);

    factory2();

})();

(function pollute() {
  class C {
    foo() {
      this.x; // Should not be a domValueRef
    }
  }
  window.myApp = new C();
  window.myApp.foo();
})();
