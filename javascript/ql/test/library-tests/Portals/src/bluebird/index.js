function Promise(exec) {
  this.exec = exec;
}

Promise.prototype.then = function(fulfilled, rejected) {
  rejected(null);
};

exports.Promise = Promise;
