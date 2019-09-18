package com.semmle.js.extractor;

import com.semmle.js.ast.Comment;
import com.semmle.js.ast.jsdoc.AllLiteral;
import com.semmle.js.ast.jsdoc.ArrayType;
import com.semmle.js.ast.jsdoc.FieldType;
import com.semmle.js.ast.jsdoc.FunctionType;
import com.semmle.js.ast.jsdoc.JSDocComment;
import com.semmle.js.ast.jsdoc.JSDocElement;
import com.semmle.js.ast.jsdoc.JSDocTag;
import com.semmle.js.ast.jsdoc.JSDocTypeExpression;
import com.semmle.js.ast.jsdoc.NameExpression;
import com.semmle.js.ast.jsdoc.NonNullableType;
import com.semmle.js.ast.jsdoc.NullLiteral;
import com.semmle.js.ast.jsdoc.NullableLiteral;
import com.semmle.js.ast.jsdoc.NullableType;
import com.semmle.js.ast.jsdoc.OptionalType;
import com.semmle.js.ast.jsdoc.ParameterType;
import com.semmle.js.ast.jsdoc.RecordType;
import com.semmle.js.ast.jsdoc.RestType;
import com.semmle.js.ast.jsdoc.TypeApplication;
import com.semmle.js.ast.jsdoc.UnaryTypeConstructor;
import com.semmle.js.ast.jsdoc.UndefinedLiteral;
import com.semmle.js.ast.jsdoc.UnionType;
import com.semmle.js.ast.jsdoc.Visitor;
import com.semmle.js.ast.jsdoc.VoidLiteral;
import com.semmle.js.parser.JSDocParser;
import com.semmle.util.trap.TrapWriter;
import com.semmle.util.trap.TrapWriter.Label;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/** Extractor for populating JSDoc comments. */
public class JSDocExtractor {
  private static final Map<String, Integer> jsdocTypeExprKinds =
      new LinkedHashMap<String, Integer>();

  static {
    jsdocTypeExprKinds.put("AllLiteral", 0);
    jsdocTypeExprKinds.put("NullLiteral", 1);
    jsdocTypeExprKinds.put("UndefinedLiteral", 2);
    jsdocTypeExprKinds.put("NullableLiteral", 3);
    jsdocTypeExprKinds.put("VoidLiteral", 4);
    jsdocTypeExprKinds.put("NameExpression", 5);
    jsdocTypeExprKinds.put("TypeApplication", 6);
    jsdocTypeExprKinds.put("NullableType", 7);
    jsdocTypeExprKinds.put("NonNullableType", 8);
    jsdocTypeExprKinds.put("RecordType", 9);
    jsdocTypeExprKinds.put("ArrayType", 10);
    jsdocTypeExprKinds.put("UnionType", 11);
    jsdocTypeExprKinds.put("FunctionType", 12);
    jsdocTypeExprKinds.put("OptionalType", 13);
    jsdocTypeExprKinds.put("RestType", 14);
  }

  private final TrapWriter trapwriter;
  private final LocationManager locationManager;

  public JSDocExtractor(TextualExtractor textualExtractor) {
    this.trapwriter = textualExtractor.getTrapwriter();
    this.locationManager = textualExtractor.getLocationManager();
  }

  private class V implements Visitor {
    private Label parent;
    private int idx;

    private Label visit(JSDocTypeExpression nd) {
      Label key = trapwriter.localID(nd);
      int kind = jsdocTypeExprKinds.get(nd.getType());
      trapwriter.addTuple("jsdoc_type_exprs", key, kind, parent, idx, nd.pp());
      locationManager.emitNodeLocation(nd, key);
      return key;
    }

    public void visit(Label parent, List<? extends JSDocElement> nds) {
      Label oldParent = this.parent;
      int oldIdx = this.idx;

      this.parent = parent;
      this.idx = 0;

      for (JSDocElement element : nds) {
        element.accept(this);
        ++this.idx;
      }

      this.parent = oldParent;
      this.idx = oldIdx;
    }

    public void visit(JSDocElement child, Label parent, int idx) {
      if (child == null) return;

      Label oldParent = this.parent;
      int oldIdx = this.idx;

      this.parent = parent;
      this.idx = idx;
      child.accept(this);

      this.parent = oldParent;
      this.idx = oldIdx;
    }

