/**
 * Provides classes for properties, indexers, and accessors.
 */

import Member
import Stmt
import Type
private import cil
private import dotnet
private import semmle.code.csharp.ExprOrStmtParent
private import TypeRef

/**
 * A declaration that may have accessors. Either an event (`Event`), a property
 * (`Property`), or an indexer (`Indexer`).
 */
class DeclarationWithAccessors extends AssignableMember, Virtualizable, Attributable,
  @declaration_with_accessors {
  /** Gets an accessor of this declaration. */
  Accessor getAnAccessor() { result.getDeclaration() = this }

  override DeclarationWithAccessors getOverridee() { result = Virtualizable.super.getOverridee() }

  override DeclarationWithAccessors getAnOverrider() {
    result = Virtualizable.super.getAnOverrider()
  }

  override DeclarationWithAccessors getImplementee() {
    result = Virtualizable.super.getImplementee()
  }

  override DeclarationWithAccessors getAnImplementor() {
    result = Virtualizable.super.getAnImplementor()
  }

  override DeclarationWithAccessors getAnUltimateImplementee() {
    result = Virtualizable.super.getAnUltimateImplementee()
  }

  override DeclarationWithAccessors getAnUltimateImplementor() {
    result = Virtualizable.super.getAnUltimateImplementor()
  }

  override Type getType() { none() }

  override string toString() { result = AssignableMember.super.toString() }
}

/**
 * A declaration that may have a `get` accessor and a `set` accessor. Either a
 * property (`Property`) or an indexer (`Indexer`).
 */
class DeclarationWithGetSetAccessors extends DeclarationWithAccessors, TopLevelExprParent,
  @assignable_with_accessors {
  /** Gets the `get` accessor of this declaration, if any. */
  Getter getGetter() { result = this.getAnAccessor() }

  /** Gets the `set` accessor of this declaration, if any. */
  Setter getSetter() { result = this.getAnAccessor() }

  override DeclarationWithGetSetAccessors getOverridee() {
    result = DeclarationWithAccessors.super.getOverridee()
  }

  override DeclarationWithGetSetAccessors getAnOverrider() {
    result = DeclarationWithAccessors.super.getAnOverrider()
  }

  override DeclarationWithGetSetAccessors getImplementee() {
    result = DeclarationWithAccessors.super.getImplementee()
  }

  override DeclarationWithGetSetAccessors getAnImplementor() {
    result = DeclarationWithAccessors.super.getAnImplementor()
  }

  override DeclarationWithGetSetAccessors getAnUltimateImplementee() {
    result = DeclarationWithAccessors.super.getAnUltimateImplementee()
  }

  override DeclarationWithGetSetAccessors getAnUltimateImplementor() {
    result = DeclarationWithAccessors.super.getAnUltimateImplementor()
  }

  /** Holds if this declaration is read-only. */
  predicate isReadOnly() {
    exists(this.getOverridee*().getGetter()) and
    not exists(this.getOverridee*().getSetter())
  }

  /** Holds if this declaration is write-only. */
  predicate isWriteOnly() {
    exists(this.getOverridee*().getSetter()) and
    not exists(this.getOverridee*().getGetter())
  }

  /** Holds if this declaration is read-write. */
  predicate isReadWrite() {
    exists(this.getOverridee*().getGetter()) and
    exists(this.getOverridee*().getSetter())
  }

  /** Gets the expression body of this declaration, if any. */
  Expr getExpressionBody() { result = this.getChildExpr(0) }
}

/**
 * A property, for example `P` on line 2 in
 *
 * ```csharp
 * class C {
 *   public int P { get; set; }
 * }
 * ```
 */
class Property extends DotNet::Property, DeclarationWithGetSetAccessors, @property {
  override string getName() { properties(this, result, _, _, _) }

  override string getUndecoratedName() { properties(this, result, _, _, _) }

  override ValueOrRefType getDeclaringType() { properties(this, _, result, _, _) }

  override Type getType() { properties(this, _, _, getTypeRef(result), _) }

