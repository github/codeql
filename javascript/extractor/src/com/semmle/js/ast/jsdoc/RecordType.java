package com.semmle.js.ast.jsdoc;

import com.semmle.js.ast.SourceLocation;
import java.util.List;

/** A record type. */
public class RecordType extends JSDocTypeExpression {
  private final List<FieldType> fields;

  public RecordType(SourceLocation loc, List<FieldType> fields) {
    super(loc, "RecordType");
    this.fields = fields;
  }

  /** The types of the fields of the record. */
  public List<FieldType> getFields() {
    return fields;
  }

  @Override
  public String pp() {
    StringBuilder result = new StringBuilder("{");
    String sep = "";
    for (JSDocTypeExpression field : fields) {
      result.append(sep);
      result.append(field.pp());
      sep = ", ";
    }
    result.append("}");
    return result.toString();
  }

  @Override
  public void accept(Visitor v) {
    v.visit(this);
  }
}
