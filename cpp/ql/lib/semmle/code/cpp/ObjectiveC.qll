/**
 * DEPRECATED: Objective-C is no longer supported.
 */

import semmle.code.cpp.Class
private import semmle.code.cpp.internal.ResolveClass

/**
 * DEPRECATED: Objective-C is no longer supported.
 * An Objective C class.
 */
deprecated class ObjectiveClass extends Class {
  ObjectiveClass() { none() }
}

/**
 * DEPRECATED: Objective-C is no longer supported.
 * An Objective C protocol.
 */
deprecated class Protocol extends Class {
  Protocol() { none() }

  /**
   * Holds if the type implements the protocol, either because the type
   * itself does, or because it is a type conforming to the protocol.
   */
  predicate isImplementedBy(Type t) { none() }
}

/**
 * DEPRECATED: Objective-C is no longer supported.
 * A type which conforms to a protocol. Use `getAProtocol` to get a
 * protocol that this type conforms to.
 */
deprecated class TypeConformingToProtocol extends DerivedType {
  TypeConformingToProtocol() { none() }

  /** Gets a protocol that this type conforms to. */
  Protocol getAProtocol() { none() }

  /** Gets the size of this type. */
  override int getSize() { none() }

  override int getAlignment() { none() }
}

/**
 * DEPRECATED: Objective-C is no longer supported.
 * An Objective C `@autoreleasepool` statement, for example
 * `@autoreleasepool { int x; int y; }`.
 */
deprecated class AutoReleasePoolStmt extends Stmt {
  AutoReleasePoolStmt() { none() }

  override string toString() { none() }

  /** Gets the body statement of this `@autoreleasepool` statement. */
  Stmt getStmt() { none() }

  override predicate mayBeImpure() { none() }

  override predicate mayBeGloballyImpure() { none() }
}

/**
 * DEPRECATED: Objective-C is no longer supported.
 * An Objective C `@synchronized statement`, for example
 * `@synchronized (x) { [x complicationOperation]; }`.
 */
deprecated class SynchronizedStmt extends Stmt {
  SynchronizedStmt() { none() }

  override string toString() { none() }

  /** Gets the expression which gives the object to be locked. */
  Expr getLockedObject() { none() }

  /** Gets the body statement of this `@synchronized` statement. */
  Stmt getStmt() { none() }
}

/**
 * DEPRECATED: Objective-C is no longer supported.
 * An Objective C for-in statement.
 */
deprecated class ForInStmt extends Loop {
  ForInStmt() { none() }

  /**
   * Gets the condition expression of the `while` statement that the
   * `for...in` statement desugars into.
   */
  override Expr getCondition() { none() }

  override Expr getControllingExpr() { none() }

  /** Gets the collection that the loop iterates over. */
  Expr getCollection() { none() }

  /** Gets the body of the loop. */
  override Stmt getStmt() { none() }

  override string toString() { none() }
}

/**
 * DEPRECATED: Objective-C is no longer supported.
 * An Objective C category or class extension.
 */
deprecated class Category extends Class {
  Category() { none() }
}

/**
 * DEPRECATED: Objective-C is no longer supported.
 * An Objective C class extension.
 */
deprecated class ClassExtension extends Category {
  ClassExtension() { none() }
}

/**
 * DEPRECATED: Objective-C is no longer supported.
 * An Objective C try statement.
 */
deprecated class ObjcTryStmt extends TryStmt {
  ObjcTryStmt() { none() }

  override string toString() { none() }

  /** Gets the finally clause of this try statement, if any. */
  FinallyBlock getFinallyClause() { none() }
}

/**
 * DEPRECATED: Objective-C is no longer supported.
 * An Objective C `@finally` block.
 */
deprecated class FinallyBlock extends BlockStmt {
  FinallyBlock() { none() }

  /** Gets the try statement corresponding to this finally block. */
  ObjcTryStmt getTryStmt() { none() }
}

/**
 * DEPRECATED: Objective-C is no longer supported.
 * An Objective C `@property`.
 */
deprecated class Property extends Declaration {
  Property() { none() }

  /** Gets the name of this property. */
  override string getName() { none() }

  /**
   * Gets nothing (provided for compatibility with Declaration).
   *
   * For the attribute list following the `@property` keyword, use
   * `getAnAttribute()`.
   */
  override Specifier getASpecifier() { none() }

  /**
   * Gets an attribute of this property (such as `readonly`, `nonatomic`,
   * or `getter=isEnabled`).
   */
  Attribute getAnAttribute() { none() }

  override Location getADeclarationLocation() { result = getLocation() }

  override Location getDefinitionLocation() { result = getLocation() }

  override Location getLocation() { none() }

  /** Gets the type of this property. */
  Type getType() { none() }

  /**
   * Gets the instance method which is called to get the value of this
   * property.
   */
  MemberFunction getGetter() { none() }

  /**
   * Gets the instance method which is called to set the value of this
   * property (if it is a writable property).
   */
  MemberFunction getSetter() { none() }

  /**
   * Gets the instance variable which stores the property value (if this
   * property was explicitly or automatically `@synthesize`d).
   */
  MemberVariable getInstanceVariable() { none() }
}
