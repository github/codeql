import * as dummy from 'dummy';

function F() {
  this.init();
}

F.prototype.init = function() {
  this.method();
  let m = this.method.bind(this);
  m();
};

F.prototype.method = function() {};

export default F;
