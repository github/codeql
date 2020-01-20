package com.semmle.js.extractor;

import com.semmle.js.extractor.ExtractorConfig.SourceType;
import com.semmle.js.extractor.FileExtractor.FileType;
import com.semmle.js.extractor.trapcache.DefaultTrapCache;
import com.semmle.js.extractor.trapcache.DummyTrapCache;
import com.semmle.js.extractor.trapcache.ITrapCache;
import com.semmle.js.parser.ParsedProject;
import com.semmle.js.parser.TypeScriptParser;
import com.semmle.ts.extractor.TypeExtractor;
import com.semmle.ts.extractor.TypeTable;
import com.semmle.util.data.StringUtil;
import com.semmle.util.exception.CatastrophicError;
import com.semmle.util.exception.Exceptions;
import com.semmle.util.exception.ResourceError;
import com.semmle.util.exception.UserError;
import com.semmle.util.extraction.ExtractorOutputConfig;
import com.semmle.util.files.FileUtil;
import com.semmle.util.io.csv.CSVReader;
import com.semmle.util.language.LegacyLanguage;
import com.semmle.util.process.Env;
import com.semmle.util.projectstructure.ProjectLayout;
import com.semmle.util.trap.TrapWriter;
import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.Reader;
import java.lang.ProcessBuilder.Redirect;
import java.net.URI;
import java.net.URISyntaxException;
import java.nio.charset.StandardCharsets;
import java.nio.file.FileVisitResult;
import java.nio.file.FileVisitor;
import java.nio.file.Files;
import java.nio.file.InvalidPathException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.SimpleFileVisitor;
import java.nio.file.attribute.BasicFileAttributes;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;
import java.util.stream.Stream;

