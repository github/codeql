/**
 * Provides shared functionality for computing type inference in QL.
 *
 * The code examples in this file use C# syntax, but the concepts should carry
 * over to other languages as well.
 *
 * The library is initialized in two phases: `Make1`, which constructs the
 * `TypePath` type, and `Make2`, which (using `TypePath` in the input signature)
 * constructs the `Matching` and `IsInstantiationOf` modules.
 *
 * The intended use of this library is define a predicate
 *
 * ```ql
 * Type inferType(AstNode n, TypePath path)
 * ```
 *
 * for recursively inferring the type-path-indexed types of AST nodes. For example,
 * one may have a base case for literals like
 *
 * ```ql
 * Type inferType(AstNode n, TypePath path) {
 *   ...
 *   n instanceof IntegerLiteral and
 *   result instanceof IntType and
 *   path.isEmpty()
 *   ...
 * }
 * ```
 *
 * and recursive cases for local variables like
 *
 * ```ql
 * Type inferType(AstNode n, TypePath path) {
 *   ...
 *   exists(LocalVariable v |
 *     // propagate type information from the initializer to any access
 *     n = v.getAnAccess() and
 *     result = inferType(v.getInitializer(), path)
 *     or
 *     // propagate type information from any access back to the initializer; note
 *     // that this case may not be relevant for all languages, but e.g. in Rust
 *     // it is
 *     n = v.getInitializer() and
 *     result = inferType(v.getAnAccess(), path)
 *   )
 *   ...
 * }
 * ```
 *
 * The `Matching` module is used when an AST node references a potentially generic
 * declaration, where the type of the node depends on the type of some of its sub
 * nodes. For example, if we have a generic method like `T Identity<T>(T t)`, then
 * the type of `Identity(42)` should be `int`, while the type of `Identity("foo")`
 * should be `string`; in both cases it should _not_ be `T`.
 *
 * In order to infer the type of method calls, one would define something like
 *
 * ```ql
 * private module MethodCallMatchingInput implements MatchingInputSig {
 *   private newtype TDeclarationPosition =
 *     TSelfDeclarationPosition() or
 *     TPositionalDeclarationPosition(int pos) { ... } or
 *     TReturnDeclarationPosition()
 *
 *   // A position inside a method with a declared type.
 *   class DeclarationPosition extends TDeclarationPosition {
 *     ...
 *   }
 *
 *   class Declaration extends MethodCall {
 *     // Gets a type parameter at `tppos` belonging to this method.
 *     //
 *     // For example, if this method is `T Identity<T>(T t)`, then `T`
 *     // is at position `0`.
 *     TypeParameter getTypeParameter(TypeParameterPosition tppos) { ... }
 *
 *     // Gets the declared type of this method at `dpos` and `path`.
 *     //
 *     // For example, if this method is `T Identity<T>(T t)`, then both the
 *     // the return type and parameter position `0` is `T` with `path.isEmpty()`.
 *     Type getDeclaredType(DeclarationPosition dpos, TypePath path) { ... }
 *   }
 *
 *   // A position inside a method call with an inferred type
 *   class AccessPosition = DeclarationPosition;
 *
 *   class Access extends MethodCall {
 *     AstNode getNodeAt(AccessPosition apos) { ... }
 *
 *     // Gets the inferred type of the node at `apos` and `path`.
 *     //
 *     // For example, if this method call is `Identity(42)`, then the type
 *     // at argument position `0` is `int` with `path.isEmpty()"`.
 *     Type getInferredType(AccessPosition apos, TypePath path) {
 *       result = inferType(this.getNodeAt(apos), path)
 *     }
 *
 *     // Gets the method that this method call resolves to.
 *     //
 *     // This will typically be defined in mutual recursion with the `inferType`
 *     // predicate, as we need to know the type of the receiver in order to
 *     // resolve calls to instance methods.
 *     Declaration getTarget() { ... }
 *   }
 *
 *   predicate accessDeclarationPositionMatch(AccessPosition apos, DeclarationPosition dpos) {
 *     apos = dpos
 *   }
 * }
 *
 * private module MethodCallMatching = Matching<MethodCallMatchingInput>;
 *
 * Type inferType(AstNode n, TypePath path) {
 *   ...
 *   exists(MethodCall mc, MethodCallMatchingInput::AccessPosition apos |
 *     // Some languages may want to restrict `apos` to be the return position, but in
 *     // e.g. Rust type information can flow out of all positions
 *     n = a.getNodeAt(apos) and
 *     result = MethodCallMatching::inferAccessType(a, apos, path)
 *   )
 *   ...
 * }
 * ```
 */

private import codeql.util.Location

/** Provides the input to `Make1`. */
signature module InputSig1<LocationSig Location> {
  /**
   * A type without type arguments.
   *
   * For example `int` or ``IEnumerable`1``.
   */
  class Type {
    /** Gets a type parameter of this type, if any. */
    TypeParameter getATypeParameter();

    /** Gets a textual representation of this type. */
    string toString();

    /** Gets the location of this type. */
    Location getLocation();
  }

  /** A type parameter. */
  class TypeParameter extends Type;

  /**
   * A type abstraction. I.e., a place in the program where type variables are
   * introduced.
   *
   * Example in C#:
   * ```csharp
   * class C<A, B> : D<A, B> { }
   * //     ^^^^^^ a type abstraction
   * ```
   *
   * Example in Rust:
   * ```rust
   * impl<A, B> Foo<A, B> { }
   * //  ^^^^^^ a type abstraction
   * ```
   */
  class TypeAbstraction {
    /** Gets a type parameter introduced by this abstraction. */
    TypeParameter getATypeParameter();

    /** Gets a textual representation of this type abstraction. */
    string toString();

    /** Gets the location of this type abstraction. */
    Location getLocation();
  }

  /**
   * Gets the unique identifier of type parameter `tp`.
   *
   * This is used to represent type paths `.`-separated type parameter
   * identifiers.
   */
  int getTypeParameterId(TypeParameter tp);

  /**
   * A type argument position, for example an integer.
   *
   * Type argument positions are used when type arguments are supplied explicitly,
   * for example in a method call like `M<int>()` the type argument `int` is at
   * position `0`.
   */
  bindingset[this]
  class TypeArgumentPosition {
    /** Gets the textual representation of this position. */
    bindingset[this]
    string toString();
  }

  /** A type parameter position, for example an integer. */
  bindingset[this]
  class TypeParameterPosition {
    /** Gets the textual representation of this position. */
    bindingset[this]
    string toString();
  }

  /** Holds if `tapos` and `tppos` match. */
  bindingset[tapos]
  bindingset[tppos]
  predicate typeArgumentParameterPositionMatch(
    TypeArgumentPosition tapos, TypeParameterPosition tppos
  );

  /**
   * Gets the limit on the length of type paths. Set to `none()` if there should
   * be no limit.
   *
   * Having a limit can be useful to avoid inifinite recursion on malformed
   * programs.
   */
  default int getTypePathLimit() { result = 10 }
}

