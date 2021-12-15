import python

class KeyValuePair extends KeyValuePair_, DictDisplayItem {
  /* syntax: Expr : Expr */
  override Location getLocation() { result = KeyValuePair_.super.getLocation() }

  override string toString() { result = KeyValuePair_.super.toString() }

  /** Gets the value of this dictionary unpacking. */
  override Expr getValue() { result = KeyValuePair_.super.getValue() }

  override Scope getScope() { result = this.getValue().getScope() }

  override AstNode getAChildNode() {
    result = this.getKey()
    or
    result = this.getValue()
  }
}

/** A double-starred expression in a call or dict literal. */
class DictUnpacking extends DictUnpacking_, DictUnpackingOrKeyword, DictDisplayItem {
  override Location getLocation() { result = DictUnpacking_.super.getLocation() }

  override string toString() { result = DictUnpacking_.super.toString() }

  /** Gets the value of this dictionary unpacking. */
  override Expr getValue() { result = DictUnpacking_.super.getValue() }

  override Scope getScope() { result = this.getValue().getScope() }

  override AstNode getAChildNode() { result = this.getValue() }
}

abstract class DictUnpackingOrKeyword extends DictItem {
  abstract Expr getValue();

  override string toString() { result = "DictUnpackingOrKeyword with missing toString" }
}

abstract class DictDisplayItem extends DictItem {
  abstract Expr getValue();

  override string toString() { result = "DictDisplayItem with missing toString" }
}

/** A keyword argument in a call. For example `arg=expr` in `foo(0, arg=expr)` */
class Keyword extends Keyword_, DictUnpackingOrKeyword {
  /* syntax: name = Expr */
  override Location getLocation() { result = Keyword_.super.getLocation() }

  override string toString() { result = Keyword_.super.toString() }

  /** Gets the value of this keyword argument. */
  override Expr getValue() { result = Keyword_.super.getValue() }

  override Scope getScope() { result = this.getValue().getScope() }

  override AstNode getAChildNode() { result = this.getValue() }
}
