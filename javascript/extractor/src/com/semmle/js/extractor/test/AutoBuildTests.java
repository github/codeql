package com.semmle.js.extractor.test;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.FileVisitResult;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.SimpleFileVisitor;
import java.nio.file.attribute.BasicFileAttributes;
import java.nio.file.attribute.DosFileAttributeView;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.CompletableFuture;

import org.junit.After;
import org.junit.Assert;
import org.junit.Assume;
import org.junit.Before;
import org.junit.Test;

import com.semmle.js.extractor.AutoBuild;
import com.semmle.js.extractor.DependencyInstallationResult;
import com.semmle.js.extractor.ExtractorState;
import com.semmle.js.extractor.FileExtractor;
import com.semmle.js.extractor.FileExtractor.FileType;
import com.semmle.js.extractor.VirtualSourceRoot;
import com.semmle.util.data.StringUtil;
import com.semmle.util.exception.UserError;
import com.semmle.util.files.FileUtil;
import com.semmle.util.files.FileUtil8;
import com.semmle.util.process.Env;

public class AutoBuildTests {
  private Path SEMMLE_DIST, LGTM_SRC;
  private Set<String> expected;
  private Map<String, String> envVars;

  /**
   * Set up fake distribution and source directory and environment variables pointing to them, and
   * add in a few fake externs.
   */
  @Before
  public void setup() throws IOException {
    expected = new LinkedHashSet<>();
    envVars = new LinkedHashMap<>();
    // set up an empty distribution directory with an empty sub-directory for externs
    SEMMLE_DIST = Files.createTempDirectory("autobuild-dist").toRealPath();
    Path externs =
        Files.createDirectories(Paths.get(SEMMLE_DIST.toString(), "tools", "data", "externs"));

    // set up environment variables (the value of TRAP_FOLDER and SOURCE_ARCHIVE doesn't
    // really matter, since we won't do any actual extraction)
    envVars.put(Env.Var.SEMMLE_DIST.toString(), SEMMLE_DIST.toString());
    envVars.put(Env.Var.TRAP_FOLDER.toString(), SEMMLE_DIST.toString());
    envVars.put(Env.Var.SOURCE_ARCHIVE.toString(), SEMMLE_DIST.toString());

    // set up an empty source directory
    LGTM_SRC = Files.createTempDirectory("autobuild-src").toRealPath();
    envVars.put("LGTM_SRC", LGTM_SRC.toString());

    // add a few fake externs
    addFile(true, externs, "a.js");
    addFile(false, externs, "a.html");
    addFile(true, externs, "sub", "b.js");
    addFile(false, externs, "sub", "b.json");
  }

  /** Clean up distribution and source directory, and reset environment. */
  @After
  public void teardown() throws IOException {
    FileUtil8.recursiveDelete(SEMMLE_DIST);
    FileUtil8.recursiveDelete(LGTM_SRC);
  }

  /**
   * Add a file under {@code root} that we either do or don't expect to be extracted, depending on
   * the value of {@code extracted}. If the file is expected to be extracted, its path is added to
   * {@link #expected}. If non-null, parameter {@code fileType} indicates the file type with which
   * we expect the file to be extracted.
   */
  private Path addFile(boolean extracted, FileType fileType, Path root, String... components)
      throws IOException {
    Path f = addFile(root, components);
    if (extracted) {
      expected.add(f + (fileType == null ? "" : ":" + fileType.toString()));
    }
    return f;
  }

  /** Add a file with default file type. */
  private Path addFile(boolean extracted, Path root, String... components) throws IOException {
    return addFile(extracted, null, root, components);
  }

  /** Create a file at the specified path under {@code root} and return it. */
  private Path addFile(Path root, String... components) throws IOException {
    Path p = Paths.get(root.toString(), components);
    Files.createDirectories(p.getParent());
    return Files.createFile(p);
  }