module Make1<LocationSig Location, InputSig1<Location> Input1> {
  private import Input1

  private module TypeParameter {
    private import codeql.util.DenseRank

    private module DenseRankInput implements DenseRankInputSig {
      class Ranked = TypeParameter;

      predicate getRank = getTypeParameterId/1;
    }

    int getRank(TypeParameter tp) { tp = DenseRank<DenseRankInput>::denseRank(result) }

    string encode(TypeParameter tp) { result = getRank(tp).toString() }

    bindingset[s]
    TypeParameter decode(string s) { encode(result) = s }
  }

  final private class String = string;

  /**
   * A path into a type.
   *
   * Paths are represented in left-to-right order, for example, a path `"A0.B1"`
   * into the type `A<B<S,T>,C<U,V>>` points at the type `T`, assuming that the
   * first type parameter of `A` is named `A0` and the second type parameter of
   * `B` is named `B1`.
   *
   * Type paths are used to represent constructed types without using a `newtype`, which
   * makes it practically feasible to do type inference in mutual recursion with call
   * resolution.
   *
   * As an example, the type above can be represented by the following set of
   * tuples, if assuming the same naming convention for type parameters as
   * above:
   *
   * `TypePath`  | `Type`
   * ----------- | --------
   * `""`        | ``A`2``
   * `"A0"`      | ``B`2``
   * `"A0.B0"`   | `S`
   * `"A0.B1"`   | `T`
   * `"A1"`      | ``C`2``
   * `"A1.C0"`   | `U`
   * `"A1.C1"`   | `V`
   *
   * Note that while we write type paths using type parameter names, the actual
   * implementation uses unique type parameter identifiers, in order to not mix
   * up type parameters from different types.
   */
  class TypePath extends String {
    bindingset[this]
    TypePath() { exists(this) }

    bindingset[this]
    private TypeParameter getTypeParameter(int i) {
      result = TypeParameter::decode(this.splitAt(".", i))
    }

    /** Gets a textual representation of this type path. */
    bindingset[this]
    string toString() {
      result =
        concat(int i, TypeParameter tp |
          tp = this.getTypeParameter(i)
        |
          tp.toString(), "." order by i
        )
    }

    /** Holds if this type path is empty. */
    predicate isEmpty() { this = "" }

    /** Gets the length of this path. */
    bindingset[this]
    pragma[inline_late]
    int length() {
      // Same as
      // `result = count(this.indexOf("."))`
      // but performs better because it doesn't use an aggregate
      result = this.regexpReplaceAll("[0-9]+", "").length()
    }

    /** Gets the path obtained by appending `suffix` onto this path. */
    bindingset[this, suffix]
    TypePath append(TypePath suffix) {
      result = this + suffix and
      (
        not exists(getTypePathLimit())
        or
        result.length() <= getTypePathLimit()
      )
    }

    /**
     * Gets the path obtained by appending `suffix` onto this path.
     *
     * Unlike `append`, this predicate has `result` in the binding set,
     * so there is no need to check the length of `result`.
     */
    bindingset[this, result]
    TypePath appendInverse(TypePath suffix) { suffix = result.stripPrefix(this) }

    /** Gets the path obtained by removing `prefix` from this path. */
    bindingset[this, prefix]
    TypePath stripPrefix(TypePath prefix) { this = prefix + result }

    /** Holds if this path starts with `tp`, followed by `suffix`. */
    bindingset[this]
    predicate isCons(TypeParameter tp, TypePath suffix) {
      suffix = this.stripPrefix(TypePath::singleton(tp))
    }

    /** Gets the head of this path, if any. */
    bindingset[this]
    TypeParameter getHead() { result = this.getTypeParameter(0) }
  }

  /** Provides predicates for constructing `TypePath`s. */
  module TypePath {
    /** Gets the empty type path. */
    TypePath nil() { result.isEmpty() }

    /** Gets the singleton type path `tp`. */
    TypePath singleton(TypeParameter tp) { result = TypeParameter::encode(tp) + "." }

    /**
     * Gets the type path obtained by appending the singleton type path `tp`
     * onto `suffix`.
     */
    bindingset[suffix]
    TypePath cons(TypeParameter tp, TypePath suffix) { result = singleton(tp).append(suffix) }
  }

  /**
   * A class that has a type tree associated with it.
   *
   * The type tree is represented by the `getTypeAt` predicate, which for every
   * path into the tree gives the type at that path.
   */
  signature class HasTypeTreeSig {
    /** Gets the type at `path` in the type tree. */
    Type getTypeAt(TypePath path);

    /** Gets a textual representation of this type. */
    string toString();

    /** Gets the location of this type. */
    Location getLocation();
  }

