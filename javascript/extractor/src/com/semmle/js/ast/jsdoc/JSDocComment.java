package com.semmle.js.ast.jsdoc;

import com.semmle.js.ast.Comment;
import java.util.List;

/** A JSDoc comment. */
public class JSDocComment extends JSDocElement {
  private final Comment comment;
  private final String description;
  private final List<JSDocTag> tags;

  public JSDocComment(Comment comment, String description, List<JSDocTag> tags) {
    super(comment.getLoc());
    this.comment = comment;
    this.description = description;
    this.tags = tags;
  }

  @Override
  public void accept(Visitor v) {
    v.visit(this);
  }

  /** The underlying comment. */
  public Comment getComment() {
    return comment;
  }

  /** The description string of this JSDoc comment. */
  public String getDescription() {
    return description;
  }

  /** The block tags in this JSDoc comment. */
  public List<JSDocTag> getTags() {
    return tags;
  }
}