  /**
   * Holds if this property is automatically implemented. For example, `P1`
   * on line 2 is automatically implemented, while `P2` on line 5 is not in
   *
   * ```csharp
   * class C {
   *   public int P1 { get; set; }
   *
   *   int p2;
   *   public int P2 {
   *     get { return p2; }
   *     set { p2 = value; }
   *   }
   * }
   * ```
   *
   * Note that this information is only avaiable for properties in source
   * code.
   */
  predicate isAutoImplemented() {
    this.fromSource() and
    this.isReadWrite() and
    not this.isExtern() and
    not this.isAbstract() and
    not this.getAnAccessor().hasBody()
  }

  override Property getUnboundDeclaration() { properties(this, _, _, _, result) }

  override Property getOverridee() { result = DeclarationWithGetSetAccessors.super.getOverridee() }

  override Property getAnOverrider() {
    result = DeclarationWithGetSetAccessors.super.getAnOverrider()
  }

  override Property getImplementee() {
    result = DeclarationWithGetSetAccessors.super.getImplementee()
  }

  override Property getAnImplementor() {
    result = DeclarationWithGetSetAccessors.super.getAnImplementor()
  }

  override Property getAnUltimateImplementee() {
    result = DeclarationWithGetSetAccessors.super.getAnUltimateImplementee()
  }

  override Property getAnUltimateImplementor() {
    result = DeclarationWithGetSetAccessors.super.getAnUltimateImplementor()
  }

  override PropertyAccess getAnAccess() { result.getTarget() = this }

  override Location getALocation() { property_location(this, result) }

  override Expr getAnAssignedValue() {
    result = DeclarationWithGetSetAccessors.super.getAnAssignedValue()
    or
    // For library types, we don't know about assignments in constructors. We instead assume that
    // arguments passed to parameters of constructors with suitable names.
    this.getDeclaringType().fromLibrary() and
    exists(Parameter param, Constructor c, string propertyName |
      propertyName = this.getName() and
      c = this.getDeclaringType().getAConstructor() and
      param = c.getAParameter() and
      // Find a constructor parameter with the same name, but with a lower case initial letter.
      param.hasName(propertyName.charAt(0).toLowerCase() + propertyName.suffix(1))
    |
      result = param.getAnAssignedArgument()
    )
  }

  /**
   * Gets the initial value of this property, if any. For example, the initial
   * value of `P` on line 2 is `20` in
   *
   * ```csharp
   * class C {
   *   public int P { get; set; } = 20;
   * }
   * ```
   */
  Expr getInitializer() { result = this.getChildExpr(1).getChildExpr(0) }

  /**
   * Holds if this property has an initial value. For example, the initial
   * value of `P` on line 2 is `20` in
   *
   * ```csharp
   * class C {
   *   public int P { get; set; } = 20;
   * }
   * ```
   */
  predicate hasInitializer() { exists(this.getInitializer()) }

  /**
   * Gets the expression body of this property, if any. For example, the expression
   * body of `P` on line 2 is `20` in
   *
   * ```csharp
   * class C {
   *   public int P => 20;
   * }
   * ```
   */
  override Expr getExpressionBody() {
    result = DeclarationWithGetSetAccessors.super.getExpressionBody()
  }

  override Getter getGetter() { result = DeclarationWithGetSetAccessors.super.getGetter() }

  override Setter getSetter() { result = DeclarationWithGetSetAccessors.super.getSetter() }

  override string getAPrimaryQlClass() { result = "Property" }
}

/**
 * An indexer, for example `string this[int i]` on line 2 in
 *
 * ```csharp
 * class C {
 *   public string this[int i] {
 *     get { return i.ToString(); }
 *   }
 * }
 * ```
 */
class Indexer extends DeclarationWithGetSetAccessors, Parameterizable, @indexer {
  override string getName() { indexers(this, result, _, _, _) }

  override string getUndecoratedName() { indexers(this, result, _, _, _) }

  /** Gets the dimension of this indexer, that is, its number of parameters. */
  int getDimension() { result = this.getNumberOfParameters() }

  override ValueOrRefType getDeclaringType() { indexers(this, _, result, _, _) }

  override Type getType() { indexers(this, _, _, getTypeRef(result), _) }

  override IndexerAccess getAnAccess() { result.getTarget() = this }