  /** Provides the input to `Make2`. */
  signature module InputSig2 {
    /** A type mention, for example a type annotation in a local variable declaration. */
    class TypeMention {
      /**
       * Gets the type being mentioned at `path` inside this type mention.
       *
       * For example, in
       *
       * ```csharp
       * C<int> x = ...
       * ```
       *
       * the type mention in the declaration of `x` resolves to the following
       * types:
       *
       * `TypePath` | `Type`
       * ---------- | -------
       * `""`       | ``C`1``
       * `"0"`      | `int`
       */
      Type resolveTypeAt(TypePath path);

      /** Gets a textual representation of this type mention. */
      string toString();

      /** Gets the location of this type mention. */
      Location getLocation();
    }

    /**
     * Gets a base type mention of `t`, if any. Example:
     *
     * ```csharp
     * class C<T> : Base<T>, Interface { }
     * //    ^ `t`
     * //           ^^^^^^^ `result`
     * //                    ^^^^^^^^^ `result`
     * ```
     */
    TypeMention getABaseTypeMention(Type t);

    /**
     * Gets a type constraint on the type parameter `tp`, if any. All
     * instantiations of the type parameter must satisfy the constraint.
     *
     * For example, in
     * ```csharp
     * class GenericClass<T> : IComparable<GenericClass<T>>
     * //                 ^ `tp`
     *     where T : IComparable<T> { }
     * //            ^^^^^^^^^^^^^^ `result`
     * ```
     * the type parameter `T` has the constraint `IComparable<T>`.
     */
    TypeMention getATypeParameterConstraint(TypeParameter tp);

    /**
     * Holds if
     * - `abs` is a type abstraction that introduces type variables that are
     *   free in `condition` and `constraint`,
     * - and for every instantiation of the type parameters from `abs` the
     *   resulting `condition` satisifies the constraint given by `constraint`.
     *
     * Example in C#:
     * ```csharp
     * class C<T> : IComparable<C<T>> { }
     * //     ^^^ `abs`
     * //    ^^^^ `condition`
     * //           ^^^^^^^^^^^^^^^^^ `constraint`
     * ```
     *
     * Example in Rust:
     * ```rust
     * impl<A> Trait<i64, A> for Type<String, A> { }
     * //  ^^^ `abs`             ^^^^^^^^^^^^^^^ `condition`
     * //      ^^^^^^^^^^^^^ `constraint`
     * ```
     *
     * To see how `abs` changes the meaning of the type parameters that occur in
     * `condition`, consider the following examples in Rust:
     * ```rust
     * impl<T> Trait for T { }
     * //  ^^^ `abs`     ^ `condition`
     * //      ^^^^^ `constraint`
     * ```
     * Here the meaning is "for all type parameters `T` it is the case that `T`
     * implements `Trait`". On the other hand, in
     * ```rust
     * fn foo<T: Trait>() { }
     * //     ^ `condition`
     * //        ^^^^^ `constraint`
     * ```
     * the meaning is "`T` implements `Trait`" where the constraint is only
     * valid for the specific `T`. Note that `condition` and `condition` are
     * identical in the two examples. To encode the difference, `abs` in the
     * first example should contain `T` whereas in the seconds example `abs`
     * should be empty.
     */
    predicate conditionSatisfiesConstraint(
      TypeAbstraction abs, TypeMention condition, TypeMention constraint
    );
  }

  module Make2<InputSig2 Input2> {
    private import Input2

    /** Gets the type at the empty path of `tm`. */
    bindingset[tm]
    pragma[inline_late]
    private Type resolveTypeMentionRoot(TypeMention tm) {
      result = tm.resolveTypeAt(TypePath::nil())
    }

    /** Provides the input to `IsInstantiationOf`. */
    signature module IsInstantiationOfInputSig<HasTypeTreeSig App> {
      /**
       * Holds if `abs` is a type abstraction, `tm` occurs in the scope of
       * `abs`, and `app` is potentially an application/instantiation of `abs`.
       *
       * For example:
       * ```rust
       * impl<A> Foo<A, A> {
       * //  ^^^ `abs`
       * //      ^^^^^^^^^ `tm`
       *   fn bar(self) { ... }
       * }
       * // ...
       *    foo.bar();
       * // ^^^ `app`
       * ```
       * Here `abs` introduces the type parameter `A` and `tm` occurs in the
       * scope of `abs` (i.e., `A` is bound in `tm` by `abs`). On the last line,
       * accessing the `bar` method of `foo` potentially instantiates the `impl`
       * block with a type argument for `A`.
       */
      predicate potentialInstantiationOf(App app, TypeAbstraction abs, TypeMention tm);

      /**
       * Holds if `constraint` might occur as the third argument of
       * `potentialInstantiationOf`. Defaults to simply projecting the third
       * argument of `potentialInstantiationOf`.
       */
      default predicate relevantTypeMention(TypeMention tm) { potentialInstantiationOf(_, _, tm) }
    }

    /**
     * Provides functionality for determining if a type is a possible
     * instantiation of a type mention containing type parameters.
     */
    module IsInstantiationOf<HasTypeTreeSig App, IsInstantiationOfInputSig<App> Input> {
      private import Input

      /** Gets the `i`th path in `tm` per some arbitrary order. */
      pragma[nomagic]
      private TypePath getNthPath(TypeMention tm, int i) {
        result =
          rank[i + 1](TypePath path |
            exists(tm.resolveTypeAt(path)) and relevantTypeMention(tm)
          |
            path
          )
      }

      /**
       * Holds if `app` is a possible instantiation of `tm` at `path`. That is
       * the type at `path` in `tm` is either a type parameter or equal to the
       * type at the same path in `app`.
       */
      bindingset[app, abs, tm, path]
      private predicate satisfiesConcreteTypeAt(
        App app, TypeAbstraction abs, TypeMention tm, TypePath path
      ) {
        exists(Type t |
          tm.resolveTypeAt(path) = t and
          if t = abs.getATypeParameter() then any() else app.getTypeAt(path) = t
        )
      }

      pragma[nomagic]
      private predicate satisfiesConcreteTypesFromIndex(
        App app, TypeAbstraction abs, TypeMention tm, int i
      ) {
        potentialInstantiationOf(app, abs, tm) and
        satisfiesConcreteTypeAt(app, abs, tm, getNthPath(tm, i)) and
        // Recurse unless we are at the first path
        if i = 0 then any() else satisfiesConcreteTypesFromIndex(app, abs, tm, i - 1)
      }

      /** Holds if all the concrete types in `tm` also occur in `app`. */
      pragma[nomagic]
      private predicate satisfiesConcreteTypes(App app, TypeAbstraction abs, TypeMention tm) {
        satisfiesConcreteTypesFromIndex(app, abs, tm, max(int i | exists(getNthPath(tm, i))))
      }

      private TypeParameter getNthTypeParameter(TypeAbstraction abs, int i) {
        result =
          rank[i + 1](TypeParameter tp |
            tp = abs.getATypeParameter()
          |
            tp order by TypeParameter::getRank(tp)
          )
      }

      /**
       * Gets the path to the `i`th occurrence of `tp` within `tm` per some
       * arbitrary order, if any.
       */
      private TypePath getNthTypeParameterPath(TypeMention tm, TypeParameter tp, int i) {
        result =
          rank[i + 1](TypePath path | tp = tm.resolveTypeAt(path) and relevantTypeMention(tm) | path)
      }

