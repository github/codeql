package com.semmle.js.extractor;

import java.util.LinkedHashMap;
import java.util.Map;

import com.semmle.js.ast.Node;
import com.semmle.js.ast.Position;
import com.semmle.js.ast.SourceElement;
import com.semmle.js.ast.regexp.BackReference;
import com.semmle.js.ast.regexp.Caret;
import com.semmle.js.ast.regexp.CharacterClass;
import com.semmle.js.ast.regexp.CharacterClassEscape;
import com.semmle.js.ast.regexp.CharacterClassRange;
import com.semmle.js.ast.regexp.Constant;
import com.semmle.js.ast.regexp.ControlEscape;
import com.semmle.js.ast.regexp.ControlLetter;
import com.semmle.js.ast.regexp.DecimalEscape;
import com.semmle.js.ast.regexp.Disjunction;
import com.semmle.js.ast.regexp.Dollar;
import com.semmle.js.ast.regexp.Dot;
import com.semmle.js.ast.regexp.Error;
import com.semmle.js.ast.regexp.Group;
import com.semmle.js.ast.regexp.HexEscapeSequence;
import com.semmle.js.ast.regexp.IdentityEscape;
import com.semmle.js.ast.regexp.Literal;
import com.semmle.js.ast.regexp.NamedBackReference;
import com.semmle.js.ast.regexp.NonWordBoundary;
import com.semmle.js.ast.regexp.OctalEscape;
import com.semmle.js.ast.regexp.Opt;
import com.semmle.js.ast.regexp.Plus;
import com.semmle.js.ast.regexp.Quantifier;
import com.semmle.js.ast.regexp.Range;
import com.semmle.js.ast.regexp.RegExpTerm;
import com.semmle.js.ast.regexp.Sequence;
import com.semmle.js.ast.regexp.Star;
import com.semmle.js.ast.regexp.UnicodeEscapeSequence;
import com.semmle.js.ast.regexp.UnicodePropertyEscape;
import com.semmle.js.ast.regexp.Visitor;
import com.semmle.js.ast.regexp.WordBoundary;
import com.semmle.js.ast.regexp.ZeroWidthNegativeLookahead;
import com.semmle.js.ast.regexp.ZeroWidthNegativeLookbehind;
import com.semmle.js.ast.regexp.ZeroWidthPositiveLookahead;
import com.semmle.js.ast.regexp.ZeroWidthPositiveLookbehind;
import com.semmle.js.parser.RegExpParser;
import com.semmle.js.parser.RegExpParser.Result;
import com.semmle.util.locations.SourceMap;
import com.semmle.util.trap.TrapWriter;
import com.semmle.util.trap.TrapWriter.Label;

/** Extractor for populating regular expressions. */
public class RegExpExtractor {
  private final TrapWriter trapwriter;
  private final LocationManager locationManager;
  private final RegExpParser parser = new RegExpParser();
  private SourceMap sourceMap;

  public RegExpExtractor(TrapWriter trapwriter, LocationManager locationManager) {
    this.trapwriter = trapwriter;
    this.locationManager = locationManager;
  }

  private static final Map<String, Integer> termkinds = new LinkedHashMap<String, Integer>();

  static {
    termkinds.put("Disjunction", 0);
    termkinds.put("Sequence", 1);
    termkinds.put("Caret", 2);
    termkinds.put("Dollar", 3);
    termkinds.put("WordBoundary", 4);
    termkinds.put("NonWordBoundary", 5);
    termkinds.put("ZeroWidthPositiveLookahead", 6);
    termkinds.put("ZeroWidthNegativeLookahead", 7);
    termkinds.put("Star", 8);
    termkinds.put("Plus", 9);
    termkinds.put("Opt", 10);
    termkinds.put("Range", 11);
    termkinds.put("Dot", 12);
    termkinds.put("Group", 13);
    termkinds.put("Constant", 14);
    termkinds.put("HexEscapeSequence", 15);
    termkinds.put("UnicodeEscapeSequence", 16);
    termkinds.put("DecimalEscape", 17);
    termkinds.put("OctalEscape", 18);
    termkinds.put("ControlEscape", 19);
    termkinds.put("ControlLetter", 19); // not a typo; these two are merged in the database
    termkinds.put("CharacterClassEscape", 20);
    termkinds.put("IdentityEscape", 21);
    termkinds.put("BackReference", 22);
    termkinds.put("CharacterClass", 23);
    termkinds.put("CharacterClassRange", 24);
    termkinds.put("NamedBackReference", 22); // merged with BackReference in the database
    termkinds.put("ZeroWidthPositiveLookbehind", 25);
    termkinds.put("ZeroWidthNegativeLookbehind", 26);
    termkinds.put("UnicodePropertyEscape", 27);
  }

