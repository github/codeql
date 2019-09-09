package com.semmle.js.parser;

import com.semmle.js.ast.Comment;
import com.semmle.js.ast.Node;
import com.semmle.js.ast.Token;
import com.semmle.js.extractor.ExtractionMetrics;
import com.semmle.js.extractor.ExtractionMetrics.ExtractionPhase;
import com.semmle.js.extractor.ExtractorConfig;
import com.semmle.js.extractor.ExtractorConfig.SourceType;
import java.util.List;

/** Helper class for invoking the underlying JavaScript parser. */
public class JSParser {
  /**
   * The result of a parse.
   *
   * <p>If the parse was successful, {@link #ast} will be non-null. Otherwise, {@link #errors} holds
   * a list of parse errors encountered.
   */
  public static class Result {
    /** The parsed source code. */
    private final String source;

    /** The root of the parsed AST. */
    private final Node ast;

    /** The list of parsed tokens. */
    private final List<Token> tokens;

    /** The list of parsed comments. */
    private final List<Comment> comments;

    /** The list of parser errors encountered while parsing. */
    private final List<ParseError> errors;

    public Result(
        String source,
        Node ast,
        List<Token> tokens,
        List<Comment> comments,
        List<ParseError> errors) {
      this.source = source;
      this.ast = ast;
      this.tokens = tokens;
      this.comments = comments;
      this.errors = errors;
    }

    public Node getAST() {
      return ast;
    }

    public String getSource() {
      return source;
    }

    public List<Comment> getComments() {
      return comments;
    }

    public List<Token> getTokens() {
      return tokens;
    }

    public List<ParseError> getErrors() {
      return errors;
    }
  }

  public static Result parse(
      ExtractorConfig config, SourceType sourceType, String source, ExtractionMetrics metrics) {
    metrics.startPhase(ExtractionPhase.JSParser_parse);
    Result result = JcornWrapper.parse(config, sourceType, source);
    metrics.stopPhase(ExtractionPhase.JSParser_parse);
    return result;
  }
}