      pragma[nomagic]
      private predicate typeParametersEqualFromIndex(
        App app, TypeAbstraction abs, TypeMention tm, TypeParameter tp, Type t, int i
      ) {
        satisfiesConcreteTypes(app, abs, tm) and
        exists(TypePath path |
          path = getNthTypeParameterPath(tm, tp, i) and
          t = app.getTypeAt(path) and
          if i = 0
          then
            // no need to compute this predicate if there is only one path
            exists(getNthTypeParameterPath(tm, tp, 1))
          else typeParametersEqualFromIndex(app, abs, tm, tp, t, i - 1)
        )
      }

      private predicate typeParametersEqual(
        App app, TypeAbstraction abs, TypeMention tm, TypeParameter tp
      ) {
        satisfiesConcreteTypes(app, abs, tm) and
        tp = getNthTypeParameter(abs, _) and
        (
          not exists(getNthTypeParameterPath(tm, tp, _))
          or
          exists(int n | n = max(int i | exists(getNthTypeParameterPath(tm, tp, i))) |
            // If the largest index is 0, then there are no equalities to check as
            // the type parameter only occurs once.
            if n = 0 then any() else typeParametersEqualFromIndex(app, abs, tm, tp, _, n)
          )
        )
      }

      private predicate typeParametersHaveEqualInstantiationFromIndex(
        App app, TypeAbstraction abs, TypeMention tm, int i
      ) {
        exists(TypeParameter tp | tp = getNthTypeParameter(abs, i) |
          typeParametersEqual(app, abs, tm, tp) and
          if i = 0
          then any()
          else typeParametersHaveEqualInstantiationFromIndex(app, abs, tm, i - 1)
        )
      }

      /**
       * Holds if `app` is a possible instantiation of `tm`. That is, by making
       * appropriate substitutions for the free type parameters in `tm` given by
       * `abs`, it is possible to obtain `app`.
       *
       * For instance, if `A` and `B` are free type parameters we have:
       * - `Pair<int, string>` is an instantiation of       `A`
       * - `Pair<int, string>` is an instantiation of       `Pair<A, B>`
       * - `Pair<int, int>`    is an instantiation of       `Pair<A, A>`
       * - `Pair<int, bool>`   is _not_ an instantiation of `Pair<A, A>`
       * - `Pair<int, string>` is _not_ an instantiation of `Pair<string, string>`
       */
      predicate isInstantiationOf(App app, TypeAbstraction abs, TypeMention tm) {
        // We only need to check equality if the concrete types are satisfied.
        satisfiesConcreteTypes(app, abs, tm) and
        // Check if all the places where the same type parameter occurs in `tm`
        // are equal in `app`.
        //
        // TODO: As of now this only checks equality at the root of the types
        // instantiated for type parameters. So, for instance, `Pair<Vec<i64>, Vec<bool>>`
        // is mistakenly considered an instantiation of `Pair<A, A>`.
        (
          not exists(getNthTypeParameter(abs, _))
          or
          exists(int n | n = max(int i | exists(getNthTypeParameter(abs, i))) |
            typeParametersHaveEqualInstantiationFromIndex(app, abs, tm, n)
          )
        )
      }
    }

    /** Provides logic related to base types. */
    private module BaseTypes {
      /**
       * Holds if, when `tm1` is considered an instantiation of `tm2`, then at
       * the type parameter `tp` it has the type `t` at `path`.
       *
       * For instance, if the type `Map<int, List<int>>` is considered an
       * instantion of `Map<K, V>` then it has the type `int` at `K` and the
       * type `List<int>` at `V`.
       */
      bindingset[tm1, tm2]
      private predicate instantiatesWith(
        TypeMention tm1, TypeMention tm2, TypeParameter tp, TypePath path, Type t
      ) {
        exists(TypePath prefix |
          tm2.resolveTypeAt(prefix) = tp and t = tm1.resolveTypeAt(prefix.appendInverse(path))
        )
      }

      final private class FinalTypeMention = TypeMention;

      final private class TypeMentionTypeTree extends FinalTypeMention {
        Type getTypeAt(TypePath path) { result = this.resolveTypeAt(path) }
      }

      private module IsInstantiationOfInput implements
        IsInstantiationOfInputSig<TypeMentionTypeTree>
      {
        pragma[nomagic]
        private predicate typeCondition(Type type, TypeAbstraction abs, TypeMentionTypeTree lhs) {
          conditionSatisfiesConstraint(abs, lhs, _) and type = resolveTypeMentionRoot(lhs)
        }

        pragma[nomagic]
        private predicate typeConstraint(Type type, TypeMentionTypeTree rhs) {
          conditionSatisfiesConstraint(_, _, rhs) and type = resolveTypeMentionRoot(rhs)
        }

        predicate potentialInstantiationOf(
          TypeMentionTypeTree condition, TypeAbstraction abs, TypeMention constraint
        ) {
          exists(Type type |
            typeConstraint(type, condition) and typeCondition(type, abs, constraint)
          )
        }
      }

      /**
       * Holds if the type mention `condition` satisfies `constraint` with the
       * type `t` at the path `path`.
       */
      predicate conditionSatisfiesConstraintTypeAt(
        TypeAbstraction abs, TypeMention condition, TypeMention constraint, TypePath path, Type t
      ) {
        // base case
        conditionSatisfiesConstraint(abs, condition, constraint) and
        constraint.resolveTypeAt(path) = t
        or
        // recursive case
        exists(TypeAbstraction midAbs, TypeMention midSup, TypeMention midSub |
          conditionSatisfiesConstraint(abs, condition, midSup) and
          // NOTE: `midAbs` describe the free type variables in `midSub`, hence
          // we use that for instantiation check.
          IsInstantiationOf<TypeMentionTypeTree, IsInstantiationOfInput>::isInstantiationOf(midSup,
            midAbs, midSub)
        |
          conditionSatisfiesConstraintTypeAt(midAbs, midSub, constraint, path, t) and
          not t = midAbs.getATypeParameter()
          or
          exists(TypePath prefix, TypePath suffix, TypeParameter tp |
            tp = midAbs.getATypeParameter() and
            conditionSatisfiesConstraintTypeAt(midAbs, midSub, constraint, prefix, tp) and
            instantiatesWith(midSup, midSub, tp, suffix, t) and
            path = prefix.append(suffix)
          )
        )
      }

