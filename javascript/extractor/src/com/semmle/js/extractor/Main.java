package com.semmle.js.extractor;

import java.io.File;
import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

import com.semmle.extractor.html.HtmlPopulator;
import com.semmle.js.extractor.ExtractorConfig.Platform;
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
import com.semmle.util.data.UnitParser;
import com.semmle.util.exception.ResourceError;
import com.semmle.util.exception.UserError;
import com.semmle.util.extraction.ExtractorOutputConfig;
import com.semmle.util.files.FileUtil;
import com.semmle.util.files.PathMatcher;
import com.semmle.util.io.WholeIO;
import com.semmle.util.language.LegacyLanguage;
import com.semmle.util.process.ArgsParser;
import com.semmle.util.process.ArgsParser.FileMode;
import com.semmle.util.process.Env;
import com.semmle.util.process.Env.Var;
import com.semmle.util.trap.TrapWriter;

/** The main entry point of the JavaScript extractor. */
public class Main {
  /**
   * A version identifier that should be updated every time the extractor changes in such a way that
   * it may produce different tuples for the same file under the same {@link ExtractorConfig}.
   */
  public static final String EXTRACTOR_VERSION = "2022-02-22";

  public static final Pattern NEWLINE = Pattern.compile("\n");

  // symbolic constants for command line parameter names
  private static final String P_ABORT_ON_PARSE_ERRORS = "--abort-on-parse-errors";
  private static final String P_DEBUG_EXCLUSIONS = "--debug-exclusions";
  private static final String P_DEFAULT_ENCODING = "--default-encoding";
  private static final String P_EXCLUDE = "--exclude";
  private static final String P_EXPERIMENTAL = "--experimental";
  private static final String P_EXTERNS = "--externs";
  private static final String P_EXTRACT_PROGRAM_TEXT = "--extract-program-text";
  private static final String P_FILE_TYPE = "--file-type";
  private static final String P_HTML = "--html";
  private static final String P_INCLUDE = "--include";
  private static final String P_PLATFORM = "--platform";
  private static final String P_QUIET = "--quiet";
  private static final String P_SOURCE_TYPE = "--source-type";
  private static final String P_TRAP_CACHE = "--trap-cache";
  private static final String P_TRAP_CACHE_BOUND = "--trap-cache-bound";
  private static final String P_TYPESCRIPT = "--typescript";
  private static final String P_TYPESCRIPT_FULL = "--typescript-full";
  private static final String P_TYPESCRIPT_RAM = "--typescript-ram";

  // symbolic constants for deprecated command line parameter names
  private static final String P_EXCLUDE_PATH = "--exclude-path";
  private static final String P_TOLERATE_PARSE_ERRORS = "--tolerate-parse-errors";
  private static final String P_NODEJS = "--nodejs";
  private static final String P_MOZ_EXTENSIONS = "--mozExtensions";
  private static final String P_JSCRIPT = "--jscript";
  private static final String P_HELP = "--help";
  private static final String P_ECMA_VERSION = "--ecmaVersion";

  private final ExtractorOutputConfig extractorOutputConfig;
  private ExtractorConfig extractorConfig;

  private PathMatcher includeMatcher, excludeMatcher;
  private FileExtractor fileExtractor;
  private ExtractorState extractorState;
  private Set<File> projectFiles = new LinkedHashSet<>();
  private Set<File> files = new LinkedHashSet<>();
  private final Set<File> extractedFiles = new LinkedHashSet<>();

  /* used to detect cyclic directory hierarchies */
  private final Set<String> seenDirectories = new LinkedHashSet<>();

  /**
   * If true, the extractor state is shared with other extraction jobs.
   *
   * <p>This is used by the test runner.
   */
  private boolean hasSharedExtractorState = false;

  public Main(ExtractorOutputConfig extractorOutputConfig) {
    this.extractorOutputConfig = extractorOutputConfig;
    this.extractorState = new ExtractorState();
  }

