package com.semmle.js.extractor;

import java.util.ArrayList;
import java.util.Collections;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.semmle.js.ast.Comment;
import com.semmle.js.ast.Node;
import com.semmle.js.ast.Token;
import com.semmle.js.extractor.ExtractionMetrics.ExtractionPhase;
import com.semmle.js.extractor.ExtractorConfig.ECMAVersion;
import com.semmle.js.extractor.ExtractorConfig.Platform;
import com.semmle.js.extractor.ExtractorConfig.SourceType;
import com.semmle.js.parser.JSParser;
import com.semmle.js.parser.ParseError;
import com.semmle.util.data.Pair;
import com.semmle.util.exception.Exceptions;
import com.semmle.util.exception.UserError;
import com.semmle.util.trap.TrapWriter;
import com.semmle.util.trap.TrapWriter.Label;
import com.semmle.js.extractor.ParseResultInfo;

/**
 * Extractor for populating JavaScript source code, including AST information, lexical information
 * about comments and tokens, textual information about lines, control flow graphs, and JSDoc
 * comments.
 */
public class JSExtractor {
  private final ExtractorConfig config;

  public JSExtractor(ExtractorConfig config) {
    this.config = config;
  }

  // heuristic: if `import`, `export`, or `goog.module` appears at the beginning of a line, it's
  // probably a module
  private static final Pattern containsModuleIndicator =
      Pattern.compile("(?m)^([ \t]*)(import|export|goog\\.module)\\b");

  public Pair<Label, ParseResultInfo> extract(
      TextualExtractor textualExtractor, String source, TopLevelKind toplevelKind, ScopeManager scopeManager)
      throws ParseError {
    // if the file starts with `{ "<string>":` it won't parse as JavaScript; try parsing as JSON
    // instead
    if (FileExtractor.JSON_OBJECT_START.matcher(textualExtractor.getSource()).matches()) {
      try {
        ParseResultInfo loc =
            new JSONExtractor(config.withTolerateParseErrors(false)).extract(textualExtractor);
        return Pair.make(null, loc);
      } catch (UserError ue) {
        // didn't work, so parse as JavaScript (and fail)
        Exceptions.ignore(ue, "Try parsing as JavaScript instead.");
      }
    }

    SourceType sourceType = establishSourceType(source, true);

    JSParser.Result parserRes =
        JSParser.parse(config, sourceType, source, textualExtractor.getMetrics());

    // Check if we guessed wrong with the regex in `establishSourceType`, (which could
    // happen due to a block-comment line starting with '  import').
    if (config.getSourceType() == SourceType.AUTO && sourceType != SourceType.SCRIPT) {
      boolean wrongGuess = false;

      if (sourceType == SourceType.MODULE) {
        // check that we did see an import/export declaration
        wrongGuess = ES2015Detector.looksLikeES2015(parserRes.getAST()) == false;
      } else if (sourceType == SourceType.CLOSURE_MODULE ) {
        // TODO
      }

      if (wrongGuess) {
        sourceType = SourceType.SCRIPT;
        parserRes =
          JSParser.parse(config, sourceType, source, textualExtractor.getMetrics());
      }
    }

    return extract(textualExtractor, source, toplevelKind, scopeManager, sourceType, parserRes);
  }

  /**
   * Determine the {@link SourceType} of {@code source}.
   *
   * <p>If the configuration specifies as explicit source type, we use that. Otherwise, for
   * ECMAScript 2015 and greater we check for lines starting with {@code import} or {@code export},
   * and if we find any we assume it's a module. For plain JavaScript, we allow leading whitespace
   * before the {@code import}/ {@code export}, but not for TypeScript, to avoid getting confused by
   * namespace exports.
   *
   * <p>If all else fails, we go with {@link SourceType#SCRIPT}.
   */
  public SourceType establishSourceType(String source, boolean allowLeadingWS) {
    SourceType sourceType = config.getSourceType();
    if (sourceType != SourceType.AUTO) return sourceType;
    if (config.getEcmaVersion().compareTo(ECMAVersion.ECMA2015) >= 0) {
      Matcher m = containsModuleIndicator.matcher(source);
      if (m.find() && (allowLeadingWS || m.group(1).isEmpty())) {
        return m.group(2).startsWith("goog") ? SourceType.CLOSURE_MODULE : SourceType.MODULE;
      }
    }
    return SourceType.SCRIPT;
  }