/**
 * An alternative entry point to the JavaScript extractor.
 *
 * <p>It assumes the following environment variables to be set:
 *
 * <ul>
 *   <li><code>LGTM_SRC</code>: the source root;
 *   <li><code>SEMMLE_DIST</code>: the distribution root.
 * </ul>
 *
 * <p>Additionally, the following environment variables may be set to customise extraction
 * (explained in more detail below):
 *
 * <ul>
 *   <li><code>LGTM_INDEX_INCLUDE</code>: a newline-separated list of paths to include
 *   <li><code>LGTM_INDEX_EXCLUDE</code>: a newline-separated list of paths to exclude
 *   <li><code>LGTM_REPOSITORY_FOLDERS_CSV</code>: the path of a CSV file containing file
 *       classifications
 *   <li><code>LGTM_INDEX_FILTERS</code>: a newline-separated list of {@link ProjectLayout}-style
 *       patterns that can be used to refine the list of files to include and exclude
 *   <li><code>LGTM_INDEX_TYPESCRIPT</code>: whether to extract TypeScript
 *   <li><code>LGTM_INDEX_FILETYPES</code>: a newline-separated list of ".extension:filetype" pairs
 *       specifying which {@link FileType} to use for the given extension; the additional file type
 *       <code>XML</code> is also supported
 *   <li><code>LGTM_INDEX_XML_MODE</code>: whether to extract XML files
 *   <li><code>LGTM_THREADS</code>: the maximum number of files to extract in parallel
 *   <li><code>LGTM_TRAP_CACHE</code>: the path of a directory to use for trap caching
 *   <li><code>LGTM_TRAP_CACHE_BOUND</code>: the size to bound the trap cache to
 * </ul>
 *
 * <p>It extracts the following:
 *
 * <ol>
 *   <li>all <code>*.js</code> files under <code>$SEMMLE_DIST/tools/data/externs</code> (cf. {@link
 *       AutoBuild#extractExterns()};
 *   <li>all source code files (cf. {@link AutoBuild#extractSource()}.
 * </ol>
 *
 * <p>In the second step, the set of files to extract is determined in two phases: the walking
 * phase, which computes a set of candidate files, and the filtering phase. A file is extracted if
 * it is a candidate, its type is supported (cf. {@link FileExtractor#supports(File)}), and it is
 * not filtered out in the filtering phase.
 *
 * <p>The walking phase is parameterised by a set of <i>include paths</i> and a set of <i>exclude
 * paths</i>. By default, the single include path is <code>LGTM_SRC</code>. If the environment
 * variable <code>LGTM_INDEX_INCLUDE</code> is set, it is interpreted as a newline-separated list of
 * include paths, which are slash-separated paths relative to <code>LGTM_SRC</code>. This list
 * <i>replaces</i> (rather than extends) the default include path.
 *
 * <p>Similarly, the set of exclude paths is determined by the environment variables <code>
 * LGTM_INDEX_EXCLUDE</code> and <code>LGTM_REPOSITORY_FOLDERS_CSV</code>. The former is interpreted
 * like <code>LGTM_INDEX_EXCLUDE</code>, that is, a newline-separated list of exclude paths relative
 * to <code>LGTM_SRC</code>. The latter is interpreted as the path of a CSV file, where each line in
 * the file consists of a classification tag and an absolute path; any path classified as "external"
 * or "metadata" becomes an exclude path. Note that there are no implicit exclude paths.
 *
 * <p>The walking phase starts at each include path in turn and recursively traverses folders and
 * files. Symlinks and hidden folders are skipped, but not hidden files. If it encounters a
 * sub-folder whose path is excluded, traversal stops. If it encounters a file, that file becomes a
 * candidate, unless its path is excluded. If the path of a file is both an include path and an
 * exclude path, the inclusion takes precedence, and the file becomes a candidate after all.
 *
 * <p>If an include or exclude path cannot be resolved, a warning is printed and the path is
 * ignored.
 *
 * <p>Note that the overall effect of this procedure is that the precedence of include and exclude
 * paths is derived from their specificity: a more specific include/exclude takes precedence over a
 * less specific include/exclude. In case of a tie, the include takes precedence.
 *
 * <p>The filtering phase is parameterised by a list of include/exclude patterns in the style of
 * {@link ProjectLayout} specifications. There are some built-in include/exclude patterns discussed
 * below. Additionally, the environment variable <code>LGTM_INDEX_FILTERS</code> is interpreted as a
 * newline-separated list of patterns to append to that list (hence taking precedence over the
 * built-in patterns). Unlike for {@link ProjectLayout}, patterns in <code>LGTM_INDEX_FILTERS</code>
 * use the syntax <code>include: pattern</code> for inclusions and <code>exclude: pattern</code> for
 * exclusions.
 *
 * <p>The default inclusion patterns cause the following files to be included:
 *
 * <ul>
 *   <li>All JavaScript files, that is, files with one of the extensions supported by {@link
 *       FileType#JS} (currently ".js", ".jsx", ".mjs", ".es6", ".es").
 *   <li>All HTML files, that is, files with with one of the extensions supported by {@link
 *       FileType#HTML} (currently ".htm", ".html", ".xhtm", ".xhtml", ".vue").
 *   <li>All YAML files, that is, files with one of the extensions supported by {@link
 *       FileType#YAML} (currently ".raml", ".yaml", ".yml").
 *   <li>Files with base name "package.json".
 *   <li>JavaScript, JSON or YAML files whose base name starts with ".eslintrc".
 *   <li>All extension-less files.
 * </ul>
 *
 * <p>Additionally, if the environment variable <code>LGTM_INDEX_TYPESCRIPT</code> is set to "basic"
 * or "full" (default), files with one of the extensions supported by {@link FileType#TYPESCRIPT}
 * (currently ".ts" and ".tsx") are also included. In case of "full", type information from the
 * TypeScript compiler is extracted as well.
 *
 * <p>The environment variable <code>LGTM_INDEX_FILETYPES</code> may be set to a newline-separated
 * list of file type specifications of the form <code>.extension:filetype</code>, causing all files
 * whose name ends in <code>.extension</code> to also be included by default.
 *
 * <p>The default exclusion patterns cause the following files to be excluded:
 *
 * <ul>
 *   <li>All JavaScript files whose name ends with <code>-min.js</code> or <code>.min.js</code>.
 *       Such files typically contain minified code. Since LGTM by default does not show results in
 *       minified files, it is not usually worth extracting them in the first place.
 * </ul>
 *
 * <p>JavaScript files are normally extracted with {@link SourceType#AUTO}, but an explicit source
 * type can be specified in the environment variable <code>LGTM_INDEX_SOURCE_TYPE</code>.
 *
 * <p>The file type as which a file is extracted can be customised via the <code>
 * LGTM_INDEX_FILETYPES</code> environment variable explained above.
 *
 * <p>If <code>LGTM_INDEX_XML_MODE</code> is set to <code>ALL</code>, then all files with extension
 * <code>.xml</code> under <code>LGTM_SRC</code> are extracted as XML (in addition to any files
 * whose file type is specified to be <code>XML</code> via <code>LGTM_INDEX_SOURCE_TYPE</code>).
 * Currently XML extraction does not respect inclusion and exclusion filters, but this is a bug, not
 * a feature, and hence will change eventually.
 *
 * <p>Note that all these customisations only apply to <code>LGTM_SRC</code>. Extraction of externs
 * is not customisable.
 *
 * <p>To customise the actual extraction (as opposed to determining which files to extract), the
 * following environment variables are available:
 *
 * <ul>
 *   <li><code>LGTM_THREADS</code> determines how many threads are used for parallel extraction of
 *       JavaScript files (TypeScript files cannot currently be extracted in parallel). If left
 *       unspecified, the extractor uses a single thread.
 *   <li><code>LGTM_TRAP_CACHE</code> and <code>LGTM_TRAP_CACHE_BOUND</code> can be used to specify
 *       the location and size of a trap cache to be used during extraction.
 * </ul>
 */