      /**
       * Holds if its possible for a type with `conditionRoot` at the root to
       * satisfy a constraint with `constraintRoot` at the root through `abs`,
       * `condition`, and `constraint`.
       */
      predicate rootTypesSatisfaction(
        Type conditionRoot, Type constraintRoot, TypeAbstraction abs, TypeMention condition,
        TypeMention constraint
      ) {
        conditionSatisfiesConstraintTypeAt(abs, condition, constraint, _, _) and
        conditionRoot = resolveTypeMentionRoot(condition) and
        constraintRoot = resolveTypeMentionRoot(constraint)
      }

      /**
       * Gets the number of ways in which it is possible for a type with
       * `conditionRoot` at the root to satisfy a constraint with
       * `constraintRoot` at the root.
       */
      int countConstraintImplementations(Type conditionRoot, Type constraintRoot) {
        result =
          strictcount(TypeAbstraction abs, TypeMention tm, TypeMention constraint |
            rootTypesSatisfaction(conditionRoot, constraintRoot, abs, tm, constraint)
          |
            constraint
          )
      }

      /**
       * Holds if `baseMention` is a (transitive) base type mention of `sub`,
       * and `t` is mentioned (implicitly) at `path` inside `baseMention`. For
       * example, in
       *
       * ```csharp
       * class C<T1> { }
       *
       * class Base<T2> { }
       *
       * class Mid<T3> : Base<C<T3>> { }
       *
       * class Sub<T4> : Mid<C<T4>> { } // Sub<T4> extends Base<C<C<T4>>
       * ```
       *
       * - ``C`1`` is mentioned at `T2` for immediate base type mention `Base<C<T3>>`
       *   of `Mid`,
       * - `T3` is mentioned at `T2.T1` for immediate base type mention `Base<C<T3>>`
       *   of `Mid`,
       * - ``C`1`` is mentioned at `T3` for immediate base type mention `Mid<C<T4>>`
       *   of `Sub`,
       * - `T4` is mentioned at `T3.T1` for immediate base type mention `Mid<C<T4>>`
       *   of `Sub`,
       * - ``C`1`` is mentioned at `T2` and implicitly at `T2.T1` for transitive base type
       *   mention `Base<C<T3>>` of `Sub`, and
       * - `T4` is mentioned implicitly at `T2.T1.T1` for transitive base type mention
       *   `Base<C<T3>>` of `Sub`.
       */
      pragma[nomagic]
      predicate baseTypeMentionHasTypeAt(Type sub, TypeMention baseMention, TypePath path, Type t) {
        exists(TypeMention immediateBaseMention |
          pragma[only_bind_into](immediateBaseMention) =
            getABaseTypeMention(pragma[only_bind_into](sub))
        |
          // immediate base class
          baseMention = immediateBaseMention and
          t = immediateBaseMention.resolveTypeAt(path)
          or
          // transitive base class
          exists(Type immediateBase | immediateBase = resolveTypeMentionRoot(immediateBaseMention) |
            baseTypeMentionHasNonTypeParameterAt(immediateBase, baseMention, path, t)
            or
            exists(TypePath path0, TypePath prefix, TypePath suffix, TypeParameter tp |
              /*
               * Example:
               *
               * - `prefix = "T2.T1"`,
               * - `path0 = "T3"`,
               * - `suffix = ""`,
               * - `path = "T2.T1"`
               *
               * ```csharp
               * class C<T1> { }
               *       ^ `t`
               *
               * class Base<T2> { }
               *
               * class Mid<T3> : Base<C<T3>> { }
               * //    ^^^ `immediateBase`
               * //        ^^ `tp`
               * //              ^^^^^^^^^^^ `baseMention`
               *
               * class Sub<T4> : Mid<C<T4>> { }
               * //    ^^^ `sub`
               * //              ^^^^^^^^^^ `immediateBaseMention`
               * ```
               */

              baseTypeMentionHasTypeParameterAt(immediateBase, baseMention, prefix, tp) and
              t = immediateBaseMention.resolveTypeAt(path0) and
              path0.isCons(tp, suffix) and
              path = prefix.append(suffix)
            )
          )
        )
      }

      pragma[inline]
      predicate baseTypeMentionHasNonTypeParameterAt(
        Type sub, TypeMention baseMention, TypePath path, Type t
      ) {
        not t = sub.getATypeParameter() and baseTypeMentionHasTypeAt(sub, baseMention, path, t)
      }

      pragma[inline]
      predicate baseTypeMentionHasTypeParameterAt(
        Type sub, TypeMention baseMention, TypePath path, TypeParameter tp
      ) {
        tp = sub.getATypeParameter() and baseTypeMentionHasTypeAt(sub, baseMention, path, tp)
      }
    }

    private import BaseTypes

    /** Provides the input to `Matching`. */
    signature module MatchingInputSig {
      /**
       * A position inside a declaration. For example, the integer position of a
       * parameter inside a method or the return type of a method.
       */
      bindingset[this]
      class DeclarationPosition {
        /** Gets a textual representation of this position. */
        bindingset[this]
        string toString();
      }

      /** A declaration, for example a method. */
      class Declaration {
        /** Gets a textual representation of this declaration. */
        string toString();

        /** Gets the location of this declaration. */
        Location getLocation();

        /** Gets the type parameter at position `tppos` of this declaration, if any. */
        TypeParameter getTypeParameter(TypeParameterPosition tppos);

        /**
         * Gets the declared type of this declaration at `path` for position `dpos`.
         *
         * For example, if this declaration is the method `int M(bool b)`,
         * then the declared type at parameter position `0` is `bool`, the
         * declared type at the `this` position is the class type, and the
         * declared return type is `int`.
         */
        Type getDeclaredType(DeclarationPosition dpos, TypePath path);
      }

      /**
       * A position inside an access. For example, the integer position of an
       * argument inside a method call.
       */
      bindingset[this]
      class AccessPosition {
        /** Gets a textual representation of this position. */
        bindingset[this]
        string toString();
      }

      /** An access that targets a declaration, for example a method call. */
      class Access {
        /** Gets a textual representation of this access. */
        string toString();

        /** Gets the location of this access. */
        Location getLocation();

        /**
         * Gets the type at `path` for the type argument at position `tapos` of
         * this access, if any.
         *
         * For example, in a method call like `M<int>()`, `int` is an explicit
         * type argument at position `0`.
         */
        Type getTypeArgument(TypeArgumentPosition tapos, TypePath path);

        /**
         * Gets the inferred type at `path` for the position `apos` of this access.
         *
         * For example, if this access is the method call `M(42)`, then the inferred
         * type at argument position `0` is `int`.
         */
        Type getInferredType(AccessPosition apos, TypePath path);

        /** Gets the declaration that this access targets. */
        Declaration getTarget();
      }

      /** Holds if `apos` and `dpos` match. */
      bindingset[apos]
      bindingset[dpos]
      predicate accessDeclarationPositionMatch(AccessPosition apos, DeclarationPosition dpos);

      /**
       * Holds if matching an inferred type `t` at `path` inside an access at `apos`
       * against the declaration `target` means that the type should be adjusted to
       * `tAdj` at `pathAdj`.
       *
       * For example, in
       *
       * ```csharp
       * void M(int? i) {}
       * M(42);
       * ```
       *
       * the inferred type of `42` is `int`, but it should be adjusted to `int?`
       * when matching against `M`.
       */
      bindingset[apos, target, path, t]
      default predicate adjustAccessType(
        AccessPosition apos, Declaration target, TypePath path, Type t, TypePath pathAdj, Type tAdj
      ) {
        pathAdj = path and
        tAdj = t
      }
    }

