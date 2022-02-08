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
}
