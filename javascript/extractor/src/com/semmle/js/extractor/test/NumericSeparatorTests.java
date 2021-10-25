package com.semmle.js.extractor.test;

import static org.junit.Assert.*;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;

import com.semmle.jcorn.ESNextParser;
import com.semmle.jcorn.Options;
import com.semmle.jcorn.SyntaxError;
import com.semmle.js.ast.ExpressionStatement;
import com.semmle.js.ast.Literal;
import com.semmle.js.ast.Program;
import org.junit.Test;

public class NumericSeparatorTests {
  private void test(String src, Integer numVal) {
    try {
      Program p = new ESNextParser(new Options().esnext(true), src, 0).parse();
      assertNotNull(numVal);
      assertEquals(1, p.getBody().size());
      assertTrue(p.getBody().get(0) instanceof ExpressionStatement);
      ExpressionStatement exprStmt = (ExpressionStatement) p.getBody().get(0);
      assertTrue(exprStmt.getExpression() instanceof Literal);
      assertEquals(numVal.longValue(), ((Literal) exprStmt.getExpression()).getValue());
    } catch (SyntaxError e) {
      assertNull(e.toString(), numVal);
    }
  }

  @Test
  public void test() {
    test("0b_", null);
    test("0b0_1", 0b01);
    test("0B0_1", 0b01);
    test("0b0_10", 0b010);
    test("0B0_10", 0b010);
    test("0b01_0", 0b010);
    test("0B01_0", 0b010);
    test("0b01_00", 0b0100);
    test("0B01_00", 0b0100);
    test("0b0__0", null);
    test("0b0_", null);
  }
}
