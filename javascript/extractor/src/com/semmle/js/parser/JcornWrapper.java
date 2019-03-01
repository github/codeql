package com.semmle.js.parser;

import com.semmle.jcorn.CustomParser;
import com.semmle.jcorn.Options;
import com.semmle.jcorn.SyntaxError;
import com.semmle.jcorn.jsx.JSXOptions;
import com.semmle.js.ast.Comment;
import com.semmle.js.ast.Program;
import com.semmle.js.ast.Token;
import com.semmle.js.extractor.ExtractorConfig;
import com.semmle.js.extractor.ExtractorConfig.ECMAVersion;
import com.semmle.js.extractor.ExtractorConfig.SourceType;
import java.util.ArrayList;
import java.util.List;

public class JcornWrapper {
  /** Parse source code as a program. */
  public static JSParser.Result parse(
      ExtractorConfig config, SourceType sourceType, String source) {
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
    if (config.isMozExtensions()) options.mozExtensions(true);
    if (config.isJscript()) options.jscript(true);
    if (config.isJsx()) options = new JSXOptions(options);
    if (config.isEsnext()) options.esnext(true);
    if (config.isV8Extensions()) options.v8Extensions(true);
    if (config.isE4X()) options.e4x(true);

    Program program = null;
    List<ParseError> errors = new ArrayList<>();
    try {
      if (config.isTolerateParseErrors())
        options.onRecoverableError((err) -> errors.add(mkParseError(err)));

      program = new CustomParser(options, source, 0).parse();
    } catch (SyntaxError e) {
      errors.add(mkParseError(e));
    }
    return new JSParser.Result(source, program, tokens, comments, errors);
  }

  private static ParseError mkParseError(SyntaxError e) {
    return new ParseError(e.getMessage(), e.getPosition());
  }
}