    /**
     * Provides logic for matching types at accesses against types at the
     * declarations that the accesses target.
     *
     * Matching takes both base types and explicit type arguments into account.
     */
    module Matching<MatchingInputSig Input> {
      private import Input

      /**
       * Holds if `a` targets `target` and the type for `apos` at `path` in `a`
       * is `t` after adjustment by `target`.
       */
      pragma[nomagic]
      private predicate adjustedAccessType(
        Access a, AccessPosition apos, Declaration target, TypePath path, Type t
      ) {
        target = a.getTarget() and
        exists(TypePath path0, Type t0 |
          t0 = a.getInferredType(apos, path0) and
          adjustAccessType(apos, target, path0, t0, path, t)
        )
      }

      /**
       * Gets the type of the type argument at `path` in `a` that corresponds to
       * the type parameter `tp` in `target`, if any.
       *
       * Note that this predicate crucially does not depend on type inference,
       * and hence can appear in negated position, e.g., as in
       * `directTypeMatch`.
       */
      bindingset[a, target]
      pragma[inline_late]
      private Type getTypeArgument(Access a, Declaration target, TypeParameter tp, TypePath path) {
        exists(TypeArgumentPosition tapos, TypeParameterPosition tppos |
          result = a.getTypeArgument(tapos, path) and
          tp = target.getTypeParameter(tppos) and
          typeArgumentParameterPositionMatch(tapos, tppos)
        )
      }

      /**
       * Holds if the type `t` at `path` of `a` matches the type parameter `tp`
       * of `target`.
       */
      pragma[nomagic]
      private predicate directTypeMatch(
        Access a, Declaration target, TypePath path, Type t, TypeParameter tp
      ) {
        not exists(getTypeArgument(a, target, tp, _)) and
        exists(AccessPosition apos, DeclarationPosition dpos, TypePath pathToTypeParam |
          tp = target.getDeclaredType(dpos, pathToTypeParam) and
          accessDeclarationPositionMatch(apos, dpos) and
          adjustedAccessType(a, apos, target, pathToTypeParam.appendInverse(path), t)
        )
      }

      private module AccessBaseType {
        /**
         * Holds if inferring types at `a` might depend on the type at `path` of
         * `apos` having `base` as a transitive base type.
         */
        private predicate relevantAccess(Access a, AccessPosition apos, Type base) {
          exists(Declaration target, DeclarationPosition dpos |
            adjustedAccessType(a, apos, target, _, _) and
            accessDeclarationPositionMatch(apos, dpos) and
            declarationBaseType(target, dpos, base, _, _)
          )
        }

        pragma[nomagic]
        private Type inferTypeAt(Access a, AccessPosition apos, TypeParameter tp, TypePath suffix) {
          relevantAccess(a, apos, _) and
          exists(TypePath path0 |
            result = a.getInferredType(apos, path0) and
            path0.isCons(tp, suffix)
          )
        }

        /**
         * Holds if `baseMention` is a (transitive) base type mention of the
         * type of `a` at position `apos` at path `pathToSub`, and `t` is
         * mentioned (implicitly) at `path` inside `base`. For example, in
         *
         * ```csharp
         * class C<T1> { }
         *
         * class Base<T2> { }
         *
         * class Mid<T3> : Base<C<T3>> { }
         *
         * class Sub<T4> : Mid<C<T4>> { }
         *
         *     new Sub<int>().ToString();
         * //  ^^^^^^^^^^^^^^ node at `apos`
         * //  ^^^^^^^^^^^^^^^^^^^^^^^^^ `a`
         * ```
         *
         * where the method call is an access, `new Sub<int>()` is at the access
         * position which is the receiver of a method call, and `pathToSub` is
         * `""` we have:
         *
         * `baseMention` | `path`       | `t`
         * ------------- | ------------ | ---
         * `Mid<C<T4>>`  | `"T3"`       | ``C`1``
         * `Mid<C<T4>>`  | `"T3.T1"`    | `int`
         * `Base<C<T3>>` | `"T2"`       | ``C`1``
         * `Base<C<T3>>` | `"T2.T1"`    | ``C`1``
         * `Base<C<T3>>` | `"T2.T1.T1"` | `int`
         */
        predicate hasBaseTypeMention(
          Access a, AccessPosition apos, TypeMention baseMention, TypePath path, Type t
        ) {
          relevantAccess(a, apos, resolveTypeMentionRoot(baseMention)) and
          exists(Type sub | sub = a.getInferredType(apos, TypePath::nil()) |
            baseTypeMentionHasNonTypeParameterAt(sub, baseMention, path, t)
            or
            exists(TypePath prefix, TypePath suffix, TypeParameter tp |
              baseTypeMentionHasTypeParameterAt(sub, baseMention, prefix, tp) and
              t = inferTypeAt(a, apos, tp, suffix) and
              path = prefix.append(suffix)
            )
          )
        }
      }

