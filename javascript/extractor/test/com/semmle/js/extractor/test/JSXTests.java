package com.semmle.js.extractor.test;

import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.semmle.jcorn.SyntaxError;
import com.semmle.jcorn.jsx.JSXOptions;
import com.semmle.jcorn.jsx.JSXParser;
import com.semmle.js.ast.AST2JSON;
import com.semmle.js.ast.Program;
import com.semmle.util.files.FileUtil;
import com.semmle.util.io.WholeIO;
import com.semmle.util.tests.TestPaths;
import java.io.File;
import java.util.ArrayList;
import java.util.List;
import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.junit.runners.Parameterized.Parameters;

/**
 * Tests for the JSX parser, automatically generated from the acorn-jsx test suite as described in
 * <code>parser-tests/jcorn-jsx/README.md</code>.
 */
@RunWith(Parameterized.class)
public class JSXTests extends ASTMatchingTests {
  private static final File BASE = TestPaths.get("parser-tests/jcorn-jsx").toAbsolutePath().toFile();

  @Parameters(name = "{0}")
  public static Iterable<Object[]> tests() {
    List<Object[]> testData = new ArrayList<Object[]>();

    // iterate over all tests
    for (File test : BASE.listFiles(FileUtil.extensionFilter(true, ".js"))) {
      String testName = FileUtil.basename(test);

      JSXOptions options = new JSXOptions().allowNamespacedObjects(false);
      File optionsFile = new File(test.getParentFile(), testName + ".options.json");
      if (optionsFile.exists()) {
        JsonObject optionsJson =
            new JsonParser().parse(new WholeIO().strictread(optionsFile)).getAsJsonObject();
        if (optionsJson.has("allowNamespacedObjects"))
          options =
              options.allowNamespacedObjects(
                  optionsJson.get("allowNamespacedObjects").getAsBoolean());
        if (optionsJson.has("allowNamespaces"))
          options = options.allowNamespaces(optionsJson.get("allowNamespaces").getAsBoolean());
      }

      JsonObject expectedAST;
      File expectedASTFile = new File(test.getParentFile(), testName + ".ast");
      if (expectedASTFile.exists())
        expectedAST =
            new JsonParser().parse(new WholeIO().strictread(expectedASTFile)).getAsJsonObject();
      else expectedAST = null;

      String expectedFailure;
      File expectedFailureFile = new File(test.getParentFile(), testName + ".fail");
      if (expectedFailureFile.exists())
        expectedFailure = new WholeIO().strictread(expectedFailureFile).trim();
      else expectedFailure = null;

      testData.add(new Object[] {testName, options, expectedAST, expectedFailure});
    }

    return testData;
  }

  private final String testName;
  private final JSXOptions options;
  private final JsonObject expectedAST;
  private final String expectedFailure;

  public JSXTests(
      String testName, JSXOptions options, JsonObject expectedAST, String expectedFailure) {
    this.testName = testName;
    this.options = options;
    this.expectedAST = expectedAST;
    this.expectedFailure = expectedFailure;
  }

  @Test
  public void runtest() {
    File inputFile = new File(BASE, testName + ".js");
    String input = new WholeIO().strictread(inputFile);
    try {
      Program actualProgram = new JSXParser(options, input, 0).parse();
      JsonElement actualAST = AST2JSON.convert(actualProgram);
      assertMatch("<root>", expectedAST, actualAST);
    } catch (SyntaxError e) {
      Assert.assertEquals(expectedFailure, e.getMessage());
    }
  }
}