    @Override
    public void visit(AllLiteral nd) {
      visit((JSDocTypeExpression) nd);
    }

    @Override
    public void visit(FieldType nd) {
      trapwriter.addTuple("jsdoc_record_field_name", parent, idx, nd.getKey());
      if (nd.hasValue()) visit(nd.getValue(), parent, idx);
    }

    @Override
    public void visit(RecordType nd) {
      Label label = visit((JSDocTypeExpression) nd);
      visit(label, nd.getFields());
    }

    @Override
    public void visit(NameExpression nd) {
      visit((JSDocTypeExpression) nd);
    }

    @Override
    public void visit(NullableLiteral nd) {
      visit((JSDocTypeExpression) nd);
    }

    @Override
    public void visit(NullLiteral nd) {
      visit((JSDocTypeExpression) nd);
    }

    @Override
    public void visit(UndefinedLiteral nd) {
      visit((JSDocTypeExpression) nd);
    }

    @Override
    public void visit(VoidLiteral nd) {
      visit((JSDocTypeExpression) nd);
    }

    @Override
    public void visit(JSDocComment nd) {
      Label commentLabel = trapwriter.localID(nd.getComment());
      Label jsdocLabel = trapwriter.freshLabel();
      trapwriter.addTuple("jsdoc", jsdocLabel, nd.getDescription(), commentLabel);
      locationManager.emitNodeLocation(nd, jsdocLabel);
      visit(jsdocLabel, nd.getTags());
    }

    @Override
    public void visit(JSDocTag nd) {
      Label label = trapwriter.localID(nd);
      trapwriter.addTuple("jsdoc_tags", label, nd.getTitle(), parent, idx, "@" + nd.getTitle());
      locationManager.emitNodeLocation(nd, label);

      if (nd.hasDescription() && !nd.getDescription().isEmpty())
        trapwriter.addTuple("jsdoc_tag_descriptions", label, nd.getDescription());
      if (nd.hasName()) trapwriter.addTuple("jsdoc_tag_names", label, nd.getName());
      visit(nd.getType(), label, 0);

      for (String msg : nd.getErrors())
        trapwriter.addTuple(
            "jsdoc_errors",
            trapwriter.freshLabel(),
            label,
            msg,
            TextualExtractor.sanitiseToString(msg));
    }

    @Override
    public void visit(UnionType nd) {
      Label label = visit((JSDocTypeExpression) nd);
      List<JSDocTypeExpression> elements = nd.getElements();
      visit(label, elements);
    }

    @Override
    public void visit(ArrayType nd) {
      Label label = visit((JSDocTypeExpression) nd);
      List<JSDocTypeExpression> elements = nd.getElements();
      visit(label, elements);
    }

    @Override
    public void visit(TypeApplication nd) {
      Label label = visit((JSDocTypeExpression) nd);
      visit(nd.getExpression(), label, -1);
      visit(label, nd.getApplications());
    }

    @Override
    public void visit(FunctionType nd) {
      Label label = visit((JSDocTypeExpression) nd);
      visit(label, nd.getParams());
      visit(nd.getResult(), label, -1);
      visit(nd.getThis(), label, -2);
      if (nd.isNew()) trapwriter.addTuple("jsdoc_has_new_parameter", label);
    }

    @Override
    public void visit(ParameterType nd) {
      visit(nd.getExpression(), parent, idx);
    }

    private void visit(UnaryTypeConstructor nd) {
      Label label = visit((JSDocTypeExpression) nd);
      visit(nd.getExpression(), label, 0);
      if (!(nd instanceof RestType) && nd.isPrefix())
        trapwriter.addTuple("jsdoc_prefix_qualifier", label);
    }

    @Override
    public void visit(NonNullableType nd) {
      visit((UnaryTypeConstructor) nd);
    }

    @Override
    public void visit(NullableType nd) {
      visit((UnaryTypeConstructor) nd);
    }

    @Override
    public void visit(OptionalType nd) {
      visit((UnaryTypeConstructor) nd);
    }

    @Override
    public void visit(RestType nd) {
      visit((UnaryTypeConstructor) nd);
    }
  }

  public void extract(List<Comment> comments) {
    JSDocParser jsdocParser = new JSDocParser();

    for (Comment comment : comments) {
      if (comment.isDocComment()) {
        JSDocComment docComment = jsdocParser.parse(comment);
        docComment.accept(new V());
      }
    }
  }
}