  /** Run autobuild and compare the set of actually extracted files against {@link #expected}. */
  private void runTest() throws IOException {
    Env.systemEnv().pushEnvironmentContext(envVars);
    try {
      Set<String> actual = new LinkedHashSet<>();
      new AutoBuild() {
        @Override
        protected CompletableFuture<?> extract(FileExtractor extractor, Path file, boolean concurrent) {
          String extracted = file.toString();
          if (extractor.getConfig().hasFileType())
            extracted += ":" + extractor.getFileType(file.toFile());
          actual.add(extracted);
          return CompletableFuture.completedFuture(null);
        }

        @Override
        public void verifyTypeScriptInstallation(ExtractorState state) {}

        @Override
        public void extractTypeScriptFiles(
            java.util.List<Path> files,
            java.util.Set<Path> extractedFiles,
            FileExtractors extractors) {
          for (Path f : files) {
            actual.add(f.toString());
          }
        }

        @Override
        protected DependencyInstallationResult preparePackagesAndDependencies(Set<Path> filesToExtract) {
          // currently disabled in tests
          return DependencyInstallationResult.empty;
        }

        @Override
        protected VirtualSourceRoot makeVirtualSourceRoot() {
          return VirtualSourceRoot.none; // not used in these tests
        }

        @Override
        protected void extractXml() throws IOException {
          Files.walkFileTree(
              LGTM_SRC,
              new SimpleFileVisitor<Path>() {
                @Override
                public FileVisitResult visitFile(Path file, BasicFileAttributes attrs)
                    throws IOException {
                  String ext = FileUtil.extension(file);
                  if (!ext.isEmpty() && getXmlExtensions().contains(ext.substring(1)))
                    actual.add(file.toString());
                  return FileVisitResult.CONTINUE;
                }
              });
        }
      }.run();
      String expectedString = StringUtil.glue("\n", expected.stream().sorted().toArray());
      String actualString = StringUtil.glue("\n", actual.stream().sorted().toArray());
      Assert.assertEquals(expectedString, actualString);
    } finally {
      Env.systemEnv().popEnvironmentContext();
    }
  }

  @Test
  public void basicTest() throws IOException {
    addFile(true, LGTM_SRC, "tst.js");
    addFile(true, LGTM_SRC, "tst.ts");
    addFile(true, LGTM_SRC, "tst.html");
    addFile(false, LGTM_SRC, "tst.json");
    addFile(true, LGTM_SRC, "package.json");
    addFile(true, LGTM_SRC, ".eslintrc.yml");
    addFile(true, LGTM_SRC, "vendor", "leftpad", "index.js");
    runTest();
  }

  @Test
  public void typescript() throws IOException {
    envVars.put("LGTM_INDEX_TYPESCRIPT", "basic");
    addFile(true, LGTM_SRC, "tst.ts");
    addFile(true, LGTM_SRC, "tst.tsx");
    runTest();
  }

  @Test(expected = UserError.class)
  public void typescriptWrongConfig() throws IOException {
    envVars.put("LGTM_INDEX_TYPESCRIPT", "true");
    addFile(true, LGTM_SRC, "tst.ts");
    addFile(true, LGTM_SRC, "tst.tsx");
    runTest();
  }

  @Test
  public void includeFile() throws IOException {
    envVars.put("LGTM_INDEX_INCLUDE", "tst.js");
    addFile(true, LGTM_SRC, "tst.js");
    addFile(false, LGTM_SRC, "vendor", "leftpad", "index.js");
    runTest();
  }

  @Test
  public void excludeFile() throws IOException {
    envVars.put("LGTM_INDEX_EXCLUDE", "vendor/leftpad/index.js");
    addFile(true, LGTM_SRC, "tst.js");
    addFile(false, LGTM_SRC, "vendor", "leftpad", "index.js");
    runTest();
  }

  @Test
  public void excludeFolderByPattern() throws IOException {
    envVars.put("LGTM_INDEX_FILTERS", "exclude:**/vendor");
    addFile(true, LGTM_SRC, "tst.js");
    addFile(false, LGTM_SRC, "vendor", "leftpad", "index.js");
    runTest();
  }

  @Test
  public void excludeFolderByPattern2() throws IOException {
    envVars.put("LGTM_INDEX_FILTERS", "exclude:*/**/vendor");
    addFile(true, LGTM_SRC, "tst.js");
    addFile(true, LGTM_SRC, "vendor", "dep", "index.js");
    addFile(false, LGTM_SRC, "vendor", "dep", "vendor", "depdep", "index.js");
    runTest();
  }

