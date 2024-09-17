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
  override AnnotationType getType() {
    result = Expr.super.getType().(Interface).getSourceDeclaration()
  }

  /** Gets the annotation element with the specified `name`. */
  AnnotationElement getAnnotationElement(string name) {
    result = this.getType().getAnnotationElement(name)
  }

  /**
   * Gets the value of the annotation element with the specified `name`.
   * This includes default values in case no explicit value is specified.
   * For elements with an array value type this might get an `ArrayInit` instance.
   * To properly handle array values, prefer the predicate `getAnArrayValue`.
   */
  Expr getValue(string name) { filteredAnnotValue(this, this.getAnnotationElement(name), result) }

  /**
   * Gets the value of the annotation element, if its type is not an array.
   * This guarantees that for consistency even elements of type array with a
   * single value have no result, to prevent accidental error-prone usage.
   */
  private Expr getNonArrayValue(string name) {
    result = this.getValue(name) and
    not this.getAnnotationElement(name).getType() instanceof Array
  }

  /**
   * If the value type of the annotation element with the specified `name` is an enum type,
   * gets the enum constant used as value for that element. This includes default values in
   * case no explicit value is specified.
   *
   * If the element value type is an enum type array, use `getAnEnumConstantArrayValue`.
   */
  EnumConstant getEnumConstantValue(string name) {
    result = this.getNonArrayValue(name).(FieldRead).getField()
  }

  /**
   * If the value type of the annotation element with the specified `name` is `String`,
   * gets the string value used for that element. This includes default values in case no
   * explicit value is specified.
   *
   * If the element value type is a string array, use `getAStringArrayValue`.
   */
  string getStringValue(string name) {
    // Uses CompileTimeConstantExpr instead of StringLiteral because this can for example
    // be a read from a final variable as well.
    result = this.getNonArrayValue(name).(CompileTimeConstantExpr).getStringValue()
  }

  /**
   * If the value type of the annotation element with the specified `name` is `int` or
   * a smaller integral type or `char`, gets the int value used for that element.
   * This includes default values in case no explicit value is specified.
   *
   * If the element value type is an `int` array or an array of a smaller integral
   * type or `char`, use `getAnIntArrayValue`.
   */
  int getIntValue(string name) {
    // Uses CompileTimeConstantExpr instead of IntegerLiteral because this can for example
    // be a read from a final variable as well.
    result = this.getNonArrayValue(name).(CompileTimeConstantExpr).getIntValue() and
    // Verify that type is integral; ignore floating point elements with IntegerLiteral as value
    this.getAnnotationElement(name).getType().hasName(["byte", "short", "int", "char"])
  }

  /**
   * If the value type of the annotation element with the specified `name` is `boolean`,
   * gets the boolean value used for that element. This includes default values in case
   * no explicit value is specified.
   */
  boolean getBooleanValue(string name) {
    // Uses CompileTimeConstantExpr instead of BooleanLiteral because this can for example
    // be a read from a final variable as well.
    result = this.getNonArrayValue(name).(CompileTimeConstantExpr).getBooleanValue()
  }

  /**
   * If the value type of the annotation element with the specified `name` is `java.lang.Class`,
   * gets the type referred to by that `Class`. This includes default values in case no explicit
   * value is specified.
   *
   * If the element value type is a `Class` array, use `getATypeArrayValue`.
   */
  Type getTypeValue(string name) {
    result = this.getNonArrayValue(name).(TypeLiteral).getReferencedType()
  }

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
   * elements of that array. Otherwise, the result will be the single expression used as value.
   */
  Expr getAnArrayValue(string name) { result = this.getArrayValue(name, _) }

  /**
   * Gets a value of the annotation element with the specified `name`, which must be declared as an enum
   * type array. This includes default values in case no explicit value is specified.
   *
   * If the annotation element is defined with an array initializer, then the result will be one of the
   * elements of that array. Otherwise, the result will be the single expression used as value.
   */
  EnumConstant getAnEnumConstantArrayValue(string name) {
    result = this.getAnArrayValue(name).(FieldRead).getField()
  }

  /**
   * Gets a value of the annotation element with the specified `name`, which must be declared as a string
   * array. This includes default values in case no explicit value is specified.
   *
   * If the annotation element is defined with an array initializer, then the result will be one of the
   * elements of that array. Otherwise, the result will be the single expression used as value.
   */
  string getAStringArrayValue(string name) {
    result = this.getAnArrayValue(name).(CompileTimeConstantExpr).getStringValue()
  }

  /**
   * Gets a value of the annotation element with the specified `name`, which must be declared as an `int`
   * array or an array of a smaller integral type or `char`. This includes default values in case no
   * explicit value is specified.
   *
   * If the annotation element is defined with an array initializer, then the result will be one of the
   * elements of that array. Otherwise, the result will be the single expression used as value.
   */
  int getAnIntArrayValue(string name) {
    result = this.getAnArrayValue(name).(CompileTimeConstantExpr).getIntValue() and
    // Verify that type is integral; ignore floating point elements with IntegerLiteral as value
    this.getAnnotationElement(name).getType().hasName(["byte[]", "short[]", "int[]", "char[]"])
  }

  /**
   * Gets a value of the annotation element with the specified `name`, which must be declared as a `Class`
   * array. This includes default values in case no explicit value is specified.
   *
   * If the annotation element is defined with an array initializer, then the result will be one of the
   * elements of that array. Otherwise, the result will be the single expression used as value.
   */
  Type getATypeArrayValue(string name) {
    result = this.getAnArrayValue(name).(TypeLiteral).getReferencedType()
  }

  /**
   * Gets the value at a given index of the annotation element with the specified `name`, which must be
   * declared as an array type. This includes default values in case no explicit value is specified.
   *
   * If the annotation element is defined with an array initializer, then the result will be the element
   * at the given index of that array, starting at 0. Otherwise, the result will be the single expression
   * defined for the value and the `index` will be 0.
   */
  Expr getArrayValue(string name, int index) {
    this.getType().getAnnotationElement(name).getType() instanceof Array and
    exists(Expr value | value = this.getValue(name) |
      if value instanceof ArrayInit
      then
        // TODO: Currently reports incorrect index values in some cases, see https://github.com/github/codeql/issues/8645
        result = value.(ArrayInit).getInit(index)
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
  val.getFile().isSourceFile()
}

/** An abstract representation of language elements that can be annotated. */
class Annotatable extends Element {
  /**
   * Holds if this element has an annotation, including inherited annotations.
   * The retention policy of the annotation type is not considered.
   */
  predicate hasAnnotation() { exists(this.getAnAnnotation()) }

  /**
   * Holds if this element has a declared annotation, excluding inherited annotations.
   * The retention policy of the annotation type is not considered.
   */
  predicate hasDeclaredAnnotation() { exists(this.getADeclaredAnnotation()) }

  /**
   * Holds if this element has the specified annotation, including inherited
   * annotations. The retention policy of the annotation type is not considered.
   */
  predicate hasAnnotation(string package, string name) {
    exists(AnnotationType at | at = this.getAnAnnotation().getType() |
      at.getNestedName() = name and at.getPackage().getName() = package
    )
  }

  /**
   * Gets an annotation that applies to this element, including inherited annotations.
   * The results only include _direct_ annotations; _indirect_ annotations, that is
   * repeated annotations in an (implicit) container annotation, are not included.
   * The retention policy of the annotation type is not considered.
   */
  cached
  Annotation getAnAnnotation() {
    // This predicate is overridden by Class to consider inherited annotations
    result = this.getADeclaredAnnotation()
  }

  /**
   * Gets an annotation that is declared on this element, excluding inherited annotations.
   * The retention policy of the annotation type is not considered.
   */
  Annotation getADeclaredAnnotation() { result.getAnnotatedElement() = this }

  /** Gets an _indirect_ (= repeated) annotation. */
  private Annotation getAnIndirectAnnotation() {
    // 'indirect' as defined by https://docs.oracle.com/en/java/javase/11/docs/api/java.base/java/lang/reflect/AnnotatedElement.html
    exists(AnnotationType t, Annotation containerAnn |
      t = result.getType() and
      containerAnn = this.getADeclaredAnnotation() and
      containerAnn.getType() = t.getContainingAnnotationType()
    |
      result = containerAnn.getAnArrayValue("value")
    )
  }

  private Annotation getADeclaredAssociatedAnnotation(AnnotationType t) {
    // Direct or indirect annotation
    result.getType() = t and
    result = [this.getADeclaredAnnotation(), this.getAnIndirectAnnotation()]
  }

  private Annotation getAnAssociatedAnnotation(AnnotationType t) {
    // 'associated' as defined by https://docs.oracle.com/en/java/javase/11/docs/api/java.base/java/lang/reflect/AnnotatedElement.html
    if exists(this.getADeclaredAssociatedAnnotation(t))
    then result = this.getADeclaredAssociatedAnnotation(t)
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
   *
   * The retention policy of the annotation type is not considered.
   */
  Annotation getAnAssociatedAnnotation() { result = this.getAnAssociatedAnnotation(_) }

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
    this.(LocalClassOrInterface)
        .getLocalTypeDeclStmt()
        .getEnclosingCallable()
        .suppressesWarningsAbout(category)
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
    this.getADeclaredAnnotation().getType().hasQualifiedName("java.lang.annotation", "Inherited")
  }

  /** Holds if this annotation type is annotated with the meta-annotation `@Documented`. */
  predicate isDocumented() {
    this.getADeclaredAnnotation().getType().hasQualifiedName("java.lang.annotation", "Documented")
  }

  /**
   * Gets the retention policy of this annotation type, that is, the name of one of the
   * enum constants of `java.lang.annotation.RetentionPolicy`. If this annotation type
   * has no `@Retention` annotation, the result is `CLASS`.
   */
  string getRetentionPolicy() {
    if this.getADeclaredAnnotation() instanceof RetentionAnnotation
    then result = this.getADeclaredAnnotation().(RetentionAnnotation).getRetentionPolicy()
    else
      // If not explicitly specified retention is CLASS
      result = "CLASS"
  }

  /**
   * Holds if the element type is a possible target for this annotation type.
   * The `elementType` is the name of one of the `java.lang.annotation.ElementType`
   * enum constants.
   *
   * If this annotation type has no `@Target` annotation, it is considered to be applicable
   * in all declaration contexts. This matches the behavior of the latest Java versions
   * but differs from the behavior of older Java versions. This predicate must only be
   * called with names of `ElementType` enum constants; for other values it might hold
   * erroneously.
   */
  bindingset[elementType]
  predicate isATargetType(string elementType) {
    /*
     * Note: Cannot use a predicate with string as result because annotation type without
     * explicit @Target can be applied in all declaration contexts, requiring to hardcode
     * element types here; then the results could become outdated if this predicate is not
     * updated for future JDK versions, or it could have irritating results, e.g. RECORD_COMPONENT
     * for a database created for Java 8.
     *
     * Could in theory read java.lang.annotation.ElementType constants from database, but might
     * be brittle in case ElementType is not present in the database for whatever reason.
     */

    if this.getADeclaredAnnotation() instanceof TargetAnnotation
    then elementType = this.getADeclaredAnnotation().(TargetAnnotation).getATargetElementType()
    else
      /*
       * Behavior for missing @Target annotation changed between Java versions. In older Java
       * versions it allowed usage in most (but not all) declaration contexts. Then for Java 14
       * JDK-8231435 changed it to allow usage in all declaration and type contexts. In Java 17
       * it was changed by JDK-8261610 to only allow usage in all declaration contexts, but not
       * in type contexts anymore. However, during these changes javac did not always comply with
       * the specification, see for example JDK-8254023.
       *
       * For simplicity pretend the latest behavior defined by the JLS applied in all versions;
       * that means any declaration context is allowed, but type contexts (represented by TYPE_USE,
       * see JLS 17 section 9.6.4.1) are not allowed.
       */

      elementType != "TYPE_USE"
  }

  /** Holds if this annotation type is annotated with the meta-annotation `@Repeatable`. */
  predicate isRepeatable() { this.getADeclaredAnnotation() instanceof RepeatableAnnotation }

  /**
   * If this annotation type is annotated with the meta-annotation `@Repeatable`,
   * gets the annotation type which acts as _containing annotation type_.
   */
  AnnotationType getContainingAnnotationType() {
    result = this.getADeclaredAnnotation().(RepeatableAnnotation).getContainingType()
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
