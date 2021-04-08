package com.semmle.js.extractor;

import java.nio.charset.Charset;
import java.nio.charset.IllegalCharsetNameException;
import java.nio.charset.StandardCharsets;
import java.nio.charset.UnsupportedCharsetException;
import java.util.Arrays;
import java.util.Collections;
import java.util.LinkedHashSet;
import java.util.Set;

import com.semmle.js.parser.JcornWrapper;
import com.semmle.util.data.StringUtil;
import com.semmle.util.exception.UserError;

/**
 * Configuration options that affect the behaviour of the extractor.
 *
 * <p>The intended invariants are:
 *
 * <ol>
 *   <li>If the extractor is invoked twice on the same file (contents and path both the same) with
 *       the same configuration options, it will produce exactly the same TRAP files.
 *   <li>If the extractor is invoked on two files that have the same content, but whose path (and
 *       file extension) may be different, and the two invocations have the same configuration
 *       options, then the trap files it produces are identical from label #20000 onwards. (See
 *       comments on the trap cache below for further explanation.)
 * </ol>
 */
public class ExtractorConfig {
  public static enum ECMAVersion {
    ECMA3(3),
    ECMA5(5),
    ECMA2015(2015, 6),
    ECMA2016(2016, 7),
    ECMA2017(2017, 8),
    ECMA2018(2018, 9),
    ECMA2019(2019, 10),
    ECMA2020(2020, 11);

    private final int version;
    public final int legacyVersion;

    private ECMAVersion(int version, int legacyVersion) {
      this.version = version;
      this.legacyVersion = legacyVersion;
    }

    private ECMAVersion(int version) {
      this(version, version);
    }

    public static ECMAVersion of(int version) {
      for (ECMAVersion v : values())
        if (v.version == version || v.legacyVersion == version) return v;
      return null;
    }
  };

  /**
   * The type of a source file, which together with the {@link Platform} determines how the
   * top-level scope of the file behaves, and whether ES2015 module syntax should be allowed.
   *
   * <p>Note that the names of these enum members are depended on by {@link Main}, {@link
   * AutoBuild}, and {@link JcornWrapper}.
   */
  public static enum SourceType {
    /** A script executed in the global scope. */
    SCRIPT,

    /** An ES2015 module. */
    MODULE,

    /** A Closure-Library module, defined using `goog.module()`. */
    CLOSURE_MODULE,

    /** A CommonJS module that is not also an ES2015 module. */
    COMMONJS_MODULE,

    /** Automatically determined source type. */
    AUTO;

    @Override
    public String toString() {
      return StringUtil.lc(name());
    }

    /**
     * Returns true if this source is executed directly in the global scope, or false if it has its
     * own local scope.
     */
    public boolean hasLocalScope() {
      return this != SCRIPT;
    }

    /** Returns true if this source is implicitly in strict mode. */
    public boolean isStrictMode() {
      return this == MODULE;
    }

    private static final Set<String> closureLocals = Collections.singleton("exports");
    private static final Set<String> commonJsLocals =
        new LinkedHashSet<>(
            Arrays.asList("require", "module", "exports", "__filename", "__dirname", "arguments"));

    /**
     * Returns the set of local variables in scope at the top-level of this module.
     *
     * <p>If this source type has no local scope, the empty set is returned.
     */
    public Set<String> getPredefinedLocals(Platform platform, String extension) {
      switch (this) {
        case CLOSURE_MODULE:
          return closureLocals;
        case COMMONJS_MODULE:
          return commonJsLocals;
        case MODULE:
          if (platform == Platform.NODE && !extension.equals(".mjs")) {
            // An ES2015 module that is compiled to a Node.js module effectively has the locals
            // from Node.js even if they are not part of the ES2015 standard.
            return commonJsLocals;
          }
          return Collections.emptySet();
        default:
          return Collections.emptySet();
      }
    }
  };

  public static enum Platform {
    WEB,
    NODE,
    AUTO;

    @Override
    public String toString() {
      return StringUtil.lc(name());
    }

    private static final Set<String> nodejsGlobals =
        new LinkedHashSet<>(Arrays.asList("global", "process", "console", "Buffer"));

    /** Gets the set of predefined globals for this platform. */
    public Set<String> getPredefinedGlobals() {
      return this == NODE ? nodejsGlobals : Collections.emptySet();
    }
  }

  /** How to handle HTML files. */
  public static enum HTMLHandling {
    /** Only extract embedded scripts, not the HTML itself. */
    SCRIPTS(false, false),
    /** Only extract elements and embedded scripts, not text. */
    ELEMENTS(true, false),
    /** Extract elements, embedded scripts, and text. */
    ALL(true, true);

    private final boolean extractElements;

    private final boolean extractText;