  @Test
  public void excludeFolderByPattern3() throws IOException {
    envVars.put("LGTM_INDEX_FILTERS", "exclude:**/vendor\n");
    addFile(true, LGTM_SRC, "tst.js");
    addFile(false, LGTM_SRC, "vendor", "leftpad", "index.js");
    runTest();
  }

  @Test
  public void excludeFolderByPatterns() throws IOException {
    envVars.put("LGTM_INDEX_FILTERS", "exclude:foo\nexclude:**/vendor");
    addFile(true, LGTM_SRC, "tst.js");
    addFile(false, LGTM_SRC, "vendor", "leftpad", "index.js");
    runTest();
  }

  @Test
  public void excludeFolderByName() throws IOException {
    envVars.put("LGTM_INDEX_EXCLUDE", "vendor");
    addFile(true, LGTM_SRC, "tst.js");
    addFile(false, LGTM_SRC, "vendor", "leftpad", "index.js");
    runTest();
  }

  @Test
  public void excludeFolderByName2() throws IOException {
    envVars.put("LGTM_INDEX_EXCLUDE", "vendor\n");
    addFile(true, LGTM_SRC, "tst.js");
    addFile(false, LGTM_SRC, "vendor", "leftpad", "index.js");
    runTest();
  }

  @Test
  public void excludeFolderByName3() throws IOException {
    envVars.put("LGTM_INDEX_EXCLUDE", "./vendor\n");
    addFile(true, LGTM_SRC, "tst.js");
    addFile(false, LGTM_SRC, "vendor", "leftpad", "index.js");
    runTest();
  }

  @Test
  public void excludeByExtension() throws IOException {
    envVars.put("LGTM_INDEX_FILTERS", "exclude:**/*.js");
    addFile(false, LGTM_SRC, "tst.js");
    addFile(true, LGTM_SRC, "tst.html");
    addFile(false, LGTM_SRC, "vendor", "leftpad", "index.js");
    addFile(true, LGTM_SRC, "vendor", "leftpad", "index.html");
    runTest();
  }

  @Test
  public void includeByExtension() throws IOException {
    envVars.put("LGTM_INDEX_FILTERS", "include:**/*.json");
    addFile(true, LGTM_SRC, "tst.js");
    addFile(true, LGTM_SRC, "tst.json");
    addFile(true, LGTM_SRC, "vendor", "leftpad", "tst.json");
    runTest();
  }

  @Test
  public void includeByExtensionInRootOnly() throws IOException {
    envVars.put("LGTM_INDEX_FILTERS", "include:*.json");
    addFile(true, LGTM_SRC, "tst.js");
    addFile(true, LGTM_SRC, "tst.json");
    addFile(false, LGTM_SRC, "vendor", "leftpad", "tst.json");
    runTest();
  }

  @Test
  public void includeAndExclude() throws IOException {
    envVars.put("LGTM_INDEX_FILTERS", "include:**/*.json\n" + "exclude:**/vendor");
    addFile(true, LGTM_SRC, "tst.js");
    addFile(true, LGTM_SRC, "tst.json");
    addFile(false, LGTM_SRC, "vendor", "leftpad", "tst.json");
    runTest();
  }

  @Test
  public void excludeByClassification() throws IOException {
    Path repositoryFolders = Files.createFile(SEMMLE_DIST.resolve("repositoryFolders.csv"));
    List<String> csvLines = new ArrayList<>();
    csvLines.add("classification,path");
    csvLines.add("thirdparty," + LGTM_SRC.resolve("vendor"));
    csvLines.add("external," + LGTM_SRC.resolve("foo").resolve("bar").toUri());
    csvLines.add("metadata," + LGTM_SRC.resolve(".git"));
    Files.write(repositoryFolders, csvLines, StandardCharsets.UTF_8);
    envVars.put("LGTM_REPOSITORY_FOLDERS_CSV", repositoryFolders.toString());
    addFile(true, LGTM_SRC, "tst.js");
    addFile(false, LGTM_SRC, "foo", "bar", "tst.js");
    addFile(false, LGTM_SRC, ".git", "tst.js");
    addFile(true, LGTM_SRC, "vendor", "leftpad", "tst.js");
    runTest();
  }

