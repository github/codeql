package com.semmle.js.extractor.test;

import com.semmle.js.ast.Node;
import com.semmle.js.extractor.ES2015Detector;
import com.semmle.js.extractor.ExtractionMetrics;
import com.semmle.js.extractor.ExtractorConfig;
import com.semmle.js.extractor.ExtractorConfig.SourceType;
import com.semmle.js.parser.JSParser;
import com.semmle.js.parser.JSParser.Result;
import org.junit.Assert;
import org.junit.Test;

public class ES2015DetectorTests {
  // using `experimental: true` as we do in real extractor, see `extractSource` method
  // in `AutoBuild.java`
  private static final ExtractorConfig CONFIG = new ExtractorConfig(true);

  private void isES2015(String src, boolean expected) {
    Result res = JSParser.parse(CONFIG, SourceType.MODULE, src, new ExtractionMetrics());
    Node ast = res.getAST();
    Assert.assertNotNull(ast);
    Assert.assertTrue(ES2015Detector.looksLikeES2015(ast) == expected);
  }

  @Test
  public void testImport() {
    isES2015("import * as fs from 'fs';", true);
  }

  @Test
  public void testExport() {
    isES2015("export function foo() { };", true);
  }

  @Test
  public void testDynamicImport() {
    isES2015("import('fs');", true);
  }

  @Test
  public void testDynamicImportAssign() {
    isES2015("var fs = import('fs');", true);
  }

  @Test
  public void testDynamicImportThen() {
    isES2015("import('o').then((o) => {});", true);
  }

  @Test
  public void importInBlockComment() {
    isES2015("/*\n"
      + "  import * from 'fs';\n"
      + "*/\n"
      + "const fs = require('fs');",
      false);
  }
}
