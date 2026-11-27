package com.semmle.js.extractor.test;

import com.semmle.jcorn.CustomParser;
import com.semmle.jcorn.ESNextParser;
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

  @Test
  public void staticBlockSuperTest() {
    String src =
        """
        class Base {
          static schema = { openapi: (x) => x };
        }
        class Child extends Base {
          static {
            this.schema = super.schema.openapi({});
            const getter = () => super.schema;
            const nt = new.target;
            function helper() {
              return 1;
            }
            async function asyncHelper() {
              await Promise.resolve();
            }
            for (let i = 0; i < 1; i++) {
              break;
            }
          }
        }
        const ExprChild = class extends Base {
          static {
            this.schema = super.schema.openapi({});
          }
        };
        """;
    new ESNextParser(new Options().esnext(true), src, 0).parse();
  }

  @Test
  public void staticBlockBoundaryErrorsTest() {
    try {
      new ESNextParser(new Options().esnext(true), "super.foo;", 0).parse();
      Assert.fail("Expected syntax error for top-level super.");
    } catch (SyntaxError expected) {
      Assert.assertEquals("'super' outside of function or class (1:0)", expected.getMessage());
    }

    try {
      new ESNextParser(new Options().esnext(true), "class C extends super.foo {}", 0).parse();
      Assert.fail("Expected syntax error for super in top-level extends clause.");
    } catch (SyntaxError expected) {
      Assert.assertEquals("'super' outside of function or class (1:16)", expected.getMessage());
    }

    try {
      new ESNextParser(new Options().esnext(true), "class C { static { return 1; } }", 0).parse();
      Assert.fail("Expected syntax error for return in static block.");
    } catch (SyntaxError expected) {
      Assert.assertEquals("'return' outside of function (1:19)", expected.getMessage());
    }

    try {
      new ESNextParser(
              new Options().esnext(true), "function f() { class C { static { return 1; } } }", 0)
          .parse();
      Assert.fail("Expected syntax error for return in static block inside function.");
    } catch (SyntaxError expected) {
      Assert.assertEquals("'return' outside of function (1:34)", expected.getMessage());
    }

    try {
      new ESNextParser(
              new Options().esnext(true), "while (true) { class C { static { break; } } }", 0)
          .parse();
      Assert.fail("Expected syntax error for break escaping static block.");
    } catch (SyntaxError expected) {
      Assert.assertTrue(expected.getMessage().startsWith("Unsyntactic break"));
    }
  }

  @Test
  public void forOfRegexpTest() {
    String src =
        """
        for (let x of/a/.exec(s)) {}
        for (let x of /a/.exec(s)) {}
        for (var x of/a/gi.exec(s)) {}
        for (x of/a/.exec(s)) {}
        for (of of/a/.exec(s)) {}
        for (let x = of / 2; x < 10; x++) {}
        for (of / 2; ; ) { break; }
        """;
    new Parser(new Options(), src, 0).parse();

    String asyncSrc =
        """
        async function f(u, a, b) {
          for await(var s of/multipart\\/mixed/i.test(u)?a:b){}
        }
        for await(var s of/multipart\\/mixed/i.test(u)?a:b){}
        """;
    new ESNextParser(new Options().esnext(true), asyncSrc, 0).parse();
  }
}