      private module AccessConstraint {
        predicate relevantAccessConstraint(
          Access a, AccessPosition apos, TypePath path, Type constraint
        ) {
          exists(DeclarationPosition dpos |
            accessDeclarationPositionMatch(apos, dpos) and
            typeParameterConstraintHasTypeParameter(a.getTarget(), dpos, path, _, constraint, _, _)
          )
        }

        private newtype TRelevantAccess =
          MkRelevantAccess(Access a, AccessPosition apos, TypePath path) {
            relevantAccessConstraint(a, apos, path, _)
          }

        /**
         * If the access `a` for `apos` and `path` has an inferred type which
         * type inference requires to satisfy some constraint.
         */
        private class RelevantAccess extends MkRelevantAccess {
          Access a;
          AccessPosition apos;
          TypePath path;

          RelevantAccess() { this = MkRelevantAccess(a, apos, path) }

          Type getTypeAt(TypePath suffix) {
            a.getInferredType(apos, path.appendInverse(suffix)) = result
          }

          /** Holds if this relevant access has the type `type` and should satisfy `constraint`. */
          predicate hasTypeConstraint(Type type, Type constraint) {
            type = a.getInferredType(apos, path) and
            relevantAccessConstraint(a, apos, path, constraint)
          }

          string toString() {
            result = a.toString() + ", " + apos.toString() + ", " + path.toString()
          }

          Location getLocation() { result = a.getLocation() }
        }

        private module IsInstantiationOfInput implements IsInstantiationOfInputSig<RelevantAccess> {
          predicate potentialInstantiationOf(
            RelevantAccess at, TypeAbstraction abs, TypeMention cond
          ) {
            exists(Type constraint, Type type |
              at.hasTypeConstraint(type, constraint) and
              rootTypesSatisfaction(type, constraint, abs, cond, _) and
              // We only need to check instantiations where there are multiple candidates.
              countConstraintImplementations(type, constraint) > 1
            )
          }

          predicate relevantTypeMention(TypeMention constraint) {
            rootTypesSatisfaction(_, _, _, constraint, _)
          }
        }

        /**
         * Holds if `at` satisfies `constraint` through `abs`, `sub`, and `constraintMention`.
         */
        private predicate hasConstraintMention(
          RelevantAccess at, TypeAbstraction abs, TypeMention sub, Type constraint,
          TypeMention constraintMention
        ) {
          exists(Type type | at.hasTypeConstraint(type, constraint) |
            not exists(countConstraintImplementations(type, constraint)) and
            conditionSatisfiesConstraintTypeAt(abs, sub, constraintMention, _, _) and
            resolveTypeMentionRoot(sub) = abs.getATypeParameter() and
            constraint = resolveTypeMentionRoot(constraintMention)
            or
            countConstraintImplementations(type, constraint) > 0 and
            rootTypesSatisfaction(type, constraint, abs, sub, constraintMention) and
            // When there are multiple ways the type could implement the
            // constraint we need to find the right implementation, which is the
            // one where the type instantiates the precondition.
            if countConstraintImplementations(type, constraint) > 1
            then
              IsInstantiationOf<RelevantAccess, IsInstantiationOfInput>::isInstantiationOf(at, abs,
                sub)
            else any()
          )
        }

        /**
         * Holds if the type at `a`, `apos`, and `path` satisfies the constraint
         * `constraint` with the type `t` at `path`.
         */
        pragma[nomagic]
        predicate satisfiesConstraintTypeMention(
          Access a, AccessPosition apos, TypePath prefix, Type constraint, TypePath path, Type t
        ) {
          exists(
            RelevantAccess at, TypeAbstraction abs, TypeMention sub, Type t0, TypePath prefix0,
            TypeMention constraintMention
          |
            at = MkRelevantAccess(a, apos, prefix) and
            hasConstraintMention(at, abs, sub, constraint, constraintMention) and
            conditionSatisfiesConstraintTypeAt(abs, sub, constraintMention, prefix0, t0)
          |
            not t0 = abs.getATypeParameter() and t = t0 and path = prefix0
            or
            t0 = abs.getATypeParameter() and
            exists(TypePath path3, TypePath suffix |
              sub.resolveTypeAt(path3) = t0 and
              at.getTypeAt(path3.appendInverse(suffix)) = t and
              path = prefix0.append(suffix)
            )
          )
        }
      }

      /**
       * Holds if the type of `a` at `apos` has the base type `base`, and when
       * viewed as an element of that type has the type `t` at `path`.
       */
      pragma[nomagic]
      private predicate accessBaseType(
        Access a, AccessPosition apos, Type base, TypePath path, Type t
      ) {
        exists(TypeMention tm |
          AccessBaseType::hasBaseTypeMention(a, apos, tm, path, t) and
          base = resolveTypeMentionRoot(tm)
        )
      }

      /**
       * Holds if the declared type at `decl` for `dpos` at the `path` is `tp`
       * and `path` starts with a type parameter of `base`.
       */
      pragma[nomagic]
      private predicate declarationBaseType(
        Declaration decl, DeclarationPosition dpos, Type base, TypePath path, TypeParameter tp
      ) {
        tp = decl.getDeclaredType(dpos, path) and
        base.getATypeParameter() = path.getHead()
      }

      /**
       * Holds if the (transitive) base type `t` at `path` of `a` for some
       * `AccessPosition` matches the type parameter `tp`, which is used in the
       * declared types of `target`.
       *
       * For example, in
       *
       * ```csharp
       * class C<T1> { }
       *
       * class Base<T2> {
       * //         ^^ `tp`
       *     public C<T2> Method() { ... }
       * //               ^^^^^^ `target`
       * }
       *
       * class Mid<T3> : Base<C<T3>> { }
       *
       * class Sub<T4> : Mid<C<T4>> { }
       *
       *    new Sub<int>().Method(); // Note: `Sub<int>` is a subtype of `Base<C<C<int>>>`
       * // ^^^^^^^^^^^^^^^^^^^^^^^ `a`
       * ```
       *
       * we have that type parameter `T2` of `Base` is matched as follows:
       *
       * `path`    | `t`
       * --------- | -------
       * `""`      | ``C`1``
       * `"T1"`    | ``C`1``
       * `"T1.T1"` | `int`
       */
      pragma[nomagic]
      private predicate baseTypeMatch(
        Access a, Declaration target, TypePath path, Type t, TypeParameter tp
      ) {
        not exists(getTypeArgument(a, target, tp, _)) and
        target = a.getTarget() and
        exists(AccessPosition apos, DeclarationPosition dpos, Type base, TypePath pathToTypeParam |
          accessBaseType(a, apos, base, pathToTypeParam.appendInverse(path), t) and
          declarationBaseType(target, dpos, base, pathToTypeParam, tp) and
          accessDeclarationPositionMatch(apos, dpos)
        )
      }