public class AutoBuild {
  private final ExtractorOutputConfig outputConfig;
  private final ITrapCache trapCache;
  private final Map<String, FileType> fileTypes = new LinkedHashMap<>();
  private final Set<Path> includes = new LinkedHashSet<>();
  private final Set<Path> excludes = new LinkedHashSet<>();
  private final Set<String> xmlExtensions = new LinkedHashSet<>();
  private ProjectLayout filters;
  private final Path LGTM_SRC, SEMMLE_DIST;
  private final TypeScriptMode typeScriptMode;
  private final String defaultEncoding;
  private ExecutorService threadPool;
  private volatile boolean seenCode = false;
  private boolean installDependencies = false;
  private int installDependenciesTimeout;

  /** The default timeout when running <code>yarn</code>, in milliseconds. */
  public static final int INSTALL_DEPENDENCIES_DEFAULT_TIMEOUT = 10 * 60 * 1000; // 10 minutes

  public AutoBuild() {
    this.LGTM_SRC = toRealPath(getPathFromEnvVar("LGTM_SRC"));
    this.SEMMLE_DIST = Paths.get(EnvironmentVariables.getExtractorRoot());
    this.outputConfig = new ExtractorOutputConfig(LegacyLanguage.JAVASCRIPT);
    this.trapCache = mkTrapCache();
    this.typeScriptMode =
        getEnumFromEnvVar("LGTM_INDEX_TYPESCRIPT", TypeScriptMode.class, TypeScriptMode.FULL);
    this.defaultEncoding = getEnvVar("LGTM_INDEX_DEFAULT_ENCODING");
    this.installDependencies = Boolean.valueOf(getEnvVar("LGTM_INDEX_TYPESCRIPT_INSTALL_DEPS"));
    this.installDependenciesTimeout =
        Env.systemEnv()
            .getInt(
                "LGTM_INDEX_TYPESCRIPT_INSTALL_DEPS_TIMEOUT", INSTALL_DEPENDENCIES_DEFAULT_TIMEOUT);
    setupFileTypes();
    setupXmlMode();
    setupMatchers();
  }

  private String getEnvVar(String envVarName) {
    return getEnvVar(envVarName, null);
  }

  private String getEnvVar(String envVarName, String deflt) {
    String value = Env.systemEnv().getNonEmpty(envVarName);
    if (value == null) return deflt;
    return value;
  }

  private Path getPathFromEnvVar(String envVarName) {
    String lgtmSrc = getEnvVar(envVarName);
    if (lgtmSrc == null) throw new UserError(envVarName + " must be set.");
    Path path = Paths.get(lgtmSrc);
    return path;
  }

  private <T extends Enum<T>> T getEnumFromEnvVar(
      String envVarName, Class<T> enumClass, T defaultValue) {
    String envValue = getEnvVar(envVarName);
    if (envValue == null) return defaultValue;
    try {
      return Enum.valueOf(enumClass, StringUtil.uc(envValue));
    } catch (IllegalArgumentException ex) {
      Exceptions.ignore(ex, "We rewrite this to a meaningful user error.");
      Stream<String> enumNames =
          Arrays.asList(enumClass.getEnumConstants()).stream()
              .map(c -> StringUtil.lc(c.toString()));
      throw new UserError(
          envVarName + " must be set to one of: " + StringUtil.glue(", ", enumNames.toArray()));
    }
  }

  /**
   * Convert {@code p} to a real path (as per {@link Path#toRealPath(java.nio.file.LinkOption...)}),
   * throwing a {@link ResourceError} if this fails.
   */
  private Path toRealPath(Path p) {
    try {
      return p.toRealPath();
    } catch (IOException e) {
      throw new ResourceError("Could not compute real path for " + p + ".", e);
    }
  }

