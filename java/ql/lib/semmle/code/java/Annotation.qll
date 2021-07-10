/**
 * Provides classes and predicates for working with Java annotations.
 *
 * Annotations are used to add meta-information to language elements in a
 * uniform fashion. They can be seen as typed modifiers that can take
 * parameters.
 *
 * Each annotation type has zero or more annotation elements that contain a
 * name and possibly a value.
 */

import Element
import Expr
import Type
import Member
import JDKAnnotations

/** Any annotation used to annotate language elements with meta-information. */
class Annotation extends @annotation, Expr {
  /** Holds if this annotation applies to a declaration. */
  predicate isDeclAnnotation() { this instanceof DeclAnnotation }

  /** Holds if this annotation applies to a type. */
  predicate isTypeAnnotation() { this instanceof TypeAnnotation }

  /** Gets the element being annotated. */
  Element getAnnotatedElement() {
    exists(Element e | e = this.getParent() |
      if e.(Field).getCompilationUnit().fromSource()
      then
        exists(FieldDeclaration decl |
          decl.getField(0) = e and
          result = decl.getAField()
        )
      else result = e
    )
  }

  /** Gets the annotation type declaration for this annotation. */
  override AnnotationType getType() { result = Expr.super.getType() }

  /** Gets the annotation element with the specified `name`. */
  AnnotationElement getAnnotationElement(string name) {
    result = this.getType().getAnnotationElement(name)
  }

  /**
   * Gets a value of an annotation element. This includes default values in case
   * no explicit value is specified.
   */
  Expr getAValue() { filteredAnnotValue(this, _, result) }

  /**
   * Gets the value of the annotation element with the specified `name`.
   * This includes default values in case no explicit value is specified.
   */
  Expr getValue(string name) { filteredAnnotValue(this, this.getAnnotationElement(name), result) }

  /**
   * If the value type of the annotation element with the specified `name` is an enum type,
   * gets the enum constant used as value for that element. This includes default values in
   * case no explicit value is specified.
   */
  EnumConstant getValueEnumConstant(string name) { result = getValue(name).(FieldRead).getField() }

  /**
   * If the value type of the annotation element with the specified `name` is `String`,
   * gets the string value used for that element. This includes default values in case no
   * explicit value is specified.
   */
  string getValueString(string name) {
    // Uses CompileTimeConstantExpr instead of StringLiteral because value can
    // be read of final variable as well
    result = getValue(name).(CompileTimeConstantExpr).getStringValue()
  }

  /**
   * If the value type of the annotation element with the specified `name` is `int`,
   * gets the int value used for that element. This includes default values in case no
   * explicit value is specified.
   */
  int getValueInt(string name) {
    // Uses CompileTimeConstantExpr instead of IntegerLiteral because value can
    // be read of final variable as well
    result = getValue(name).(CompileTimeConstantExpr).getIntValue()
  }

  /**
   * If the value type of the annotation element with the specified `name` is `boolean`,
   * gets the boolean value used for that element. This includes default values in case
   * no explicit value is specified.
   */
  boolean getValueBoolean(string name) {
    // Uses CompileTimeConstantExpr instead of BooleanLiteral because value can
    // be read of final variable as well
    result = getValue(name).(CompileTimeConstantExpr).getBooleanValue()
  }

  /**
   * If the annotation element with the specified `name` has a Java `Class` as value type,
   * gets the referenced type used as value for that element. This includes default values
   * in case no explicit value is specified.
   */
  Type getValueClass(string name) { result = getValue(name).(TypeLiteral).getReferencedType() }

  /** Gets the element being annotated. */
  Element getTarget() { result = this.getAnnotatedElement() }

  override string toString() { result = this.getType().getName() }

  /** This expression's Halstead ID (used to compute Halstead metrics). */
  override string getHalsteadID() { result = "Annotation" }

  /**
   * Gets a value of the annotation element with the specified `name`, which must be declared as an array
   * type. This includes default values in case no explicit value is specified.
   *
   * If the annotation element is defined with an array initializer, then the returned value will
   * be one of the elements of that array. Otherwise, the returned value will be the single
   * expression defined for the value.
   */
  Expr getAValue(string name) { result = getAValue(name, _) }