      /**
       * Holds if for `a` and corresponding `target`, the type parameter `tp` is
       * matched by a type argument at the access with type `t` and type path
       * `path`.
       */
      pragma[nomagic]
      private predicate explicitTypeMatch(
        Access a, Declaration target, TypePath path, Type t, TypeParameter tp
      ) {
        target = a.getTarget() and
        t = getTypeArgument(a, target, tp, path)
      }

      /**
       * Holds if `tp1` and `tp2` are distinct type parameters of `target`, the
       * declared type at `dpos` mentions `tp1` at `path1`, `tp1` has a base
       * type mention of type `constraint` that mentions `tp2` at the path
       * `path2`.
       *
       * For this example
       * ```csharp
       * interface IFoo<A> { }
       * T1 M<T1, T2>(T2 item) where T2 : IFoo<T1> { }
       * ```
       * with the method declaration being the target and the for the first
       * parameter position, we have the following
       * - `path1 = ""`,
       * - `tp1 = T2`,
       * - `constraint = IFoo`,
       * - `path2 = "A"`, and
       * - `tp2 = T1`.
       */
      pragma[nomagic]
      private predicate typeParameterConstraintHasTypeParameter(
        Declaration target, DeclarationPosition dpos, TypePath path1, TypeParameter tp1,
        Type constraint, TypePath path2, TypeParameter tp2
      ) {
        tp1 = target.getTypeParameter(_) and
        tp2 = target.getTypeParameter(_) and
        tp1 != tp2 and
        tp1 = target.getDeclaredType(dpos, path1) and
        exists(TypeMention tm |
          tm = getATypeParameterConstraint(tp1) and
          tm.resolveTypeAt(path2) = tp2 and
          constraint = resolveTypeMentionRoot(tm)
        )
      }

      pragma[nomagic]
      private predicate typeConstraintBaseTypeMatch(
        Access a, Declaration target, TypePath path, Type t, TypeParameter tp
      ) {
        not exists(getTypeArgument(a, target, tp, _)) and
        target = a.getTarget() and
        exists(
          Type constraint, AccessPosition apos, DeclarationPosition dpos, TypePath pathToTp,
          TypePath pathToTp2
        |
          accessDeclarationPositionMatch(apos, dpos) and
          typeParameterConstraintHasTypeParameter(target, dpos, pathToTp2, _, constraint, pathToTp,
            tp) and
          AccessConstraint::satisfiesConstraintTypeMention(a, apos, pathToTp2, constraint,
            pathToTp.appendInverse(path), t)
        )
      }

      pragma[inline]
      private predicate typeMatch(
        Access a, Declaration target, TypePath path, Type t, TypeParameter tp
      ) {
        // A type given at the access corresponds directly to the type parameter
        // at the target.
        explicitTypeMatch(a, target, path, t, tp)
        or
        // We can infer the type of `tp` from one of the access positions
        directTypeMatch(a, target, path, t, tp)
        or
        // We can infer the type of `tp` by going up the type hiearchy
        baseTypeMatch(a, target, path, t, tp)
        or
        // We can infer the type of `tp` by a type constraint
        typeConstraintBaseTypeMatch(a, target, path, t, tp)
      }

      /**
       * Gets the inferred type of `a` at `path` for position `apos`.
       *
       * For example, in
       *
       * ```csharp
       * class C<T1> { }
       *
       * class Base<T2> {
       *     public C<T2> Method() { ... }
       * }
       *
       * class Mid<T3> : Base<C<T3>> { }
       *
       * class Sub<T4> : Mid<C<T4>> { }
       *
       *    new Sub<int>().Method(); // Note: Sub<int> is a subtype of Base<C<C<int>>>
       * // ^^^^^^^^^^^^^^^^^^^^^^^ `a`
       * ```
       *
       * we infer the following types for the return position:
       *
       * `path`       | `t`
       * ------------ | -------
       * `""`         | ``C`1``
       * `"T1"`       | ``C`1``
       * `"T1.T1"`    | ``C`1``
       * `"T1.T1.T1"` | `int`
       *
       * We also infer the following types for the receiver position:
       *
       * `path`       | `t`
       * ------------ | -------
       * `""`         | ``Base`1``
       * `"T2"`       | ``C`1``
       * `"T2.T1"`    | ``C`1``
       * `"T2.T1.T1"` | `int`
       */
      pragma[nomagic]
      Type inferAccessType(Access a, AccessPosition apos, TypePath path) {
        exists(DeclarationPosition dpos | accessDeclarationPositionMatch(apos, dpos) |
          // A suffix of `path` leads to a type parameter in the target
          exists(Declaration target, TypePath prefix, TypeParameter tp, TypePath suffix |
            tp = target.getDeclaredType(pragma[only_bind_into](dpos), prefix) and
            path = prefix.append(suffix) and
            typeMatch(a, target, suffix, result, tp)
          )
          or
          // `path` corresponds directly to a concrete type in the declaration
          exists(Declaration target |
            result = target.getDeclaredType(pragma[only_bind_into](dpos), path) and
            target = a.getTarget() and
            not result instanceof TypeParameter
          )
        )
      }
    }

    /** Provides consistency checks. */
    module Consistency {
      query predicate missingTypeParameterId(TypeParameter tp) {
        not exists(getTypeParameterId(tp))
      }

      query predicate nonFunctionalTypeParameterId(TypeParameter tp) {
        getTypeParameterId(tp) != getTypeParameterId(tp)
      }

      query predicate nonInjectiveTypeParameterId(TypeParameter tp1, TypeParameter tp2) {
        getTypeParameterId(tp1) = getTypeParameterId(tp2) and
        tp1 != tp2
      }

      query predicate illFormedTypeMention(TypeMention tm) {
        not exists(tm.resolveTypeAt(TypePath::nil())) and exists(tm.getLocation())
      }
    }
  }
}
