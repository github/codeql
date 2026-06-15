package com.semmle.js.extractor.test;

import org.junit.Test;

/**
 * Tests for parsing <code>function.sent</code>.
 *
 * <p>Most tests are automatically derived from the Babylon test suite as described in <code>
 * parser-tests/babylon/README.md</code>.
 */
public class FunctionSentTests extends ASTMatchingTests {
  @Test
  public void testInsideFunction() {
    babylonTest("experimental/function-sent/inside-function");
  }

  @Test
  public void testInsideGenerator() {
    babylonTest("experimental/function-sent/inside-generator");
  }

  @Test
  public void testInvalidProperty() {
    babylonTest("experimental/function-sent/invalid-property");
  }
}