  @Test
  public void excludeIncludeNested() throws IOException {
    envVars.put("LGTM_INDEX_INCLUDE", ".\ntest/util");
    envVars.put("LGTM_INDEX_EXCLUDE", "test\ntest/util/test");
    addFile(true, LGTM_SRC, "index.js");
    addFile(false, LGTM_SRC, "test", "tst.js");
    addFile(false, LGTM_SRC, "test", "subtest", "tst.js");
    addFile(true, LGTM_SRC, "test", "util", "util.js");
    addFile(false, LGTM_SRC, "test", "util", "test", "utiltst.js");
    runTest();
  }

  @Test
  public void includeImplicitlyExcluded() throws IOException {
    Path repositoryFolders = Files.createFile(SEMMLE_DIST.resolve("repositoryFolders.csv"));
    List<String> csvLines = new ArrayList<>();
    csvLines.add("classification,path");
    csvLines.add("thirdparty," + LGTM_SRC.resolve("vendor"));
    csvLines.add("external," + LGTM_SRC.resolve("foo").resolve("bar"));
    csvLines.add("metadata," + LGTM_SRC.resolve(".git"));
    Files.write(repositoryFolders, csvLines, StandardCharsets.UTF_8);
    envVars.put("LGTM_REPOSITORY_FOLDERS_CSV", repositoryFolders.toString());
    envVars.put("LGTM_INDEX_INCLUDE", ".\nfoo/bar");
    addFile(true, LGTM_SRC, "tst.js");
    addFile(true, LGTM_SRC, "foo", "bar", "tst.js");
    addFile(false, LGTM_SRC, ".git", "tst.js");
    addFile(true, LGTM_SRC, "vendor", "leftpad", "tst.js");
    runTest();
  }

  /**
   * Create a symbolic link from {@code $LGTM_SRC/link} to {@code target} and invoke {@code
   * runTest}. Skip running the test if the symbolic link cannot be created.
   */
  private void createSymlinkAndRunTest(String link, Path target) throws IOException {
    createSymlinkAndRunTest(Paths.get(LGTM_SRC.toString(), link), target);
  }

  /**
   * Create a symbolic link from {@code link} to {@code target} and invoke {@code runTest}. Skip
   * running the test if the symbolic link cannot be created.
   */
  private void createSymlinkAndRunTest(Path linkPath, Path target) throws IOException {
    try {
      Files.createSymbolicLink(linkPath, target);
    } catch (UnsupportedOperationException | SecurityException | IOException e) {
      Assume.assumeNoException("Cannot create symlinks.", e);
    }
    runTest();
  }

  @Test
  public void symlinkFile() throws IOException {
    Path tst_js = addFile(true, LGTM_SRC, "tst.js");
    createSymlinkAndRunTest("tst_link.js", tst_js);
  }

  @Test
  public void symlinkDir() throws IOException {
    Path testFolder = Files.createTempDirectory("autobuild-test").toAbsolutePath();
    try {
      addFile(false, testFolder, "tst.js");
      createSymlinkAndRunTest("test", testFolder);
    } finally {
      FileUtil8.recursiveDelete(testFolder);
    }
  }

  @Test
  public void deadSymlinkFile() throws IOException {
    Path dead = Paths.get("i", "do", "not", "exist", "tst.js");
    Assert.assertFalse(Files.exists(dead));
    createSymlinkAndRunTest("tst_link.js", dead);
  }

  @Test
  public void deadSymlinkDir() throws IOException {
    Path dead = Paths.get("i", "do", "not", "exist");
    Assert.assertFalse(Files.exists(dead));
    createSymlinkAndRunTest("test", dead);
  }

  @Test
  public void excludeByClassificationSymlink() throws IOException {
    // check for robustness in case LGTM_SRC is canonicalised but repositoryFolders.csv is not
    Path testFolder = Files.createTempDirectory("autobuild-test").toAbsolutePath();
    Files.createDirectories(testFolder);
    Path repositoryFolders = Files.createFile(SEMMLE_DIST.resolve("repositoryFolders.csv"));
    List<String> csvLines = new ArrayList<>();
    csvLines.add("classification,path");
    csvLines.add("external," + testFolder.resolve("src").resolve("foo"));
    Files.write(repositoryFolders, csvLines, StandardCharsets.UTF_8);
    envVars.put("LGTM_REPOSITORY_FOLDERS_CSV", repositoryFolders.toString());
    addFile(false, LGTM_SRC, "foo", "tst.js");
    createSymlinkAndRunTest(testFolder.resolve("src"), LGTM_SRC);
    FileUtil8.recursiveDelete(testFolder);
  }