  /**
   * Set up TRAP cache based on environment variables <code>LGTM_TRAP_CACHE</code> and <code>
   * LGTM_TRAP_CACHE_BOUND</code>.
   */
  private ITrapCache mkTrapCache() {
    ITrapCache trapCache;
    String trapCachePath = getEnvVar("LGTM_TRAP_CACHE");
    if (trapCachePath != null) {
      Long sizeBound = null;
      String trapCacheBound = getEnvVar("LGTM_TRAP_CACHE_BOUND");
      if (trapCacheBound != null) {
        sizeBound = DefaultTrapCache.asFileSize(trapCacheBound);
        if (sizeBound == null)
          throw new UserError("Invalid TRAP cache size bound: " + trapCacheBound);
      }
      trapCache = new DefaultTrapCache(trapCachePath, sizeBound, Main.EXTRACTOR_VERSION);
    } else {
      trapCache = new DummyTrapCache();
    }
    return trapCache;
  }

  private void setupFileTypes() {
    for (String spec : Main.NEWLINE.split(getEnvVar("LGTM_INDEX_FILETYPES", ""))) {
      spec = spec.trim();
      if (spec.isEmpty()) continue;
      String[] fields = spec.split(":");
      if (fields.length != 2) continue;
      String extension = fields[0].trim();
      String fileType = fields[1].trim();
      try {
        fileType = StringUtil.uc(fileType);
        if ("XML".equals(fileType)) {
          if (extension.length() < 2) throw new UserError("Invalid extension '" + extension + "'.");
          xmlExtensions.add(extension.substring(1));
        } else {
          fileTypes.put(extension, FileType.valueOf(fileType));
        }
      } catch (IllegalArgumentException e) {
        Exceptions.ignore(e, "We construct a better error message.");
        throw new UserError("Invalid file type '" + fileType + "'.");
      }
    }
  }

  private void setupXmlMode() {
    String xmlMode = getEnvVar("LGTM_INDEX_XML_MODE", "DISABLED");
    xmlMode = StringUtil.uc(xmlMode.trim());
    if ("ALL".equals(xmlMode)) xmlExtensions.add("xml");
    else if (!"DISABLED".equals(xmlMode))
      throw new UserError("Invalid XML mode '" + xmlMode + "' (should be either ALL or DISABLED).");
  }

  /** Set up include and exclude matchers based on environment variables. */
  private void setupMatchers() {
    setupIncludesAndExcludes();
    setupFilters();
  }

  /**
   * Set up include matchers based on <code>LGTM_INDEX_INCLUDE</code> and <code>
   * LGTM_INDEX_TYPESCRIPT</code>.
   */
  private void setupIncludesAndExcludes() {
    // process `$LGTM_INDEX_INCLUDE` and `$LGTM_INDEX_EXCLUDE`
    boolean seenInclude = false;
    for (String pattern : Main.NEWLINE.split(getEnvVar("LGTM_INDEX_INCLUDE", "")))
      seenInclude |= addPathPattern(includes, LGTM_SRC, pattern);
    if (!seenInclude) includes.add(LGTM_SRC);
    for (String pattern : Main.NEWLINE.split(getEnvVar("LGTM_INDEX_EXCLUDE", "")))
      addPathPattern(excludes, LGTM_SRC, pattern);

    // process `$LGTM_REPOSITORY_FOLDERS_CSV`
    String lgtmRepositoryFoldersCsv = getEnvVar("LGTM_REPOSITORY_FOLDERS_CSV");
    if (lgtmRepositoryFoldersCsv != null) {
      Path path = Paths.get(lgtmRepositoryFoldersCsv);
      try (Reader reader = Files.newBufferedReader(path, StandardCharsets.UTF_8);
          CSVReader csv = new CSVReader(reader)) {
        // skip titles
        csv.readNext();
        String[] fields;
        while ((fields = csv.readNext()) != null) {
          if (fields.length != 2) continue;
          if ("external".equals(fields[0]) || "metadata".equals(fields[0])) {
            String folder = fields[1];
            try {
              Path folderPath =
                  folder.startsWith("file://") ? Paths.get(new URI(folder)) : Paths.get(folder);
              excludes.add(toRealPath(folderPath));
            } catch (InvalidPathException | URISyntaxException | ResourceError e) {
              Exceptions.ignore(e, "Ignore path and print warning message instead");
              warn(
                  "Ignoring '"
                      + fields[0]
                      + "' classification for "
                      + folder
                      + ", which is not a valid path.");
            }
          }
        }
      } catch (IOException e) {
        throw new ResourceError("Unable to process LGTM repository folder CSV.", e);
      }
    }
  }