  /**
   * Gets the value at a given index of the annotation element with the specified `name`, which must be
   * declared as an array type. This includes default values in case no explicit value is specified.
   *
   * If the annotation element is defined with an array initializer, then the returned value will
   * be the elements at the given index of that array. Otherwise, if the index is 0 the returned value
   * will be the single expression defined for the value.
   */
  Expr getAValue(string name, int index) {
    this.getType().getAnnotationElement(name).getType() instanceof Array and
    exists(Expr value | value = this.getValue(name) |
      if value instanceof ArrayInit
      then result = value.(ArrayInit).getInit(index)
      else (
        index = 0 and result = value
      )
    )
  }

  override string getAPrimaryQlClass() { result = "Annotation" }
}

/** An `Annotation` that applies to a declaration. */
class DeclAnnotation extends @declannotation, Annotation { }

/** An `Annotation` that applies to a type. */
class TypeAnnotation extends @typeannotation, Annotation { }

/**
 * There may be duplicate entries in annotValue(...) - one entry for
 * information populated from bytecode, and one for information populated
 * from source. This removes the duplication.
 */
private predicate filteredAnnotValue(Annotation a, Method m, Expr val) {
  annotValue(a, m, val) and
  (sourceAnnotValue(a, m, val) or not sourceAnnotValue(a, m, _))
}

private predicate sourceAnnotValue(Annotation a, Method m, Expr val) {
  annotValue(a, m, val) and
  val.getFile().getExtension() = "java"
}

/** An abstract representation of language elements that can be annotated. */
class Annotatable extends Element {
  /** Holds if this element has an annotation. */
  predicate hasAnnotation() { exists(Annotation a | a.getAnnotatedElement() = this) }

  /** Holds if this element has the specified annotation. */
  predicate hasAnnotation(string package, string name) {
    exists(AnnotationType at | at = this.getAnAnnotation().getType() |
      at.nestedName() = name and at.getPackage().getName() = package
    )
  }

  /** Gets an annotation that applies to this element. */
  cached
  Annotation getAnAnnotation() { result.getAnnotatedElement() = this }

  /**
   * Holds if this or any enclosing `Annotatable` has a `@SuppressWarnings("<category>")`
   * annotation attached to it for the specified `category`.
   */
  predicate suppressesWarningsAbout(string category) {
    category = this.getAnAnnotation().(SuppressWarningsAnnotation).getASuppressedWarning()
    or
    this.(Member).getDeclaringType().suppressesWarningsAbout(category)
    or
    this.(Expr).getEnclosingCallable().suppressesWarningsAbout(category)
    or
    this.(Stmt).getEnclosingCallable().suppressesWarningsAbout(category)
    or
    this.(NestedClass).getEnclosingType().suppressesWarningsAbout(category)
    or
    this.(LocalVariableDecl).getCallable().suppressesWarningsAbout(category)
  }
}

/** An annotation type is a special kind of interface type declaration. */
class AnnotationType extends Interface {
  AnnotationType() { isAnnotType(this) }

  /** Gets the annotation element with the specified `name`. */
  AnnotationElement getAnnotationElement(string name) {
    methods(result, _, _, _, this, _) and result.hasName(name)
  }

  /** Gets an annotation element that is a member of this annotation type. */
  AnnotationElement getAnAnnotationElement() { methods(result, _, _, _, this, _) }

  /** Holds if this annotation type is annotated with the meta-annotation `@Inherited`. */
  predicate isInherited() {
    exists(Annotation ann |
      ann.getAnnotatedElement() = this and
      ann.getType().hasQualifiedName("java.lang.annotation", "Inherited")
    )
  }
}

/** An annotation element is a member declared in an annotation type. */
class AnnotationElement extends Member {
  AnnotationElement() { isAnnotElem(this) }

  /** Gets the type of this annotation element. */
  Type getType() { methods(this, _, _, result, _, _) }

  /** Gets the Kotlin type of this annotation element. */
  KotlinType getKotlinType() { methodsKotlinType(this, result) }
}
