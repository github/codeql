package com.semmle.js.extractor.test;

import com.semmle.jcorn.CustomParser;
import com.semmle.jcorn.Options;
import com.semmle.jcorn.SyntaxError;
import org.junit.Assert;
import org.junit.Test;

/**
 * Tests for using <code>await</code> and <code>yield</code> as property names inside async
 * functions and generators, where they are only restricted as bindings and references.
 */
public class AwaitYieldIdentifierTests {
  private void testSucceed(String input) {
    new CustomParser(new Options().esnext(true), input, 0).parse();
  }

  private void testFail(String input, String msg) {
    try {
      new CustomParser(new Options().esnext(true), input, 0).parse();
      Assert.fail("Expected syntax error, but parsing succeeded.");
    } catch (SyntaxError e) {
      Assert.assertEquals(msg, e.getMessage());
    }
  }

  @Test
  public void awaitAsPropertyName() {
    testSucceed("async function f(pool) { return await pool.await(); }");
    testSucceed("async function f(o) { return o?.await; }");
    testSucceed("async function f() { return { await: 42 }; }");
    testSucceed("async function f() { class C { await() {} } }");
    testSucceed("async function f(o) { o.await = 42; }");
  }

  @Test
  public void yieldAsPropertyName() {
    testSucceed("function* g(o) { yield o.yield(); }");
    testSucceed("function* g() { return { yield: 42 }; }");
    testSucceed("function* g() { class C { yield() {} } }");
  }

  @Test
  public void awaitAsIdentifier() {
    testFail(
        "async function f() { var await = 42; }",
        "Can not use 'await' as identifier inside an async function (1:25)");
    testFail(
        "async function f() { return { await }; }",
        "'await' can not be used as shorthand property (1:30)");
  }

  @Test
  public void yieldAsIdentifier() {
    testFail(
        "function* g() { var yield = 42; }",
        "Can not use 'yield' as identifier inside a generator (1:20)");
    testFail(
        "function* g() { return { yield }; }",
        "'yield' can not be used as shorthand property (1:25)");
  }
}