  private void setupFilters() {
    List<String> patterns = new ArrayList<String>();
    patterns.add("/");

    // exclude all files with extensions
    patterns.add("-**/*.*");

    // but include HTML, JavaScript, YAML and (optionally) TypeScript
    Set<FileType> defaultExtract = new LinkedHashSet<FileType>();
    defaultExtract.add(FileType.HTML);
    defaultExtract.add(FileType.JS);
    defaultExtract.add(FileType.YAML);
    if (typeScriptMode != TypeScriptMode.NONE) defaultExtract.add(FileType.TYPESCRIPT);
    for (FileType filetype : defaultExtract)
      for (String extension : filetype.getExtensions()) patterns.add("**/*" + extension);

    // include .eslintrc files and package.json files
    patterns.add("**/.eslintrc*");
    patterns.add("**/package.json");

    // include any explicitly specified extensions
    for (String extension : fileTypes.keySet()) patterns.add("**/*" + extension);

    // exclude files whose name strongly suggests they are minified
    patterns.add("-**/*.min.js");
    patterns.add("-**/*-min.js");

    // exclude `node_modules` and `bower_components`
    patterns.add("-**/node_modules");
    patterns.add("-**/bower_components");

    String base = LGTM_SRC.toString().replace('\\', '/');
    // process `$LGTM_INDEX_FILTERS`
    for (String pattern : Main.NEWLINE.split(getEnvVar("LGTM_INDEX_FILTERS", ""))) {
      pattern = pattern.trim();
      if (pattern.isEmpty()) continue;
      String[] fields = pattern.split(":");
      if (fields.length != 2) continue;
      pattern = fields[1].trim();
      pattern = base + "/" + pattern;
      if ("exclude".equals(fields[0].trim())) pattern = "-" + pattern;
      patterns.add(pattern);
    }

    filters = new ProjectLayout(patterns.toArray(new String[0]));
  }

  /**
   * Add {@code pattern} to {@code patterns}, trimming off whitespace and prepending {@code base} to
   * it. If {@code pattern} ends with a trailing slash, that slash is stripped off.
   *
   * @return true if {@code pattern} is non-empty
   */
  private boolean addPathPattern(Set<Path> patterns, Path base, String pattern) {
    pattern = pattern.trim();
    if (pattern.isEmpty()) return false;
    Path path = base.resolve(pattern);
    try {
      Path realPath = toRealPath(path);
      patterns.add(realPath);
    } catch (ResourceError e) {
      Exceptions.ignore(e, "Ignore exception and print warning instead.");
      warn("Skipping path " + path + ", which does not exist.");
    }
    return true;
  }

  /** Perform extraction. */
  public int run() throws IOException {
    startThreadPool();
    try {
      extractSource();
      extractExterns();
      extractXml();
    } finally {
      shutdownThreadPool();
    }
    if (!seenCode) {
      warn("No JavaScript or TypeScript code found.");
      return -1;
    }
    return 0;
  }

  private void startThreadPool() {
    int defaultNumThreads = 1;
    int numThreads = Env.systemEnv().getInt("LGTM_THREADS", defaultNumThreads);
    if (numThreads > 1) {
      System.out.println("Parallel extraction with " + numThreads + " threads.");
      threadPool = Executors.newFixedThreadPool(numThreads);
    } else {
      System.out.println("Single-threaded extraction.");
      threadPool = null;
    }
  }

  private void shutdownThreadPool() {
    if (threadPool != null) {
      threadPool.shutdown();
      try {
        threadPool.awaitTermination(365, TimeUnit.DAYS);
      } catch (InterruptedException e) {
        Exceptions.ignore(e, "Awaiting termination is not essential.");
      }
    }
  }

  /** Extract all "*.js" files under <code>$SEMMLE_DIST/tools/data/externs</code> as externs. */
  private void extractExterns() throws IOException {
    ExtractorConfig config = new ExtractorConfig(false).withExterns(true);

    // use explicitly specified trap cache, or otherwise $SEMMLE_DIST/.cache/trap-cache/javascript,
    // which we pre-populate when building the distribution
    ITrapCache trapCache = this.trapCache;
    if (trapCache instanceof DummyTrapCache) {
      Path trapCachePath =
          SEMMLE_DIST.resolve(".cache").resolve("trap-cache").resolve("javascript");
      if (Files.isDirectory(trapCachePath)) {
        trapCache =
            new DefaultTrapCache(trapCachePath.toString(), null, Main.EXTRACTOR_VERSION) {
              boolean warnedAboutCacheMiss = false;

              @Override
              public File lookup(String source, ExtractorConfig config, FileType type) {
                File f = super.lookup(source, config, type);
                // only return `f` if it exists; this has the effect of making the cache read-only
                if (f.exists()) return f;
                // warn on first failed lookup
                if (!warnedAboutCacheMiss) {
                  warn("Trap cache lookup for externs failed.");
                  warnedAboutCacheMiss = true;
                }
                return null;
              }
            };
      } else {
        warn("No externs trap cache found");
      }
    }

    FileExtractor extractor = new FileExtractor(config, outputConfig, trapCache);
    FileVisitor<? super Path> visitor =
        new SimpleFileVisitor<Path>() {
          @Override
          public FileVisitResult visitFile(Path file, BasicFileAttributes attrs)
              throws IOException {
            if (".js".equals(FileUtil.extension(file.toString()))) extract(extractor, file, null);
            return super.visitFile(file, attrs);
          }
        };
    Path externs = SEMMLE_DIST.resolve("tools").resolve("data").resolve("externs");
    Files.walkFileTree(externs, visitor);
  }