  @Test
  public void excludeByClassificationBadPath() throws IOException {
    // check for robustness in case there are unresolvable paths in repositoryFolders.csv
    Path testFolder = Files.createTempDirectory("autobuild-test").toAbsolutePath();
    Files.createDirectories(testFolder);
    Path repositoryFolders = Files.createFile(SEMMLE_DIST.resolve("repositoryFolders.csv"));
    List<String> csvLines = new ArrayList<>();
    csvLines.add("classification,path");
    csvLines.add("external,no-such-path");
    Files.write(repositoryFolders, csvLines, StandardCharsets.UTF_8);
    envVars.put("LGTM_REPOSITORY_FOLDERS_CSV", repositoryFolders.toString());
    addFile(true, LGTM_SRC, "tst.js");
    runTest();
    FileUtil8.recursiveDelete(testFolder);
  }

  /** Hide {@code p} on using {@link DosFileAttributeView} if available; otherwise do nothing. */
  private void hide(Path p) throws IOException {
    DosFileAttributeView attrs = Files.getFileAttributeView(p, DosFileAttributeView.class);
    if (attrs != null) attrs.setHidden(true);
  }

  @Test
  public void hiddenFolders() throws IOException {
    Path tst_js = addFile(false, LGTM_SRC, ".DS_Store", "tst.js");
    hide(tst_js.getParent());
    runTest();
  }

  @Test
  public void hiddenFiles() throws IOException {
    Path eslintrc = addFile(true, LGTM_SRC, ".eslintrc.json");
    hide(eslintrc);
    runTest();
  }

  @Test
  public void noTypescriptExtraction() throws IOException {
    envVars.put("LGTM_INDEX_TYPESCRIPT", "none");
    addFile(false, LGTM_SRC, "tst.ts");
    addFile(false, LGTM_SRC, "sub.js", "tst.ts");
    addFile(false, LGTM_SRC, "tst.js.ts");
    runTest();
  }

  @Test
  public void includeNonExistentFile() throws IOException {
    envVars.put("LGTM_INDEX_INCLUDE", "tst.js");
    addFile(false, LGTM_SRC, "vendor", "leftpad", "index.js");
    runTest();
  }

  @Test
  public void excludeNonExistentFile() throws IOException {
    envVars.put("LGTM_INDEX_EXCLUDE", "vendor/leftpad/index.js");
    addFile(true, LGTM_SRC, "tst.js");
    runTest();
  }

  @Test
  public void minifiedFilesAreExcluded() throws IOException {
    addFile(true, LGTM_SRC, "admin.js");
    addFile(false, LGTM_SRC, "jquery.min.js");
    addFile(false, LGTM_SRC, "lib", "lodash-min.js");
    addFile(true, LGTM_SRC, "compute_min.js");
    runTest();
  }

  @Test
  public void minifiedFilesCanBeReIncluded() throws IOException {
    envVars.put("LGTM_INDEX_FILTERS", "include:**/*.min.js\ninclude:**/*-min.js");
    addFile(true, LGTM_SRC, "admin.js");
    addFile(true, LGTM_SRC, "jquery.min.js");
    addFile(true, LGTM_SRC, "lib", "lodash-min.js");
    addFile(true, LGTM_SRC, "compute_min.js");
    runTest();
  }

  @Test
  public void nodeModulesAreExcluded() throws IOException {
    addFile(true, LGTM_SRC, "index.js");
    addFile(false, LGTM_SRC, "node_modules", "dep", "main.js");
    addFile(false, LGTM_SRC, "node_modules", "dep", "node_modules", "leftpad", "index.js");
    runTest();
  }

  @Test
  public void nodeModulesCanBeReincluded() throws IOException {
    envVars.put("LGTM_INDEX_FILTERS", "include:**/node_modules");
    addFile(true, LGTM_SRC, "index.js");
    addFile(true, LGTM_SRC, "node_modules", "dep", "main.js");
    addFile(true, LGTM_SRC, "node_modules", "dep", "node_modules", "leftpad", "index.js");
    runTest();
  }

