package com.semmle.js.extractor;

import com.semmle.js.ast.Comment;
import com.semmle.js.ast.Position;
import com.semmle.js.ast.SourceElement;
import com.semmle.js.ast.Token;
import com.semmle.js.extractor.ExtractionMetrics.ExtractionPhase;
import com.semmle.util.trap.TrapWriter;
import com.semmle.util.trap.TrapWriter.Label;
import java.util.List;

/**
 * Extractor for populating lexical information about a JavaScript file, including comments and
 * tokens.
 */
public class LexicalExtractor {
  private final TextualExtractor textualExtractor;
  private final TrapWriter trapwriter;
  private final LocationManager locationManager;
  private final List<Token> tokens;
  private final List<Comment> comments;

  public LexicalExtractor(
      TextualExtractor textualExtractor, List<Token> tokens, List<Comment> comments) {
    this.textualExtractor = textualExtractor;
    this.trapwriter = textualExtractor.getTrapwriter();
    this.locationManager = textualExtractor.getLocationManager();
    this.tokens = tokens;
    this.comments = comments;
  }

  public TrapWriter getTrapwriter() {
    return trapwriter;
  }

  public LocationManager getLocationManager() {
    return locationManager;
  }

  public List<Comment> getComments() {
    return comments;
  }

  public ExtractionMetrics getMetrics() {
    return textualExtractor.getMetrics();
  }

  public LoCInfo extractLines(String src, Label toplevelKey) {
    textualExtractor.getMetrics().startPhase(ExtractionPhase.LexicalExtractor_extractLines);
    Position end = textualExtractor.extractLines(src, toplevelKey);
    LoCInfo info = emitNumlines(toplevelKey, new Position(1, 0, 0), end);
    textualExtractor.getMetrics().stopPhase(ExtractionPhase.LexicalExtractor_extractLines);
    return info;
  }

  /**
   * Emit line number information for an entity.
   *
   * @param key the entity key
   * @param start the start position of the node
   * @param end the end position of the node
   */
  public LoCInfo emitNumlines(Label key, Position start, Position end) {
    int num_code = 0, num_comment = 0, num_lines = end.getLine() - start.getLine() + 1;

    if (tokens != null && comments != null) {
      // every line on which there is a (non-EOF) token counts as a line of code
      int maxline = 0; // maximum line number on which we've seen a token so far
      for (int i = findNode(tokens, start), m = tokens.size(); i < m; ++i) {
        Token token = tokens.get(i);
        if (token.getLoc().getStart().compareTo(end) >= 0 || token.getType() == Token.Type.EOF)
          break;
        for (int j = token.getLoc().getStart().getLine(), n = token.getLoc().getEnd().getLine();
            j <= n;
            ++j) {
          if (j > maxline) {
            // token covers a new line, so increment count and update maxline
            maxline = j;
            ++num_code;
          }
        }
      }

      // every line on which there is a comment counts as a line of comment
      maxline = 0; // maximum line number on which we've seen a comment so far
      for (int i = findNode(comments, start), m = comments.size(); i < m; ++i) {
        Comment comment = comments.get(i);
        if (comment.getLoc().getStart().compareTo(end) >= 0) break;
        for (int j = comment.getLoc().getStart().getLine(), n = comment.getLoc().getEnd().getLine();
            j <= n;
            ++j) {
          if (j > maxline) {
            // comment covers a new line, so increment count and update maxline
            maxline = j;
            ++num_comment;
          }
        }
      }
    }

    trapwriter.addTuple("numlines", key, num_lines, num_code, num_comment);
    return new LoCInfo(num_code, num_comment);
  }

  private <T extends SourceElement> int findNode(List<T> ts, Position start) {
    int lo = 0, hi = ts.size(), mid;

    /**
     * Invariant: forall i in [0..lo), ts[i] starts before `start` and forall i in [hi..ts.size()),
     * ts[i] starts at or after `start`
     */
    while (lo < hi) {
      // other parts of the extractor will break long before this could overflow
      mid = (lo + hi) >>> 1;
      if (ts.get(mid).getLoc().getStart().compareTo(start) >= 0) hi = mid;
      else lo = mid + 1;
    }

    return hi;
  }

  public void extractTokens(Label toplevelKey) {
    textualExtractor.getMetrics().startPhase(ExtractionPhase.LexicalExtractor_extractTokens);
    int j = 0;
    for (int i = 0, n = tokens.size(), idx = 0; i < n; ++i) {
      Token token = tokens.get(i);
      if (token == null) continue;
      Label key = trapwriter.freshLabel();
      int kind = -1;
      switch (token.getType()) {
        case EOF:
          kind = 0;
          break;
        case NULL:
          kind = 1;
          break;
        case FALSE:
        case TRUE:
          kind = 2;
          break;
        case NUM:
          kind = 3;
          break;
        case STRING:
          kind = 4;
          break;
        case REGEXP:
          kind = 5;
          break;
        case NAME:
          kind = 6;
          break;
        case KEYWORD:
          kind = 7;
          break;
        case PUNCTUATOR:
          kind = 8;
          break;
      }
      trapwriter.addTuple("tokeninfo", key, kind, toplevelKey, idx++, token.getValue());
      locationManager.emitNodeLocation(token, key);

      // fill in next_token relation
      while (j < comments.size()
          && comments.get(j).getLoc().getEnd().compareTo(token.getLoc().getStart()) <= 0)
        trapwriter.addTuple("next_token", this.trapwriter.localID(comments.get(j++)), key);

      // the parser sometimes duplicates tokens; skip the second one by nulling it out
      if (i + 1 < n) {
        Token next = tokens.get(i + 1);
        // every token has a unique location
        if (token.getLoc().equals(next.getLoc())) tokens.set(i + 1, null);
      }
    }
    textualExtractor.getMetrics().stopPhase(ExtractionPhase.LexicalExtractor_extractTokens);
  }

  public void extractComments(Label toplevelKey) {
    for (Comment comment : comments) {
      Label key = this.trapwriter.localID(comment);
      String text = comment.getText();
      int kind = -1;
      switch (comment.getKind()) {
        case LINE:
          kind = 0;
          break;
        case HTML_START:
          kind = 3;
          break;
        case HTML_END:
          kind = 4;
          break;
        case BLOCK:
          if (comment.isDocComment()) {
            kind = 2;
            text = text.substring(1);
          } else {
            kind = 1;
          }
          break;
      }
      String tostring = mkToString(comment);
      this.trapwriter.addTuple("comments", key, kind, toplevelKey, text, tostring);
      this.locationManager.emitNodeLocation(comment, key);
    }
  }

  public String mkToString(SourceElement nd) {
    return textualExtractor.mkToString(nd);
  }

  /** Purge token and comments information to reduce heap pressure. */
  public void purge() {
    this.tokens.clear();
    this.comments.clear();
  }
}