  public Main(ExtractorOutputConfig extractorOutputConfig, ExtractorState extractorState) {
    this.extractorOutputConfig = extractorOutputConfig;
    this.extractorState = extractorState;
    this.hasSharedExtractorState = true;
  }

  public void run(String[] args) {
    ArgsParser ap = addArgs(new ArgsParser(args));
    ap.parse();

    extractorConfig = parseJSOptions(ap);
    ITrapCache trapCache;
    if (ap.has(P_TRAP_CACHE)) {
      Long sizeBound = null;
      if (ap.has(P_TRAP_CACHE_BOUND)) {
        String tcb = ap.getString(P_TRAP_CACHE_BOUND);
        sizeBound = DefaultTrapCache.asFileSize(tcb);
        if (sizeBound == null) ap.error("Invalid TRAP cache size bound: " + tcb);
      }
      trapCache = new DefaultTrapCache(ap.getString(P_TRAP_CACHE), sizeBound, EXTRACTOR_VERSION);
    } else {
      if (ap.has(P_TRAP_CACHE_BOUND))
        ap.error(
            P_TRAP_CACHE_BOUND + " should only be specified together with " + P_TRAP_CACHE + ".");
      trapCache = new DummyTrapCache();
    }
    fileExtractor = new FileExtractor(extractorConfig, extractorOutputConfig, trapCache);

    setupMatchers(ap);

    collectFiles(ap);

    if (files.isEmpty()) {
      verboseLog(ap, "Nothing to extract.");
      return;
    }

    // Sort files for determinism
    projectFiles = projectFiles.stream()
          .sorted(AutoBuild.FILE_ORDERING)
          .collect(Collectors.toCollection(() -> new LinkedHashSet<>()));

    files = files.stream()
        .sorted(AutoBuild.FILE_ORDERING)
        .collect(Collectors.toCollection(() -> new LinkedHashSet<>()));

    // Extract HTML files first, as they may contain embedded TypeScript code
    for (File file : files) {
      if (FileType.forFile(file, extractorConfig) == FileType.HTML) {
        ensureFileIsExtracted(file, ap);
      }
    }
    
    TypeScriptParser tsParser = extractorState.getTypeScriptParser();
    tsParser.setTypescriptRam(extractorConfig.getTypeScriptRam());
    if (containsTypeScriptFiles()) {
      tsParser.verifyInstallation(!ap.has(P_QUIET));
    }

    for (File projectFile : projectFiles) {

      long start = verboseLogStartTimer(ap, "Opening project " + projectFile);
      ParsedProject project = tsParser.openProject(projectFile, DependencyInstallationResult.empty, extractorConfig.getVirtualSourceRoot());
      verboseLogEndTimer(ap, start);
      // Extract all files belonging to this project which are also matched
      // by our include/exclude filters.
      List<File> filesToExtract = new ArrayList<>();
      for (File sourceFile : project.getOwnFiles()) {
        File normalizedFile = normalizeFile(sourceFile);
        if ((files.contains(normalizedFile) || extractorState.getSnippets().containsKey(normalizedFile.toPath()))
            && !extractedFiles.contains(sourceFile.getAbsoluteFile())
            && FileType.TYPESCRIPT.getExtensions().contains(FileUtil.extension(sourceFile))) {
          filesToExtract.add(sourceFile);
        }
      }
      tsParser.prepareFiles(filesToExtract);
      for (int i = 0; i < filesToExtract.size(); ++i) {
        ensureFileIsExtracted(filesToExtract.get(i), ap);
      }
      // Close the project to free memory. This does not need to be in a `finally` as
      // the project is not a system resource.
      tsParser.closeProject(projectFile);
    }

    if (!projectFiles.isEmpty()) {
      // Extract all the types discovered when extracting the ASTs.
      TypeTable typeTable = tsParser.getTypeTable();
      extractTypeTable(projectFiles.iterator().next(), typeTable);
    }

    List<File> remainingTypescriptFiles = new ArrayList<>();
    for (File f : files) {
      if (!extractedFiles.contains(f.getAbsoluteFile())
          && FileType.forFileExtension(f) == FileType.TYPESCRIPT) {
        remainingTypescriptFiles.add(f);
      }
    }
    if (!remainingTypescriptFiles.isEmpty()) {
      tsParser.prepareFiles(remainingTypescriptFiles);
      for (File f : remainingTypescriptFiles) {
        ensureFileIsExtracted(f, ap);
      }
    }

    // The TypeScript compiler instance is no longer needed - free up some memory.
    if (hasSharedExtractorState) {
      tsParser.reset(); // This is called from a test runner, so keep the process alive.
    } else {
      tsParser.killProcess();
    }

    // Extract files that were not part of a project.
    for (File f : files) {
      if (isFileDerivedFromTypeScriptFile(f))
        continue;
      ensureFileIsExtracted(f, ap);
    }
  }