  @Test
  public void bowerComponentsAreExcluded() throws IOException {
    addFile(true, LGTM_SRC, "index.js");
    addFile(false, LGTM_SRC, "bower_components", "dep", "main.js");
    addFile(false, LGTM_SRC, "bower_components", "dep", "bower_components", "leftpad", "index.js");
    runTest();
  }

  @Test
  public void bowerComponentsCanBeReincluded() throws IOException {
    envVars.put("LGTM_INDEX_FILTERS", "include:**/bower_components");
    addFile(true, LGTM_SRC, "index.js");
    addFile(true, LGTM_SRC, "bower_components", "dep", "main.js");
    addFile(true, LGTM_SRC, "bower_components", "dep", "bower_components", "leftpad", "index.js");
    runTest();
  }

  @Test
  public void customExtensions() throws IOException {
    envVars.put("LGTM_INDEX_FILETYPES", ".jsm:js\n.soy:html");
    addFile(true, FileType.JS, LGTM_SRC, "tst.jsm");
    addFile(false, LGTM_SRC, "tstjsm");
    addFile(true, FileType.HTML, LGTM_SRC, "tst.soy");
    addFile(true, LGTM_SRC, "tst.html");
    addFile(true, LGTM_SRC, "tst.js");
    runTest();
  }

  @Test
  public void overrideExtension() throws IOException {
    envVars.put("LGTM_INDEX_FILETYPES", ".js:typescript");
    addFile(true, FileType.TYPESCRIPT, LGTM_SRC, "tst.js");
    runTest();
  }

  @Test
  public void invalidFileType() throws IOException {
    envVars.put("LGTM_INDEX_FILETYPES", ".jsm:javascript");
    try {
      runTest();
      Assert.fail("expected UserError");
    } catch (UserError ue) {
      Assert.assertEquals("Invalid file type 'JAVASCRIPT'.", ue.getMessage());
    }
  }

  @Test
  public void includeYaml() throws IOException {
    addFile(true, LGTM_SRC, "tst.yaml");
    addFile(true, LGTM_SRC, "tst.yml");
    addFile(true, LGTM_SRC, "tst.raml");
    runTest();
  }

  @Test
  public void dontIncludeXmlByDefault() throws IOException {
    addFile(false, LGTM_SRC, "tst.xml");
    addFile(false, LGTM_SRC, "tst.qhelp");
    runTest();
  }

  @Test
  public void includeXml() throws IOException {
    envVars.put("LGTM_INDEX_XML_MODE", "all");
    addFile(true, LGTM_SRC, "tst.xml");
    addFile(false, LGTM_SRC, "tst.qhelp");
    runTest();
  }

  @Test
  public void qhelpAsXml() throws IOException {
    envVars.put("LGTM_INDEX_FILETYPES", ".qhelp:xml");
    addFile(false, LGTM_SRC, "tst.xml");
    addFile(true, LGTM_SRC, "tst.qhelp");
    runTest();
  }

  @Test
  public void qhelpAsXmlAndAllXml() throws IOException {
    envVars.put("LGTM_INDEX_XML_MODE", "all");
    envVars.put("LGTM_INDEX_FILETYPES", ".qhelp:xml");
    addFile(true, LGTM_SRC, "tst.xml");
    addFile(true, LGTM_SRC, "tst.qhelp");
    runTest();
  }

  @Test
  public void skipCodeQLDatabases() throws IOException {
    addFile(true, LGTM_SRC, "tst.js");
    addFile(false, LGTM_SRC, "db/codeql-database.yml");
    addFile(false, LGTM_SRC, "db/foo.js");
    runTest();
  }

  @Test
  public void hiddenGitHubFoldersAreIncluded() throws IOException {
    Path tst_yml = addFile(true, LGTM_SRC, ".github", "workflows", "test.yml");
    hide(tst_yml.getParent().getParent());
    runTest();
  }

  @Test
  public void hiddenGitHubFoldersCanBeExcluded() throws IOException {
    envVars.put("LGTM_INDEX_FILTERS", "exclude:**/.github");
    Path tst_yml = addFile(false, LGTM_SRC, ".github", "workflows", "test.yml");
    hide(tst_yml.getParent().getParent());
    runTest();
  }
}
