package com.semmle.js.extractor.test;

import com.semmle.jcorn.CustomParser;
import com.semmle.jcorn.Options;
import com.semmle.jcorn.Parser;
import com.semmle.jcorn.SyntaxError;
import com.semmle.util.io.WholeIO;
import com.semmle.util.tests.TestPaths;
import java.io.File;
import java.nio.charset.StandardCharsets;
import org.junit.Assert;
import org.junit.Test;

public class RobustnessTests {

  @Test
  public void letLookheadTest() {
    File test = TestPaths.get("parser-tests/robustness/letLookahead.js").toFile();
    String src = new WholeIO(StandardCharsets.UTF_8.name()).strictread(test);
    new Parser(new Options(), src, 0).parse();
  }

  @Test
  public void permissiveDestructuringTest() {
    String src =
        """
        ({ shorthand = 1 });
        ([...rest,] = values);
        function f(...args,) {}
        function g(...[first, { nested }],) {}
        const arrow = (...args,) => args;
        const destructuringArrow = (...{ value },) => value;
        async (...[first, { nested }],) => first;
        ({ method(...{ value },) {} });
        """;
    new Parser(new Options(), src, 0).parse();
  }

  @Test
  public void parenthesizedRestParameterTest() {
    try {
      new CustomParser(new Options().preserveParens(true), "async(...(x)) => x", 0)
          .parse();
      Assert.fail("Expected syntax error, but parsing succeeded.");
    } catch (SyntaxError expected) {
      Assert.assertEquals("Unexpected token (1:9)", expected.getMessage());
    }
  }
}