  /** Extract all supported candidate files that pass the filters. */
  private void extractSource() throws IOException {
    // default extractor
    FileExtractor defaultExtractor =
        new FileExtractor(mkExtractorConfig(), outputConfig, trapCache);

    // custom extractor for explicitly specified file types
    Map<String, FileExtractor> customExtractors = new LinkedHashMap<>();
    for (Map.Entry<String, FileType> spec : fileTypes.entrySet()) {
      String extension = spec.getKey();
      String fileType = spec.getValue().name();
      ExtractorConfig extractorConfig = mkExtractorConfig().withFileType(fileType);
      customExtractors.put(extension, new FileExtractor(extractorConfig, outputConfig, trapCache));
    }

    Set<Path> filesToExtract = new LinkedHashSet<>();
    List<Path> tsconfigFiles = new ArrayList<>();
    findFilesToExtract(defaultExtractor, filesToExtract, tsconfigFiles);

    if (!tsconfigFiles.isEmpty() && this.installDependencies) {
      this.installDependencies(filesToExtract);
    }

    // extract TypeScript projects and files
    Set<Path> extractedFiles = extractTypeScript(defaultExtractor, filesToExtract, tsconfigFiles);

    // extract remaining files
    for (Path f : filesToExtract) {
      if (extractedFiles.add(f)) {
        FileExtractor extractor = defaultExtractor;
        if (!fileTypes.isEmpty()) {
          String extension = FileUtil.extension(f);
          if (customExtractors.containsKey(extension)) extractor = customExtractors.get(extension);
        }
        extract(extractor, f, null);
      }
    }
  }

  /** Returns true if yarn is installed, otherwise prints a warning and returns false. */
  private boolean verifyYarnInstallation() {
    ProcessBuilder pb = new ProcessBuilder(Arrays.asList("yarn", "-v"));
    try {
      Process process = pb.start();
      boolean completed = process.waitFor(this.installDependenciesTimeout, TimeUnit.MILLISECONDS);
      if (!completed) {
        System.err.println("Yarn could not be launched. Timeout during 'yarn -v'.");
        return false;
      }
      BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
      String version = reader.readLine();
      System.out.println("Found yarn version: " + version);
      return true;
    } catch (IOException | InterruptedException ex) {
      System.err.println(
          "Yarn not found. Please put 'yarn' on the PATH for automatic dependency installation.");
      Exceptions.ignore(ex, "Continue without dependency installation");
      return false;
    }
  }

  protected void installDependencies(Set<Path> filesToExtract) {
    if (!verifyYarnInstallation()) {
      return;
    }
    for (Path file : filesToExtract) {
      if (file.getFileName().toString().equals("package.json")) {
        System.out.println("Installing dependencies from " + file);
        ProcessBuilder pb =
            new ProcessBuilder(
                Arrays.asList(
                    "yarn",
                    "install",
                    "--non-interactive",
                    "--ignore-scripts",
                    "--ignore-platform",
                    "--ignore-engines",
                    "--ignore-optional",
                    "--no-default-rc",
                    "--no-bin-links",
                    "--pure-lockfile"));
        pb.directory(file.getParent().toFile());
        pb.redirectOutput(Redirect.INHERIT);
        pb.redirectError(Redirect.INHERIT);
        try {
          pb.start().waitFor(this.installDependenciesTimeout, TimeUnit.MILLISECONDS);
        } catch (IOException | InterruptedException ex) {
          throw new ResourceError("Could not install dependencies from " + file, ex);
        }
      }
    }
  }

  private ExtractorConfig mkExtractorConfig() {
    ExtractorConfig config = new ExtractorConfig(true);
    config = config.withSourceType(getSourceType());
    config = config.withTypeScriptMode(typeScriptMode);
    if (defaultEncoding != null) config = config.withDefaultEncoding(defaultEncoding);
    return config;
  }

