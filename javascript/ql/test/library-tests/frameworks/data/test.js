import * as testlib from 'testlib';
import { preserveTaint } from 'testlib';

function testPreserveTaint() {
  sink(testlib.preserveTaint(source())); // NOT OK
  sink(preserveTaint(source())); // NOT OK
  sink(require('testlib').preserveTaint(source())); // NOT OK
  sink(require('testlib').preserveTaint('safe')); // OK
  sink(require('testlib').preserveTaint(1, source())); // OK

  sink(testlib.preserveArgZeroAndTwo(source(), 1, 1, 1)); // NOT OK
  sink(testlib.preserveArgZeroAndTwo(1, source(), 1, 1)); // OK
  sink(testlib.preserveArgZeroAndTwo(1, 1, source(), 1)); // NOT OK
  sink(testlib.preserveArgZeroAndTwo(1, 1, 1, source())); // OK

  sink(testlib.preserveAllButFirstArgument(source(), 1, 1, 1)); // OK
  sink(testlib.preserveAllButFirstArgument(1, source(), 1, 1)); // NOT OK
  sink(testlib.preserveAllButFirstArgument(1, 1, source(), 1)); // NOT OK
  sink(testlib.preserveAllButFirstArgument(1, 1, 1, source())); // NOT OK

  sink(testlib.preserveAllIfCall(source(), 1, 1, 1)); // NOT OK
  sink(testlib.preserveAllIfCall(1, source(), 1, 1)); // NOT OK
  sink(testlib.preserveAllIfCall(1, 1, source(), 1)); // NOT OK
  sink(testlib.preserveAllIfCall(1, 1, 1, source())); // NOT OK

  sink(new testlib.preserveAllIfCall(source(), 1, 1, 1)); // OK
  sink(new testlib.preserveAllIfCall(1, source(), 1, 1)); // OK
  sink(new testlib.preserveAllIfCall(1, 1, source(), 1)); // OK
  sink(new testlib.preserveAllIfCall(1, 1, 1, source())); // OK

  testlib.taintIntoCallback(source(), y => {
    sink(y); // NOT OK
  });
  testlib.taintIntoCallback('safe', y => {
    sink(y); // OK
  });
  testlib.taintIntoCallback(source(), undefined, y => {
    sink(y); // NOT OK
  });
  testlib.taintIntoCallback(source(), undefined, undefined, y => {
    sink(y); // OK - only callback 1-2 receive taint
  });
  testlib.taintIntoCallback(source(), function(y) {
    sink(y); // NOT OK
    sink(this); // OK - receiver is not tainted
  });
  testlib.taintIntoCallbackThis(source(), function(y) {
    sink(y); // OK - only receiver is tainted
    sink(this); // NOT OK
  });
}

