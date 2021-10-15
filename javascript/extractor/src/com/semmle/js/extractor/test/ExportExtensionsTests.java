package com.semmle.js.extractor.test;

import com.semmle.jcorn.Options;
import org.junit.Test;

/**
 * Tests for parsing export extensions.
 *
 * <p>Most tests are automatically derived from the Babylon test suite as described in <code>
 * parser-tests/babylon/README.md</code>.
 */
public class ExportExtensionsTests extends ASTMatchingTests {
  @Override
  protected void babylonTest(String dir) {
    babylonTest(dir, new Options().esnext(true).sourceType("module"));
  }

  @Test
  public void test50() {
    babylonTest("experimental/uncategorised/50");
  }

  @Test
  public void test51() {
    babylonTest("experimental/uncategorised/51");
  }

  @Test
  public void test52() {
    babylonTest("experimental/uncategorised/52");
  }

  @Test
  public void test53() {
    babylonTest("experimental/uncategorised/53");
  }

  @Test
  public void test54() {
    babylonTest("experimental/uncategorised/54");
  }
}
