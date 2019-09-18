package com.semmle.js.extractor.test;

import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonNull;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.google.gson.JsonPrimitive;
import com.semmle.jcorn.ESNextParser;
import com.semmle.jcorn.Options;
import com.semmle.jcorn.SyntaxError;
import com.semmle.js.ast.AST2JSON;
import com.semmle.js.ast.Program;
import com.semmle.util.io.WholeIO;
import java.io.File;
import java.util.Iterator;
import java.util.Map.Entry;
import org.junit.Assert;

/** Base class for tests that use Acorn-like AST templates to specify expected test output. */
public abstract class ASTMatchingTests {
  /**
   * Assert that the given actual sub-AST matches the expected AST template, where {@code path} is
   * the path from the root to the sub-AST.
   */
  protected void assertMatch(String path, JsonElement expected, JsonElement actual) {
    if (expected == null) Assert.assertNull(path + ": null != " + actual, actual);

    if (expected instanceof JsonPrimitive || expected instanceof JsonNull)
      Assert.assertEquals(path, expected.toString(), actual.toString());

    if (expected instanceof JsonArray) {
      Assert.assertTrue(path + ": " + expected + " != " + actual, actual instanceof JsonArray);
      Iterator<JsonElement> expectedElements = ((JsonArray) expected).iterator();
      Iterator<JsonElement> actualElements = ((JsonArray) actual).iterator();
      int elt = 0;
      while (expectedElements.hasNext()) {
        String newPath = path + "[" + elt++ + "]";
        Assert.assertTrue(newPath + ": missing", actualElements.hasNext());
        assertMatch(newPath, expectedElements.next(), actualElements.next());
      }
    }

    if (expected instanceof JsonObject) {
      Assert.assertTrue(path + ": " + expected + " != " + actual, actual instanceof JsonObject);
      JsonObject actualObject = (JsonObject) actual;
      for (Entry<String, JsonElement> expectedProp : ((JsonObject) expected).entrySet()) {
        String key = expectedProp.getKey();
        JsonElement value = expectedProp.getValue();
        String newPath = path + "." + key;
        Assert.assertTrue(newPath + ": missing", actualObject.has(key));
        assertMatch(newPath, value, actualObject.get(key));
      }
    }
  }

  private static final File BABYLON_BASE = new File("parser-tests/babylon").getAbsoluteFile();

  protected void babylonTest(String dir) {
    babylonTest(dir, new Options().esnext(true));
  }

  protected void babylonTest(String dir, Options options) {
    File actual = new File(new File(BABYLON_BASE, dir), "actual.js");
    String actualSrc = new WholeIO().strictread(actual);
    JsonElement actualJSON;
    try {
      Program actualAST = new ESNextParser(options, actualSrc, 0).parse();
      actualJSON = AST2JSON.convert(actualAST);
    } catch (SyntaxError e) {
      actualJSON = new JsonPrimitive(e.getMessage());
    }

    File expected = new File(actual.getParentFile(), "expected.ast");
    JsonElement expectedJSON;
    if (expected.exists()) {
      String expectedSrc = new WholeIO().strictread(expected);
      expectedJSON = new JsonParser().parse(expectedSrc).getAsJsonObject();
    } else {
      File expectedErrFile = new File(actual.getParentFile(), "expected.error");
      String expectedErrMsg = new WholeIO().strictread(expectedErrFile).trim();
      expectedJSON = new JsonPrimitive(expectedErrMsg);
    }

    assertMatch("<root>", expectedJSON, actualJSON);
  }
}
