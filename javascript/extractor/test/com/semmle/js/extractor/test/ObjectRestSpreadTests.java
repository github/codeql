package com.semmle.js.extractor.test;

import com.semmle.jcorn.CustomParser;
import com.semmle.jcorn.Options;
import com.semmle.jcorn.SyntaxError;
import org.junit.Assert;
import org.junit.Test;

/**
 * Tests for parsing rest/spread properties.
 *
 * <p>Most tests are automatically derived from the Babylon test suite as described in <code>
 * parser-tests/babylon/README.md</code>.
 */
public class ObjectRestSpreadTests extends ASTMatchingTests {
  private void testFail(String input, String msg) {
    try {
      new CustomParser(new Options().esnext(true), input, 0).parse();
      Assert.fail("Expected syntax error, but parsing succeeded.");
    } catch (SyntaxError e) {
      Assert.assertEquals(msg, e.getMessage());
    }
  }

  @Test
  public void test9() {
    babylonTest("experimental/uncategorised/9");
  }

  @Test
  public void test10() {
    babylonTest("experimental/uncategorised/10");
  }

  @Test
  public void test11() {
    babylonTest("experimental/uncategorised/11");
  }

  @Test
  public void test12() {
    babylonTest("experimental/uncategorised/12");
  }

  @Test
  public void test13() {
    babylonTest("experimental/uncategorised/13");
  }

  @Test
  public void testObjectRestSpread() {
    babylonTest("harmony/arrow-functions/object-rest-spread");
  }

  @Test
  public void testFail() {
    testFail("({...'hi'} = {})", "Assigning to rvalue (1:5)");
  }
}