  /**
   * Gets the expression body of this indexer, if any. For example, the
   * expression body of the indexer on line 2 is `20` in
   *
   * ```csharp
   * class C {
   *   public int this[int i] => 20;
   * }
   * ```
   */
  override Expr getExpressionBody() {
    result = DeclarationWithGetSetAccessors.super.getExpressionBody()
  }

  override Indexer getUnboundDeclaration() { indexers(this, _, _, _, result) }

  override Indexer getOverridee() { result = DeclarationWithGetSetAccessors.super.getOverridee() }

  override Indexer getAnOverrider() {
    result = DeclarationWithGetSetAccessors.super.getAnOverrider()
  }

  override Indexer getImplementee() {
    result = DeclarationWithGetSetAccessors.super.getImplementee()
  }

  override Indexer getAnImplementor() {
    result = DeclarationWithGetSetAccessors.super.getAnImplementor()
  }

  override Indexer getAnUltimateImplementee() {
    result = DeclarationWithGetSetAccessors.super.getAnUltimateImplementee()
  }

  override Indexer getAnUltimateImplementor() {
    result = DeclarationWithGetSetAccessors.super.getAnUltimateImplementor()
  }

  override Location getALocation() { indexer_location(this, result) }

  override string toStringWithTypes() {
    result = this.getName() + "[" + this.parameterTypesToString() + "]"
  }

  override string getAPrimaryQlClass() { result = "Indexer" }
}

/**
 * An accessor. Either a getter (`Getter`), a setter (`Setter`), or event
 * accessor (`EventAccessor`).
 */
class Accessor extends Callable, Modifiable, Attributable, Overridable, @callable_accessor {
  override ValueOrRefType getDeclaringType() { result = this.getDeclaration().getDeclaringType() }

  /** Gets the assembly name of this accessor. */
  string getAssemblyName() { accessors(this, _, result, _, _) }

  /**
   * Gets the declaration that this accessor belongs to. For example, both
   * accessors on lines 3 and 4 belong to the property `P` on line 2 in
   *
   * ```csharp
   * class C {
   *   public int P {
   *     get;
   *     set;
   *   }
   * }
   * ```
   */
  DeclarationWithAccessors getDeclaration() { accessors(this, _, _, result, _) }

  /**
   * Gets an explicit access modifier of this accessor, if any. For example,
   * the `get` accessor on line 3 has no access modifier and the `set` accessor
   * on line 4 has a `private` access modifier in
   *
   * ```csharp
   * class C {
   *   public int P {
   *     get;
   *     private set;
   *   }
   * }
   * ```
   */
  AccessModifier getAnAccessModifier() { result = Modifiable.super.getAModifier() }

  /**
   * Gets a modifier of this accessor, if any.
   *
   * This is either an explicit access modifier of this accessor, or a modifier
   * inherited from the declaration. For example, the `get` accessor on line 3
   * has the modifiers `public` and `virtual`, and the `set` accessor on line 4
   * has the modifiers `private` and `virtual` in
   *
   * ```csharp
   * class C {
   *   public virtual int P {
   *     get;
   *     private set;
   *   }
   * }
   * ```
   */
  override Modifier getAModifier() {
    result = this.getAnAccessModifier()
    or
    result = this.getDeclaration().getAModifier() and
    not (result instanceof AccessModifier and exists(this.getAnAccessModifier()))
  }

  override predicate isOverridableOrImplementable() {
    this.getDeclaration().isOverridableOrImplementable()
  }

  override Accessor getUnboundDeclaration() { accessors(this, _, _, _, result) }

  override Location getALocation() { accessor_location(this, result) }

  override string toString() { result = this.getName() }
}

/**
 * A `get` accessor, for example `get { return p; }` in
 *
 * ```csharp
 * public class C {
 *   int p;
 *   public int P {
 *     get { return p; }
 *     set { p = value; }
 *   }
 * }
 * ```
 */
class Getter extends Accessor, @getter {
  override string getName() { result = "get" + "_" + this.getDeclaration().getName() }

  override string getUndecoratedName() { result = "get" + "_" + this.getDeclaration().getName() }

  override Type getReturnType() { result = this.getDeclaration().getType() }

