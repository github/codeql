package com.semmle.js.extractor;

import java.io.File;
import java.io.IOException;
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
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;
import java.util.function.Predicate;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import com.google.gson.Gson;
import com.google.gson.JsonParseException;
import com.semmle.js.dependencies.AsyncFetcher;
import com.semmle.js.dependencies.DependencyResolver;
import com.semmle.js.dependencies.packument.PackageJson;
import com.semmle.js.extractor.ExtractorConfig.SourceType;
import com.semmle.js.extractor.FileExtractor.FileType;
import com.semmle.js.extractor.trapcache.DefaultTrapCache;
import com.semmle.js.extractor.trapcache.DummyTrapCache;
import com.semmle.js.extractor.trapcache.ITrapCache;
import com.semmle.js.parser.ParsedProject;
import com.semmle.ts.extractor.TypeExtractor;
import com.semmle.ts.extractor.TypeScriptParser;
import com.semmle.ts.extractor.TypeTable;
import com.semmle.util.data.StringUtil;
import com.semmle.util.exception.CatastrophicError;
import com.semmle.util.exception.Exceptions;
import com.semmle.util.exception.ResourceError;
import com.semmle.util.exception.UserError;
import com.semmle.util.extraction.ExtractorOutputConfig;
import com.semmle.util.files.FileUtil;
import com.semmle.util.io.WholeIO;
import com.semmle.util.io.csv.CSVReader;
import com.semmle.util.language.LegacyLanguage;
import com.semmle.util.process.Env;
import com.semmle.util.process.Env.OS;
import com.semmle.util.projectstructure.ProjectLayout;
import com.semmle.util.trap.TrapWriter;

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
 *   <li><code>LGTM_INDEX_FILTERS</code>: a newline-separated list of strings of form "include:PATTERN"
 *      or "exclude:PATTERN" that can be used to refine the list of files to include and exclude.
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
 *       FileType#JS} (currently ".js", ".jsx", ".mjs", ".cjs", ".es6", ".es").
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
  private volatile boolean seenFiles = false;
  private boolean installDependencies = false;
  private final VirtualSourceRoot virtualSourceRoot;
  private ExtractorState state;

  /** The default timeout when installing dependencies, in milliseconds. */
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
    this.virtualSourceRoot = makeVirtualSourceRoot();
    setupFileTypes();
    setupXmlMode();
    setupMatchers();
    this.state = new ExtractorState();
  }

  protected VirtualSourceRoot makeVirtualSourceRoot() {
    return new VirtualSourceRoot(LGTM_SRC, toRealPath(Paths.get(EnvironmentVariables.getScratchDir())));
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

    // include .eslintrc files, package.json files, and tsconfig.json files
    patterns.add("**/.eslintrc*");
    patterns.add("**/package.json");
    patterns.add("**/tsconfig.json");

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
      if (seenFiles) {
        warn("Only found JavaScript or TypeScript files that were empty or contained syntax errors.");
      } else {
        warn("No JavaScript or TypeScript code found.");
      }
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
            if (".js".equals(FileUtil.extension(file.toString()))) extract(extractor, file, true);
            return super.visitFile(file, attrs);
          }
        };
    Path externs = SEMMLE_DIST.resolve("tools").resolve("data").resolve("externs");
    Files.walkFileTree(externs, visitor);
  }

  /**
   * Compares files in the order they should be extracted.
   * <p>
   * The ordering of tsconfig.json files can affect extraction results. Since we
   * extract any given source file at most once, and a source file can be included from
   * multiple tsconfig.json files, we sometimes have to choose arbitrarily which tsconfig.json
   * to use for a given file (which is based on this ordering).
   * <p>
   * We sort them to help ensure reproducible extraction. Additionally, deeply nested files are
   * preferred over shallow ones to help ensure files are extracted with the most specific
   * tsconfig.json file.
   */
  public static final Comparator<Path> PATH_ORDERING = new Comparator<Path>() {
    public int compare(Path f1, Path f2) {
      if (f1.getNameCount() != f2.getNameCount()) {
        return f2.getNameCount() - f1.getNameCount();
      }
      return f1.compareTo(f2);
    }
  };

  /**
   * Like {@link #PATH_ORDERING} but for {@link File} objects.
   */
  public static final Comparator<File> FILE_ORDERING = new Comparator<File>() {
    public int compare(File f1, File f2) {
      return PATH_ORDERING.compare(f1.toPath(), f2.toPath());
    }
  };

  public class FileExtractors {
    FileExtractor defaultExtractor;
    Map<String, FileExtractor> customExtractors = new LinkedHashMap<>();

    FileExtractors(FileExtractor defaultExtractor) {
      this.defaultExtractor = defaultExtractor;
    }

    public FileExtractor forFile(Path f) {
      return customExtractors.getOrDefault(FileUtil.extension(f), defaultExtractor);
    }

    public FileType fileType(Path f) {
      return forFile(f).getFileType(f.toFile());
    }
  }

  /** Extract all supported candidate files that pass the filters. */
  private void extractSource() throws IOException {
    // default extractor
    FileExtractor defaultExtractor =
        new FileExtractor(mkExtractorConfig(), outputConfig, trapCache);

    FileExtractors extractors = new FileExtractors(defaultExtractor);

    // custom extractor for explicitly specified file types
    for (Map.Entry<String, FileType> spec : fileTypes.entrySet()) {
      String extension = spec.getKey();
      String fileType = spec.getValue().name();
      ExtractorConfig extractorConfig = mkExtractorConfig().withFileType(fileType);
      extractors.customExtractors.put(extension, new FileExtractor(extractorConfig, outputConfig, trapCache));
    }

    Set<Path> filesToExtract = new LinkedHashSet<>();
    List<Path> tsconfigFiles = new ArrayList<>();
    findFilesToExtract(defaultExtractor, filesToExtract, tsconfigFiles);

    tsconfigFiles = tsconfigFiles.stream()
         .sorted(PATH_ORDERING)
         .collect(Collectors.toList());

    filesToExtract = filesToExtract.stream()
        .sorted(PATH_ORDERING)
        .collect(Collectors.toCollection(() -> new LinkedHashSet<>()));

    DependencyInstallationResult dependencyInstallationResult = DependencyInstallationResult.empty;
    if (!tsconfigFiles.isEmpty()) {
      dependencyInstallationResult = this.preparePackagesAndDependencies(filesToExtract);
    }
    Set<Path> extractedFiles = new LinkedHashSet<>();
    
    // Extract HTML files as they may contain TypeScript
    CompletableFuture<?> htmlFuture = extractFiles(
        filesToExtract, extractedFiles, extractors,
        f -> extractors.fileType(f) == FileType.HTML);
    
    htmlFuture.join(); // Wait for HTML extraction to be finished.

    // extract TypeScript projects and files
    extractTypeScript(filesToExtract, extractedFiles,
              extractors, tsconfigFiles, dependencyInstallationResult);

    boolean hasTypeScriptFiles = extractedFiles.size() > 0;

    // extract remaining files
    extractFiles(
        filesToExtract, extractedFiles, extractors,
        f -> !(hasTypeScriptFiles && isFileDerivedFromTypeScriptFile(f, extractedFiles)));
  }

  private CompletableFuture<?> extractFiles(
      Set<Path> filesToExtract,
      Set<Path> extractedFiles,
      FileExtractors extractors,
      Predicate<Path> shouldExtract) {

    List<CompletableFuture<?>> futures = new ArrayList<>();
    for (Path f : filesToExtract) {
      if (extractedFiles.contains(f))
        continue;
      if (!shouldExtract.test(f)) {
        continue;
      }
      extractedFiles.add(f);
      futures.add(extract(extractors.forFile(f), f, true));
    }
    return CompletableFuture.allOf(futures.toArray(new CompletableFuture[0]));
  }

  /**
   * Returns true if the given path is likely the output of compiling a TypeScript file
   * which we have already extracted.
   */
  private boolean isFileDerivedFromTypeScriptFile(Path path, Set<Path> extractedFiles) {
    String name = path.getFileName().toString();
    if (!name.endsWith(".js"))
      return false;
    String stem = name.substring(0, name.length() - ".js".length());
    for (String ext : FileType.TYPESCRIPT.getExtensions()) {
      if (extractedFiles.contains(path.getParent().resolve(stem + ext))) {
        return true;
      }
    }
    return false;
  }

  /**
   * Returns an existing file named <code>dir/stem.ext</code> where <code>.ext</code> is any
   * of the given extensions, or <code>null</code> if no such file exists.
   */
  private static Path tryResolveWithExtensions(Path dir, String stem, Iterable<String> extensions) {
    for (String ext : extensions) {
      Path path = dir.resolve(stem + ext);
      if (Files.exists(dir.resolve(path))) {
        return path;
      }
    }
    return null;
  }

  /**
   * Returns an existing file named <code>dir/stem.ext</code> where <code>ext</code> is any TypeScript or JavaScript extension,
   * or <code>null</code> if no such file exists.
   */
  private static Path tryResolveTypeScriptOrJavaScriptFile(Path dir, String stem) {
    Path resolved = tryResolveWithExtensions(dir, stem, FileType.TYPESCRIPT.getExtensions());
    if (resolved != null) return resolved;
    return tryResolveWithExtensions(dir, stem, FileType.JS.getExtensions());
  }

  /**
   * Gets a relative path from <code>from</code> to <code>to</code> provided
   * the latter is contained in the former. Otherwise returns <code>null</code>.
   * @return a path or null
   */
  public static Path tryRelativize(Path from, Path to) {
    Path relative = from.relativize(to);
    if (relative.startsWith("..") || relative.isAbsolute()) {
      return null;
    }
    return relative;
  }

  /**
   * Prepares <tt>package.json</tt> files in a virtual source root, and, if enabled,
   * installs dependencies for use by the TypeScript type checker.
   * <p>
   * Some packages must be downloaded while others exist within the same repo ("monorepos")
   * but are not in a location where TypeScript would look for it.
   * <p>
   * Downloaded packages are intalled under <tt>SCRATCH_DIR</tt>, in a mirrored directory hierarchy
   * we call the "virtual source root".
   * <p>
   * Packages that exists within the repo are not downloaded. Since they are part of the main source tree,
   * these packages are not mirrored under the virtual source root.
   * Instead, an explicit package location mapping is passed to the TypeScript parser wrapper.
   * <p>
   * The TypeScript parser wrapper then overrides module resolution so packages can be found
   * under the virtual source root and via that package location mapping.
   */