  /**
   * Returns true if the given path is likely the output of compiling a TypeScript file
   * which we have already extracted.
   */
  private boolean isFileDerivedFromTypeScriptFile(File path) {
    String name = path.getName();
    if (!name.endsWith(".js"))
      return false;
    String stem = name.substring(0, name.length() - ".js".length());
    for (String ext : FileType.TYPESCRIPT.getExtensions()) {
      if (new File(path.getParent(), stem + ext).exists()) {
        return true;
      }
    }
    return false;
  }

  private void extractTypeTable(File fileHandle, TypeTable table) {
    TrapWriter trapWriter =
        extractorOutputConfig
            .getTrapWriterFactory()
            .mkTrapWriter(
                new File(
                    fileHandle.getParentFile(),
                    fileHandle.getName() + ".codeql-typescript-typetable"));
    try {
      new TypeExtractor(trapWriter, table).extract();
    } finally {
      FileUtil.close(trapWriter);
    }
  }

  private void ensureFileIsExtracted(File f, ArgsParser ap) {
    if (!extractedFiles.add(f.getAbsoluteFile())) {
      // The file has already been extracted as part of a project.
      return;
    }
    long start = verboseLogStartTimer(ap, "Extracting " + f);
    try {
      fileExtractor.extract(f.getAbsoluteFile(), extractorState);
      verboseLogEndTimer(ap, start);
    } catch (IOException e) {
      throw new ResourceError("Extraction of " + f + " failed.", e);
    }
  }

  private void verboseLog(ArgsParser ap, String message) {
    if (!ap.has(P_QUIET)) {
      System.out.println(message);
    }
  }

  private long verboseLogStartTimer(ArgsParser ap, String message) {
    if (!ap.has(P_QUIET)) {
      System.out.print(message + "...");
      System.out.flush();
    }
    return System.currentTimeMillis();
  }

  private void verboseLogEndTimer(ArgsParser ap, long start) {
    long end = System.currentTimeMillis();
    if (!ap.has(P_QUIET)) {
      System.out.println(" done (" + (end - start) / 1000 + " seconds).");
    }
  }

  /** Returns true if the project contains a TypeScript file to be extracted. */
  private boolean containsTypeScriptFiles() {
    for (File file : files) {
      // The file headers have already been checked, so don't use I/O.
      if (FileType.forFileExtension(file) == FileType.TYPESCRIPT) {
        return true;
      }
    }
    return false;
  }

  public void collectFiles(ArgsParser ap) {
    for (File f : getFilesArg(ap))
      collectFiles(f, true);
  }

  private List<File> getFilesArg(ArgsParser ap) {
    return ap.getOneOrMoreFiles("files", FileMode.FILE_OR_DIRECTORY_MUST_EXIST);
  }