    private HTMLHandling(boolean extractElements, boolean extractText) {
      this.extractElements = extractElements;
      this.extractText = extractText;
    }

    public boolean extractElements() {
      return extractElements;
    }

    public boolean extractText() {
      return extractText;
    }

    public boolean extractComments() {
      return extractElements;
    }

    @Override
    public String toString() {
      return StringUtil.lc(name());
    }
  }

  /** Which language version is the source code parsed as? */
  private ECMAVersion ecmaVersion;

  /** Is this code parsed as externs definitions? */
  private boolean externs;

  /** Which {@link Platform} is this code meant to be running on? */
  private Platform platform;

  /** Should Mozilla-specific language extensions be supported? */
  private boolean mozExtensions;

  /** Should JScript language extensions be supported? */
  private boolean jscript;

  /** Should JSX be supported? */
  private boolean jsx;

  /** Should unfinished ECMAScript proposals be supported? */
  private boolean esnext;

  /** Should v8-specific language extensions be supported? */
  private boolean v8Extensions;

  /** Should E4X syntax be supported? */
  private boolean e4x;

  /** Should parse errors be reported as violations instead of aborting extraction? */
  private boolean tolerateParseErrors;

  /** How should HTML files be extracted? */
  private HTMLHandling htmlHandling;

  /**
   * Which {@link FileExtractor.FileType} should this code be parsed as?
   *
   * <p>If this is {@code null}, the file type is inferred from the file extension.
   */
  private String fileType;

  /** Which {@link SourceType} should this code be parsed as? */
  private SourceType sourceType;

  /** Should textual information be extracted into the lines/4 relation? */
  private boolean extractLines;

  /** Should TypeScript files be extracted? */
  private TypeScriptMode typescriptMode;

  /** Override amount of RAM to allocate to the TypeScript compiler. */
  private int typescriptRam;

  /** The default character encoding to use for parsing source files. */
  private String defaultEncoding;

  private VirtualSourceRoot virtualSourceRoot;

  public ExtractorConfig(boolean experimental) {
    this.ecmaVersion = experimental ? ECMAVersion.ECMA2020 : ECMAVersion.ECMA2019;
    this.platform = Platform.AUTO;
    this.jsx = true;
    this.sourceType = SourceType.AUTO;
    this.htmlHandling = HTMLHandling.ELEMENTS;
    this.tolerateParseErrors = true;
    if (experimental) {
      this.mozExtensions = true;
      this.jscript = true;
      this.esnext = true;
      this.v8Extensions = true;
    }
    this.typescriptMode = TypeScriptMode.NONE;
    this.e4x = experimental;
    this.defaultEncoding = StandardCharsets.UTF_8.name();
    this.virtualSourceRoot = VirtualSourceRoot.none;
  }

  public ExtractorConfig(ExtractorConfig that) {
    this.ecmaVersion = that.ecmaVersion;
    this.externs = that.externs;
    this.platform = that.platform;
    this.mozExtensions = that.mozExtensions;
    this.jscript = that.jscript;
    this.jsx = that.jsx;
    this.esnext = that.esnext;
    this.v8Extensions = that.v8Extensions;
    this.e4x = that.e4x;
    this.tolerateParseErrors = that.tolerateParseErrors;
    this.fileType = that.fileType;
    this.sourceType = that.sourceType;
    this.htmlHandling = that.htmlHandling;
    this.extractLines = that.extractLines;
    this.typescriptMode = that.typescriptMode;
    this.typescriptRam = that.typescriptRam;
    this.defaultEncoding = that.defaultEncoding;
    this.virtualSourceRoot = that.virtualSourceRoot;
  }

  public ECMAVersion getEcmaVersion() {
    return ecmaVersion;
  }

  public ExtractorConfig withEcmaVersion(ECMAVersion ecmaVersion) {
    ExtractorConfig res = new ExtractorConfig(this);
    res.ecmaVersion = ecmaVersion;
    return res;
  }

  public boolean isExterns() {
    return externs;
  }

  public ExtractorConfig withExterns(boolean externs) {
    ExtractorConfig res = new ExtractorConfig(this);
    res.externs = externs;
    return res;
  }

  public Platform getPlatform() {
    return platform;
  }

  public ExtractorConfig withPlatform(Platform platform) {
    ExtractorConfig res = new ExtractorConfig(this);
    res.platform = platform;
    return res;
  }

  public boolean isJscript() {
    return jscript;
  }

  public ExtractorConfig withJscript(boolean jscript) {
    ExtractorConfig res = new ExtractorConfig(this);
    res.jscript = jscript;
    return res;
  }

  public boolean isMozExtensions() {
    return mozExtensions;
  }