  private static final String[] errmsgs =
      new String[] {
        "unexpected end of regular expression",
        "unexpected character",
        "expected digit",
        "expected hexadecimal digit",
        "expected control letter",
        "expected ')'",
        "expected '}'",
        "trailing characters",
        "octal escape sequence",
        "invalid back reference",
        "expected ']'",
        "expected identifier",
        "expected '>'"
      };

  private Label extractTerm(RegExpTerm term, Label parent, int idx) {
    Label lbl = trapwriter.localID(term);
    int kind = termkinds.get(term.getType());
    String srctext = term.getLoc().getSource();
    this.trapwriter.addTuple("regexpterm", lbl, kind, parent, idx, srctext);
    emitLocation(term, lbl);
    return lbl;
  }

  public void emitLocation(SourceElement term, Label lbl) {
    int start = term.getLoc().getStart().getColumn();
    int sl = sourceMap.getStart(start).getLine();
    int sc = sourceMap.getStart(start).getColumn();
    int end = term.getLoc().getEnd().getColumn();
    int el = sourceMap.getStart(end).getLine();
    int ec = sourceMap.getStart(end).getColumn() - 1; // convert to inclusive
    locationManager.emitSnippetLocation(lbl, sl, sc, el, ec);
  }


  private class V implements Visitor {
    private Label parent;
    private int idx;

    private void visit(RegExpTerm child, Label parent, int idx) {
      Label oldParent = this.parent;
      int oldIdx = this.idx;

      this.parent = parent;
      this.idx = idx;

      child.accept(this);

      this.parent = oldParent;
      this.idx = oldIdx;
    }

    @Override
    public void visit(BackReference nd) {
      Label lbl = extractTerm(nd, parent, idx);
      if (inRange(nd.getValue())) trapwriter.addTuple("backref", lbl, nd.getValue());
    }

    @Override
    public void visit(NamedBackReference nd) {
      Label lbl = extractTerm(nd, parent, idx);
      trapwriter.addTuple("named_backref", lbl, nd.getName());
    }

    @Override
    public void visit(Caret nd) {
      extractTerm(nd, parent, idx);
    }

    @Override
    public void visit(Dot nd) {
      extractTerm(nd, parent, idx);
    }

    @Override
    public void visit(Constant nd) {
      visit((Literal) nd);
    }

    @Override
    public void visit(Dollar nd) {
      extractTerm(nd, parent, idx);
    }

    @Override
    public void visit(Group nd) {
      Label lbl = extractTerm(nd, parent, idx);
      if (nd.isCapture()) trapwriter.addTuple("is_capture", lbl, nd.getNumber());
      if (nd.isNamed()) trapwriter.addTuple("is_named_capture", lbl, nd.getName());
      visit(nd.getOperand(), lbl, 0);
    }

    @Override
    public void visit(ZeroWidthPositiveLookahead nd) {
      Label lbl = extractTerm(nd, parent, idx);
      visit(nd.getOperand(), lbl, 0);
    }

    @Override
    public void visit(ZeroWidthNegativeLookahead nd) {
      Label lbl = extractTerm(nd, parent, idx);
      visit(nd.getOperand(), lbl, 0);
    }

    @Override
    public void visit(ZeroWidthPositiveLookbehind nd) {
      Label lbl = extractTerm(nd, parent, idx);
      visit(nd.getOperand(), lbl, 0);
    }

    @Override
    public void visit(ZeroWidthNegativeLookbehind nd) {
      Label lbl = extractTerm(nd, parent, idx);
      visit(nd.getOperand(), lbl, 0);
    }

    @Override
    public void visit(NonWordBoundary nd) {
      extractTerm(nd, parent, idx);
    }

    private void visit(Quantifier nd) {
      Label lbl = extractTerm(nd, parent, idx);
      if (nd.isGreedy()) trapwriter.addTuple("is_greedy", lbl);
      visit(nd.getOperand(), lbl, 0);
    }

