package com.semmle.js.extractor.test;

import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.google.gson.JsonPrimitive;
import com.semmle.js.extractor.ExtractorState;
import com.semmle.js.extractor.Main;
import com.semmle.util.data.Pair;
import com.semmle.util.data.StringUtil;
import com.semmle.util.extraction.ExtractorOutputConfig;
import com.semmle.util.io.WholeIO;
import com.semmle.util.srcarchive.DummySourceArchive;
import com.semmle.util.trap.ITrapWriterFactory;
import com.semmle.util.trap.TrapWriter;
import com.semmle.util.trap.pathtransformers.ProjectLayoutTransformer;
import java.io.File;
import java.io.StringWriter;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;
import java.util.List;
import java.util.Map.Entry;
import org.junit.AfterClass;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.junit.runners.Parameterized.Parameters;

@RunWith(Parameterized.class)
public class TrapTests {
  private static final File BASE = new File("tests").getAbsoluteFile();

  @Parameters(name = "{0}:{1}")
  public static Iterable<Object[]> tests() {
    List<Object[]> testData = new ArrayList<Object[]>();

    // iterate over all test groups
    List<String> testGroups = Arrays.asList(BASE.list());
    testGroups.sort(Comparator.naturalOrder());
    for (String testgroup : testGroups) {
      File root = new File(BASE, testgroup);
      if (root.isDirectory()) {
        // check for options.json file and process it if it exists
        List<String> options = new ArrayList<String>();
        File optionsFile = new File(root, "options.json");
        if (optionsFile.exists()) {
          JsonParser p = new JsonParser();
          JsonObject jsonOpts = p.parse(new WholeIO().strictread(optionsFile)).getAsJsonObject();
          for (Entry<String, JsonElement> e : jsonOpts.entrySet()) {
            JsonElement v = e.getValue();
            if (v instanceof JsonPrimitive) {
              JsonPrimitive pv = (JsonPrimitive) v;
              if (pv.isBoolean() && pv.getAsBoolean()) {
                options.add("--" + e.getKey());
              } else {
                options.add("--" + e.getKey());
                options.add(pv.getAsString());
              }
            } else {
              Assert.assertTrue(v instanceof JsonArray);
              JsonArray a = (JsonArray) v;
              for (JsonElement elt : a) {
                options.add("--" + e.getKey());
                options.add(elt.getAsString());
              }
            }
          }
        }

        File inputDir = new File(root, "input");
        File jsconfigFile = new File(inputDir, "tsconfig.json");

        if (jsconfigFile.exists()) {
          // create a single test with all files in the group
          testData.add(new Object[] {testgroup, "tsconfig", new ArrayList<String>(options)});
        } else {
          // create isolated tests for each input file in the group
          List<String> tests = Arrays.asList(inputDir.list());
          tests.sort(Comparator.naturalOrder());
          for (String testfile : tests) {
            testData.add(new Object[] {testgroup, testfile, new ArrayList<String>(options)});
          }
        }
      }
    }

    return testData;
  }

  private final String testgroup, testname;
  private final List<String> options;
  private static String userDir;
  private static ExtractorState state;

  public TrapTests(String testgroup, String testname, List<String> options) {
    this.testgroup = testgroup;
    this.testname = testname;
    this.options = options;
  }

  @BeforeClass
  public static void saveUserDir() {
    userDir = System.getProperty("user.dir");
  }

  @BeforeClass
  public static void setupState() {
    state = new ExtractorState();
  }

  @AfterClass
  public static void restoreUserDir() {
    System.setProperty("user.dir", userDir);
  }

  @Test
  public void runtest() {
    state.reset();
    File testdir = new File(BASE, testgroup);
    File inputDir = new File(testdir, "input");
    File inputFile = new File(inputDir, testname);
    final File outputDir = new File(testdir, "output/trap");

    System.setProperty("user.dir", inputFile.getParent());

    options.add("--extract-program-text");
    options.add("--quiet");
    if (new File(inputDir, "tsconfig.json").exists()) {
      // Use full extractor on entire directory.
      options.add("--typescript-full");
      options.add(inputDir.getAbsolutePath());
    } else {
      // Use basic extractor on a single file.
      options.add("--typescript");
      options.add(inputFile.getAbsolutePath());
    }

    final List<Pair<String, String>> expectedVsActual = new ArrayList<Pair<String, String>>();
    Main main =
        new Main(
            new ExtractorOutputConfig(
                new ITrapWriterFactory() {
                  @Override
                  public TrapWriter mkTrapWriter(final File f) {
                    final StringWriter sw = new StringWriter();
                    ProjectLayoutTransformer transformer =
                        new ProjectLayoutTransformer(new File(BASE, "project-layout"));
                    return new TrapWriter(sw, transformer) {
                      @Override
                      public void close() {
                        super.close();
                        // convert to and from UTF-8 to mimick treatment of unencodable characters
                        byte[] actual_utf8_bytes = StringUtil.stringToBytes(sw.toString());
                        String actual = new String(actual_utf8_bytes, Charset.forName("UTF-8"));
                        File trap = new File(outputDir, f.getName() + ".trap");
                        boolean replaceExpectedOutput = false;
                        if (replaceExpectedOutput) {
                          System.out.println("Replacing expected output for " + trap);
                          new WholeIO().strictwrite(trap, actual);
                        }
                        String expected = new WholeIO().strictreadText(trap);
                        expectedVsActual.add(Pair.make(expected, actual));
                      }

                      @Override
                      public void addTuple(String tableName, Object... values) {
                        if ("extraction_data".equals(tableName)
                            || "extraction_time".equals(tableName)) {
                          // ignore non-deterministic tables
                          return;
                        }
                        super.addTuple(tableName, values);
                      }
                    };
                  }

                  @Override
                  public File getTrapFileFor(File f) {
                    return null;
                  }
                },
                new DummySourceArchive()),
            state);

    main.run(options.toArray(new String[options.size()]));
    for (Pair<String, String> p : expectedVsActual) Assert.assertEquals(p.fst(), p.snd());
  }
}
