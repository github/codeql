package com.semmle.js.parser;

import java.util.ArrayList;
import java.util.List;

import com.semmle.jcorn.Options;
import com.semmle.jcorn.SyntaxError;
import com.semmle.jcorn.jsx.JSXOptions;
import com.semmle.js.ast.Comment;
import com.semmle.js.ast.Program;
import com.semmle.js.ast.Token;
import com.semmle.js.extractor.ExtractorConfig;
import com.semmle.js.extractor.ExtractorConfig.ECMAVersion;
import com.semmle.js.extractor.ExtractorConfig.SourceType;

public class JcornWrapper {
  public static boolean alwaysParseWithJsx(String extension) {
    // Note that .tsx is not relevant here since this is specifically for the JS parser.
    return extension.equals(".jsx");
  }

  /** Parse source code as a program. */
  public static JSParser.Result parse(
      ExtractorConfig config, SourceType sourceType, String extension, String source) {
    ECMAVersion ecmaVersion = config.getEcmaVersion();
    List<Comment> comments = new ArrayList<>();
    List<Token> tokens = new ArrayList<>();
    Options options =
        new Options()
            .ecmaVersion(ecmaVersion.legacyVersion)
            .sourceType(sourceType.toString())
            .onComment(comments)
            .onToken(tokens)
            .preserveParens(true)
            .allowReturnOutsideFunction(true);
    if (config.isEsnext()) options.esnext(true);

    Program program = null;
    List<ParseError> errors = new ArrayList<>();

    // If the file extension implies JSX syntax, use that in the first parsing attempt.
    // This enables us to parse JSX files that the Flow parser cannot handle due to ambiguous syntax.
    if (alwaysParseWithJsx(extension)) options = new JSXOptions(options);

    try {
      try {
        // First try to parse as a regular JavaScript program.
        program = sourceType.createParser(options, source, 0).parse();
      } catch (SyntaxError e) {
        // If that fails, try to enable all the extensions that we support.
        if (config.isTolerateParseErrors())
          options.onRecoverableError((err) -> errors.add(mkParseError(err)));
        comments.clear();
        tokens.clear();
        if (config.isMozExtensions()) options.mozExtensions(true);
        if (config.isJscript()) options.jscript(true);
        if (config.isJsx()) options = new JSXOptions(options);
        if (config.isV8Extensions()) options.v8Extensions(true);
        if (config.isE4X()) options.e4x(true);
        if (config.isEsnext()) options.allowFlowTypes(true); // allow the flow-parser to parse types.
        program = sourceType.createParser(options, source, 0).parse();
      }
    } catch (SyntaxError e) {
      errors.add(mkParseError(e));
    }
    return new JSParser.Result(source, program, tokens, comments, errors);
  }

  private static ParseError mkParseError(SyntaxError e) {
    return new ParseError(e.getMessage(), e.getPosition());
  }
}
