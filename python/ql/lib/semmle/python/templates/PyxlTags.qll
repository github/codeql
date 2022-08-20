import python

/**
 * A Tag in Pyxl (which gets converted to a call in Python).
 */
class PyxlTag extends Call {
  PyxlTag() { pyxl_tag(this, _) }

  string getPyxlTagName() { pyxl_tag(this, result) }

  /** Gets the pyxl or Python node that is enclosed by this one in the pyxl source */
  Expr getEnclosedNode() { none() }

  /** Gets the Python code (if any) that is contained in this pyxl node */
  Expr getEnclosedPythonCode() {
    result = this.getEnclosedNode() and not result instanceof PyxlTag
    or
    result = this.getEnclosedNode().(PyxlTag).getEnclosedPythonCode()
  }
}

private predicate pyxl_tag(Call c, string name) {
  exists(Attribute tag, Name html |
    tag = c.getFunc() and
    html = tag.getObject() and
    name = tag.getName() and
    html.getId() = "html"
  )
}

class PyxlHtmlTag extends PyxlTag {
  PyxlHtmlTag() { this.getPyxlTagName().matches("x\\_%") }

  string getTagName() { result = this.getPyxlTagName().suffix(2) }

  /** Html tags get transformed into a call. This node is the callee function and the enclosed node is an argument. */
  override Expr getEnclosedNode() {
    exists(Call c |
      c.getFunc() = this and
      result = c.getAnArg()
    )
  }
}

class PyxlIfTag extends PyxlTag {
  PyxlIfTag() { this.getPyxlTagName() = "_push_condition" }

  override Expr getEnclosedNode() { result = this.getAnArg() }
}

class PyxlEndIfTag extends PyxlTag {
  PyxlEndIfTag() { this.getPyxlTagName() = "_leave_if" }

  override Expr getEnclosedNode() { result = this.getAnArg() }
}

class PyxlRawHtml extends PyxlTag {
  PyxlRawHtml() { this.getPyxlTagName() = "rawhtml" }

  /** Gets the text for this raw html, if it is simple text. */
  string getText() {
    exists(Unicode text |
      text = this.getValue() and
      result = text.getS()
    )
  }

  Expr getValue() { result = this.getArg(0) }

  override Expr getEnclosedNode() { result = this.getAnArg() }
}