protected DependencyInstallationResult preparePackagesAndDependencies(Set<Path> filesToExtract) {
    final Path sourceRoot = LGTM_SRC;

    // Read all package.json files and index them by name.
    Map<Path, PackageJson> packageJsonFiles = new LinkedHashMap<>();
    Map<String, Path> packagesInRepo = new LinkedHashMap<>();
    Map<String, Path> packageMainFile = new LinkedHashMap<>();
    for (Path file : filesToExtract) {
      if (file.getFileName().toString().equals("package.json")) {
        try {
          PackageJson packageJson = new Gson().fromJson(new WholeIO().read(file), PackageJson.class);
          file = file.toAbsolutePath();
          if (tryRelativize(sourceRoot, file) == null) {
            continue; // Ignore package.json files outside the source root.
          }
          packageJsonFiles.put(file, packageJson);

          String name = packageJson.getName();
          if (name != null) {
            packagesInRepo.put(name, file);
          }
        } catch (JsonParseException e) {
          System.err.println("Could not parse JSON file: " + file);
          System.err.println(e);
          // Continue without the malformed package.json file
        }
      }
    }

    // Guess the main file for each package.
    packageJsonFiles.forEach(
      (path, packageJson) -> {
          Path relativePath = sourceRoot.relativize(path);
          // For named packages, find the main file.
          String name = packageJson.getName();
          if (name != null) {
            Path entryPoint = guessPackageMainFile(path, packageJson, FileType.TYPESCRIPT.getExtensions());
            if (entryPoint == null) {
              // Try a TypeScript-recognized JS extension instead
              entryPoint = guessPackageMainFile(path, packageJson, Arrays.asList(".js", ".jsx"));
            }
            if (entryPoint != null) {
              System.out.println(relativePath + ": Main file set to " + sourceRoot.relativize(entryPoint));
              packageMainFile.put(name, entryPoint);
            } else {
              System.out.println(relativePath + ": Main file not found");
            }
          }
        });

    if (installDependencies) {
      // Use more threads for dependency installation than for extraction, as this is mainly I/O bound and we want
      // many concurrent HTTP requests.
      ExecutorService installationThreadPool = Executors.newFixedThreadPool(50);
      AsyncFetcher fetcher = new AsyncFetcher(installationThreadPool, err -> { System.err.println(err); });
      try {
        List<CompletableFuture<Void>> futures = new ArrayList<>();
        packageJsonFiles.forEach((file, packageJson) -> {
          Path virtualFile = virtualSourceRoot.toVirtualFile(file);
          Path nodeModulesDir = virtualFile.getParent().resolve("node_modules");
          futures.add(new DependencyResolver(fetcher, packagesInRepo.keySet()).installDependencies(packageJson, nodeModulesDir));
        });
        CompletableFuture.allOf(futures.toArray(new CompletableFuture[0])).join();
      } finally {
        installationThreadPool.shutdown();
        try {
          installationThreadPool.awaitTermination(1, TimeUnit.HOURS);
        } catch (InterruptedException e) {
          Exceptions.ignore(e, "Awaiting termination is not essential.");
        }
      }
    }

    return new DependencyInstallationResult(packageMainFile, packagesInRepo);
  }

  /**
   * Attempts to find a TypeScript file that acts as the main entry point to the
   * given package - that is, the file you get when importing the package by name
   * without any path suffix.
   */
  private Path guessPackageMainFile(Path packageJsonFile, PackageJson packageJson, Iterable<String> extensions) {
    Path packageDir = packageJsonFile.getParent();

    // Try <package_dir>/index.ts.
    Path resolved = tryResolveWithExtensions(packageDir, "index", extensions);
    if (resolved != null) {
      return resolved;
    }

    // Get the "main" property from the package.json
    // This usually refers to the compiled output, such as `./out/foo.js` but may hint as to
    // the name of main file ("foo" in this case).
    String mainStr = packageJson.getMain();

    // Look for source files `./src` if it exists
    Path sourceDir = packageDir.resolve("src");
    if (Files.isDirectory(sourceDir)) {
      // Try `src/index.ts`
      resolved = tryResolveTypeScriptOrJavaScriptFile(sourceDir, "index");
      if (resolved != null) {
        return resolved;
      }

      // If "main" was defined, try to map it to a file in `src`.
      // For example `out/dist/foo.bundle.js` might be mapped back to `src/foo.ts`.
      if (mainStr != null) {
        Path candidatePath = Paths.get(mainStr);

        // Strip off prefix directories that don't exist under `src/`, such as `out` and `dist`.
        while (candidatePath.getNameCount() > 1 && !Files.isDirectory(sourceDir.resolve(candidatePath.getParent()))) {
          candidatePath = candidatePath.subpath(1, candidatePath.getNameCount());
        }

        // Strip off extensions until a file can be found
        while (true) {
          resolved = tryResolveWithExtensions(sourceDir, candidatePath.toString(), extensions);
          if (resolved != null) {
            return resolved;
          }
          Path withoutExt = candidatePath.resolveSibling(FileUtil.stripExtension(candidatePath.getFileName().toString()));
          if (withoutExt.equals(candidatePath)) break; // No more extensions to strip
          candidatePath = withoutExt;
        }
      }
    }

    // Try to resolve main as a sibling of the package.json file, such as "./main.js" -> "./main.ts".
    if (mainStr != null) {
      Path mainPath = Paths.get(mainStr);
      String withoutExt = FileUtil.stripExtension(mainPath.getFileName().toString());
      resolved = tryResolveWithExtensions(packageDir, withoutExt, extensions);
      if (resolved != null) {
        return resolved;
      }
    }

    return null;
  }

  private ExtractorConfig mkExtractorConfig() {
    ExtractorConfig config = new ExtractorConfig(true);
    config = config.withSourceType(getSourceType());
    config = config.withTypeScriptMode(typeScriptMode);
    config = config.withVirtualSourceRoot(virtualSourceRoot);
    if (defaultEncoding != null) config = config.withDefaultEncoding(defaultEncoding);
    return config;
  }

  private Set<Path> extractTypeScript(
      Set<Path> files,
      Set<Path> extractedFiles,
      FileExtractors extractors,
      List<Path> tsconfig,
      DependencyInstallationResult deps) {
    if (hasTypeScriptFiles(files) || !tsconfig.isEmpty()) {
      TypeScriptParser tsParser = state.getTypeScriptParser();
      verifyTypeScriptInstallation(state);

      // Collect all files included in a tsconfig.json inclusion pattern.
      // If a given file is referenced by multiple tsconfig files, we prefer to extract it using
      // one that includes it rather than just references it.
      Set<File> explicitlyIncludedFiles = new LinkedHashSet<>();
      if (tsconfig.size() > 1) { // No prioritization needed if there's only one tsconfig.
        for (Path projectPath : tsconfig) {
          explicitlyIncludedFiles.addAll(tsParser.getOwnFiles(projectPath.toFile(), deps, virtualSourceRoot));
        }
      }

      // Extract TypeScript projects
      for (Path projectPath : tsconfig) {
        File projectFile = projectPath.toFile();
        long start = logBeginProcess("Opening project " + projectFile);
        ParsedProject project = tsParser.openProject(projectFile, deps, virtualSourceRoot);
        logEndProcess(start, "Done opening project " + projectFile);
        // Extract all files belonging to this project which are also matched
        // by our include/exclude filters.
        List<Path> typeScriptFiles = new ArrayList<Path>();
        for (File sourceFile : project.getAllFiles()) {
          Path sourcePath = sourceFile.toPath();
          Path normalizedFile = normalizePath(sourcePath);
          if (!files.contains(normalizedFile) && !state.getSnippets().containsKey(normalizedFile)) {
            continue;
          }
          if (!project.getOwnFiles().contains(sourceFile) && explicitlyIncludedFiles.contains(sourceFile)) continue;
          if (extractors.fileType(sourcePath) != FileType.TYPESCRIPT) {
            // For the time being, skip non-TypeScript files, even if the TypeScript
            // compiler can parse them for us.
            continue;
          }
          if (!extractedFiles.contains(sourcePath)) {
            typeScriptFiles.add(sourcePath);
          }
        }
        typeScriptFiles.sort(PATH_ORDERING);
        extractTypeScriptFiles(typeScriptFiles, extractedFiles, extractors);
        tsParser.closeProject(projectFile);
      }

      // Extract all the types discovered when extracting the ASTs.
      if (!tsconfig.isEmpty()) {
        TypeTable typeTable = tsParser.getTypeTable();
        extractTypeTable(tsconfig.iterator().next(), typeTable);
      }

      // Extract remaining TypeScript files.
      List<Path> remainingTypeScriptFiles = new ArrayList<>();
      for (Path f : files) {
        if (!extractedFiles.contains(f)
            && extractors.fileType(f) == FileType.TYPESCRIPT) {
          remainingTypeScriptFiles.add(f);
        }
      }
      if (!remainingTypeScriptFiles.isEmpty()) {
        extractTypeScriptFiles(remainingTypeScriptFiles, extractedFiles, extractors);
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
                && !excludes.contains(file)
                && isFileIncluded(file)) {
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
      List<Path> files,
      Set<Path> extractedFiles,
      FileExtractors extractors) {
    List<File> list = files
        .stream()
        .sorted(PATH_ORDERING)
        .map(p -> p.toFile()).collect(Collectors.toList());
    state.getTypeScriptParser().prepareFiles(list);
    for (Path path : files) {
      extractedFiles.add(path);
      extract(extractors.forFile(path), path, false);
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
  protected CompletableFuture<?> extract(FileExtractor extractor, Path file, boolean concurrent) {
    if (concurrent && threadPool != null) {
      return CompletableFuture.runAsync(() -> doExtract(extractor, file, state), threadPool);
    } else {
      doExtract(extractor, file, state);
      return CompletableFuture.completedFuture(null);
    }
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
      if (!extractor.getConfig().isExterns()) seenFiles = true;
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
    if (EnvironmentVariables.getCodeQLDist() == null) {
      // Use the legacy odasa XML extractor
      cmd.add("odasa");
      cmd.add("index");
      cmd.add("--xml");
      cmd.add("--extensions");
      cmd.addAll(xmlExtensions);
    } else {
      String command = Env.getOS() == OS.WINDOWS ? "codeql.exe" : "codeql";
      cmd.add(Paths.get(EnvironmentVariables.getCodeQLDist(), command).toString());
      cmd.add("database");
      cmd.add("index-files");
      cmd.add("--language");
      cmd.add("xml");
      cmd.add("--size-limit");
      cmd.add("10m");
      for (String extension : xmlExtensions) {
        cmd.add("--include-extension");
        cmd.add(extension);
      }
      cmd.add("--");
      cmd.add(EnvironmentVariables.getWipDatabase());
    }
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
