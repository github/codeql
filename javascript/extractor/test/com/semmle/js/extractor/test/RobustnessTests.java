package com.semmle.js.extractor.test;

import com.semmle.jcorn.Options;
import com.semmle.jcorn.Parser;
import com.semmle.util.io.WholeIO;
import com.semmle.util.tests.TestPaths;
import java.io.File;
import java.nio.charset.StandardCharsets;
import org.junit.Test;

public class RobustnessTests {

  @Test
  public void letLookheadTest() {
    File test = TestPaths.get("parser-tests/robustness/letLookahead.js").toFile();
    String src = new WholeIO(StandardCharsets.UTF_8.name()).strictread(test);
    new Parser(new Options(), src, 0).parse();
  }
}