  public Pair<Label, ParseResultInfo> extract(
      TextualExtractor textualExtractor,
      String source,
      TopLevelKind toplevelKind,
      ScopeManager scopeManager,
      SourceType sourceType,
      JSParser.Result parserRes)
      throws ParseError {
    textualExtractor.getMetrics().startPhase(ExtractionPhase.JSExtractor_extract);
    Label toplevelLabel;
    TrapWriter trapwriter = textualExtractor.getTrapwriter();
    LocationManager locationManager = textualExtractor.getLocationManager();
    Platform platform = config.getPlatform();
    Node ast = parserRes.getAST();
    LexicalExtractor lexicalExtractor;
    ParseResultInfo loc;
    if (ast != null) {
      platform = getPlatform(platform, ast);
      if (sourceType == SourceType.SCRIPT && platform == Platform.NODE) {
        sourceType = SourceType.COMMONJS_MODULE;
      }

      lexicalExtractor =
          new LexicalExtractor(textualExtractor, parserRes.getTokens(), parserRes.getComments());
      ASTExtractor scriptExtractor = new ASTExtractor(config, lexicalExtractor, scopeManager);
      toplevelLabel = scriptExtractor.getToplevelLabel();
      lexicalExtractor.extractComments(toplevelLabel);
      loc = lexicalExtractor.extractLines(parserRes.getSource(), toplevelLabel);
      lexicalExtractor.extractTokens(toplevelLabel);
      new JSDocExtractor(textualExtractor).extract(lexicalExtractor.getComments());
      lexicalExtractor.purge();

      parserRes.getErrors().addAll(scriptExtractor.extract(ast, platform, sourceType, toplevelKind));
      new CFGExtractor(scriptExtractor).extract(ast);
    } else {
      lexicalExtractor =
          new LexicalExtractor(textualExtractor, new ArrayList<Token>(), new ArrayList<Comment>());
      ASTExtractor scriptExtractor = new ASTExtractor(config, lexicalExtractor, null);
      toplevelLabel = scriptExtractor.getToplevelLabel();

      trapwriter.addTuple("toplevels", toplevelLabel, toplevelKind.getValue());
      locationManager.emitSnippetLocation(toplevelLabel, 1, 1, 1, 1);
      loc = new ParseResultInfo(0, 0, Collections.emptyList());
    }

    loc.addParseErrors(parserRes.getErrors());
    for (ParseError parseError : parserRes.getErrors()) {
      if (!config.isTolerateParseErrors()) throw parseError;
      Label key = trapwriter.freshLabel();
      String errorLine = textualExtractor.getLine(parseError.getPosition().getLine());
      trapwriter.addTuple("js_parse_errors", key, toplevelLabel, "Error: " + parseError, errorLine);
      locationManager.emitErrorLocation(
          key, parseError.getPosition(), textualExtractor.getNumLines());
      lexicalExtractor.extractLines(source, toplevelLabel);
    }

    if (config.isExterns()) textualExtractor.getTrapwriter().addTuple("is_externs", toplevelLabel);
    if (platform == Platform.NODE && sourceType == SourceType.COMMONJS_MODULE)
      textualExtractor.getTrapwriter().addTuple("is_nodejs", toplevelLabel);

    textualExtractor.getMetrics().stopPhase(ExtractionPhase.JSExtractor_extract);

    return Pair.make(toplevelLabel, loc);
  }

  private Platform getPlatform(Platform platform, Node ast) {
    if (platform == Platform.AUTO)
      return NodeJSDetector.looksLikeNodeJS(ast) ? Platform.NODE : Platform.WEB;

    return platform;
  }
}
