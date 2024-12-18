package com.semmle.js.extractor;

import java.util.regex.Pattern;

import com.semmle.util.data.StringUtil;
import com.semmle.util.locations.Position;
import com.semmle.util.trap.TrapWriter.Label;

public class TemplateEngines {
  private static final String MUSTACHE_TAG_TRIPLE = "\\{\\{\\{[~]?(.*?)[~]?\\}\\}\\}"; // {{{ x }}}
  private static final String MUSTACHE_TAG_DOUBLE = "\\{\\{(?!\\{)[~&!=]?(.*?)[~]?\\}\\}"; // {{ x }}}
  private static final String MUSTACHE_TAG_PERCENT = "\\{%(?!>)(.*?)%\\}"; // {% x %}
  private static final String EJS_TAG = "<%(?![%<>}])[-=]?(.*?)[_-]?%>"; // <% x %>

  /** Pattern for a template tag whose contents should be parsed as an expression */
  public static final Pattern TEMPLATE_EXPR_OPENING_TAG =
      Pattern.compile("^(?:\\{\\{[{!]?|<%[-=])"); // {{, {{{, {{!, <%=, <%-

  /**
   * Pattern matching a template tag from a supported template engine.
   */
  public static final Pattern TEMPLATE_TAGS =
      Pattern.compile(
          StringUtil.glue(
              "|", MUSTACHE_TAG_DOUBLE, MUSTACHE_TAG_TRIPLE, MUSTACHE_TAG_PERCENT, EJS_TAG),
          Pattern.DOTALL);

  /**
   * Returns the location label for a template tag at the given offsets.
   */
  public static Label makeLocation(TextualExtractor extractor, int startOffset, int endOffset) {
    Position startPos = extractor.getSourceMap().getStart(startOffset);
    Position endPos = extractor.getSourceMap().getEnd(endOffset - 1);
    int endColumn = endPos.getColumn() - 1; // Convert to inclusive end position (still 1-based)
    return extractor.getLocationManager().emitLocationsDefault(startPos.getLine(), startPos.getColumn(), endPos.getLine(), endColumn);
  }
}
