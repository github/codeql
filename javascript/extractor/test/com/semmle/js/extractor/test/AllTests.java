package com.semmle.js.extractor.test;

import com.google.devtools.build.runfiles.Runfiles;
import com.semmle.util.process.Env;
import java.io.FileInputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.HashMap;
import java.util.Map;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;
import org.junit.BeforeClass;
import org.junit.runner.RunWith;
import org.junit.runners.Suite;
import org.junit.runners.Suite.SuiteClasses;

@RunWith(Suite.class)
@SuiteClasses({
  JSXTests.class,
  NodeJSDetectorTests.class,
  ES2015DetectorTests.class,
  TrapTests.class,
  ObjectRestSpreadTests.class,
  ClassPropertiesTests.class,
  FunctionSentTests.class,
  DecoratorTests.class,
  ExportExtensionsTests.class,
  AutoBuildTests.class,
  RobustnessTests.class,
  NumericSeparatorTests.class
})
public class AllTests {

  @BeforeClass
  public static void setUp() throws Exception {
    Runfiles.Preloaded runfiles = Runfiles.preload();
    String nodePath = runfiles.unmapped().rlocation(System.getenv("NODE_BIN"));
    String tsWrapperZip = runfiles.unmapped().rlocation(System.getenv("TS_WRAPPER_ZIP"));
    Path tempDir = Files.createTempDirectory("ts-wrapper");
    // extract the ts-wrapper.zip to tempDir:
    try (ZipInputStream zis = new ZipInputStream(new FileInputStream(tsWrapperZip))) {
      ZipEntry entry = zis.getNextEntry();
      while (entry != null) {
        Path entryPath = tempDir.resolve(entry.getName());
        if (entry.isDirectory()) {
          Files.createDirectories(entryPath);
        } else {
          Files.copy(zis, entryPath);
        }
        entry = zis.getNextEntry();
      }
    }
    Path tsWrapper = tempDir.resolve("typescript-parser-wrapper/main.js");
    if (!Files.exists(tsWrapper)) {
      throw new RuntimeException("Could not find ts-wrapper at " + tsWrapper);
    }
    Map<String, String> envUpdate = new HashMap<>();
    envUpdate.put("SEMMLE_TYPESCRIPT_NODE_RUNTIME", nodePath);
    envUpdate.put("SEMMLE_TYPESCRIPT_PARSER_WRAPPER", tsWrapper.toString());

    Env.systemEnv().pushEnvironmentContext(envUpdate);
  }
}