  public void setupMatchers(ArgsParser ap) {
    Set<String> includes = new LinkedHashSet<>();

    // only extract HTML and JS by default
    addIncludesFor(includes, FileType.HTML);
    addIncludesFor(includes, FileType.JS);

    // extract TypeScript if `--typescript` or `--typescript-full` was specified
    if (getTypeScriptMode(ap) != TypeScriptMode.NONE) addIncludesFor(includes, FileType.TYPESCRIPT);

    // add explicit include patterns
    for (String pattern : ap.getZeroOrMore(P_INCLUDE))
      addPathPattern(includes, System.getProperty("user.dir"), pattern);
    this.includeMatcher = new PathMatcher(includes);

    // if we are extracting (potential) Node.js code, we also want to
    // include package.json files, and files without extension
    if (getPlatform(ap) != Platform.WEB) {
      PathMatcher innerIncludeMatcher = this.includeMatcher;
      this.includeMatcher =
          new PathMatcher("**/package.json") {
            @Override
            public boolean matches(String path) {
              // match files without extension
              String basename = path.substring(path.lastIndexOf(File.separatorChar) + 1);
              if (FileUtil.extension(basename).isEmpty()) return true;

              // match package.json and anything matched by the inner matcher
              return super.matches(path) || innerIncludeMatcher.matches(path);
            }
          };
    }

    Set<String> excludes = new LinkedHashSet<>();
    for (String pattern : ap.getZeroOrMore(P_EXCLUDE))
      addPathPattern(excludes, System.getProperty("user.dir"), pattern);
    for (String excl : ap.getZeroOrMore(P_EXCLUDE_PATH)) {
      File exclFile = new File(excl).getAbsoluteFile();
      String base = exclFile.getParent();
      for (String pattern : NEWLINE.split(new WholeIO().strictread(exclFile)))
        addPathPattern(excludes, base, pattern);
    }
    this.excludeMatcher = new PathMatcher(excludes);

    if (ap.has(P_DEBUG_EXCLUSIONS)) {
      System.out.println("Inclusion patterns: " + this.includeMatcher);
      System.out.println("Exclusion patterns: " + this.excludeMatcher);
    }
  }

  private void addIncludesFor(Set<String> includes, FileType filetype) {
    for (String extension : filetype.getExtensions()) includes.add("**/*" + extension);
  }

  private void addPathPattern(Set<String> patterns, String base, String pattern) {
    pattern = pattern.trim();
    if (pattern.isEmpty()) return;
    if (!FileUtil.isAbsolute(pattern) && base != null) {
      pattern = base + "/" + pattern;
    }
    if (pattern.endsWith("/")) pattern = pattern.substring(0, pattern.length() - 1);
    patterns.add(pattern);
  }

