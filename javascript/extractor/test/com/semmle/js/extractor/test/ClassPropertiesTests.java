package com.semmle.js.extractor.test;

import org.junit.Test;

/**
 * Tests for parsing class properties.
 *
 * <p>Most tests are automatically derived from the Babylon test suite as described in <code>
 * parser-tests/babylon/README.md</code>.
 */
public class ClassPropertiesTests extends ASTMatchingTests {
  @Test
  public void testASIFailureComputed() {
    babylonTest("experimental/class-properties/asi-failure-computed");
  }

  @Test
  public void testASIFailureGenerator() {
    babylonTest("experimental/class-properties/asi-failure-generator");
  }

  @Test
  public void testASISuccess() {
    babylonTest("experimental/class-properties/asi-success");
  }

  @Test
  public void test43() {
    babylonTest("experimental/uncategorised/43");
  }

  @Test
  public void test44() {
    babylonTest("experimental/uncategorised/44");
  }

  @Test
  public void test45() {
    babylonTest("experimental/uncategorised/45");
  }

  @Test
  public void test46() {
    babylonTest("experimental/uncategorised/46");
  }
}