function testSinks() {
  testlib.mySink(source()); // NOT OK
  new testlib.mySink(source()); // NOT OK

  testlib.mySinkIfCall(source()); // NOT OK
  new testlib.mySinkIfCall(source()); // OK

  testlib.mySinkIfNew(source()); // OK
  new testlib.mySinkIfNew(source()); // NOT OK

  testlib.mySinkLast(source(), 2, 3, 4); // OK
  testlib.mySinkLast(1, source(), 3, 4); // OK
  testlib.mySinkLast(1, 2, source(), 4); // OK
  testlib.mySinkLast(1, 2, 3, source()); // NOT OK

  testlib.mySinkSecondLast(source(), 2, 3, 4); // OK
  testlib.mySinkSecondLast(1, source(), 3, 4); // OK
  testlib.mySinkSecondLast(1, 2, source(), 4); // NOT OK
  testlib.mySinkSecondLast(1, 2, 3, source()); // OK

  testlib.mySinkTwoLast(source(), 2, 3, 4); // OK
  testlib.mySinkTwoLast(1, source(), 3, 4); // OK
  testlib.mySinkTwoLast(1, 2, source(), 4); // NOT OK
  testlib.mySinkTwoLast(1, 2, 3, source()); // NOT OK

  testlib.mySinkTwoLastRange(source(), 2, 3, 4); // OK
  testlib.mySinkTwoLastRange(1, source(), 3, 4); // OK
  testlib.mySinkTwoLastRange(1, 2, source(), 4); // NOT OK
  testlib.mySinkTwoLastRange(1, 2, 3, source()); // NOT OK

  testlib.mySinkExceptLast(source(), 2, 3, 4); // NOT OK
  testlib.mySinkExceptLast(1, source(), 3, 4); // NOT OK
  testlib.mySinkExceptLast(1, 2, source(), 4); // NOT OK
  testlib.mySinkExceptLast(1, 2, 3, source()); // OK

  testlib.mySinkIfArityTwo(source()); // OK
  testlib.mySinkIfArityTwo(source(), 2); // NOT OK
  testlib.mySinkIfArityTwo(1, source()); // OK
  testlib.mySinkIfArityTwo(source(), 2, 3); // OK
  testlib.mySinkIfArityTwo(1, source(), 3); // OK
  testlib.mySinkIfArityTwo(1, 2, source()); // OK

  testlib.sink1(source()); // NOT OK
  testlib.sink2(source()); // NOT OK
  testlib.sink3(source()); // NOT OK
  testlib.sink4(source()); // OK
}

function testFlowThroughReceiver() {
  let source = testlib.getSource();
  sink(source); // NOT OK
  sink(source.continue()); // NOT OK
  sink(source.blah()); // OK
}

@testlib.ClassDecorator
class DecoratedClass {
  returnValueIsSink() {
    return source(); // NOT OK
  }
  inputIsSource(x) {
    sink(x); // NOT OK
  }
}

class OtherClass {
  @testlib.FieldDecoratorSink
  fieldSink;

  @testlib.FieldDecoratorSink
  static staticFieldSink;

  @testlib.FieldDecoratorSource
  fieldSource;

  @testlib.FieldDecoratorSource
  static staticFieldSource;

  useFields() {
    sink(this.fieldSource); // NOT OK
    sink(OtherClass.staticFieldSource); // NOT OK
    this.fieldSink = source(); // NOT OK
    OtherClass.staticFieldSink = source(); // NOT OK

    sink(this.staticFieldSource); // OK - not a valid field access
    sink(OtherClass.fieldSource); // OK - not a valid field access
    this.staticFieldSink = source(); // OK - not a valid field access
    OtherClass.fieldSink = source(); // OK - not a valid field access
  }

  @testlib.FieldDecoratorSink
  fieldSink2 = source(); // NOT OK

  @testlib.FieldDecoratorSink
  static staticFieldSink2 = source(); // NOT OK

  @testlib.MethodDecorator
  decoratedMethod(x) {
    sink(x); // NOT OK
    return source(); // NOT OK
  }

  @testlib.MethodDecorator
  static decoratedStaticMethod(x) {
    sink(x); // NOT OK
    return source(); // NOT OK
  }

  @testlib.MethodDecoratorWithArgs({ something: true })
  decoratedMethod2(x) {
    sink(x); // NOT OK
    return source(); // NOT OK
  }

  @testlib.FieldDecoratorSink
  get sinkViaGetter() {
    // If a field with this decorator should be seen as a sink it generally means the framework
    // will read it and pass it to an underlying sink. Therefore the return value of its getter
    // should be seen as a sink as well.
    return source(); // NOT OK
  }

  @testlib.FieldDecoratorSource
  set sourceViaSetter(x) {
    sink(x); // NOT OK
  }

  get sinkViaGetterIndirect() {
    // Same as 'sinkViaGetter', but where the decorator is placed on the corresponding setter
    return source(); // NOT OK
  }
  @testlib.FieldDecoratorSink // indirectly decorate the getter above
  set sinkViaGetterIndirect(x) {}