  private ArgsParser addArgs(ArgsParser argsParser) {
    argsParser.addDeprecatedFlag(
        P_ECMA_VERSION, 1, "Files are now always extracted as ECMAScript 2017.");
    argsParser.addFlag(
        P_EXCLUDE, 1, "Do not extract files matching the given filename pattern.", true);
    argsParser.addToleratedFlag(P_EXCLUDE_PATH, 1, true);
    argsParser.addFlag(
        P_EXPERIMENTAL,
        0,
        "Enable experimental support for pending ECMAScript proposals "
            + "(public class fields, function.sent, decorators, export extensions, function bind, "
            + "parameter-less catch, dynamic import, numeric separators, bigints, top-level await), "
            + "as well as other language extensions (E4X, JScript, Mozilla and v8-specific extensions) and full HTML extraction.");
    argsParser.addFlag(
        P_EXTERNS, 0, "Extract the given JavaScript files as Closure-style externs.");
    argsParser.addFlag(
        P_EXTRACT_PROGRAM_TEXT,
        0,
        "Extract a representation of the textual content of the program "
            + "(in addition to its syntactic structure).");
    argsParser.addFlag(
        P_FILE_TYPE,
        1,
        "Assume all files to be of the given type, regardless of extension; "
            + "the type must be one of "
            + StringUtil.glue(", ", FileExtractor.FileType.allNames)
            + ".");
    argsParser.addFlag(P_HELP, 0, "Display this help.");
    argsParser.addFlag(
        P_HTML,
        1,
        "Control extraction of HTML files: "
            + "'scripts' extracts JavaScript code embedded inside HTML, but not the HTML itself; "
            + "'elements' additionally extracts HTML elements and their attributes, as well as HTML comments, but not textual content (default); "
            + "'all' extracts elements, embedded scripts, comments and text.");
    argsParser.addFlag(
        P_INCLUDE,
        1,
        "Extract files matching the given filename pattern (in addition to HTML and JavaScript files).",
        true);
    argsParser.addDeprecatedFlag(P_JSCRIPT, 0, "Use '" + P_EXPERIMENTAL + "' instead.");
    argsParser.addDeprecatedFlag(P_MOZ_EXTENSIONS, 0, "Use '" + P_EXPERIMENTAL + "' instead.");
    argsParser.addDeprecatedFlag(P_NODEJS, 0, "Use '" + P_PLATFORM + " node' instead.");
    argsParser.addFlag(
        P_PLATFORM,
        1,
        "Extract the given JavaScript files as code for the given platform: "
            + "'node' extracts them as Node.js modules; "
            + "'web' as plain JavaScript files; "
            + "'auto' uses heuristics to automatically detect "
            + "Node.js modules and extracts everything else as plain JavaScript files. "
            + "The default is 'auto'.");
    argsParser.addFlag(P_QUIET, 0, "Produce less output.");
    argsParser.addFlag(
        P_SOURCE_TYPE,
        1,
        "The source type to use; must be one of 'script', 'module' or 'auto'. "
            + "The default is 'auto'.");
    argsParser.addToleratedFlag(P_TOLERATE_PARSE_ERRORS, 0);
    argsParser.addFlag(
        P_ABORT_ON_PARSE_ERRORS, 0, "Abort extraction if a parse error is encountered.");
    argsParser.addFlag(P_TRAP_CACHE, 1, "Use the given directory as the TRAP cache.");
    argsParser.addFlag(
        P_TRAP_CACHE_BOUND,
        1,
        "A (soft) upper limit on the size of the TRAP cache, "
            + "in standard size units (e.g., 'g' for gigabytes).");
    argsParser.addFlag(P_DEFAULT_ENCODING, 1, "The encoding to use; default is UTF-8.");
    argsParser.addFlag(P_TYPESCRIPT, 0, "Enable basic TypesScript support.");
    argsParser.addFlag(
        P_TYPESCRIPT_FULL, 0, "Enable full TypeScript support with static type information.");
    argsParser.addFlag(
        P_TYPESCRIPT_RAM,
        1,
        "Amount of memory allocated to the TypeScript compiler process. The default is 1G.");
    argsParser.addToleratedFlag(P_DEBUG_EXCLUSIONS, 0);
    argsParser.addTrailingParam("files", "Files and directories to extract.");
    return argsParser;
  }

  private boolean enableExperimental(ArgsParser ap) {
    return ap.has(P_EXPERIMENTAL) || ap.has(P_JSCRIPT) || ap.has(P_MOZ_EXTENSIONS);
  }

  private static TypeScriptMode getTypeScriptMode(ArgsParser ap) {
    if (ap.has(P_TYPESCRIPT_FULL)) return TypeScriptMode.FULL;
    if (ap.has(P_TYPESCRIPT)) return TypeScriptMode.BASIC;
    return TypeScriptMode.NONE;
  }
  
  private Path inferSourceRoot(ArgsParser ap) {
    List<File> files = getFilesArg(ap);
    Path sourceRoot = files.iterator().next().toPath().toAbsolutePath().getParent();
    for (File file : files) {
      Path path = file.toPath().toAbsolutePath().getParent();
      for (int i = 0; i < sourceRoot.getNameCount(); ++i) {
        if (!(i < path.getNameCount() && path.getName(i).equals(sourceRoot.getName(i)))) {
          sourceRoot = sourceRoot.subpath(0, i);
          break;
        }
      }
    }
    return sourceRoot;
  }

