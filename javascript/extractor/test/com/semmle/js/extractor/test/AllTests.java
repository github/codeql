package com.semmle.js.extractor.test;

import com.google.devtools.build.runfiles.Runfiles;
import com.semmle.util.process.Env;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.HashMap;
import java.util.Map;
import org.apache.commons.compress.archivers.zip.ZipArchiveEntry;
import org.apache.commons.compress.archivers.zip.ZipFile;
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
  TypeScriptTests.class,
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
    String tsNativeZip = runfiles.unmapped().rlocation(System.getenv("TS_NATIVE_ZIP"));
    Path tempDir = Files.createTempDirectory("ts-wrapper");
    extractZip(tsWrapperZip, tempDir);
    extractZip(tsNativeZip, tempDir.resolve("typescript-parser-wrapper/node_modules/@typescript"));
    Path tsWrapper = tempDir.resolve("typescript-parser-wrapper/main.js");
    if (!Files.exists(tsWrapper)) {
      throw new RuntimeException("Could not find ts-wrapper at " + tsWrapper);
    }
    Map<String, String> envUpdate = new HashMap<>();
    envUpdate.put("SEMMLE_TYPESCRIPT_NODE_RUNTIME", nodePath);
    envUpdate.put("SEMMLE_TYPESCRIPT_PARSER_WRAPPER", tsWrapper.toString());

    Env.systemEnv().pushEnvironmentContext(envUpdate);
  }

  private static void extractZip(String filename, Path destination) throws IOException {
    // Unix modes are in the central directory, which ZipInputStream does not expose.
    try (ZipFile zip = new ZipFile(Path.of(filename).toFile())) {
      var entries = zip.getEntries();
      while (entries.hasMoreElements()) {
        ZipArchiveEntry entry = entries.nextElement();
        Path entryPath = destination.resolve(entry.getName()).normalize();
        if (!entryPath.startsWith(destination)) {
          throw new IOException("ZIP entry is outside its destination: " + entry.getName());
        }
        if (entry.isDirectory()) {
          Files.createDirectories(entryPath);
        } else {
          Files.createDirectories(entryPath.getParent());
          try (InputStream input = zip.getInputStream(entry)) {
            Files.copy(input, entryPath);
          }
          if ((entry.getUnixMode() & 0111) != 0
              && entryPath.getFileSystem().supportedFileAttributeViews().contains("posix")
              && !entryPath.toFile().setExecutable(true, false)) {
            throw new IOException("Could not make ZIP entry executable: " + entryPath);
          }
        }
      }
    }
  }
}