  private Set<Path> extractTypeScript(
      FileExtractor extractor, Set<Path> files, List<Path> tsconfig) {
    Set<Path> extractedFiles = new LinkedHashSet<>();

    if (hasTypeScriptFiles(files) || !tsconfig.isEmpty()) {
      ExtractorState extractorState = new ExtractorState();
      TypeScriptParser tsParser = extractorState.getTypeScriptParser();
      verifyTypeScriptInstallation(extractorState);

      // Extract TypeScript projects
      for (Path projectPath : tsconfig) {
        File projectFile = projectPath.toFile();
        long start = logBeginProcess("Opening project " + projectFile);
        ParsedProject project = tsParser.openProject(projectFile);
        logEndProcess(start, "Done opening project " + projectFile);
        // Extract all files belonging to this project which are also matched
        // by our include/exclude filters.
        List<File> typeScriptFiles = new ArrayList<File>();
        for (File sourceFile : project.getSourceFiles()) {
          Path sourcePath = sourceFile.toPath();
          if (!files.contains(normalizePath(sourcePath))) continue;
          if (!FileType.TYPESCRIPT.getExtensions().contains(FileUtil.extension(sourcePath))) {
            // For the time being, skip non-TypeScript files, even if the TypeScript
            // compiler can parse them for us.
            continue;
          }
          if (!extractedFiles.contains(sourcePath)) {
            typeScriptFiles.add(sourcePath.toFile());
          }
        }
        extractTypeScriptFiles(typeScriptFiles, extractedFiles, extractor, extractorState);
        tsParser.closeProject(projectFile);
      }

      // Extract all the types discovered when extracting the ASTs.
      if (!tsconfig.isEmpty()) {
        TypeTable typeTable = tsParser.getTypeTable();
        extractTypeTable(tsconfig.iterator().next(), typeTable);
      }

      // Extract remaining TypeScript files.
      List<File> remainingTypeScriptFiles = new ArrayList<File>();
      for (Path f : files) {
        if (!extractedFiles.contains(f)
            && FileType.forFileExtension(f.toFile()) == FileType.TYPESCRIPT) {
          remainingTypeScriptFiles.add(f.toFile());
        }
      }
      if (!remainingTypeScriptFiles.isEmpty()) {
        extractTypeScriptFiles(remainingTypeScriptFiles, extractedFiles, extractor, extractorState);
      }

      // The TypeScript compiler instance is no longer needed.
      tsParser.killProcess();
    }

    return extractedFiles;
  }

  private boolean hasTypeScriptFiles(Set<Path> filesToExtract) {
    for (Path file : filesToExtract) {
      // Check if there are any files with the TypeScript extension.
      // Do not use FileType.forFile as it involves I/O for file header checks,
      // and files with a bad header have already been excluded.
      if (FileType.forFileExtension(file.toFile()) == FileType.TYPESCRIPT) return true;
    }
    return false;
  }

  private void findFilesToExtract(
      FileExtractor extractor, final Set<Path> filesToExtract, final List<Path> tsconfigFiles)
      throws IOException {
    Path[] currentRoot = new Path[1];
    FileVisitor<? super Path> visitor =
        new SimpleFileVisitor<Path>() {
          private boolean isFileIncluded(Path file) {
            // normalise path for matching
            String path = file.toString().replace('\\', '/');
            if (path.charAt(0) != '/') path = "/" + path;
            return filters.includeFile(path);
          }

          @Override
          public FileVisitResult visitFile(Path file, BasicFileAttributes attrs)
              throws IOException {
            if (attrs.isSymbolicLink()) return FileVisitResult.SKIP_SUBTREE;

            if (!file.equals(currentRoot[0]) && excludes.contains(file))
              return FileVisitResult.SKIP_SUBTREE;

            // extract files that are supported and pass the include/exclude patterns
            boolean supported = extractor.supports(file.toFile());
            if (!supported && !fileTypes.isEmpty()) {
              supported = fileTypes.containsKey(FileUtil.extension(file));
            }
            if (supported && isFileIncluded(file)) {
              filesToExtract.add(normalizePath(file));
            }

            // extract TypeScript projects from 'tsconfig.json'
            if (typeScriptMode == TypeScriptMode.FULL
                && file.getFileName().endsWith("tsconfig.json")
                && !excludes.contains(file)) {
              tsconfigFiles.add(file);
            }

            return super.visitFile(file, attrs);
          }

          @Override
          public FileVisitResult preVisitDirectory(Path dir, BasicFileAttributes attrs)
              throws IOException {
            if (!dir.equals(currentRoot[0]) && (excludes.contains(dir) || dir.toFile().isHidden()))
              return FileVisitResult.SKIP_SUBTREE;
            if (Files.exists(dir.resolve("codeql-database.yml"))) {
              return FileVisitResult.SKIP_SUBTREE;
            }
            return super.preVisitDirectory(dir, attrs);
          }
        };
    for (Path root : includes) {
      currentRoot[0] = root;
      Files.walkFileTree(currentRoot[0], visitor);
    }
  }

