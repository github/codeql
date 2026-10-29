function foo() {
  let self = this;

  /** name:direct */
  self.foo.bar.direct = function() {};

  /** calls:direct */
  self.foo.bar.direct();

  self.foo.bar = {
    /** name:baz */
    baz() {},
    bong() {
      /** calls:baz */
      self.foo.bar.baz();
    }
  }

  /** calls:baz */
  self.foo.bar.baz();

  self.foo.bar.Class = class {
    /** name:m */
    m() {}
  }

  self.foo.bar.instance = new self.foo.bar.Class();

  /** calls:m */
  self.foo.bar.instance.m();

  let unknownObject = unknownCall();

  /** name:direct2 */
  unknownObject.bar.baz.direct = function() {};

  /** calls:direct2 */
  unknownObject.bar.baz.direct();
}
