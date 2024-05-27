package com.semmle.js.extractor.test;

import com.semmle.js.ast.Node;
import com.semmle.js.extractor.ExtractionMetrics;
import com.semmle.js.extractor.ExtractorConfig;
import com.semmle.js.extractor.ExtractorConfig.SourceType;
import com.semmle.js.extractor.NodeJSDetector;
import com.semmle.js.parser.JSParser;
import com.semmle.js.parser.JSParser.Result;
import org.junit.Assert;
import org.junit.Test;

public class NodeJSDetectorTests {
  // using `experimental: true` as we do in real extractor, see `extractSource` method
  // in `AutoBuild.java`
  private static final ExtractorConfig CONFIG = new ExtractorConfig(true);

  private void isNodeJS(String src, boolean expected) {
    Result res = JSParser.parse(CONFIG, SourceType.SCRIPT, src, new ExtractionMetrics());
    Node ast = res.getAST();
    Assert.assertNotNull(ast);
    Assert.assertTrue(NodeJSDetector.looksLikeNodeJS(ast) == expected);
  }

  @Test
  public void testBareRequire() {
    isNodeJS("require('fs');", true);
  }

  @Test
  public void testRequireInit() {
    isNodeJS("var fs = require('fs');", true);
  }

  @Test
  public void testRequireInit2() {
    isNodeJS("var foo, fs = require('fs');", true);
  }

  @Test
  public void testDirective() {
    isNodeJS("\"use strict\"; require('fs');", true);
  }

  @Test
  public void testComment() {
    isNodeJS(
        "/** My awesome package.\n"
            + "* (C) me.\n"
            + "*/\n"
            + "\n"
            + "var isArray = require(\"isArray\");",
        true);
  }

  @Test
  public void testInitialExport() {
    isNodeJS("exports.foo = 0; console.log('Hello, world!');", true);
  }

  @Test
  public void testInitialModuleExport() {
    isNodeJS("module.exports.foo = 0; console.log('Hello, world!');", true);
  }

  @Test
  public void testInitialBulkExport() {
    isNodeJS("module.exports = {}; console.log('Hello, world!');", true);
  }

  @Test
  public void testTrailingExport() {
    isNodeJS("console.log('Hello, world!'); exports.foo = 0;", true);
  }

  @Test
  public void testTrailingModuleExport() {
    isNodeJS("console.log('Hello, world!'); module.exports.foo = 0;", true);
  }

  @Test
  public void testTrailingBulkExport() {
    isNodeJS("console.log('Hello, world!'); module.exports = {};", true);
  }

  @Test
  public void testInitialNestedExport() {
    isNodeJS("mystuff = module.exports = {}; mystuff.foo = 0;", true);
  }

  @Test
  public void testInitialNestedExportInit() {
    isNodeJS("var mystuff = module.exports = exports = {}; mystuff.foo = 0;", true);
  }

  @Test
  public void testTrailingRequire() {
    isNodeJS("console.log('Hello, world!'); var fs = require('fs');", true);
  }

  @Test
  public void testSandwichedExport() {
    isNodeJS("console.log('Hello'); exports.foo = 0; console.log('world!');", true);
  }

  @Test
  public void umd() {
    isNodeJS(
        "(function(define) {\n"
            + "  define(function (require, exports, module) {\n"
            + "    var b = require('b');\n"
            + "    return function () {};\n"
            + "  });\n"
            + "}(\n"
            + "  typeof module === 'object' && module.exports && typeof define !== 'function' ?\n"
            + "  function (factory) { module.exports = factory(require, exports, module); } :\n"
            + "  define\n"
            + "));",
        false);
  }

  @Test
  public void testRequirePropAccess() {
    isNodeJS("var foo = require('./b').foo;", true);
  }

  @Test
  public void testReExport() {
    isNodeJS("module.exports = require('./e');", true);
  }

  @Test
  public void testSeparateVar() {
    isNodeJS("var fs; fs = require('fs');", true);
  }

  @Test
  public void testLet() {
    isNodeJS("let fs = require('fs');", true);
  }

  @Test
  public void testSeparateLet() {
    isNodeJS("let fs; fs = require('fs');", true);
  }

  @Test
  public void testConst() {
    isNodeJS("const fs = require('fs');", true);
  }

  @Test
  public void testIife() {
    isNodeJS(";(function() { require('fs'); })()", true);
  }

  @Test
  public void testIife2() {
    isNodeJS("!function() { require('fs'); }()", true);
  }

  @Test
  public void testUMD() {
    isNodeJS("(function(require) { require('fs'); })(myRequire);", false);
  }

  @Test
  public void amdefine() {
    isNodeJS(
        "if (typeof define !== 'function') define = require('amdefine')(module, require);", true);
  }

  @Test
  public void requireAndReadProp() {
    isNodeJS("var readFileSync = require('fs').readFileSync;", true);
  }

  @Test
  public void toplevelAMDRequire() {
    isNodeJS("require(['foo'], function(foo) { });", false);
  }

  @Test
  public void requireInTry() {
    isNodeJS(
        "var fs;"
            + "try {"
            + "  fs = require('graceful-fs');"
            + "} catch(e) {"
            + "  fs = require('fs');"
            + "}",
        true);
  }

  @Test
  public void requireInIf() {
    isNodeJS(
        "var fs;"
            + "if (useGracefulFs) {"
            + "  fs = require('graceful-fs');"
            + "} else {"
            + "  fs = require('fs');"
            + "}",
        true);
  }

  @Test
  public void requireAndCall() {
    isNodeJS("var foo = require('foo')();", true);
  }

  @Test
  public void requireAndCallMethod() {
    isNodeJS("var foo = require('foo').bar();", true);
  }
}