  /**
   * Gets the field used in the trival implementation of this getter, if any.
   * For example, the field `p` in
   *
   * ```csharp
   * public class C {
   *   int p;
   *   public int P {
   *     get { return p; }
   *     set { p = value; }
   *   }
   * }
   * ```
   */
  Field trivialGetterField() {
    exists(ReturnStmt ret |
      this.getStatementBody().getNumberOfStmts() = 1 and
      this.getStatementBody().getAChild() = ret and
      ret.getExpr() = result.getAnAccess()
    )
  }

  override DeclarationWithGetSetAccessors getDeclaration() {
    result = Accessor.super.getDeclaration()
  }

  override string getAPrimaryQlClass() { result = "Getter" }
}

/**
 * A `set` accessor, for example `set { p = value; }` in
 *
 * ```csharp
 * public class C {
 *   int p;
 *   public int P {
 *     get { return p; }
 *     set { p = value; }
 *   }
 * }
 * ```
 */
class Setter extends Accessor, @setter {
  override string getName() { result = "set" + "_" + this.getDeclaration().getName() }

  override string getUndecoratedName() { result = "set" + "_" + this.getDeclaration().getName() }

  override Type getReturnType() {
    exists(this) and // needed to avoid compiler warning
    result instanceof VoidType
  }

  /**
   * Gets the field used in the trival implementation of this setter, if any.
   * For example, the field `p` in
   *
   * ```csharp
   * public class C {
   *   int p;
   *   public int P {
   *     get { return p; }
   *     set { p = value; }
   *   }
   * }
   * ```
   */
  Field trivialSetterField() {
    exists(AssignExpr assign |
      this.getStatementBody().getNumberOfStmts() = 1 and
      assign.getParent() = this.getStatementBody().getAChild() and
      assign.getLValue() = result.getAnAccess() and
      assign.getRValue() = accessToValue()
    )
  }

  override DeclarationWithGetSetAccessors getDeclaration() {
    result = Accessor.super.getDeclaration()
  }

  /** Holds if this setter is an `init`-only accessor. */
  predicate isInitOnly() { init_only_accessors(this) }

  override string getAPrimaryQlClass() { result = "Setter" }
}

/**
 * Gets an access to the special `value` parameter available in setters.
 */
private ParameterAccess accessToValue() {
  result.getTarget().hasName("value") and
  result.getEnclosingCallable() instanceof Setter
}

/**
 * A property with a trivial getter and setter. For example, properties `P1`
 * and `P2` are trivial, while `P3` is not, in
 *
 * ```csharp
 * public class C {
 *   int p1;
 *   public int P1 {
 *     get { return p1; }
 *     set { p1 = value; }
 *   }
 *
 *   public int P2 {
 *     get;
 *     set;
 *   }
 *
 *   int p3;
 *   public int P3 {
 *     get { return p3; }
 *     set { p3 = value + 1; }
 *   }
 * }
 * ```
 */
class TrivialProperty extends Property {
  TrivialProperty() {
    this.isAutoImplemented()
    or
    this.getGetter().trivialGetterField() = this.getSetter().trivialSetterField()
    or
    exists(CIL::TrivialProperty prop | this.matchesHandle(prop))
  }
}

/**
 * A `Property` which holds a type with an indexer.
 */
class IndexerProperty extends Property {
  Indexer i;

  IndexerProperty() { this.getType().(RefType).hasMember(i) }

  pragma[nomagic]
  private IndexerCall getAnIndexerCall0() {
    exists(Expr qualifier | qualifier = result.getQualifier() |
      DataFlow::localExprFlow(this.getAnAccess(), qualifier)
    )
  }

  /**
   * Gets a call to the indexer of the type returned by this property, for a value returned by this
   * property.
   *
   * This tracks instances returned by the property using local data flow.
   */
  IndexerCall getAnIndexerCall() {
    result = this.getAnIndexerCall0() and
    // Omitting the constraint below would potentially include
    // too many indexer calls, for example the call to the indexer
    // setter at `dict[0]` in
    //
    // ```csharp
    // class A
    // {
    //     Dictionary<int, string> dict;
    //     public IReadonlyDictionary<int, string> Dict { get => dict; }
    // }
    //
    // class B
    // {
    //     void M(A a)
    //     {
    //         var dict = (Dictionary<int, string>) a.Dict;
    //         dict[0] = "";
    //     }
    // }
    // ```
    result.getIndexer() = i
  }
}
