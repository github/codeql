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
 * The intended use of this library is to define a predicate
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
overlay[local?]
module;

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

  /**
   * Holds if `t` is a pseudo type. Pseudo types are skipped when checking for
   * non-instantiations in `isNotInstantiationOf`.
   */
  predicate isPseudoType(Type t);

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
  private import codeql.util.UnboundList as UnboundListImpl

  private module UnboundListInput implements UnboundListImpl::InputSig<Location> {
    class Element = TypeParameter;

    predicate getId = getTypeParameterId/1;

    predicate getLengthLimit = getTypePathLimit/0;
  }

  private import UnboundListImpl::Make<Location, UnboundListInput>

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
  class TypePath = UnboundList;

  /** Provides predicates for constructing `TypePath`s. */
  module TypePath = UnboundList;

  /**
   * A class that has a type tree associated with it.
   *
   * The type tree is represented by the `getTypeAt` predicate, which for every
   * path into the tree gives the type at that path.
   */
  signature class HasTypeTreeSig {
    /** Gets the type at `path` in the type tree. */
    Type getTypeAt(TypePath path);

    /** Gets a textual representation of this type tree. */
    string toString();

    /** Gets the location of this type tree. */
    Location getLocation();
  }

  /**
   * Provides the input to `Make2`.
   *
   * The `TypeMention` parameter is used to build the base type hierarchy based on
   * `getABaseTypeMention` and to construct the constraint satisfaction
   * hierarchy based on `conditionSatisfiesConstraint`.
   *
   * It will usually be based on syntactic occurrences of types in the source
   * code. For example, in
   *
   * ```csharp
   * class C<T> : Base<T>, Interface { }
   * ```
   *
   * a type mention would exist for `Base<T>` and resolve to the following
   * types:
   *
   * `TypePath` | `Type`
   * ---------- | -------
   * `""`       | ``Base`1``
   * `"0"`      | `T`
   */
  signature module InputSig2<HasTypeTreeSig TypeMention> {
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
     *   resulting `condition` satisfies the constraint given by `constraint`.
     * - `transitive` corresponds to whether any further constraints satisfied
     *   through `constraint` should also apply to `condition`.
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
      TypeAbstraction abs, TypeMention condition, TypeMention constraint, boolean transitive
    );

    /**
     * Holds if the constraint belonging to `abs` with root type `constraint` is
     * ambiguous at `path`, meaning that there is _some_ other abstraction `abs2`
     * with a structurally identical condition and same root constraint type
     * `constraint`, and where the constraints differ at `path`.
     *
     * Example:
     *
     * ```rust
     * trait Trait<T1, T2> { }
     *
     *    impl<T> Trait<i32, bool> for Foo<T> { ... }
     * //     ^^^ `abs`
     * //         ^^^^^ `constraint`
     * //                              ^^^^^^ `condition`
     *
     *    impl<T> Trait<i64, bool> for Foo<T> { }
     * //     ^^^ `abs2`
     * //         ^^^^^ `constraint`
     * //                              ^^^^^^ `condition2`
     * ```
     *
     * In the above, `abs` and `abs2` have structurally identical conditions,
     * `condition` and `condition2`, and they differ at the path `"T1"`, but
     * not at the path `"T2"`.
     */
    predicate typeAbstractionHasAmbiguousConstraintAt(
      TypeAbstraction abs, Type constraint, TypePath path
    );

    /**
     * Holds if all instantiations of `tp` are functionally determined by the
     * instantiations of the other type parameters in the same abstraction.
     *
     * For example, in Rust all associated types act as functionally determined
     * type parameters.
     */
    predicate typeParameterIsFunctionallyDetermined(TypeParameter tp);
  }

  module Make2<HasTypeTreeSig TypeMention, InputSig2<TypeMention> Input2> {
    private import Input2

    /** Gets the type at the empty path of `tm`. */
    bindingset[tm]
    pragma[inline_late]
    private Type getTypeMentionRoot(TypeMention tm) { result = tm.getTypeAt(TypePath::nil()) }

    /** Provides the input to `IsInstantiationOf`. */
    signature module IsInstantiationOfInputSig<HasTypeTreeSig App, HasTypeTreeSig Constraint> {
      /**
       * Holds if `abs` is a type abstraction, `constraint` occurs in the scope of
       * `abs`, and `app` is potentially an application/instantiation of `abs`.
       *
       * For example:
       * ```rust
       * impl<A> Foo<A, A> {
       * //  ^^^ `abs`
       * //      ^^^^^^^^^ `constraint`
       *   fn bar(self) { ... }
       * }
       * // ...
       *    foo.bar();
       * // ^^^ `app`
       * ```
       * Here `abs` introduces the type parameter `A` and `constraint` occurs in the
       * scope of `abs` (i.e., `A` is bound in `constraint` by `abs`). On the last line,
       * accessing the `bar` method of `foo` potentially instantiates the `impl`
       * block with a type argument for `A`.
       */
      predicate potentialInstantiationOf(App app, TypeAbstraction abs, Constraint constraint);

      /**
       * Holds if `constraint` might occur as the third argument of
       * `potentialInstantiationOf`. Defaults to simply projecting the third
       * argument of `potentialInstantiationOf`.
       */
      default predicate relevantConstraint(Constraint constraint) {
        potentialInstantiationOf(_, _, constraint)
      }
    }

    /**
     * Provides functionality for determining if a type is a possible
     * instantiation of a type mention containing type parameters.
     */
    module IsInstantiationOf<
      HasTypeTreeSig App, HasTypeTreeSig Constraint,
      IsInstantiationOfInputSig<App, Constraint> Input>
    {
      private import Input

      /** Gets the `i`th path in `constraint` per some arbitrary order. */
      pragma[nomagic]
      private TypePath getNthPath(Constraint constraint, int i) {
        result =
          rank[i + 1](TypePath path |
            exists(constraint.getTypeAt(path)) and relevantConstraint(constraint)
          |
            path
          )
      }

      pragma[nomagic]
      private Type getTypeAt(App app, TypeAbstraction abs, Constraint constraint, TypePath path) {
        potentialInstantiationOf(app, abs, constraint) and
        result = constraint.getTypeAt(path)
      }

      pragma[nomagic]
      private Type getNthTypeAt(
        App app, TypeAbstraction abs, Constraint constraint, int i, TypePath path
      ) {
        path = getNthPath(constraint, i) and
        result = getTypeAt(app, abs, constraint, path)
      }

      pragma[nomagic]
      private predicate satisfiesConcreteTypesToIndex(
        App app, TypeAbstraction abs, Constraint constraint, int i
      ) {
        exists(Type t, TypePath path |
          t = getNthTypeAt(app, abs, constraint, i, path) and
          if t = abs.getATypeParameter() then any() else app.getTypeAt(path) = t
        ) and
        // Recurse unless we are at the first path
        if i = 0 then any() else satisfiesConcreteTypesToIndex(app, abs, constraint, i - 1)
      }

      /** Holds if all the concrete types in `constraint` also occur in `app`. */
      pragma[nomagic]
      private predicate satisfiesConcreteTypes(App app, TypeAbstraction abs, Constraint constraint) {
        satisfiesConcreteTypesToIndex(app, abs, constraint,
          max(int i | exists(getNthPath(constraint, i))))
      }

      private TypeParameter getNthTypeParameter(TypeAbstraction abs, int i) {
        result =
          rank[i + 1](TypeParameter tp | tp = abs.getATypeParameter() | tp order by getRank(tp))
      }

      /**
       * Gets the path to the `i`th occurrence of `tp` within `constraint` per some
       * arbitrary order, if any.
       */
      pragma[nomagic]
      private TypePath getNthTypeParameterPath(Constraint constraint, TypeParameter tp, int i) {
        result =
          rank[i + 1](TypePath path |
            tp = constraint.getTypeAt(path) and relevantConstraint(constraint)
          |
            path
          )
      }

      pragma[nomagic]
      private predicate typeParametersEqualToIndexBase(
        App app, TypeAbstraction abs, Constraint constraint, TypeParameter tp, TypePath path
      ) {
        path = getNthTypeParameterPath(constraint, tp, 0) and
        satisfiesConcreteTypes(app, abs, constraint) and
        // no need to compute this predicate if there is only one path
        exists(getNthTypeParameterPath(constraint, tp, 1))
      }

      pragma[nomagic]
      private predicate typeParametersEqualToIndex(
        App app, TypeAbstraction abs, Constraint constraint, TypeParameter tp, Type t, int i
      ) {
        exists(TypePath path |
          t = app.getTypeAt(path) and
          if i = 0
          then typeParametersEqualToIndexBase(app, abs, constraint, tp, path)
          else (
            typeParametersEqualToIndex(app, abs, constraint, tp, t, i - 1) and
            path = getNthTypeParameterPath(constraint, tp, i)
          )
        )
      }

      pragma[nomagic]
      private predicate typeParametersEqual(
        App app, TypeAbstraction abs, Constraint constraint, int i
      ) {
        exists(TypeParameter tp |
          satisfiesConcreteTypes(app, abs, constraint) and
          tp = getNthTypeParameter(abs, i)
        |
          not exists(getNthTypeParameterPath(constraint, tp, _))
          or
          exists(int n | n = max(int j | exists(getNthTypeParameterPath(constraint, tp, j))) |
            // If the largest index is 0, then there are no equalities to check as
            // the type parameter only occurs once.
            if n = 0 then any() else typeParametersEqualToIndex(app, abs, constraint, tp, _, n)
          )
        )
      }

      private predicate typeParametersHaveEqualInstantiationToIndex(
        App app, TypeAbstraction abs, Constraint constraint, int i
      ) {
        typeParametersEqual(app, abs, constraint, i) and
        if i = 0
        then any()
        else typeParametersHaveEqualInstantiationToIndex(app, abs, constraint, i - 1)
      }

      /**
       * Holds if `app` is a possible instantiation of `constraint`. That is, by making
       * appropriate substitutions for the free type parameters in `constraint` given by
       * `abs`, it is possible to obtain `app`.
       *
       * For instance, if `A` and `B` are free type parameters we have:
       * - `Pair<int, string>` is an instantiation of       `A`
       * - `Pair<int, string>` is an instantiation of       `Pair<A, B>`
       * - `Pair<int, int>`    is an instantiation of       `Pair<A, A>`
       * - `Pair<int, bool>`   is _not_ an instantiation of `Pair<A, A>`
       * - `Pair<int, string>` is _not_ an instantiation of `Pair<string, string>`
       */
      pragma[nomagic]
      predicate isInstantiationOf(App app, TypeAbstraction abs, Constraint constraint) {
        // We only need to check equality if the concrete types are satisfied.
        satisfiesConcreteTypes(app, abs, constraint) and
        // Check if all the places where the same type parameter occurs in `constraint`
        // are equal in `app`.
        //
        // TODO: As of now this only checks equality at the root of the types
        // instantiated for type parameters. So, for instance, `Pair<Vec<i64>, Vec<bool>>`
        // is mistakenly considered an instantiation of `Pair<A, A>`.
        (
          not exists(getNthTypeParameter(abs, _))
          or
          exists(int n | n = max(int i | exists(getNthTypeParameter(abs, i))) |
            typeParametersHaveEqualInstantiationToIndex(app, abs, constraint, n)
          )
        )
      }

      pragma[nomagic]
      private predicate hasTypeParameterAt(
        App app, TypeAbstraction abs, Constraint constraint, TypePath path, TypeParameter tp
      ) {
        tp = getTypeAt(app, abs, constraint, path) and
        tp = abs.getATypeParameter()
      }

      private Type getNonPseudoTypeAt(App app, TypePath path) {
        result = app.getTypeAt(path) and not isPseudoType(result)
      }

      pragma[nomagic]
      private Type getNonPseudoTypeAtTypeParameter(
        App app, TypeAbstraction abs, Constraint constraint, TypeParameter tp, TypePath path
      ) {
        hasTypeParameterAt(app, abs, constraint, path, tp) and
        result = getNonPseudoTypeAt(app, path)
      }

      /**
       * Holds if `app` is _not_ a possible instantiation of `constraint`, because `app`
       * and `constraint` differ on concrete types at `path`.
       *
       * This is an approximation of `not isInstantiationOf(app, abs, constraint)`, but
       * defined without a negative occurrence of `isInstantiationOf`.
       *
       * Due to the approximation, both `isInstantiationOf` and `isNotInstantiationOf`
       * can hold for the same values. For example, if `app` has two different types `t1`
       * and `t2` at the same type path, and `t1` satisfies `constraint` while `t2` does
       * not, then both `isInstantiationOf` and `isNotInstantiationOf` will hold.
       *
       * Dually, if `app` does not have a type at a required type path, then neither
       * `isInstantiationOf` nor `isNotInstantiationOf` will hold.
       */
      pragma[nomagic]
      predicate isNotInstantiationOf(
        App app, TypeAbstraction abs, Constraint constraint, TypePath path
      ) {
        // `app` and `constraint` differ on a non-pseudo concrete type
        exists(Type t, Type t2 |
          t = getTypeAt(app, abs, constraint, path) and
          not t = abs.getATypeParameter() and
          t2 = getNonPseudoTypeAt(app, path) and
          t2 != t
        )
        or
        // `app` has different instantiations of a type parameter mentioned at two
        // different paths
        exists(TypeParameter tp, TypePath path2, Type t, Type t2 |
          t = getNonPseudoTypeAtTypeParameter(app, abs, constraint, tp, path) and
          t2 = getNonPseudoTypeAtTypeParameter(app, abs, constraint, tp, path2) and
          t != t2 and
          path != path2
        )
      }
    }

    /** Provides logic related to base types. */
    module BaseTypes {
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
          tm2.getTypeAt(prefix) = tp and t = tm1.getTypeAt(prefix.appendInverse(path))
        )
      }

      private module IsInstantiationOfInput implements
        IsInstantiationOfInputSig<TypeMention, TypeMention>
      {
        pragma[nomagic]
        private predicate typeCondition(Type type, TypeAbstraction abs, TypeMention condition) {
          conditionSatisfiesConstraint(abs, condition, _, _) and
          type = getTypeMentionRoot(condition)
        }

        pragma[nomagic]
        private predicate typeConstraint(Type type, TypeMention constraint) {
          conditionSatisfiesConstraint(_, _, constraint, _) and
          type = getTypeMentionRoot(constraint)
        }

        predicate potentialInstantiationOf(
          TypeMention constraint, TypeAbstraction abs, TypeMention condition
        ) {
          exists(Type type |
            typeConstraint(type, constraint) and typeCondition(type, abs, condition)
          )
        }
      }

      /**
       * Holds if the type mention `condition` satisfies `constraint` with the
       * type `t` at the path `path`.
       */
      pragma[nomagic]
      predicate conditionSatisfiesConstraintTypeAt(
        TypeAbstraction abs, TypeMention condition, TypeMention constraint, TypePath path, Type t
      ) {
        // base case
        conditionSatisfiesConstraint(abs, condition, constraint, _) and
        constraint.getTypeAt(path) = t
        or
        // recursive case
        exists(TypeAbstraction midAbs, TypeMention midConstraint, TypeMention midCondition |
          conditionSatisfiesConstraint(abs, condition, midConstraint, true) and
          // NOTE: `midAbs` describe the free type variables in `midCondition`, hence
          // we use that for instantiation check.
          IsInstantiationOf<TypeMention, TypeMention, IsInstantiationOfInput>::isInstantiationOf(midConstraint,
            midAbs, midCondition)
        |
          conditionSatisfiesConstraintTypeAt(midAbs, midCondition, constraint, path, t) and
          not t = midAbs.getATypeParameter()
          or
          exists(TypePath prefix, TypePath suffix, TypeParameter tp |
            tp = midAbs.getATypeParameter() and
            conditionSatisfiesConstraintTypeAt(midAbs, midCondition, constraint, prefix, tp) and
            instantiatesWith(midConstraint, midCondition, tp, suffix, t) and
            path = prefix.append(suffix)
          )
        )
      }

      /**
       * Holds if it's possible for a type with `conditionRoot` at the root to
       * satisfy a constraint with `constraintRoot` at the root through `abs`,
       * `condition`, and `constraint`.
       */
      predicate rootTypesSatisfaction(
        Type conditionRoot, Type constraintRoot, TypeAbstraction abs, TypeMention condition,
        TypeMention constraint
      ) {
        conditionSatisfiesConstraintTypeAt(abs, condition, constraint, _, _) and
        conditionRoot = getTypeMentionRoot(condition) and
        constraintRoot = getTypeMentionRoot(constraint)
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
       * Holds if there is multiple ways in which a type with `conditionRoot` at
       * the root can satisfy a constraint with `constraintRoot` at the root.
       */
      predicate multipleConstraintImplementations(Type conditionRoot, Type constraintRoot) {
        countConstraintImplementations(conditionRoot, constraintRoot) > 1
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
          t = immediateBaseMention.getTypeAt(path)
          or
          // transitive base class
          exists(Type immediateBase | immediateBase = getTypeMentionRoot(immediateBaseMention) |
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
              t = immediateBaseMention.getTypeAt(path0) and
              path0.isCons(tp, suffix) and
              path = prefix.append(suffix)
            )
          )
        )
      }

      overlay[caller?]
      pragma[inline]
      predicate baseTypeMentionHasNonTypeParameterAt(
        Type sub, TypeMention baseMention, TypePath path, Type t
      ) {
        not t = sub.getATypeParameter() and baseTypeMentionHasTypeAt(sub, baseMention, path, t)
      }

      overlay[caller?]
      pragma[inline]
      predicate baseTypeMentionHasTypeParameterAt(
        Type sub, TypeMention baseMention, TypePath path, TypeParameter tp
      ) {
        tp = sub.getATypeParameter() and baseTypeMentionHasTypeAt(sub, baseMention, path, tp)
      }
    }

    private import BaseTypes

    /** Provides the input to `SatisfiesConstraintWithTypeMatching`. */
    signature module SatisfiesConstraintWithTypeMatchingInputSig<
      HasTypeTreeSig Term, HasTypeTreeSig Constraint>
    {
      /** Holds if it is relevant to know if `term` satisfies `constraint`. */
      predicate relevantConstraint(Term term, Constraint constraint);

      /** A context in which a type parameter can be matched with an instantiation. */
      class TypeMatchingContext;

      /** Gets the type matching context for `t`. */
      TypeMatchingContext getTypeMatchingContext(Term t);

      /**
       * Holds if `tp` can be matched with the type `t` at `path` in the context `ctx`.
       *
       * This may be used to disambiguate between multiple constraints that a term may satisfy.
       */
      predicate typeMatch(TypeMatchingContext ctx, TypeParameter tp, TypePath path, Type t);
    }

    module SatisfiesConstraintWithTypeMatching<
      HasTypeTreeSig Term, HasTypeTreeSig Constraint,
      SatisfiesConstraintWithTypeMatchingInputSig<Term, Constraint> Input>
    {
      private import Input

      pragma[nomagic]
      private Type getTypeAt(Term term, TypePath path) {
        relevantConstraint(term, _) and
        result = term.getTypeAt(path)
      }

      /** Holds if the type tree has the type `type` and should satisfy `constraint`. */
      pragma[nomagic]
      private predicate hasTypeConstraint(
        Term term, Type type, Constraint constraint, Type constraintRoot
      ) {
        type = getTypeAt(term, TypePath::nil()) and
        relevantConstraint(term, constraint) and
        constraintRoot = constraint.getTypeAt(TypePath::nil())
      }

      private module TermIsInstantiationOfConditionInput implements
        IsInstantiationOfInputSig<Term, TypeMention>
      {
        predicate potentialInstantiationOf(Term term, TypeAbstraction abs, TypeMention cond) {
          exists(Constraint constraint, Type type, Type constraintRoot |
            hasTypeConstraint(term, type, constraint, constraintRoot) and
            rootTypesSatisfaction(type, constraintRoot, abs, cond, _) and
            // We only need to check instantiations where there are multiple candidates.
            multipleConstraintImplementations(type, constraintRoot)
          )
        }

        predicate relevantConstraint(TypeMention constraint) {
          rootTypesSatisfaction(_, _, _, constraint, _)
        }
      }

      private module TermIsInstantiationOfCondition =
        IsInstantiationOf<Term, TypeMention, TermIsInstantiationOfConditionInput>;

      /**
       * Holds if `term` satisfies `constraint` through `abs`, `sub`, and `constraintMention`.
       */
      pragma[nomagic]
      private predicate hasConstraintMention(
        Term term, TypeAbstraction abs, TypeMention condition, Constraint constraint,
        Type constraintRoot, TypeMention constraintMention
      ) {
        exists(Type type | hasTypeConstraint(term, type, constraint, constraintRoot) |
          // TODO: Handle universal conditions properly, which means checking type parameter constraints
          // Also remember to update logic in `hasNotConstraintMention`
          //
          // not exists(countConstraintImplementations(type, constraint)) and
          // conditionSatisfiesConstraintTypeAt(abs, condition, constraintMention, _, _) and
          // getTypeMentionRoot(condition) = abs.getATypeParameter() and
          // constraint = getTypeMentionRoot(constraintMention)
          // or
          countConstraintImplementations(type, constraintRoot) > 0 and
          rootTypesSatisfaction(type, constraintRoot, abs, condition, constraintMention) and
          // When there are multiple ways the type could implement the
          // constraint we need to find the right implementation, which is the
          // one where the type instantiates the precondition.
          if multipleConstraintImplementations(type, constraintRoot)
          then TermIsInstantiationOfCondition::isInstantiationOf(term, abs, condition)
          else any()
        )
      }

      pragma[nomagic]
      private predicate isNotInstantiationOf(
        Term term, TypeAbstraction abs, TypeMention condition, Type root
      ) {
        exists(TypePath path |
          TermIsInstantiationOfCondition::isNotInstantiationOf(term, abs, condition, path) and
          path.isCons(root.getATypeParameter(), _)
        )
      }

      /**
       * Holds if `term` does not satisfy `constraint`.
       *
       * This predicate is an approximation of `not hasConstraintMention(term, _, _, constraint, _, _)`.
       */
      pragma[nomagic]
      private predicate hasNotConstraintMention(
        Term term, Constraint constraint, Type constraintRoot
      ) {
        exists(Type type | hasTypeConstraint(term, type, constraint, constraintRoot) |
          // TODO: Handle universal conditions properly, which means taking type parameter constraints into account
          // (
          //   exists(countConstraintImplementations(type, constraint))
          //   or
          //   forall(TypeAbstraction abs, TypeMention condition, TypeMention constraintMention |
          //     conditionSatisfiesConstraintTypeAt(abs, condition, constraintMention, _, _) and
          //     getTypeMentionRoot(condition) = abs.getATypeParameter()
          //   |
          //     not constraint = getTypeMentionRoot(constraintMention)
          //   )
          // ) and
          (
            countConstraintImplementations(type, constraintRoot) = 0
            or
            not rootTypesSatisfaction(type, constraintRoot, _, _, _)
            or
            multipleConstraintImplementations(type, constraintRoot) and
            forex(TypeAbstraction abs, TypeMention condition |
              rootTypesSatisfaction(type, constraintRoot, abs, condition, _)
            |
              isNotInstantiationOf(term, abs, condition, type)
            )
          )
        )
      }

      pragma[nomagic]
      private predicate satisfiesConstraintTypeMention0(
        Term term, Constraint constraint, TypeMention constraintMention, TypeAbstraction abs,
        TypeMention sub, TypePath path, Type t, boolean ambiguous
      ) {
        exists(Type constraintRoot |
          hasConstraintMention(term, abs, sub, constraint, constraintRoot, constraintMention) and
          conditionSatisfiesConstraintTypeAt(abs, sub, constraintMention, path, t) and
          if
            exists(TypePath prefix |
              typeAbstractionHasAmbiguousConstraintAt(abs, constraintRoot, prefix) and
              prefix.isPrefixOf(path)
            )
          then ambiguous = true
          else ambiguous = false
        )
      }

      pragma[nomagic]
      private predicate conditionSatisfiesConstraintTypeAtForDisambiguation(
        TypeAbstraction abs, TypeMention condition, TypeMention constraint, TypePath path, Type t
      ) {
        conditionSatisfiesConstraintTypeAt(abs, condition, constraint, path, t) and
        not t instanceof TypeParameter and
        not typeParameterIsFunctionallyDetermined(path.getHead())
      }

      pragma[nomagic]
      private predicate constraintTypeMatchForDisambiguation0(
        Term term, Constraint constraint, TypePath path, TypePath suffix, TypeParameter tp
      ) {
        exists(
          TypeMention constraintMention, TypeAbstraction abs, TypeMention sub, TypePath prefix
        |
          satisfiesConstraintTypeMention0(term, constraint, constraintMention, abs, sub, _, _, true) and
          conditionSatisfiesConstraintTypeAtForDisambiguation(abs, sub, constraintMention, path, _) and
          tp = constraint.getTypeAt(prefix) and
          path = prefix.appendInverse(suffix)
        )
      }

      pragma[nomagic]
      private predicate constraintTypeMatchForDisambiguation1(
        Term term, Constraint constraint, TypePath path, TypeMatchingContext ctx, TypePath suffix,
        TypeParameter tp
      ) {
        constraintTypeMatchForDisambiguation0(term, constraint, path, suffix, tp) and
        ctx = getTypeMatchingContext(term)
      }

      /**
       * Holds if the type of `constraint` at `path` is `t` because it is possible
       * to match some type parameter that occurs in `constraint` at a prefix of
       * `path` in the context of `term`.
       *
       * For example, if we have
       *
       * ```rust
       * fn f<T1, T2: SomeTrait<T1>>(x: T1, y: T2) -> T2::Output { ... }
       * ```
       *
       * then at a call like `f(true, ...)` the constraint `SomeTrait<T1>` has the
       * type `bool` substituted for `T1`.
       */
      pragma[nomagic]
      private predicate constraintTypeMatchForDisambiguation(
        Term term, Constraint constraint, TypePath path, Type t
      ) {
        exists(TypeMatchingContext ctx, TypeParameter tp, TypePath suffix |
          constraintTypeMatchForDisambiguation1(term, constraint, path, ctx, suffix, tp) and
          typeMatch(ctx, tp, suffix, t)
        )
      }

      pragma[nomagic]
      private predicate satisfiesConstraint0(
        Term term, Constraint constraint, TypeAbstraction abs, TypeMention sub, TypePath path,
        Type t
      ) {
        exists(TypeMention constraintMention, boolean ambiguous |
          satisfiesConstraintTypeMention0(term, constraint, constraintMention, abs, sub, path, t,
            ambiguous)
        |
          if ambiguous = true
          then
            // When the constraint is not uniquely satisfied, we check that the satisfying
            // abstraction is not more specific than the constraint to be satisfied. For example,
            // if the constraint is `MyTrait<i32>` and there is both `impl MyTrait<i32> for ...` and
            // `impl MyTrait<i64> for ...`, then the latter will be filtered away
            forall(TypePath path1, Type t1 |
              conditionSatisfiesConstraintTypeAtForDisambiguation(abs, sub, constraintMention,
                path1, t1)
            |
              t1 = constraint.getTypeAt(path1)
              or
              // The constraint may contain a type parameter, which we can match to the right type
              constraintTypeMatchForDisambiguation(term, constraint, path1, t1)
            )
          else any()
        )
      }

      pragma[inline]
      private predicate satisfiesConstraintInline(
        Term term, Constraint constraint, TypeAbstraction abs, TypePath pathToTypeParamInConstraint,
        TypePath pathToTypeParamInSub, TypeParameter tp
      ) {
        exists(TypeMention sub |
          satisfiesConstraint0(term, constraint, abs, sub, pathToTypeParamInConstraint, tp) and
          tp = abs.getATypeParameter() and
          sub.getTypeAt(pathToTypeParamInSub) = tp
        )
      }

      /**
       * Holds if `term` satisfies the constraint `constraint` with _some_ type
       * parameter at `pathToTypeParamInConstraint`, and the type parameter occurs
       * at `pathToTypeParamInSub` in a satisfying condition.
       *
       * Example:
       *
       * ```rust
       * struct MyThing<A> { ... }
       *
       * trait MyTrait<B> { ... }
       *
       * impl<T> MyTrait<T> for MyThing<T> { ... }
       *
       * fn foo<T: MyTrait<i32>>(x: T) { ... }
       *
       * let x = MyThing(Default::default());
       * foo(x);
       * ```
       *
       * At `term` = `foo(x)`, we have `constraint = MyTrait<i32>`, and because of the
       * `impl` block, `pathToTypeParamInConstraint` = `"B"`, and
       * `pathToTypeParamInSub` = `"A"`.
       */
      pragma[nomagic]
      predicate satisfiesConstraintAtTypeParameter(
        Term term, Constraint constraint, TypePath pathToTypeParamInConstraint,
        TypePath pathToTypeParamInSub
      ) {
        satisfiesConstraintInline(term, constraint, _, pathToTypeParamInConstraint,
          pathToTypeParamInSub, _)
      }

      pragma[inline]
      private predicate satisfiesConstraintNonTypeParamInline(
        Term term, TypeAbstraction abs, Constraint constraint, TypePath path, Type t
      ) {
        satisfiesConstraint0(term, constraint, abs, _, path, t) and
        not t = abs.getATypeParameter()
      }

      pragma[nomagic]
      private predicate hasTypeConstraint(Term term, Constraint constraint) {
        exists(Type constraintRoot |
          hasTypeConstraint(term, constraintRoot, constraint, constraintRoot)
        )
      }

      /**
       * Holds if `term` satisfies the constraint `constraint` with the type `t` at `path`.
       */
      pragma[nomagic]
      predicate satisfiesConstraint(Term term, Constraint constraint, TypePath path, Type t) {
        satisfiesConstraintNonTypeParamInline(term, _, constraint, path, t)
        or
        exists(TypePath prefix0, TypePath pathToTypeParamInSub, TypePath suffix |
          satisfiesConstraintAtTypeParameter(term, constraint, prefix0, pathToTypeParamInSub) and
          getTypeAt(term, pathToTypeParamInSub.appendInverse(suffix)) = t and
          path = prefix0.append(suffix)
        )
        or
        hasTypeConstraint(term, constraint) and
        t = getTypeAt(term, path)
      }

      pragma[nomagic]
      private predicate satisfiesConstraintThrough0(
        Term term, Constraint constraint, TypeAbstraction abs, TypePath pathToTypeParamInConstraint,
        TypePath pathToTypeParamInSub
      ) {
        satisfiesConstraintInline(term, constraint, abs, pathToTypeParamInConstraint,
          pathToTypeParamInSub, _)
      }

      /**
       * Holds if `term` satisfies the constraint `constraint` through `abs` with
       * the type `t` at `path`.
       */
      pragma[nomagic]
      predicate satisfiesConstraintThrough(
        Term term, TypeAbstraction abs, Constraint constraint, TypePath path, Type t
      ) {
        satisfiesConstraintNonTypeParamInline(term, abs, constraint, path, t)
        or
        exists(TypePath prefix0, TypePath pathToTypeParamInSub, TypePath suffix |
          satisfiesConstraintThrough0(term, constraint, abs, prefix0, pathToTypeParamInSub) and
          getTypeAt(term, pathToTypeParamInSub.appendInverse(suffix)) = t and
          path = prefix0.append(suffix)
        )
      }

      /**
       * Holds if `term` does _not_ satisfy the constraint `constraint`.
       *
       * This is an approximation of `not satisfiesConstraintType(term, constraint, _, _)`,
       * but defined without a negative occurrence of `satisfiesConstraintType`.
       *
       * Due to the approximation, both `satisfiesConstraintType` and `dissatisfiesConstraint`
       * can hold for the same values. For example, if `term` has two different types `t1`
       * and `t2`, and `t1` satisfies `constraint` while `t2` does not, then both
       * `satisfiesConstraintType` and `dissatisfiesConstraint` will hold.
       *
       * Dually, if `term` does not have a type, then neither `satisfiesConstraintType` nor
       * `dissatisfiesConstraint` will hold.
       */
      pragma[nomagic]
      predicate dissatisfiesConstraint(Term term, Constraint constraint) {
        hasNotConstraintMention(term, constraint, _) and
        exists(Type t, Type constraintRoot |
          hasTypeConstraint(term, t, constraint, constraintRoot) and
          t != constraintRoot
        )
      }
    }

    /** Provides the input to `SatisfiesConstraint`. */
    signature module SatisfiesConstraintInputSig<HasTypeTreeSig Term, HasTypeTreeSig Constraint> {
      /** Holds if it is relevant to know if `term` satisfies `constraint`. */
      predicate relevantConstraint(Term term, Constraint constraint);
    }

    module SatisfiesConstraint<
      HasTypeTreeSig Term, HasTypeTreeSig Constraint,
      SatisfiesConstraintInputSig<Term, Constraint> Input>
    {
      private module Inp implements SatisfiesConstraintWithTypeMatchingInputSig<Term, Constraint> {
        private import codeql.util.Void

        predicate relevantConstraint(Term term, Constraint constraint) {
          Input::relevantConstraint(term, constraint)
        }

        class TypeMatchingContext = Void;

        TypeMatchingContext getTypeMatchingContext(Term t) { none() }

        predicate typeMatch(TypeMatchingContext ctx, TypeParameter tp, TypePath path, Type t) {
          none()
        }
      }

      import SatisfiesConstraintWithTypeMatching<Term, Constraint, Inp>
    }

    /** Provides the input to `SatisfiesType`. */
    signature module SatisfiesTypeInputSig<HasTypeTreeSig Term> {
      /** Holds if it is relevant to know if `term` satisfies `type`. */
      predicate relevantConstraint(Term term, Type type);
    }

    /**
     * A helper module wrapping `SatisfiesConstraint` where the constraint is simply a type.
     */
    module SatisfiesType<HasTypeTreeSig Term, SatisfiesTypeInputSig<Term> Input> {
      private import Input

      final private class TypeFinal = Type;

      private class TypeAsTypeTree extends TypeFinal {
        Type getTypeAt(TypePath path) {
          result = this and
          path.isEmpty()
        }
      }

      private module SatisfiesConstraintInput implements
        SatisfiesConstraintInputSig<Term, TypeAsTypeTree>
      {
        predicate relevantConstraint(Term term, TypeAsTypeTree constraint) {
          Input::relevantConstraint(term, constraint)
        }
      }

      import SatisfiesConstraint<Term, TypeAsTypeTree, SatisfiesConstraintInput>
    }

    /** Provides the input to `MatchingWithEnvironment`. */
    signature module MatchingWithEnvironmentInputSig {
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
       * Gets a type constraint on the type parameter `tp` that applies to `decl`,
       * if any.
       */
      bindingset[decl]
      default TypeMention getATypeParameterConstraint(TypeParameter tp, Declaration decl) {
        result = getATypeParameterConstraint(tp)
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

      /** An environment to track during type matching. */
      bindingset[this]
      class AccessEnvironment {
        /** Gets a textual representation of this environment. */
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
         * Gets the inferred type at `path` for the position `apos` and environment `e`
         * of this access.
         *
         * For example, if this access is the method call `M(42)`, then the inferred
         * type at argument position `0` is `int`.
         */
        bindingset[e]
        Type getInferredType(AccessEnvironment e, AccessPosition apos, TypePath path);

        /** Gets the declaration that this access targets in environment `e`. */
        Declaration getTarget(AccessEnvironment e);
      }

      /** Holds if `apos` and `dpos` match. */
      bindingset[apos]
      bindingset[dpos]
      predicate accessDeclarationPositionMatch(AccessPosition apos, DeclarationPosition dpos);
    }

    /**
     * Provides logic for matching types at accesses against types at the
     * declarations that the accesses target.
     *
     * Matching takes both base types and explicit type arguments into account.
     */
    module MatchingWithEnvironment<MatchingWithEnvironmentInputSig Input> {
      private import Input

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

      pragma[nomagic]
      private predicate directTypeMatch0(
        Access a, DeclarationPosition dpos, AccessEnvironment e, Declaration target,
        TypePath pathToTypeParam, TypeParameter tp
      ) {
        not exists(getTypeArgument(a, target, tp, _)) and
        tp = target.getDeclaredType(dpos, pathToTypeParam) and
        target = a.getTarget(e)
      }

      /**
       * Holds if the type `t` at `path` of `a` in environment `e` matches the type
       * parameter `tp` of `target`.
       */
      pragma[nomagic]
      private predicate directTypeMatch(
        Access a, AccessEnvironment e, Declaration target, TypePath path, Type t, TypeParameter tp
      ) {
        exists(AccessPosition apos, DeclarationPosition dpos, TypePath pathToTypeParam |
          directTypeMatch0(a, dpos, e, target, pathToTypeParam, tp) and
          accessDeclarationPositionMatch(apos, dpos) and
          t = a.getInferredType(e, apos, pathToTypeParam.appendInverse(path))
        )
      }

      private module AccessBaseType {
        /**
         * Holds if inferring types at `a` in environment `e` might depend on the type at
         * `path` of `apos` having `base` as a transitive base type.
         */
        private predicate relevantAccess(
          Access a, AccessEnvironment e, AccessPosition apos, Type base
        ) {
          exists(Declaration target, DeclarationPosition dpos |
            target = a.getTarget(e) and
            accessDeclarationPositionMatch(apos, dpos) and
            declarationBaseType(target, dpos, base, _, _)
          )
        }

        pragma[nomagic]
        private Type inferTypeAt(
          Access a, AccessEnvironment e, AccessPosition apos, TypeParameter tp, TypePath suffix
        ) {
          relevantAccess(a, e, apos, _) and
          exists(TypePath path0 |
            result = a.getInferredType(e, apos, path0) and
            path0.isCons(tp, suffix)
          )
        }

        /**
         * Holds if `baseMention` is a (transitive) base type mention of the
         * type of `a` at position `apos` at path `pathToSub` in environment
         * `e`, and `t` is mentioned (implicitly) at `path` inside `base`.
         *
         * For example, in
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
          Access a, AccessEnvironment e, AccessPosition apos, TypeMention baseMention,
          TypePath path, Type t
        ) {
          relevantAccess(a, e, apos, getTypeMentionRoot(baseMention)) and
          exists(Type sub | sub = a.getInferredType(e, apos, TypePath::nil()) |
            baseTypeMentionHasNonTypeParameterAt(sub, baseMention, path, t)
            or
            exists(TypePath prefix, TypePath suffix, TypeParameter tp |
              baseTypeMentionHasTypeParameterAt(sub, baseMention, prefix, tp) and
              t = inferTypeAt(a, e, apos, tp, suffix) and
              path = prefix.append(suffix)
            )
          )
        }
      }

      private module AccessConstraint {
        private predicate relevantAccessConstraint(
          Access a, AccessEnvironment e, Declaration target, AccessPosition apos, TypePath path,
          TypeMention constraint
        ) {
          target = a.getTarget(e) and
          typeParameterHasConstraint(target, apos, _, path, constraint)
        }

        private newtype TRelevantAccess =
          MkRelevantAccess(Access a, AccessPosition apos, AccessEnvironment e, TypePath path) {
            relevantAccessConstraint(a, e, _, apos, path, _)
          }

        /**
         * If the access `a` for `apos`, environment `e`, and `path` has an inferred type
         * which type inference requires to satisfy some constraint.
         */
        private class RelevantAccess extends MkRelevantAccess {
          Access a;
          AccessPosition apos;
          AccessEnvironment e;
          TypePath path;

          RelevantAccess() { this = MkRelevantAccess(a, apos, e, path) }

          pragma[nomagic]
          Type getTypeAt(TypePath suffix) {
            result = a.getInferredType(e, apos, path.appendInverse(suffix))
          }

          /** Gets the constraint that this relevant access should satisfy. */
          TypeMention getConstraint(Declaration target) {
            relevantAccessConstraint(a, e, target, apos, path, result)
          }

          string toString() {
            result = a.toString() + ", " + apos.toString() + ", " + path.toString()
          }

          Location getLocation() { result = a.getLocation() }
        }

        private module SatisfiesTypeParameterConstraintInput implements
          SatisfiesConstraintWithTypeMatchingInputSig<RelevantAccess, TypeMention>
        {
          predicate relevantConstraint(RelevantAccess at, TypeMention constraint) {
            constraint = at.getConstraint(_)
          }

          class TypeMatchingContext = Access;

          TypeMatchingContext getTypeMatchingContext(RelevantAccess at) {
            at = MkRelevantAccess(result, _, _, _)
          }

          pragma[nomagic]
          predicate typeMatch(TypeMatchingContext ctx, TypeParameter tp, TypePath path, Type t) {
            typeMatch(ctx, _, _, path, t, tp)
          }
        }

        private module SatisfiesTypeParameterConstraint =
          SatisfiesConstraintWithTypeMatching<RelevantAccess, TypeMention,
            SatisfiesTypeParameterConstraintInput>;

        pragma[nomagic]
        predicate satisfiesConstraintAtTypeParameter(
          Access a, AccessEnvironment e, Declaration target, AccessPosition apos, TypePath prefix,
          TypeMention constraint, TypePath pathToTypeParamInConstraint,
          TypePath pathToTypeParamInSub
        ) {
          exists(RelevantAccess ra |
            ra = MkRelevantAccess(a, apos, e, prefix) and
            SatisfiesTypeParameterConstraint::satisfiesConstraintAtTypeParameter(ra, constraint,
              pathToTypeParamInConstraint, pathToTypeParamInSub) and
            constraint = ra.getConstraint(target)
          )
        }

        pragma[nomagic]
        predicate satisfiesConstraint(
          Access a, AccessEnvironment e, Declaration target, AccessPosition apos, TypePath prefix,
          TypeMention constraint, TypePath path, Type t
        ) {
          exists(RelevantAccess ra |
            ra = MkRelevantAccess(a, apos, e, prefix) and
            SatisfiesTypeParameterConstraint::satisfiesConstraint(ra, constraint, path, t) and
            constraint = ra.getConstraint(target)
          )
        }

        pragma[nomagic]
        predicate satisfiesConstraintThrough(
          Access a, AccessEnvironment e, Declaration target, AccessPosition apos, TypePath prefix,
          TypeAbstraction abs, TypeMention constraint, TypePath path, Type t
        ) {
          exists(RelevantAccess ra |
            ra = MkRelevantAccess(a, apos, e, prefix) and
            SatisfiesTypeParameterConstraint::satisfiesConstraintThrough(ra, abs, constraint, path,
              t) and
            constraint = ra.getConstraint(target)
          )
        }
      }

      /**
       * Holds if the type of `a` at `apos` in environment `e` has the base type `base`,
       * and when viewed as an element of that type has the type `t` at `path`.
       */
      pragma[nomagic]
      private predicate accessBaseType(
        Access a, AccessEnvironment e, AccessPosition apos, Type base, TypePath path, Type t
      ) {
        exists(TypeMention tm |
          AccessBaseType::hasBaseTypeMention(a, e, apos, tm, path, t) and
          base = getTypeMentionRoot(tm)
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
       * Holds if the (transitive) base type `t` at `path` of `a` in environment `e`
       * for some `AccessPosition` matches the type parameter `tp`, which is used in
       * the declared types of `target`.
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
        Access a, AccessEnvironment e, Declaration target, TypePath path, Type t, TypeParameter tp
      ) {
        not exists(getTypeArgument(a, target, tp, _)) and
        target = a.getTarget(e) and
        exists(AccessPosition apos, DeclarationPosition dpos, Type base, TypePath pathToTypeParam |
          accessBaseType(a, e, apos, base, pathToTypeParam.appendInverse(path), t) and
          declarationBaseType(target, dpos, base, pathToTypeParam, tp) and
          accessDeclarationPositionMatch(apos, dpos)
        )
      }

      /**
       * Holds if for `a` and corresponding `target` in environment `e`, the type parameter
       * `tp` is matched by a type argument at the access with type `t` and type path
       * `path`.
       */
      pragma[nomagic]
      private predicate explicitTypeMatch(
        Access a, AccessEnvironment e, Declaration target, TypePath path, Type t, TypeParameter tp
      ) {
        target = a.getTarget(e) and
        t = getTypeArgument(a, target, tp, path)
      }

      /**
       * Holds if the type parameter `constrainedTp` occurs in the declared type of
       * `target` at `apos` and `pathToConstrained`, and there is a constraint
       * `constraint` on `constrainedTp`.
       */
      pragma[nomagic]
      private predicate typeParameterHasConstraint(
        Declaration target, AccessPosition apos, TypeParameter constrainedTp,
        TypePath pathToConstrained, TypeMention constraint
      ) {
        exists(DeclarationPosition dpos |
          accessDeclarationPositionMatch(apos, dpos) and
          constrainedTp = target.getTypeParameter(_) and
          constrainedTp = target.getDeclaredType(dpos, pathToConstrained) and
          constraint = getATypeParameterConstraint(constrainedTp, target)
        )
      }

      /**
       * Holds if the declared type of `target` contains a type parameter at
       * `apos` and `pathToConstrained` that must satisfy `constraint` and `tp`
       * occurs at `pathToTp` in `constraint`.
       *
       * For example, in
       * ```csharp
       * interface IFoo<A> { }
       * T1 M<T1, T2>(T2 item) where T2 : IFoo<T1> { }
       * ```
       * with the method declaration being the target and with `apos`
       * corresponding to `item`, we have the following
       * - `pathToConstrained = ""`,
       * - `tp = T1`,
       * - `constraint = IFoo`,
       * - `pathToTp = "A"`.
       */
      pragma[nomagic]
      private predicate typeParameterConstraintHasTypeParameter(
        Declaration target, AccessPosition apos, TypePath pathToConstrained, TypeMention constraint,
        TypePath pathToTp, TypeParameter tp
      ) {
        exists(TypeParameter constrainedTp |
          typeParameterHasConstraint(target, apos, constrainedTp, pathToConstrained, constraint) and
          tp = target.getTypeParameter(_) and
          tp = constraint.getTypeAt(pathToTp) and
          constrainedTp != tp
        )
      }

      pragma[nomagic]
      private predicate typeConstraintBaseTypeMatch(
        Access a, AccessEnvironment e, Declaration target, TypePath path, Type t, TypeParameter tp
      ) {
        not exists(getTypeArgument(a, target, tp, _)) and
        exists(TypeMention constraint, AccessPosition apos, TypePath pathToTp, TypePath pathToTp2 |
          typeParameterConstraintHasTypeParameter(target, apos, pathToTp2, constraint, pathToTp, tp) and
          AccessConstraint::satisfiesConstraint(a, e, target, apos, pathToTp2, constraint,
            pathToTp.appendInverse(path), t)
        )
      }

      pragma[inline]
      private predicate typeMatch(
        Access a, AccessEnvironment e, Declaration target, TypePath path, Type t, TypeParameter tp
      ) {
        // A type given at the access corresponds directly to the type parameter
        // at the target.
        explicitTypeMatch(a, e, target, path, t, tp)
        or
        // We can infer the type of `tp` from one of the access positions
        directTypeMatch(a, e, target, path, t, tp)
        or
        // We can infer the type of `tp` by going up the type hiearchy
        baseTypeMatch(a, e, target, path, t, tp)
        or
        // We can infer the type of `tp` by a type constraint
        typeConstraintBaseTypeMatch(a, e, target, path, t, tp)
      }

      /**
       * Gets the inferred type of `a` at `path` for position `apos` and environment `e`.
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
      Type inferAccessType(Access a, AccessEnvironment e, AccessPosition apos, TypePath path) {
        exists(DeclarationPosition dpos | accessDeclarationPositionMatch(apos, dpos) |
          // A suffix of `path` leads to a type parameter in the target
          exists(Declaration target, TypePath prefix, TypeParameter tp, TypePath suffix |
            tp = target.getDeclaredType(dpos, prefix) and
            path = prefix.append(suffix) and
            typeMatch(a, e, target, suffix, result, tp)
          )
          or
          // `path` corresponds directly to a concrete type in the declaration
          exists(Declaration target |
            result = target.getDeclaredType(dpos, path) and
            target = a.getTarget(e) and
            not result instanceof TypeParameter
          )
        )
        or
        exists(
          Declaration target, TypePath prefix, TypeMention constraint,
          TypePath pathToTypeParamInConstraint, TypePath pathToTypeParamInSub
        |
          AccessConstraint::satisfiesConstraintAtTypeParameter(a, e, target, apos, prefix,
            constraint, pathToTypeParamInConstraint, pathToTypeParamInSub)
        |
          exists(TypePath suffix |
            /*
             * Example:
             *
             * ```rust
             * struct MyThing<A> { ... }
             *
             * trait MyTrait<B> { ... }
             *
             * impl<T> MyTrait<T> for MyThing<T> { ... }
             *
             * fn foo<T: MyTrait<i32>>(x: T) { ... }
             *
             * let x = MyThing(Default::default());
             * foo(x);
             * ```
             *
             * At `term` = `foo(x)`, we have
             * - `constraint = MyTrait<i32>`,
             * - `pathToTypeParamInConstraint` = `"B"`,
             * - `pathToTypeParamInSub` = `"A"`,
             * - `prefix` = `suffix` = `""`, and
             * - `result` = `i32`.
             *
             * That is, it allows us to infer that the type of `x` is `MyThing<i32>`.
             */

            result = constraint.getTypeAt(pathToTypeParamInConstraint.appendInverse(suffix)) and
            not result instanceof TypeParameter and
            path = prefix.append(pathToTypeParamInSub.append(suffix))
          )
          or
          exists(TypeParameter tp, TypePath suffix, TypePath mid, TypePath pathToTp |
            /*
             * Example:
             *
             * ```rust
             * struct MyThing<A> { ... }
             *
             * trait MyTrait<B> { ... }
             *
             * impl<T> MyTrait<T> for MyThing<T> { ... }
             *
             * fn bar<T1, T2: MyTrait<T1>>(x: T1, y: T2) {}
             *
             * let x : i32 = ...;
             * let y = MyThing(Default::default());
             * bar(x, y);
             * ```
             *
             * At `term` = `bar(x, y)`, we have
             * - `constraint = MyTrait<T1>`,
             * - `pathToTypeParamInConstraint` = `"B"`,
             * - `pathToTypeParamInSub` = `"A"`,
             * - `prefix` = `suffix` = `mid` = `""`,
             * - `tp = T1`,
             * - `pathToTp` = `"B"`, and
             * - `result` = `i32`.
             *
             * That is, it allows us to infer that the type of `y` is `MyThing<i32>`.
             */

            typeMatch(a, e, target, suffix, result, tp) and
            typeParameterConstraintHasTypeParameter(target, apos, _, constraint, pathToTp, tp) and
            pathToTp = pathToTypeParamInConstraint.appendInverse(mid) and
            path = prefix.append(pathToTypeParamInSub.append(mid).append(suffix))
          )
        )
      }
    }

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
       * Gets a type constraint on the type parameter `tp` that applies to `decl`,
       * if any.
       */
      bindingset[decl]
      default TypeMention getATypeParameterConstraint(TypeParameter tp, Declaration decl) {
        result = getATypeParameterConstraint(tp)
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
    }

    /**
     * Provides logic for matching types at accesses against types at the
     * declarations that the accesses target.
     *
     * Matching takes both base types and explicit type arguments into account.
     */
    module Matching<MatchingInputSig Input> {
      private module Inp implements MatchingWithEnvironmentInputSig {
        private import codeql.util.Unit
        import Input

        predicate getATypeParameterConstraint = Input::getATypeParameterConstraint/2;

        class AccessEnvironment = Unit;

        final private class AccessFinal = Input::Access;

        class Access extends AccessFinal {
          Type getInferredType(AccessEnvironment e, AccessPosition apos, TypePath path) {
            exists(e) and
            result = super.getInferredType(apos, path)
          }

          Declaration getTarget(AccessEnvironment e) {
            exists(e) and
            result = super.getTarget()
          }
        }
      }

      private module M = MatchingWithEnvironment<Inp>;

      import M

      Type inferAccessType(Input::Access a, Input::AccessPosition apos, TypePath path) {
        result = M::inferAccessType(a, _, apos, path)
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
        not exists(tm.getTypeAt(TypePath::nil())) and exists(tm.getLocation())
      }
    }
  }
}