  private ExtractorConfig parseJSOptions(ArgsParser ap) {
    ExtractorConfig cfg =
        new ExtractorConfig(enableExperimental(ap))
            .withExterns(ap.has(P_EXTERNS))
            .withPlatform(getPlatform(ap))
            .withTolerateParseErrors(
                ap.has(P_TOLERATE_PARSE_ERRORS) || !ap.has(P_ABORT_ON_PARSE_ERRORS))
            .withHtmlHandling(
                ap.getEnum(
                    P_HTML,
                    HtmlPopulator.Config.class,
                    ap.has(P_EXPERIMENTAL) ? HtmlPopulator.Config.ALL : HtmlPopulator.Config.ELEMENTS))
            .withFileType(getFileType(ap))
            .withSourceType(ap.getEnum(P_SOURCE_TYPE, SourceType.class, SourceType.AUTO))
            .withExtractLines(ap.has(P_EXTRACT_PROGRAM_TEXT))
            .withTypeScriptMode(getTypeScriptMode(ap))
            .withTypeScriptRam(
                ap.has(P_TYPESCRIPT_RAM)
                    ? UnitParser.parseOpt(ap.getString(P_TYPESCRIPT_RAM), UnitParser.MEGABYTES)
                    : 0);
    if (ap.has(P_DEFAULT_ENCODING)) cfg = cfg.withDefaultEncoding(ap.getString(P_DEFAULT_ENCODING));

    // Make a usable virtual source root mapping.
    // The concept of source root and scratch directory do not exist in the legacy extractor,
    // so we construct these based on what we have.
    String odasaDbDir = Env.systemEnv().getNonEmpty(Var.ODASA_DB);
    VirtualSourceRoot virtualSourceRoot =
        odasaDbDir == null
            ? VirtualSourceRoot.none
            : new VirtualSourceRoot(inferSourceRoot(ap), Paths.get(odasaDbDir, "working"));
    cfg = cfg.withVirtualSourceRoot(virtualSourceRoot);

    return cfg;
  }

  private String getFileType(ArgsParser ap) {
    String fileType = null;
    if (ap.has(P_FILE_TYPE)) {
      fileType = StringUtil.uc(ap.getString(P_FILE_TYPE));
      if (!FileExtractor.FileType.allNames.contains(fileType))
        ap.error("Invalid file type " + ap.getString(P_FILE_TYPE));
    }
    return fileType;
  }

  private Platform getPlatform(ArgsParser ap) {
    if (ap.has(P_NODEJS)) return Platform.NODE;
    return ap.getEnum(P_PLATFORM, Platform.class, Platform.AUTO);
  }

  /**
   * Collect files to extract under a given root, which may be either a file or a directory. The
   * {@code explicit} flag indicates whether {@code root} was explicitly passed to the extractor as
   * a command line argument, or whether it is examined as part of a recursive traversal.
   */
  private void collectFiles(File root, boolean explicit) {
    if (!root.exists()) {
      System.err.println("Skipping " + root + ", which does not exist.");
      return;
    }

    if (root.isDirectory()) {
      // exclude directories we've seen before
      if (seenDirectories.add(FileUtil.tryMakeCanonical(root).getPath()))
        // apply exclusion filters for directories
        if (!excludeMatcher.matches(root.getAbsolutePath())) {
          File[] gs = root.listFiles();
          if (gs == null) System.err.println("Skipping " + root + ", which cannot be listed.");
          else for (File g : gs) collectFiles(g, false);
        }
    } else {
      String path = root.getAbsolutePath();

      // extract files that are supported, match the layout (if any), pass the includeMatcher,
      // and do not pass the excludeMatcher
      if (fileExtractor.supports(root)
          && extractorOutputConfig.shouldExtract(root)
          && (explicit || includeMatcher.matches(path) && !excludeMatcher.matches(path))) {
        files.add(normalizeFile(root));
      }

      if (extractorConfig.getTypeScriptMode() == TypeScriptMode.FULL
          && root.getName().equals("tsconfig.json")
          && !excludeMatcher.matches(path)) {
        projectFiles.add(root);
      }
    }
  }

  private File normalizeFile(File root) {
    return root.getAbsoluteFile().toPath().normalize().toFile();
  }

  public static void main(String[] args) {
    try {
      new Main(new ExtractorOutputConfig(LegacyLanguage.JAVASCRIPT)).run(args);
    } catch (UserError e) {
      System.err.println(e.getMessage());
      if (!e.reportAsInfoMessage()) System.exit(1);
    }
  }
}