  set sourceViaSetterIndirect(x) {
    // Same as 'sourceViaSetter', but where the decorator is placed on the corresponding getter
    sink(x); // NOT OK
  }
  @testlib.FieldDecoratorSource // indirectly decorate the setter above
  get sourceViaSetterIndirect() {}

  @testlib.FieldDecoratorSink
  get accessorAroundField() {
    return this._wrappedField; // OK - the alert occurs at the assignment to 'accessorAroundField'
  }
  set accessorAroundField(x) {
    this._wrappedField = x;
  }

  useWrappedField() {
    this.accessorAroundField = source(); // NOT OK
  }
}

testlib.foo.memberSink(source()); // NOT OK
testlib.bar.memberSink(source()); // NOT OK
testlib.memberSink(source()); // OK
testlib.overloadedSink('safe', source()); // OK
testlib.overloadedSink('danger', source()); // NOT OK

function typeVars() {
  testlib.typevar.a.b().c.mySink(source()); // NOT OK

  testlib.typevar.mySink(source()); // OK - does not match sub path
  testlib.typevar.a.mySink(source()); // OK - does not match sub path
  testlib.typevar.a.b.mySink(source()); // OK - does not match sub path
  testlib.typevar.a.b.c.mySink(source()); // OK - does not match sub path
  testlib.typevar.a.b(1).c.mySink(source()); // OK - does not match sub path

  testlib.typevar.a.b().c.a.b().c.mySink(source(), 0); // OK
  testlib.typevar.a.b().c.a.b().c.mySink(0, source()); // NOT OK

  testlib.typevar.left.x.right.mySink(source()); // NOT OK
  testlib.typevar.left.left.x.right.right.mySink(source()); // NOT OK
  testlib.typevar.left.x.right.right.mySink(source()); // OK - mismatched left and right
  testlib.typevar.left.left.x.right.mySink(source()); // OK - mismatched left and right

  testlib.typevar.getThis().getThis().left.x.right.mySink(source()); // NOT OK
  testlib.typevar.left.getThis().getThis().x.right.mySink(source()); // NOT OK
  testlib.typevar.left.x.getThis().getThis().right.mySink(source()); // NOT OK
  testlib.typevar.left.x.right.getThis().getThis().mySink(source()); // NOT OK
}

function fuzzy() {
  testlib.fuzzyCall(source()); // NOT OK
  testlib.foo.fuzzyCall(source()); // NOT OK
  testlib.foo().fuzzyCall(source()); // NOT OK
  new testlib.Blah().foo.bar(async p => {
    p.fuzzyCall(source()); // NOT OK
    p.otherCall(source()); // OK
    p.fuzzyCall().laterMethod(source()); // OK
    (await p.promise).fuzzyCall(source()); // NOT OK
  });

  const wrapped = _.partial(testlib.foo, [123]);
  wrapped().fuzzyCall(source()); // NOT OK [INCONSISTENCY] - API graphs do not currently propagate return values through partial invocation
  wrapped(p => p.fuzzyCall(source())); // NOT OK

  const wrappedSink = _.partial(testlib.fuzzyCall);
  wrappedSink(source()); // NOT OK

  _.partial(testlib.fuzzyCall, source()); // NOT OK

  fuzzyCall(source()); // OK - does not come from 'testlib'
  require('blah').fuzzyCall(source()); // OK - does not come from 'testlib'
}

class MySubclass extends testlib.BaseClass {
  foo() {
    sink(this.baseclassSource()); // NOT OK
  }
}
sink(new MySubclass().baseclassSource()); // NOT OK

class MySubclass2 extends MySubclass {
  foo2() {
    sink(this.baseclassSource()); // NOT OK
  }
}
sink(new MySubclass2().baseclassSource()); // NOT OK

sink(testlib.parenthesizedPackageName()); // NOT OK

function dangerConstant() {
  sink("danger-constant".danger); // NOT OK
  sink("danger-constant".safe); // OK
  sink("danger-constant"); // OK
}