    @Override
    public void visit(Opt nd) {
      visit((Quantifier) nd);
    }

    @Override
    public void visit(Plus nd) {
      visit((Quantifier) nd);
    }

    private boolean inRange(long l) {
      return 0 <= l && l <= Integer.MAX_VALUE;
    }

    @Override
    public void visit(Range nd) {
      Label lbl = extractTerm(nd, parent, idx);
      if (nd.isGreedy()) trapwriter.addTuple("is_greedy", lbl);

      long lo = nd.getLowerBound();
      if (inRange(lo)) trapwriter.addTuple("range_quantifier_lower_bound", lbl, lo);

      if (nd.hasUpperBound()) {
        long hi = nd.getUpperBound();
        if (inRange(hi)) trapwriter.addTuple("range_quantifier_upper_bound", lbl, hi);
      }

      this.visit(nd.getOperand(), lbl, 0);
    }

    @Override
    public void visit(Sequence nd) {
      Label lbl = extractTerm(nd, parent, idx);
      int i = 0;
      for (RegExpTerm element : nd.getElements()) visit(element, lbl, i++);
    }

    @Override
    public void visit(Disjunction nd) {
      Label lbl = extractTerm(nd, parent, idx);
      int i = 0;
      for (RegExpTerm element : nd.getDisjuncts()) visit(element, lbl, i++);
    }

    @Override
    public void visit(Star nd) {
      visit((Quantifier) nd);
    }

    @Override
    public void visit(WordBoundary nd) {
      extractTerm(nd, parent, idx);
    }

    @Override
    public void visit(CharacterClassEscape nd) {
      Label lbl = extractTerm(nd, parent, idx);
      trapwriter.addTuple("char_class_escape", lbl, nd.getClassIdentifier());
    }

    @Override
    public void visit(UnicodePropertyEscape nd) {
      Label lbl = extractTerm(nd, parent, idx);
      trapwriter.addTuple("unicode_property_escapename", lbl, nd.getName());
      if (nd.hasValue()) trapwriter.addTuple("unicode_property_escapevalue", lbl, nd.getValue());
    }

    @Override
    public void visit(DecimalEscape nd) {
      visit((Literal) nd);
    }

    private void visit(Literal nd) {
      Label lbl = extractTerm(nd, parent, idx);
      trapwriter.addTuple("regexp_const_value", lbl, nd.getValue());
    }

    @Override
    public void visit(HexEscapeSequence nd) {
      visit((Literal) nd);
    }

    @Override
    public void visit(OctalEscape nd) {
      visit((Literal) nd);
    }

    @Override
    public void visit(UnicodeEscapeSequence nd) {
      visit((Literal) nd);
    }

    @Override
    public void visit(ControlEscape nd) {
      visit((Literal) nd);
    }

    @Override
    public void visit(ControlLetter nd) {
      visit((Literal) nd);
    }

    @Override
    public void visit(IdentityEscape nd) {
      visit((Literal) nd);
    }

    @Override
    public void visit(CharacterClass nd) {
      Label lbl = extractTerm(nd, parent, idx);
      if (nd.isInverted()) trapwriter.addTuple("is_inverted", lbl);
      int i = 0;
      for (RegExpTerm element : nd.getElements()) visit(element, lbl, i++);
    }

    @Override
    public void visit(CharacterClassRange nd) {
      Label lbl = extractTerm(nd, parent, idx);
      visit(nd.getLeft(), lbl, 0);
      visit(nd.getRight(), lbl, 1);
    }
  }

  public void extract(String src, SourceMap sourceMap, Node parent, boolean isSpeculativeParsing) {
    Result res = parser.parse(src);
    if (isSpeculativeParsing && res.getErrors().size() > 0) {
      return;
    }

    this.sourceMap = sourceMap;
    RegExpTerm ast = res.getAST();
    new V().visit(ast, trapwriter.localID(parent), 0);

    Label rootLbl = trapwriter.localID(ast);
    for (Error err : res.getErrors()) {
      Label lbl = this.trapwriter.freshLabel();
      String msg = errmsgs[err.getCode()];
      this.trapwriter.addTuple("regexp_parse_errors", lbl, rootLbl, msg);
      this.emitLocation(err, lbl);
    }
  }
}