  /** Verifies that Node.js and the TypeScript compiler are installed and can be found. */
  public void verifyTypeScriptInstallation(ExtractorState extractorState) {
    extractorState.getTypeScriptParser().verifyInstallation(true);
  }

  public void extractTypeScriptFiles(
      List<File> files,
      Set<Path> extractedFiles,
      FileExtractor extractor,
      ExtractorState extractorState) {
    extractorState.getTypeScriptParser().prepareFiles(files);
    for (File f : files) {
      Path path = f.toPath();
      extractedFiles.add(path);
      extract(extractor, f.toPath(), extractorState);
    }
  }

  private Path normalizePath(Path path) {
    return path.toAbsolutePath().normalize();
  }

  private void extractTypeTable(Path fileHandle, TypeTable table) {
    TrapWriter trapWriter =
        outputConfig
            .getTrapWriterFactory()
            .mkTrapWriter(new File(fileHandle.toString() + ".codeql-typescript-typetable"));
    try {
      new TypeExtractor(trapWriter, table).extract();
    } finally {
      FileUtil.close(trapWriter);
    }
  }

  /**
   * Get the source type specified in <code>LGTM_INDEX_SOURCE_TYPE</code>, or the default of {@link
   * SourceType#AUTO}.
   */
  private SourceType getSourceType() {
    String sourceTypeName = getEnvVar("LGTM_INDEX_SOURCE_TYPE");
    if (sourceTypeName != null) {
      try {
        return SourceType.valueOf(StringUtil.uc(sourceTypeName));
      } catch (IllegalArgumentException e) {
        Exceptions.ignore(e, "We construct a better error message.");
        throw new UserError(sourceTypeName + " is not a valid source type.");
      }
    }
    return SourceType.AUTO;
  }

  /**
   * Extract a single file using the given extractor and state.
   *
   * <p>If the state is {@code null}, the extraction job will be submitted to the {@link
   * #threadPool}, otherwise extraction will happen on the main thread.
   */
  protected void extract(FileExtractor extractor, Path file, ExtractorState state) {
    if (state == null && threadPool != null)
      threadPool.submit(() -> doExtract(extractor, file, state));
    else doExtract(extractor, file, state);
  }

  private void doExtract(FileExtractor extractor, Path file, ExtractorState state) {
    File f = file.toFile();
    if (!f.exists()) {
      warn("Skipping " + file + ", which does not exist.");
      return;
    }

    try {
      long start = logBeginProcess("Extracting " + file);
      Integer loc = extractor.extract(f, state);
      if (!extractor.getConfig().isExterns() && (loc == null || loc != 0)) seenCode = true;
      logEndProcess(start, "Done extracting " + file);
    } catch (Throwable t) {
      System.err.println("Exception while extracting " + file + ".");
      t.printStackTrace(System.err);
      System.exit(1);
    }
  }

  private void warn(String msg) {
    System.err.println(msg);
    System.err.flush();
  }

  private long logBeginProcess(String message) {
    System.out.println(message);
    return System.nanoTime();
  }

  private void logEndProcess(long timedLogMessageStart, String message) {
    long end = System.nanoTime();
    int milliseconds = (int) ((end - timedLogMessageStart) / 1_000_000);
    System.out.println(message + " (" + milliseconds + " ms)");
    System.out.flush();
  }

  public Set<String> getXmlExtensions() {
    return xmlExtensions;
  }

  protected void extractXml() throws IOException {
    if (xmlExtensions.isEmpty()) return;
    List<String> cmd = new ArrayList<>();
    cmd.add("odasa");
    cmd.add("index");
    cmd.add("--xml");
    cmd.add("--extensions");
    cmd.addAll(xmlExtensions);
    ProcessBuilder pb = new ProcessBuilder(cmd);
    try {
      pb.redirectError(Redirect.INHERIT);
      pb.redirectOutput(Redirect.INHERIT);
      pb.start().waitFor();
    } catch (InterruptedException e) {
      throw new CatastrophicError(e);
    }
  }

  public static void main(String[] args) {
    try {
      System.exit(new AutoBuild().run());
    } catch (IOException | UserError | CatastrophicError e) {
      System.err.println(e.toString());
      System.exit(1);
    }
  }
}
