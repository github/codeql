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
   * DEPRECATED: Getting the value of _any_ annotation element is error-prone because
   * it could lead to selecting the value of the wrong element by accident (for example
   * when an annotation type is extended in the future). Prefer the predicate `getValue(string)`
   * and explicitly specify the element name. Use `getValue(_)` if it is really desired to
   * get the value of any element.
   *
   * Gets a value of an annotation element. This includes default values in case
   * no explicit value is specified. For elements with an array value type this
   * might have an `ArrayInit` as result. To properly handle array values, prefer
   * the predicate `getAnArrayValue`.
   */
  deprecated Expr getAValue() { filteredAnnotValue(this, _, result) }

  /**
   * Gets the value of the annotation element with the specified `name`.
   * This includes default values in case no explicit value is specified.
   * For elements with an array value type this might have an `ArrayInit` as result.
   * To properly handle array values, prefer the predicate `getAnArrayValue`.
   */
  Expr getValue(string name) { filteredAnnotValue(this, this.getAnnotationElement(name), result) }

  /**
   * If the value type of the annotation element with the specified `name` is an enum type,
   * gets the enum constant used as value for that element. This includes default values in
   * case no explicit value is specified.
   *
   * If the element value type is an enum type array, use `getAnEnumConstantArrayValue`.
   */
  EnumConstant getEnumConstantValue(string name) { result = getValue(name).(FieldRead).getField() }

  /**
   * If the value type of the annotation element with the specified `name` is `String`,
   * gets the string value used for that element. This includes default values in case no
   * explicit value is specified.
   *
   * If the element value type is a string array, use `getAStringArrayValue`.
   */
  string getStringValue(string name) {
    // Uses CompileTimeConstantExpr instead of StringLiteral because value can
    // be read of final variable as well
    result = getValue(name).(CompileTimeConstantExpr).getStringValue()
  }

  /**
   * If the value type of the annotation element with the specified `name` is `int`,
   * gets the int value used for that element. This includes default values in case no
   * explicit value is specified.
   *
   * If the element value type is an `int` array, use `getAnIntArrayValue`.
   */
  int getIntValue(string name) {
    // Uses CompileTimeConstantExpr instead of IntegerLiteral because value can
    // be read of final variable as well
    result = getValue(name).(CompileTimeConstantExpr).getIntValue()
  }

  /**
   * If the value type of the annotation element with the specified `name` is `boolean`,
   * gets the boolean value used for that element. This includes default values in case
   * no explicit value is specified.
   */
  boolean getBooleanValue(string name) {
    // Uses CompileTimeConstantExpr instead of BooleanLiteral because value can
    // be read of final variable as well
    result = getValue(name).(CompileTimeConstantExpr).getBooleanValue()
  }

  /**
   * If the annotation element with the specified `name` has a Java `Class` as value type,
   * gets the referenced type used as value for that element. This includes default values
   * in case no explicit value is specified.
   *
   * If the element value type is a `Class` array, use `getATypeArrayValue`.
   */
  Type getTypeValue(string name) { result = getValue(name).(TypeLiteral).getReferencedType() }

  /** Gets the element being annotated. */
  Element getTarget() { result = this.getAnnotatedElement() }

  override string toString() { result = this.getType().getName() }

  /** This expression's Halstead ID (used to compute Halstead metrics). */
  override string getHalsteadID() { result = "Annotation" }

  /**
   * Gets a value of the annotation element with the specified `name`, which must be declared as an array
   * type. This includes default values in case no explicit value is specified.
   *
   * If the annotation element is defined with an array initializer, then the result will be one of the
   * elements of that array. Otherwise, the result will be the single expression defined for the value.
   */
  Expr getAnArrayValue(string name) { result = getArrayValue(name, _) }

  /**
   * DEPRECATED: Predicate has been renamed to `getAnArrayValue`
   */
  deprecated Expr getAValue(string name) { result = getAnArrayValue(name) }

  /**
   * Gets a value of the annotation element with the specified `name`, which must be declared as an enum
   * type array. This includes default values in case no explicit value is specified.
   *
   * If the annotation element is defined with an array initializer, then the result will be one of the
   * elements of that array. Otherwise, the result will be the single expression defined for the value.
   */
  EnumConstant getAnEnumConstantArrayValue(string name) {
    result = this.getAnArrayValue(name).(FieldRead).getField()
  }

  /**
   * Gets a value of the annotation element with the specified `name`, which must be declared as a string
   * array. This includes default values in case no explicit value is specified.
   *
   * If the annotation element is defined with an array initializer, then the result will be one of the
   * elements of that array. Otherwise, the result will be the single expression defined for the value.
   */
  string getAStringArrayValue(string name) {
    result = this.getAnArrayValue(name).(CompileTimeConstantExpr).getStringValue()
  }

  /**
   * Gets a value of the annotation element with the specified `name`, which must be declared as an `int`
   * array. This includes default values in case no explicit value is specified.
   *
   * If the annotation element is defined with an array initializer, then the result will be one of the
   * elements of that array. Otherwise, the result will be the single expression defined for the value.
   */
  int getAnIntArrayValue(string name) {
    result = this.getAnArrayValue(name).(CompileTimeConstantExpr).getIntValue()
  }

  /**
   * Gets a value of the annotation element with the specified `name`, which must be declared as a `Class`
   * array. This includes default values in case no explicit value is specified.
   *
   * If the annotation element is defined with an array initializer, then the result will be one of the
   * elements of that array. Otherwise, the result will be the single expression defined for the value.
   */
  Type getATypeArrayValue(string name) {
    result = this.getAnArrayValue(name).(TypeLiteral).getReferencedType()
  }

  /**
   * Gets the value at a given index of the annotation element with the specified `name`, which must be
   * declared as an array type. This includes default values in case no explicit value is specified.
   *
   * If the annotation element is defined with an array initializer, then the result will be the element
   * at the given index of that array. Otherwise, the result will be the single expression defined for
   * the value and the `index` will be 0.
   */
  Expr getArrayValue(string name, int index) {
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
  /** Holds if this element has an annotation, including inherited annotations. */
  predicate hasAnnotation() { exists(getAnAnnotation()) }

  /** Holds if this element has a declared annotation, excluding inherited annotations. */
  predicate hasDeclaredAnnotation() { exists(getADeclaredAnnotation()) }

  /**
   * Holds if this element has the specified annotation, including inherited
   * annotations.
   */
  predicate hasAnnotation(string package, string name) {
    exists(AnnotationType at | at = this.getAnAnnotation().getType() |
      at.nestedName() = name and at.getPackage().getName() = package
    )
  }

  /**
   * Gets an annotation that applies to this element, including inherited annotations.
   * The results only include _direct_ annotations; _indirect_ annotations, that is
   * repeated annotations in an (implicit) container annotation, are not included.
   */
  // This predicate is overridden by Class to consider inherited annotations
  cached
  Annotation getAnAnnotation() { result = getADeclaredAnnotation() }

  /**
   * Gets an annotation that is declared on this element, excluding inherited annotations.
   */
  Annotation getADeclaredAnnotation() { result.getAnnotatedElement() = this }

  /** Gets an _indirect_ (= repeated) annotation. */
  // 'indirect' as defined by https://docs.oracle.com/en/java/javase/11/docs/api/java.base/java/lang/reflect/AnnotatedElement.html
  private Annotation getAnIndirectAnnotation() {
    exists(AnnotationType t, Annotation containerAnn |
      t = result.getType() and
      containerAnn = getADeclaredAnnotation() and
      containerAnn.getType() = t.getContainingAnnotationType()
    |
      result = containerAnn.getAnArrayValue("value")
    )
  }

  private Annotation getADeclaredAssociatedAnnotation(AnnotationType t) {
    // Direct or indirect annotation
    result.getType() = t and result = [getADeclaredAnnotation(), getAnIndirectAnnotation()]
  }

  private Annotation getAnAssociatedAnnotation(AnnotationType t) {
    if exists(getADeclaredAssociatedAnnotation(t))
    then result = getADeclaredAssociatedAnnotation(t)
    else (
      // Only if neither a direct nor an indirect annotation is present look for an inherited one
      t.isInherited() and
      // @Inherited only works for classes; cast to Annotatable is necessary because predicate is private
      result = this.(Class).getASupertype().(Class).(Annotatable).getAnAssociatedAnnotation(t)
    )
  }

  /**
   * Gets an annotation _associated_ with this element, that is:
   * - An annotation directly present on this element, or
   * - An annotation indirectly present on this element (in the form of a repeated annotation), or
   * - If an annotation of a type is neither directly nor indirectly present
   *   the result is an associated inherited annotation (recursively)
   */
  // 'associated' as defined by https://docs.oracle.com/en/java/javase/11/docs/api/java.base/java/lang/reflect/AnnotatedElement.html
  Annotation getAnAssociatedAnnotation() { result = getAnAssociatedAnnotation(_) }

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
    getADeclaredAnnotation().getType().hasQualifiedName("java.lang.annotation", "Inherited")
  }

  /** Holds if this annotation type is annotated with the meta-annotation `@Documented`. */
  predicate isDocumented() {
    getADeclaredAnnotation().getType().hasQualifiedName("java.lang.annotation", "Documented")
  }

  /**
   * Gets the retention policy of this annotation type, that is, the name of one of the
   * enum constants of `java.lang.annotation.RetentionPolicy`. If no explicit retention
   * policy is specified the result is `CLASS`.
   */
  string getRetentionPolicy() {
    if getADeclaredAnnotation() instanceof RetentionAnnotation
    then result = getADeclaredAnnotation().(RetentionAnnotation).getRetentionPolicy()
    else
      // If not explicitly specified retention is CLASS
      result = "CLASS"
  }

  /**
   * Holds if the element type is a possible target for this annotation type.
   * The `elementType` is the name of one of the `java.lang.annotation.ElementType`
   * enum constants. If no explicit target is specified for this annotation type
   * it is considered to be applicable to all elements.
   */
  // Note: Cannot use a predicate with string as result because annotation type without
  // explicit @Target can be applied to all targets, requiring to hardcode element types here
  bindingset[elementType]
  predicate isATargetType(string elementType) {
    if getADeclaredAnnotation() instanceof TargetAnnotation
    then elementType = getADeclaredAnnotation().(TargetAnnotation).getATargetElementType()
    else
      // No Target annotation means "applicable to all contexts" since JDK 14, see https://bugs.openjdk.java.net/browse/JDK-8231435
      // The compiler does not completely implement that, but pretend it did
      any()
  }

  /** Holds if this annotation type is annotated with the meta-annotation `@Repeatable`. */
  predicate isRepeatable() { getADeclaredAnnotation() instanceof RepeatableAnnotation }

  /**
   * If this annotation type is annotated with the meta-annotation `@Repeatable`,
   * gets the annotation type which acts as _containing annotation type_.
   */
  AnnotationType getContainingAnnotationType() {
    result = getADeclaredAnnotation().(RepeatableAnnotation).getContainingType()
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