  public ExtractorConfig withMozExtensions(boolean mozExtensions) {
    ExtractorConfig res = new ExtractorConfig(this);
    res.mozExtensions = mozExtensions;
    return res;
  }

  public boolean isEsnext() {
    return esnext;
  }

  public ExtractorConfig withEsnext(boolean esnext) {
    ExtractorConfig res = new ExtractorConfig(this);
    res.esnext = esnext;
    return res;
  }

  public boolean isV8Extensions() {
    return v8Extensions;
  }

  public ExtractorConfig withV8Extensions(boolean v8Extensions) {
    ExtractorConfig res = new ExtractorConfig(this);
    res.v8Extensions = v8Extensions;
    return res;
  }

  public boolean isE4X() {
    return e4x;
  }

  public ExtractorConfig withE4X(boolean e4x) {
    ExtractorConfig res = new ExtractorConfig(this);
    res.e4x = e4x;
    return res;
  }

  public boolean isTolerateParseErrors() {
    return tolerateParseErrors;
  }

  public ExtractorConfig withTolerateParseErrors(boolean tolerateParseErrors) {
    ExtractorConfig res = new ExtractorConfig(this);
    res.tolerateParseErrors = tolerateParseErrors;
    return res;
  }

  public boolean hasFileType() {
    return fileType != null;
  }

  public String getFileType() {
    return fileType;
  }

  public ExtractorConfig withFileType(String fileType) {
    ExtractorConfig res = new ExtractorConfig(this);
    res.fileType = fileType;
    return res;
  }

  public SourceType getSourceType() {
    return sourceType;
  }

  public ExtractorConfig withSourceType(SourceType sourceType) {
    ExtractorConfig res = new ExtractorConfig(this);
    res.sourceType = sourceType;
    return res;
  }

  public boolean isJsx() {
    return jsx;
  }

  public ExtractorConfig withJsx(boolean jsx) {
    ExtractorConfig res = new ExtractorConfig(this);
    res.jsx = jsx;
    return res;
  }

  public HTMLHandling getHtmlHandling() {
    return htmlHandling;
  }

  public ExtractorConfig withHtmlHandling(HTMLHandling htmlHandling) {
    ExtractorConfig res = new ExtractorConfig(this);
    res.htmlHandling = htmlHandling;
    return res;
  }

  public boolean getExtractLines() {
    return extractLines;
  }

  public ExtractorConfig withExtractLines(boolean extractLines) {
    ExtractorConfig res = new ExtractorConfig(this);
    res.extractLines = extractLines;
    return res;
  }

  public TypeScriptMode getTypeScriptMode() {
    return typescriptMode;
  }

  public int getTypeScriptRam() {
    return typescriptRam;
  }

  public ExtractorConfig withTypeScriptMode(TypeScriptMode typescriptMode) {
    ExtractorConfig res = new ExtractorConfig(this);
    res.typescriptMode = typescriptMode;
    return res;
  }

  public ExtractorConfig withTypeScriptRam(int ram) {
    ExtractorConfig res = new ExtractorConfig(this);
    res.typescriptRam = ram;
    return res;
  }

  public String getDefaultEncoding() {
    return defaultEncoding;
  }

  public ExtractorConfig withDefaultEncoding(String defaultEncoding) {
    ExtractorConfig res = new ExtractorConfig(this);
    try {
      res.defaultEncoding = Charset.forName(defaultEncoding).name();
    } catch (IllegalCharsetNameException | UnsupportedCharsetException e) {
      throw new UserError("Unsupported encoding " + defaultEncoding + ".", e);
    }
    return res;
  }

  public VirtualSourceRoot getVirtualSourceRoot() {
    return virtualSourceRoot;
  }

  public ExtractorConfig withVirtualSourceRoot(VirtualSourceRoot virtualSourceRoot) {
    ExtractorConfig res = new ExtractorConfig(this);
    res.virtualSourceRoot = virtualSourceRoot;
    return res;
  }

  @Override
  public String toString() {
    return "ExtractorConfig [ecmaVersion="
        + ecmaVersion
        + ", externs="
        + externs
        + ", platform="
        + platform
        + ", mozExtensions="
        + mozExtensions
        + ", jscript="
        + jscript
        + ", jsx="
        + jsx
        + ", esnext="
        + esnext
        + ", v8Extensions="
        + v8Extensions
        + ", e4x="
        + e4x
        + ", tolerateParseErrors="
        + tolerateParseErrors
        + ", htmlHandling="
        + htmlHandling
        + ", fileType="
        + fileType
        + ", sourceType="
        + sourceType
        + ", extractLines="
        + extractLines
        + ", typescriptMode="
        + typescriptMode
        + ", defaultEncoding="
        + defaultEncoding
        + ", virtualSourceRoot="
        + virtualSourceRoot
        + "]";
  }
}
