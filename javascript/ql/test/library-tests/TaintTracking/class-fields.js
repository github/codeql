import * as dummy from 'dummy'; // treat as module

class EcmaClass {
  constructor(param) {
    this.param = param;
    this.taint = source();
  }

  fieldSinks() {
    sink(this.param); // NOT OK
    sink(this.taint); // NOT OK
  }

  getParam() {
    return this.param;
  }

  getTaint() {
    return this.taint;
  }
}

function testEcmaClass() {
  let c = new EcmaClass(source());
  sink(c.getParam()); // NOT OK
  sink(c.getTaint()); // NOT OK
}


function ProtoStyleClass(param) {
  this.param = param;
  this.taint = source();
}

ProtoStyleClass.prototype.fieldSinks = function() {
  sink(this.param); // NOT OK
  sink(this.taint); // NOT OK
};

ProtoStyleClass.prototype.getParam = function() {
  return this.param;
};

ProtoStyleClass.prototype.getTaint = function() {
  return this.taint;
};

function testProtoStyleClass() {
  let c = new ProtoStyleClass(source());
  sink(c.getParam()); // NOT OK
  sink(c.getTaint()); // NOT OK
}


function ProtoAssignmentClass(param) {
  this.param = param;
  this.taint = source();
}

ProtoAssignmentClass.prototype = {
  fieldSinks() {
    sink(this.param); // NOT OK
    sink(this.taint); // NOT OK
  },

  getParam() {
    return this.param;
  },

  getTaint() {
    return this.taint;
  }
};

function testProtoAssignmentClass() {
  let c = new ProtoAssignmentClass(source());
  sink(c.getParam()); // NOT OK
  sink(c.getTaint()); // NOT OK
}


function ProtoExtensionClass(param) {
  this.param = param;
  this.taint = source();
}

let extend = require('extend');
extend(ProtoExtensionClass.prototype, {
  fieldSinks() {
    sink(this.param); // NOT OK
    sink(this.taint); // NOT OK
  },

  getParam() {
    return this.param;
  },

  getTaint() {
    return this.taint;
  }
});

function testProtoExtensionClass() {
  let c = new ProtoExtensionClass(source());
  sink(c.getParam()); // NOT OK
  sink(c.getTaint()); // NOT OK
}
