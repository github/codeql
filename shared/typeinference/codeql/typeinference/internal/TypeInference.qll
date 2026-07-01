/**
 * Provides shared functionality for computing type inference in QL.
 *
 * The library is initialized in three phases:
 *
 * 1. `Make1`, which takes as input a definition of atomic types (including type
 *    parameters) and constructs the `TypePath` type used to represent paths into
 *    compound types.
 *
 * 2. `Make2`, which takes as input a definition of type mentions (using the `TypePath`
 *    type) as well as the type hierarchy and type constraints, and constructs the
 *    `Matching` and `IsInstantiationOf` modules, which are core building blocks for
 *    matching type instantiations against type parameters, taking the type hierarchy
 *    and type constraints into account.
 *
 * 3. `Make3`, which takes as input a definition of AST nodes, including common concepts
 *    such as calls and callables, as well as language-specific typing rules, and
 *    constructs the `inferType` predicate for recursively inferring the types of AST
 *    nodes.
 *
 * Unlike unification-based type inference, this library does directed/bottom-up type
 * inference by default, but allowing for contextual/top-down type inference when
 * explicitly needed.
 *
 * For example, in order to infer the type of a conditional expression,
 * `if cond { e1 } else { e2 }`, we propagate type information from either of the
 * branches `e1` and `e2` into the conditional expression (for simplicity, we do not
 * attempt to calculate least-upper-bound types or similar). This corresponds to the
 * two bottom-up type inference rules:
 *
 * ```text
 *             e1: T
 * ------------------------------- (cond-then)
 * if cond { e1 } else { e2 } : T
 *
 *
 *             e2: T
 * ------------------------------- (cond-else)
 * if cond { e1 } else { e2 } : T
 * ```
 *
 * Now, if we have a conditional expression like
 *
 * ```rust
 * if cond { 42i64 } else { Default::default() }
 * ```
 *
 * where the type of `Default::default()` needs to be inferred from the context, we
 *
 * 1. assign `Default::default()` the special `UnknownType`,
 * 2. using the `cond-then` rule we conclude that the conditional has type `i64`, and
 * 3. since the `else` branch has `UnknownType`, we apply the `cond-else` rule _backwards_
 *    to infer that `Default::default()` has type `i64`.
 *
 * Note that `UnknownType` can propagate bottom-up like any other type, which is needed
 * in cases like for example
 *
 * ```rust
 * let x = if cond { Default::default() } else { Default::default() };
 * let y : i64 = x;
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
   * A psuedo type. Pseudo types are skipped when checking for non-instantiations
   * in `isNotInstantiationOf`.
   */
  class PseudoType extends Type;

  /**
   * A special pseudo type used to represent cases where the actual type needs
   * to be inferred using contextual information. For example, in
   *
   * ```rust
   * let x = Vec::new();
   * x.push(42);
   * ```
   *
   * the element type of `x` is assigned an unknown type, which allows for type
   * information to flow into `x` from the call to `push`.
   */
  class UnknownType extends PseudoType;

  /** A type parameter. */
  class TypeParameter extends Type;

  /**
   * A type abstraction. I.e., a place in the program where type variables may
   * be introduced.
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
    /** Gets a type parameter introduced by this abstraction, if any. */
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
  module TypePath {
    import UnboundList

    private string printTypeParameterVerbose(TypeParameter tp) {
      exists(Type t |
        t.getATypeParameter() = tp and
        result = t.toString() + "<" + tp.toString() + ">"
      )
    }

    /**
     * Gets a verbose textual representation of `path`, which includes the names
     * of the types that the type parameters belong to.
     *
     * For example, the verbose textual representation of the path `"T1.T2"` is
     * `"S1<T1>.S2<T2>"`, provided that `T1` is a type parameter of `S1` and `T2`
     * is a type parameter of `S2`.
     */
    bindingset[path]
    string printTypePathVerbose(TypePath path) {
      result =
        concat(int i, TypeParameter e |
          e = path.getElement(i)
        |
          printTypeParameterVerbose(e), "." order by i
        )
    }
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

    /** Gets a textual representation of this type tree. */
    string toString();

    /** Gets the location of this type tree. */
    Location getLocation();
  }

  /**
   * Provides the input to `Make2`.
   *
   * The `TypeMention` parameter is used to construct the constraint satisfaction
   * hierarchy based on `conditionSatisfiesConstraint`, which is general enough
   * to model both class hierarchies and trait implementation hierarchies in Rust.
   */
  signature module InputSig2<HasTypeTreeSig TypeMention> {
    /**
     * Gets a type constraint on the type parameter `tp`, if any. All
     * instantiations of the type parameter must satisfy the constraint.
     *
     * For example, in
     *
     * ```csharp
     * class GenericClass<T> : IComparable<GenericClass<T>>
     * //                 ^ `tp`
     *     where T : IComparable<T> { }
     * //            ^^^^^^^^^^^^^^ `result`
     * ```
     *
     * the type parameter `T` has the constraint `IComparable<T>`.
     */
    TypeMention getATypeParameterConstraint(TypeParameter tp);

    /**
     * Holds if
     * - `abs` is a type abstraction that may introduce type variables that are
     *   free in `condition` and `constraint`,
     * - and for every instantiation of the type parameters from `abs` the
     *   resulting `condition` satisfies the constraint given by `constraint`.
     * - `transitive` corresponds to whether any further constraints satisfied
     *   through `constraint` should also apply to `condition`.
     *
     * Example in C#:
     *
     * ```csharp
     * class C<T> : IComparable<C<T>> { }
     * //     ^^^ `abs`
     * //    ^^^^ `condition`
     * //           ^^^^^^^^^^^^^^^^^ `constraint`
     * ```
     *
     * Example in Rust:
     *
     * ```rust
     * impl<A> Trait<i64, A> for Type<String, A> { }
     * //  ^^^ `abs`             ^^^^^^^^^^^^^^^ `condition`
     * //      ^^^^^^^^^^^^^ `constraint`
     * ```
     *
     * To see how `abs` changes the meaning of the type parameters that occur in
     * `condition`, consider the following examples in Rust:
     *
     * ```rust
     * impl<T> Trait for T { }
     * //  ^^^ `abs`     ^ `condition`
     * //      ^^^^^ `constraint`
     * ```
     *
     * Here the meaning is "for all type parameters `T` it is the case that `T`
     * implements `Trait`". On the other hand, in
     *
     * ```rust
     * fn foo<T: Trait>() { }
     * //     ^ `condition`
     * //        ^^^^^ `constraint`
     * ```
     *
     * the meaning is "`T` implements `Trait`" where the constraint is only
     * valid for the specific `T`. Note that `condition` and `constraint` are
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
        result = app.getTypeAt(path) and
        not result instanceof PseudoType
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

        /** Gets the type parameter at position `pos` of this declaration, if any. */
        TypeParameter getTypeParameter(int pos);

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
         * Gets the type at `path` for the type argument at position `pos` of
         * this access, if any.
         *
         * For example, in a method call like `M<int>()`, `int` is an explicit
         * type argument at position `0`.
         */
        Type getTypeArgument(int pos, TypePath path);

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
      Type getTypeArgument(Access a, Declaration target, TypeParameter tp, TypePath path) {
        exists(int pos |
          result = a.getTypeArgument(pos, path) and
          tp = target.getTypeParameter(pos) and
          not result instanceof PseudoType
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
         * Holds if the type of `target` at `apos` and `pathToTp` is type parameter `tp`,
         * and an argument with root type `argRootType` may be able to be matched against
         * `tp` via the `conditionSatisfiesConstraint` hierarchy.
         */
        pragma[nomagic]
        private predicate argRootTypeSatisfiesTargetTypeCand(
          Type argRootType, Declaration target, AccessPosition apos, TypeParameter tp,
          TypePath pathToTp
        ) {
          exists(
            DeclarationPosition dpos, TypeMention condition, TypeMention constraint,
            Type constraintRootType
          |
            accessDeclarationPositionMatch(apos, dpos) and
            tp = target.getDeclaredType(dpos, pathToTp) and
            conditionSatisfiesConstraintTypeAt(_, condition, constraint, TypePath::nil(),
              constraintRootType) and
            constraintRootType = target.getDeclaredType(dpos, TypePath::nil()) and
            argRootType = condition.getTypeAt(TypePath::nil())
          )
        }

        private newtype TRelevantTarget =
          MkRelevantTarget(Declaration target, AccessPosition apos) {
            argRootTypeSatisfiesTargetTypeCand(_, target, apos, _, _)
          }

        private class RelevantTarget extends MkRelevantTarget {
          Declaration target;
          AccessPosition apos;

          RelevantTarget() { this = MkRelevantTarget(target, apos) }

          Type getTypeAt(TypePath path) {
            exists(DeclarationPosition dpos |
              accessDeclarationPositionMatch(apos, dpos) and
              result = target.getDeclaredType(dpos, path)
            )
          }

          string toString() { result = target.toString() + ", " + apos.toString() }

          Location getLocation() { result = target.getLocation() }
        }

        pragma[nomagic]
        private predicate argRootTypeSatisfiesTargetTypeCand(
          Type argRootType, Access a, AccessEnvironment e, Declaration target, AccessPosition apos,
          TypeParameter tp, TypePath pathToTp
        ) {
          target = a.getTarget(e) and
          argRootTypeSatisfiesTargetTypeCand(argRootType, target, apos, tp, pathToTp) and
          not exists(getTypeArgument(a, target, tp, _))
        }

        private newtype TRelevantAccess =
          MkRelevantAccess(Access a, AccessPosition apos, AccessEnvironment e) {
            argRootTypeSatisfiesTargetTypeCand(a.getInferredType(e, apos, TypePath::nil()), a, e, _,
              apos, _, _)
          }

        private class RelevantAccess extends MkRelevantAccess {
          Access a;
          AccessPosition apos;
          AccessEnvironment e;

          RelevantAccess() { this = MkRelevantAccess(a, apos, e) }

          RelevantTarget getTarget() { result = MkRelevantTarget(a.getTarget(e), apos) }

          pragma[nomagic]
          Type getTypeAt(TypePath path) { result = a.getInferredType(e, apos, path) }

          string toString() { result = a.toString() + ", " + apos.toString() }

          Location getLocation() { result = a.getLocation() }
        }

        private module SatisfiesParameterConstraintInput implements
          SatisfiesConstraintInputSig<RelevantAccess, RelevantTarget>
        {
          predicate relevantConstraint(RelevantAccess at, RelevantTarget constraint) {
            constraint = at.getTarget()
          }
        }

        private module SatisfiesParameterConstraint =
          SatisfiesConstraint<RelevantAccess, RelevantTarget, SatisfiesParameterConstraintInput>;

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
        predicate baseTypeMatch(
          Access a, AccessEnvironment e, Declaration target, TypePath path, Type t, TypeParameter tp
        ) {
          exists(AccessPosition apos, TypePath pathToTp |
            argRootTypeSatisfiesTargetTypeCand(_, a, e, target, apos, tp, pathToTp) and
            SatisfiesParameterConstraint::satisfiesConstraint(MkRelevantAccess(a, apos, e),
              MkRelevantTarget(target, apos), pathToTp.appendInverse(path), t)
          )
        }
      }

      private module AccessConstraint {
        private predicate relevantAccessConstraint(
          Access a, AccessEnvironment e, Declaration target, TypeParameter constrainedTp,
          TypeMention constraint
        ) {
          target = a.getTarget(e) and
          typeParameterHasConstraint(target, constrainedTp, constraint)
        }

        private newtype TRelevantAccess =
          MkRelevantAccess(Access a, AccessEnvironment e, TypeParameter constrainedTp) {
            relevantAccessConstraint(a, e, _, constrainedTp, _)
          }

        private class RelevantAccess extends MkRelevantAccess {
          Access a;
          AccessEnvironment e;
          TypeParameter constrainedTp;

          RelevantAccess() { this = MkRelevantAccess(a, e, constrainedTp) }

          pragma[nomagic]
          Type getTypeAt(TypePath path) { typeMatch(a, e, _, path, result, constrainedTp) }

          /** Gets the constraint that this relevant access should satisfy. */
          TypeMention getConstraint(Declaration target) {
            relevantAccessConstraint(a, e, target, constrainedTp, result)
          }

          string toString() {
            result = a.toString() + ", " + e.toString() + ", " + constrainedTp.toString()
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
            at = MkRelevantAccess(result, _, _)
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
        predicate argSatisfiesConstraintAtTypeParameter(
          Access a, AccessEnvironment e, Declaration target, AccessPosition apos, TypePath prefix,
          TypeMention constraint, TypePath pathToTypeParamInConstraint,
          TypePath pathToTypeParamInSub
        ) {
          exists(RelevantAccess ra, TypeParameter constrainedTp |
            ra = MkRelevantAccess(a, e, constrainedTp) and
            relevantAccessConstraint(a, e, target, constrainedTp, constraint) and
            SatisfiesTypeParameterConstraint::satisfiesConstraintAtTypeParameter(ra, constraint,
              pathToTypeParamInConstraint, pathToTypeParamInSub) and
            exists(DeclarationPosition dpos |
              accessDeclarationPositionMatch(apos, dpos) and
              constrainedTp = target.getDeclaredType(dpos, prefix)
            )
          )
        }

        pragma[nomagic]
        predicate satisfiesConstraint(
          Access a, AccessEnvironment e, Declaration target, TypeParameter constrainedTp,
          TypeMention constraint, TypePath path, Type t
        ) {
          exists(RelevantAccess ra |
            ra = MkRelevantAccess(a, e, constrainedTp) and
            relevantAccessConstraint(a, e, target, constrainedTp, constraint) and
            SatisfiesTypeParameterConstraint::satisfiesConstraint(ra, constraint, path, t)
          )
        }
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
       * Holds if the type parameter `constrainedTp` applies to `target` and the
       * constraint `constraint` applies to `constrainedTp`.
       */
      pragma[nomagic]
      private predicate typeParameterHasConstraint(
        Declaration target, TypeParameter constrainedTp, TypeMention constraint
      ) {
        constrainedTp = target.getTypeParameter(_) and
        constraint = getATypeParameterConstraint(constrainedTp, target)
      }

      /**
       * Holds if the type parameter `constrainedTp` applies to `target`, the
       * constraint `constraint` applies to `constrainedTp`, and type parameter
       * `tp` occurs at `pathToTp` in `constraint`.
       *
       * For example, in
       *
       * ```csharp
       * interface IFoo<A> { }
       * T1 M<T1, T2>(T2 item) where T2 : IFoo<T1> { }
       * ```
       *
       * with the method declaration being the target, we have the following
       * - `constrainedTp = T2`,
       * - `constraint = IFoo`,
       * - `tp = T1`, and
       * - `pathToTp = "A"`.
       */
      pragma[nomagic]
      private predicate typeParameterConstraintHasTypeParameter(
        Declaration target, TypeParameter constrainedTp, TypeMention constraint, TypePath pathToTp,
        TypeParameter tp
      ) {
        typeParameterHasConstraint(target, constrainedTp, constraint) and
        tp = target.getTypeParameter(_) and
        tp = constraint.getTypeAt(pathToTp) and
        constrainedTp != tp
      }

      pragma[nomagic]
      private predicate typeConstraintBaseTypeMatch(
        Access a, AccessEnvironment e, Declaration target, TypePath path, Type t, TypeParameter tp
      ) {
        not exists(getTypeArgument(a, target, tp, _)) and
        exists(TypeMention constraint, TypeParameter constrainedTp, TypePath pathToTp |
          typeParameterConstraintHasTypeParameter(target, constrainedTp, constraint, pathToTp, tp) and
          AccessConstraint::satisfiesConstraint(a, e, target, constrainedTp, constraint,
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
        // We can infer the type of `tp` by going up the type hierarchy
        AccessBaseType::baseTypeMatch(a, e, target, path, t, tp)
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
          AccessConstraint::argSatisfiesConstraintAtTypeParameter(a, e, target, apos, prefix,
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
            exists(TypeParameter constrainedTp, DeclarationPosition dpos |
              typeParameterConstraintHasTypeParameter(target, constrainedTp, constraint, pathToTp,
                tp) and
              accessDeclarationPositionMatch(apos, dpos) and
              constrainedTp = target.getDeclaredType(dpos, _)
            ) and
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

        /** Gets the type parameter at position `pos` of this declaration, if any. */
        TypeParameter getTypeParameter(int pos);

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
        Type getTypeArgument(int pos, TypePath path);

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
      query predicate nonUniqueUnknownType() { strictcount(UnknownType t) > 1 }

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

    private module Consistency2 = Consistency;

    /**
     * Provides the input to `Make3`.
     */
    signature module InputSig3 {
      /**
       * Reverse references to the cached predicates that reference
       * `CachedStage::ref()`.
       */
      default predicate cacheRevRef() { none() }

      /** A boolean type. */
      class BoolType extends Type;

      /** An AST node. */
      class AstNode {
        /** Gets a textual representation of this AST node. */
        string toString();

        /** Gets the location of this AST node. */
        Location getLocation();
      }

      // todo: remove
      /** Gets the type annotation that applies to `n`, if any. */
      TypeMention getTypeAnnotation(AstNode n);

      /** An expression. */
      class Expr extends AstNode;

      /** A cast expression. */
      class Cast extends Expr {
        /** Gets the type being cast to. */
        TypeMention getType();
      }

      /**
       * A switch.
       */
      class Switch extends AstNode {
        /**
         * Gets the expression being switched on.
         */
        Expr getExpr();

        /** Gets the case at the specified (zero-based) `index`. */
        Case getCase(int index);
      }

      /** A case in a switch. */
      class Case extends AstNode {
        /** Gets a pattern being matched by this case. */
        AstNode getAPattern();

        /** Gets the body of this case. */
        AstNode getBody();
      }

      /** A ternary conditional expression. */
      class ConditionalExpr extends Expr {
        /** Gets the condition of this expression. */
        Expr getCondition();

        /** Gets the true branch of this expression. */
        Expr getThen();

        /** Gets the false branch of this expression. */
        Expr getElse();
      }

      /** A binary expression. */
      class BinaryExpr extends Expr {
        /** Gets the left operand of this binary expression. */
        Expr getLeftOperand();

        /** Gets the right operand of this binary expression. */
        Expr getRightOperand();
      }

      /** A short-circuiting logical AND expression. */
      class LogicalAndExpr extends BinaryExpr;

      /** A short-circuiting logical OR expression. */
      class LogicalOrExpr extends BinaryExpr;

      /**
       * An assignment expression, either compound or simple.
       *
       * Examples:
       *
       * ```
       * x = y
       * sum += element
       * ```
       */
      class Assignment extends BinaryExpr;

      /** A simple assignment expression, for example `x = y`. */
      class AssignExpr extends Assignment;

      /** A parenthesized expression. */
      class ParenExpr extends Expr {
        Expr getExpr();
      }

      /**
       * A local variable, or an entity that behaves like a local variable with
       * respect to type inference, for example a `const` or `static` in Rust.
       */
      class LocalVariable {
        /**
         * Gets the AST node that defines this variable.
         *
         * If this variable is explicitly typed, then the type annotation must be
         * applied to the defining node in `getTypeAnnotation`.
         */
        AstNode getDefiningNode();

        /** Gets an access to this variable. */
        Expr getAnAccess();

        /** Gets a textual representation of this element. */
        string toString();

        /** Gets the location of this element. */
        Location getLocation();
      }

      /**
       * A declaration of one or more local variables, for example a `let` statement
       * in Rust.
       */
      class LocalVariableDeclaration extends AstNode {
        /**
         * Holds if this declaration is a coercion site, meaning that the type of the
         * initializer may have to be coerced to the type of the pattern.
         */
        predicate isCoercionSite();

        /** Gets the declared type of this declaration, if any. */
        TypeMention getType();

        /**
         * Gets the pattern of this declaration.
         *
         * Any local variable declared by this declaration will have its defining node in the
         * pattern, for example in `let Some(x) = opt`, the defining node of `x` is under
         * the `Some` pattern.
         */
        AstNode getPattern();

        /** Gets the initializer of this declaration, if any. */
        AstNode getInitializer();
      }

      /** A parameter. */
      class Parameter extends AstNode {
        /** Gets the pattern of this parameter, if any. */
        AstNode getPattern();

        /** Gets the declared type of this parameter, if any. */
        TypeMention getType();
      }

      /** A parameterizable element, such as a function or variant constructor. */
      class Parameterizable extends AstNode {
        /** Gets the type at `path` of the entity that declares this member. */
        Type getDeclaringType(TypePath path);

        /**
         * Gets the type parameter at position `pos` of this element, if any.
         *
         * TODO:
         * This should include type parameters declared on the element itself,
         * as well as type parameters declared on the enclosing declaration(s).
         */
        TypeParameter getTypeParameter(int pos);

        /**
         * Gets an additional type parameter constraint for the given type parameter,
         * which applies to this element. For example, in Rust, a function can apply
         * additional constraints on type parameters belonging to the `impl` block
         * that the function is defined in:
         *
         * ```rust
         * impl<T> MyThing<T> {
         *     fn foo(self) where T: MyTrait { ... }
         * }
         */
        TypeMention getAdditionalTypeParameterConstraint(TypeParameter tp);

        /**
         * Gets the `i`th parameter of this element.
         *
         * This should also include (possibly implicit) `this`/`self` parameters,
         * using index `0`.
         */
        Parameter getParameter(int i);

        /**
         * Gets the declared type of this element, if any.
         *
         * For callables this is the return type and for constructors this is the type
         * being constructed.
         */
        TypeMention getType();
      }

      /** A callable. */
      class Callable extends Parameterizable {
        /** Gets the body of this callable, if any. */
        AstNode getBody();
      }

      /**
       * Gets the declared type of `p` at `path`.
       *
       * By default, this is the declared type of `p` at `path`, but in for example Rust,
       * `async` functions must have their return type wrapped in a `Future` type.
       */
      default Type getParameterizableType(Parameterizable p, TypePath path) {
        result = p.getType().getTypeAt(path)
      }

      bindingset[this]
      class ResolutionContext {
        /** Gets a textual representation of this context. */
        bindingset[this]
        string toString();
      }

      /** An invocation expression, for example a call or a variant construction. */
      class Invocation extends Expr {
        /** Gets the explicit type argument at position `pos` and `path` for this invocation, if any. */
        Type getTypeArgument(int pos, TypePath path);

        /**
         * Gets the AST node corresponding to the `i`th argument of this invocation.
         *
         * This should include the receiver argument for method calls, using index `0`.
         */
        AstNode getArgument(int i);

        TypeMention getTypeQualifier();

        /** Gets the target of this invocation in the given resolution context. */
        Parameterizable getTarget(ResolutionContext ctx);
      }

      /**
       * Gets the inferred type of the `i`th argument of `invocation` at `path` in context
       * `ctx`, to be used when propagating type information out of the invocation via the
       * target.
       *
       * By default, this is the inferred type of the argument at the given position, but
       * in for example Rust, the inferred type of the receiver of a method call needs
       * to take the resolution context into account, in order to use the correct candidate
       * receiver type.
       */
      bindingset[ctx]
      default Type inferInvocationArgumentType(
        Invocation invocation, ResolutionContext ctx, int i, TypePath path
      ) {
        result = inferTypeForDefaults(invocation.getArgument(i), path) and
        exists(ctx)
      }

      /**
       * Gets the contextually inferred type of invocation argument `n` at `path`.
       * The context used is the target of the invocation, for example in
       *
       * ```csharp
       * [1,2,3].Select(x => x + 1);
       * ```
       *
       * the `Select` context allows us to infer that the type of `x => x + 1` is `Func<int, ?>`
       *
       * This predicate must be implemented using `inferInvocationArgumentTypeContextualDefault`,
       * performing the dual post-processing of `inferInvocationArgumentType`.
       *
       * When no post-processing is needed, simply implement this predicate as
       * `result = inferInvocationArgumentTypeContextualDefault(_, _, _, n, path)`.
       */
      Type inferInvocationArgumentTypeContextual(AstNode n, TypePath path);

      /**
       * Gets the inferred type of `invocation`, found by propagating type information
       * out of the invocation via the target.
       *
       * When no post-processing is needed, simply implement this predicate as
       * `result = inferInvocationTypeDefault(invocation, _, path)`.
       */
      Type inferInvocationType(Invocation invocation, TypePath path);

      /**
       * Gets the contextually inferred type of `invocation`, to be used when propagating
       * type information out of the invocation via the declared type of the target.
       *
       * For example, in
       *
       * ```rust
       * fn id<T>(x: T) -> T { x }
       * let x = Default::default();
       * let y : i32 = id(x);
       * ```
       *
       * knowing that the return type of `id(x)` is `i32` allows us to infer that
       * the type of `x` is also `i32`.
       *
       * This predicate should perform the dual post-processing of `inferInvocationType`.
       */
      default Type inferInvocationTypeContextual(Invocation invocation, TypePath path) {
        result = inferTypeForDefaults(invocation, path)
      }

      /** TODO. */
      default Parameterizable getAdditionalTargetForContextualReturnTyping(Invocation invocation) {
        none()
      }

      /** A member that can be accessed, such as a field. */
      class Member extends AstNode {
        /** Gets the type at `path` of the entity that declares this member. */
        Type getDeclaringType(TypePath path);

        /** Gets the declared type of this member at `path`. */
        TypeMention getType();
      }

      /** A member access expression, for example `x.f`. */
      class MemberAccess extends Expr {
        /* Gets the AST node corresponding to the receiver of this member access. */
        AstNode getReceiver();

        /** Gets the member being accessed. */
        Member getMember();
      }

      /**
       * Gets the inferred type of the receiver of `ma` at `path`, to be used when propagating
       * type information out of the member access via the member declaration.
       *
       * By default, this is the inferred type of the receiver node, but in for example Rust,
       * implicit dereferencing may have to be taken into account
       */
      default Type inferMemberAccessReceiverType(MemberAccess ma, TypePath path) {
        result = inferTypeForDefaults(ma.getReceiver(), path)
      }

      /**
       * Gets the contextually inferred type of member access receiver `n` at `path`.
       * The context used is the member being accessed, for example in
       *
       * ```rust
       * let x : i32 = tuple.0;
       * ```
       *
       * we will be able to infer that the type of `tuple` is a tuple type with `i32`
       * as the first element type.
       *
       * This predicate must be implemented using `inferMemberAccessReceiverTypeContextualDefault`,
       * performing the dual post-processing of `inferMemberAccessReceiverType`.
       *
       * When no post-processing is needed, simply implement this predicate as
       * `result = inferMemberAccessReceiverTypeContextualDefault(_, n, path)`.
       */
      Type inferMemberAccessReceiverTypeContextual(AstNode n, TypePath path);

      /** A closure/lambda expression. */
      class Closure extends Callable, Expr;

      /**
       * A special pseudo type representing a particular closure parameter.
       *
       * This is needed in cases where the type of a closure parameter must be
       * inferred from the inferred _return type_ of the closure. For example,
       * in
       *
       * ```rust
       * let c = |x| x;
       * let r: i32 = c(Default::default());
       * ```
       *
       * We
       *
       * 1. assign `x` the pseudo type `T_x`,
       * 2. infer that the return type of `c` is `T_x` and hence that `c` has type
       *    `Fn(_) -> T_x`,
       * 3. this enables us to detect that contextual inference is needed, so we also
       *    assign `c` the type `Fn(_) -> UnknownType`,
       * 4. infer that `c(42)` must have `UnknownType`,
       * 5. infer, using contextual inference, that `c` has type `Fn(_) -> i32`, and finally
       * 6. since `c` also has type `Fn(_) -> T_x`, we conclude that `x` has type `i32`.
       *
       * Note that steps 2, 4, and 5 are standard inference steps.
       */
      class ClosureParameterPseudoType extends PseudoType;

      /** Gets the pseudo type corresponding to closure parameter `p`. */
      ClosureParameterPseudoType getClosureParameterPseudoType(Parameter p);

      /** Gets the root type of closure `c`. */
      bindingset[c]
      Type getClosureType(Closure c);

      /**
       * Gets the type path corresponding to closure parameter `p`. This should be
       * a path into the `getClosureType(c)` type, where `c` is the closure that `p`
       * belongs to.
       */
      TypePath getClosureParameterTypePath(Parameter p);

      /**
       * Gets the type path corresponding to the return type of closure `c`. This should be
       * a path into the `getClosureType(c)` type.
       */
      bindingset[c]
      TypePath getClosureReturnTypePath(Closure c);

      /**
       * Holds if `n1` having certain type `t` at `path1` implies that `n2` has
       * certain type `t` at `path2`, but not necessarily the other way around.
       *
       * Any tuples included in this predicate will also automatically be included
       * in `inferStep`.
       */
      default predicate inferStepCertain(AstNode n1, TypePath path1, AstNode n2, TypePath path2) {
        none()
      }

      /**
       * Gets the inferred certain type of `n` at `path`.
       *
       * Use this predicate to implement any bespoke inference logic, but only for
       * nodes where `inferStepCertain` cannot be used, such as leaf nodes in the AST.
       *
       * Any tuples included in this predicate will also automatically be included
       * in `inferType`.
       */
      default Type inferTypeCertainSpecific(AstNode n, TypePath path) { none() }

      /**
       * Holds if `n1` having type `t` at `path1` implies that `n2` has type `t` at `path2`,
       * but not necessarily the other way around.
       */
      predicate inferStep(AstNode n1, TypePath path1, AstNode n2, TypePath path2);

      /**
       * Gets the inferred type of `n` at `path`.
       *
       * Use this predicate to implement any bespoke inference logic, but only for
       * nodes where `inferStep` cannot be used, such as leaf nodes in the AST.
       */
      Type inferTypeSpecific(AstNode n, TypePath path);

      /**
       * Gets the inferred type of `n` at `path`.
       *
       * This predicate must be implemented as an alias for the the `inferType` predicate
       * defined in this module, and is needed in order to provide default implementations
       * inside this signature.
       */
      Type inferTypeForDefaults(AstNode n, TypePath path);
    }

    module Make3<InputSig3 Input3> {
      private import Input3

      /** Gets the type of `n`, which has an explicit type annotation. */
      pragma[nomagic]
      private Type inferAnnotatedType(AstNode n, TypePath path) {
        result = getTypeAnnotation(n).getTypeAt(path)
        or
        result = n.(Cast).getType().getTypeAt(path)
        or
        exists(LocalVariableDeclaration decl |
          result = decl.getType().getTypeAt(path) and
          n = decl.getPattern()
        )
        or
        exists(Parameter p |
          n = p.getPattern() and
          result = p.getType().getTypeAt(path)
        )
        or
        exists(Closure c, TypePath suffix |
          n = c and
          result = getParameterizableType(c, suffix) and
          path = getClosureReturnTypePath(c).append(suffix)
        )
      }

      private predicate closureStep(AstNode n1, TypePath path1, Closure n2, TypePath path2) {
        exists(int index, Parameter p |
          n1 = p.getPattern() and
          p = n2.getParameter(index) and
          path1.isEmpty() and
          path2 = getClosureParameterTypePath(p)
        )
      }

      /** Provides logic for inferring certain type information. */
      private module Certain {
        predicate stepCertain(AstNode n1, TypePath path1, AstNode n2, TypePath path2) {
          inferStepCertain(n1, path1, n2, path2)
          or
          path1.isEmpty() and
          path2.isEmpty() and
          (
            exists(LocalVariable v | n1 = v.getDefiningNode() and n2 = v.getAnAccess())
            or
            exists(LocalVariableDeclaration decl |
              not decl.isCoercionSite() and
              n1 = decl.getInitializer() and
              n2 = decl.getPattern()
            )
            or
            n1 = n2.(ParenExpr).getExpr()
          )
        }

        pragma[nomagic]
        private Type inferTypeFromStepCertain(AstNode n, TypePath path) {
          exists(TypePath path1, AstNode n2, TypePath path2, TypePath suffix |
            result = inferTypeCertain(n2, path2.appendInverse(suffix)) and
            path = path1.append(suffix)
          |
            stepCertain(n2, path2, n, path1)
            or
            closureStep(n2, path2, n, path1)
          )
        }

        private Type inferLogicalOperationType(AstNode n, TypePath path) {
          (
            exists(LogicalAndExpr lae | n = [lae, lae.getLeftOperand(), lae.getRightOperand()]) or
            exists(LogicalOrExpr loe | n = [loe, loe.getLeftOperand(), loe.getRightOperand()])
          ) and
          result instanceof BoolType and
          path.isEmpty()
        }

        /** Gets the inferred certain type of `n` at `path`. */
        cached
        Type inferTypeCertain(AstNode n, TypePath path) {
          (
            CachedStage::ref() and
            result = Input3::inferTypeCertainSpecific(n, path)
            or
            result = inferAnnotatedType(n, path)
            or
            result = inferTypeFromStepCertain(n, path)
            or
            result = inferLogicalOperationType(n, path)
            or
            result = getClosureType(n) and
            path.isEmpty()
            or
            infersCertainTypeAt(n, path, result.getATypeParameter())
          ) and
          // type annotation may for example include unknown types, such as
          // `x : Vec<_>` in Rust
          not result instanceof PseudoType
        }

        /**
         * Holds if `n` has complete and certain type information at `path`.
         */
        pragma[nomagic]
        predicate hasInferredCertainType(AstNode n, TypePath path) {
          exists(inferTypeCertain(n, path))
        }

        /**
         * Holds if `n` has complete and certain type information at the type path
         * `prefix.tp`. This entails that the type at `prefix` must be the type
         * that declares `tp`.
         */
        pragma[nomagic]
        private predicate infersCertainTypeAt(AstNode n, TypePath prefix, TypeParameter tp) {
          exists(TypePath path |
            hasInferredCertainType(n, path) and
            not path.isEmpty() and // implied by `isSnoc` below, but improves performance slightly
            path.isSnoc(prefix, tp)
          )
        }

        /**
         * Holds if `n` having type `t` at `path` conflicts with certain type information
         * at `prefix`.
         */
        bindingset[n, prefix, path, t]
        pragma[inline_late]
        predicate certainTypeConflict(AstNode n, TypePath prefix, TypePath path, Type t) {
          inferTypeCertain(n, path) != t
          or
          // If we infer that `n` has _some_ type at `T1.T2....Tn`, and we also
          // know that `n` certainly has type `certainType` at `T1.T2...Ti`, `0 <= i < n`,
          // then it must be the case that `T(i+1)` is a type parameter of `certainType`,
          // otherwise there is a conflict.
          //
          // Below, `prefix` is `T1.T2...Ti` and `tp` is `T(i+1)`.
          exists(TypePath suffix, TypeParameter tp, Type certainType |
            path = prefix.appendInverse(suffix) and
            tp = suffix.getHead() and
            inferTypeCertain(n, prefix) = certainType and
            not certainType.getATypeParameter() = tp
          )
        }
      }

      predicate inferTypeCertain = Certain::inferTypeCertain/2;

      private predicate step(AstNode n1, TypePath path1, AstNode n2, TypePath path2) {
        inferStep(n1, path1, n2, path2)
        or
        Certain::stepCertain(n1, path1, n2, path2)
        or
        path1.isEmpty() and
        path2.isEmpty() and
        (
          exists(AssignExpr ae |
            n1 = ae.getRightOperand() and
            n2 = ae.getLeftOperand()
          )
          or
          exists(LocalVariableDeclaration decl |
            n1 = decl.getInitializer() and
            n2 = decl.getPattern()
          )
          or
          exists(Switch switch |
            n1 = switch.getExpr() and
            n2 = switch.getCase(_).getAPattern()
          )
          or
          n1 = n2.(Switch).getCase(_).getBody()
          or
          n2 = any(ConditionalExpr ce | n1 = [ce.getThen(), ce.getElse()])
        )
        or
        exists(Closure c |
          n1 = c.getBody() and
          n2 = c and
          path1.isEmpty() and
          path2 = getClosureReturnTypePath(n2)
        )
      }

      pragma[nomagic]
      private Type inferTypeFromStep(AstNode n, TypePath path) {
        exists(TypePath path1, AstNode n2, TypePath path2, TypePath suffix |
          result = inferType(n2, path2.appendInverse(suffix)) and
          path = path1.append(suffix)
        |
          step(n2, path2, n, path1)
          or
          closureStep(n2, path2, n, path1) and
          not result = getClosureParameterPseudoType(n.(Closure).getParameter(_))
        )
      }

      /**
       * Provides functionality related to contextual typing. By default, types are inferred
       * bottom-up, but when AST nodes have an explicit `UnknownType`, contextual typing is
       * allowed.
       *
       * This module identifies calls where the return type may need to be inferred from the
       * context, and also implements logic for performing contextual inference.
       */
      private module ContextualTyping {
        pragma[nomagic]
        private TypeParameter getAConstrained(TypeParameter tp) {
          result = getATypeParameterConstraint(tp).getTypeAt(_)
        }

        /**
         * Holds if parameterizable `p` mentions type parameter `tp` at some parameter,
         * possibly via a constraint on another mentioned type parameter.
         */
        pragma[nomagic]
        private predicate mentionsTypeParameterAtParameter(Parameterizable p, TypeParameter tp) {
          tp = getAConstrained*(p.getParameter(_).getType().getTypeAt(_))
        }

        /**
         * Holds if the return type of the parameterizable `p` at `path` is type parameter
         * `tp`, and `tp` does not appear in the type of any parameter of `p`.
         *
         * In this case, the context in which `p` is called may be needed to infer
         * the instantiation of `tp`.
         *
         * This covers functions like `Default::default` and `Vec::new` in Rust.
         */
        pragma[nomagic]
        private predicate parameterizableReturnContextTypedAt(
          Parameterizable p, TypePath path, TypeParameter tp
        ) {
          tp = getParameterizableType(p, path) and
          not mentionsTypeParameterAtParameter(p, tp)
        }

        // only needed to get access to `Matching::getTypeArgument`.
        private module InvocationMatchingGetTypeArgumentInput implements MatchingInputSig {
          import InvocationMatchingInput

          predicate getATypeParameterConstraint =
            InvocationMatchingInput::getATypeParameterConstraint/2;

          class Access extends InvocationMatchingInput::Access {
            Type getInferredType(AccessPosition apos, TypePath path) { none() }

            Declaration getTarget() {
              result = this.getTarget(_)
              or
              result = getAdditionalTargetForContextualReturnTyping(this)
            }
          }
        }

        private module InvocationMatchingGetTypeArgument =
          Matching<InvocationMatchingGetTypeArgumentInput>;

        /**
         * Holds if `invocation` resolves some target where the return type at `path`
         * may have to be inferred from the context.
         */
        pragma[nomagic]
        predicate needsContextualTyping(Invocation invocation, TypePath path) {
          exists(Parameterizable target, TypeParameter tp |
            target = invocation.(InvocationMatchingGetTypeArgumentInput::Access).getTarget() and
            parameterizableReturnContextTypedAt(target, path, tp) and
            tp = target.getTypeParameter(_) and
            // check that no explicit type arguments have been supplied which bind `tp`
            not exists(TypeParameter supplied |
              tp = getAConstrained*(supplied) and
              exists(
                InvocationMatchingGetTypeArgument::getTypeArgument(invocation, target, supplied, _)
              )
            )
          )
        }

        pragma[nomagic]
        private predicate hasUnknownTypeAt(AstNode n, TypePath path) {
          inferType(n, path) instanceof UnknownType
        }

        pragma[nomagic]
        predicate hasUnknownType(AstNode n) { hasUnknownTypeAt(n, _) }

        pragma[nomagic]
        private Type inferTypeContextualCand(AstNode n, TypePath path) {
          exists(Callable c |
            n = c.getBody() and
            result = getParameterizableType(c, path)
          )
          or
          result = inferInvocationArgumentTypeContextual(n, path)
          or
          result = inferMemberAccessReceiverTypeContextual(n, path)
          or
          exists(TypePath path1, AstNode n2, TypePath path2, TypePath suffix |
            result = inferType(n2, path2.appendInverse(suffix)) and
            path = path1.append(suffix)
          |
            step(n, path1, n2, path2)
            or
            closureStep(n, path1, n2, path2)
          )
        }

        pragma[nomagic]
        private Type inferTypeContextualCand(AstNode n, TypePath prefix, TypePath path) {
          result = inferTypeContextualCand(n, path) and
          hasUnknownType(n) and
          prefix = path.getAPrefix() and
          // no need to propagate `UnknownType`s contextually; `n` must already have an
          // `UnknownType` at some prefix of `path`
          not result instanceof UnknownType
        }

        pragma[nomagic]
        private Type inferTypeContextual0(AstNode n, TypePath path) {
          exists(TypePath prefix |
            result = inferTypeContextualCand(n, prefix, path) and
            hasUnknownTypeAt(n, prefix)
          )
        }

        pragma[nomagic]
        private predicate isValidContextualNonEmptyPath(AstNode n, TypePath path) {
          hasUnknownType(n) and
          exists(TypePath prefix, TypeParameter tp |
            tp = inferType(n, prefix).getATypeParameter() and
            path = TypePath::snoc(prefix, tp)
          )
        }

        /**
         * Gets the contextually inferred type of `n` at `path`, if any. This is only
         * allowed when `n` has `UnknownType` at some prefix of `path`, and furthermore
         * if `path` is non-empty, then it must be compatible with an already inferred
         * type (contextually or not).
         */
        pragma[nomagic]
        Type inferTypeContextual(AstNode n, TypePath path) {
          result = inferTypeContextual0(n, path) and
          (
            path.isEmpty()
            or
            isValidContextualNonEmptyPath(n, path)
          )
        }
      }

      private module ClosureTyping {
        pragma[nomagic]
        private predicate hasClosureParameterPseudoType(AstNode n, Parameter p, TypePath path) {
          // use `inferType0` to also detect propagation into enclosing closure
          inferType0(n, path) = getClosureParameterPseudoType(p)
        }

        pragma[nomagic]
        private predicate hasClosureParameterPseudoType(AstNode n) {
          hasClosureParameterPseudoType(n, _, _)
        }

        pragma[nomagic]
        private predicate hasTypeAt(AstNode n, TypePath path) { exists(inferType(n, path)) }

        pragma[nomagic]
        private predicate hasTypeAtPrefix(AstNode n, TypePath prefix, TypePath path) {
          hasTypeAt(n, path) and
          hasClosureParameterPseudoType(n) and
          prefix = path.getAPrefix()
        }

        pragma[nomagic]
        private predicate hasClosureParameterPseudoType(
          AstNode n, TypePath path, AstNode pattern, TypePath suffix
        ) {
          exists(Parameter p, TypePath prefix |
            hasClosureParameterPseudoType(n, p, prefix) and
            hasTypeAtPrefix(n, prefix, path) and
            path = prefix.appendInverse(suffix) and
            pattern = p.getPattern()
          )
        }

        pragma[nomagic]
        private Type inferClosureParameterTypeCand(AstNode n, TypePath path) {
          result = inferType(n, path) and
          hasClosureParameterPseudoType(n) and
          not result instanceof UnknownType
        }

        // The `case X` comments below refer to the cases in the QL doc for
        // `ClosureParameterPseudoType`.
        private Type inferClosureParameterPseudoType(AstNode n, TypePath path) {
          exists(Closure c, Parameter p | p = c.getParameter(_) |
            // case 1
            n = p.getPattern() and
            path.isEmpty() and
            result = getClosureParameterPseudoType(p)
            or
            // case 3
            hasClosureParameterPseudoType(c, p, path) and
            n = c and
            result instanceof UnknownType
          )
          or
          // case 6
          exists(AstNode n0, TypePath path0 |
            hasClosureParameterPseudoType(n0, path0, n, path) and
            result = inferClosureParameterTypeCand(n0, path0)
          )
        }

        Type inferClosureParameterType(AstNode n, TypePath path) {
          result = inferClosureParameterPseudoType(n, path)
          or
          exists(Closure c, Parameter p |
            p = c.getParameter(_) and
            not exists(p.getType())
          |
            n = c and
            path = getClosureParameterTypePath(p) and
            result instanceof UnknownType
            or
            n = p.getPattern() and
            result = inferType(c, getClosureParameterTypePath(p).appendInverse(path)) and
            not result instanceof UnknownType
          )
        }
      }

      private Type inferType0(AstNode n, TypePath path) {
        result = Input3::inferTypeSpecific(n, path)
        or
        result = inferAnnotatedType(n, path)
        or
        exists(LocalVariableDeclaration decl |
          n = decl.getPattern() and
          not exists(decl.getInitializer()) and
          result instanceof UnknownType and
          path.isEmpty()
        )
        or
        result = inferTypeFromStep(n, path)
        or
        result = inferInvocationType(n, path)
        or
        result = inferMemberAccessType(n, path)
        or
        result = ClosureTyping::inferClosureParameterType(n, path)
        or
        ContextualTyping::needsContextualTyping(n, path) and
        result instanceof UnknownType
        or
        result = ContextualTyping::inferTypeContextual(n, path)
      }

      /**
       * Gets the inferred type of `n` at `path`.
       */
      cached
      Type inferType(AstNode n, TypePath path) {
        CachedStage::ref() and
        result = inferTypeCertain(n, path)
        or
        // Don't propagate type information into a node which conflicts with certain
        // type information.
        result = inferType0(n, path) and
        forall(TypePath prefix |
          Certain::hasInferredCertainType(n, prefix) and
          prefix.isPrefixOf(path)
        |
          not Certain::certainTypeConflict(n, prefix, path, result)
          or
          // propagate closure parameter pseudo types even when there is certain information,
          // but prevent propagation outside of the closure
          exists(Parameter p |
            result = getClosureParameterPseudoType(p) and
            not p = n.(Closure).getParameter(_)
          )
        )
        or
        // If `n` has an explicitly unknown type at `prefix` and at the same time a certain
        // type at `prefix.suffix`, then extend the unknown type information to any path
        // extending `prefix.suffix` where there is no certain type information
        exists(TypePath prefix, TypePath suffix, Type certain, TypeParameter tp |
          inferType0(n, prefix) instanceof UnknownType and
          certain = inferTypeCertain(n, prefix.appendInverse(suffix)) and
          tp = certain.getATypeParameter() and
          path = prefix.append(suffix).append(TypePath::singleton(tp)) and
          not exists(inferTypeCertain(n, path)) and
          result instanceof UnknownType
        )
        or
        infersTypeAt(n, path, result.getATypeParameter())
      }

      pragma[nomagic]
      private predicate infersTypeAt(AstNode n, TypePath prefix, TypeParameter tp) {
        exists(TypePath path |
          exists(inferType(n, path)) and
          not path.isEmpty() and // implied by `isSnoc` below, but improves performance slightly
          path.isSnoc(prefix, tp)
        )
      }

      /**
       * A matching configuration for resolving types of invocations.
       */
      private module InvocationMatchingInput implements MatchingWithEnvironmentInputSig {
        class DeclarationPosition = int;

        class AccessPosition = DeclarationPosition;

        bindingset[apos]
        bindingset[dpos]
        predicate accessDeclarationPositionMatch(AccessPosition apos, DeclarationPosition dpos) {
          apos = dpos
        }

        /** Gets the position used to represent the return type of a callable/type of a call. */
        additional int getReturnPosition() { result = -1 }

        /** Gets the position used to represent the declaring type of a callable/type qualifier of a call. */
        additional int getDeclaringPosition() { result = -2 }

        final private class ParameterizableFinal = Parameterizable;

        class Declaration extends ParameterizableFinal {
          Type getDeclaredType(DeclarationPosition dpos, TypePath path) {
            result = this.getParameter(dpos).getType().getTypeAt(path)
            or
            dpos = getReturnPosition() and
            result = getParameterizableType(this, path)
            or
            dpos = getDeclaringPosition() and
            result = this.getDeclaringType(path)
          }
        }

        bindingset[decl]
        TypeMention getATypeParameterConstraint(TypeParameter tp, Declaration decl) {
          result = Input2::getATypeParameterConstraint(tp) and
          exists(decl)
          or
          result = decl.getAdditionalTypeParameterConstraint(tp)
        }

        class AccessEnvironment = ResolutionContext;

        final private class InvocationFinal = Invocation;

        class Access extends InvocationFinal {
          pragma[nomagic]
          private Type getInferredResultType(AccessPosition apos, TypePath path) {
            result = inferInvocationTypeContextual(this, path) and
            apos = getReturnPosition()
          }

          bindingset[e]
          Type getInferredType(AccessEnvironment e, AccessPosition apos, TypePath path) {
            result = inferInvocationArgumentType(this, e, apos, path)
            or
            result = this.getInferredResultType(apos, path) and
            exists(e)
            or
            result = this.getTypeQualifier().getTypeAt(path) and
            apos = getDeclaringPosition() and
            exists(e)
          }

          Declaration getTarget(AccessEnvironment e) { result = super.getTarget(e) }
        }
      }

      private module InvocationMatching = MatchingWithEnvironment<InvocationMatchingInput>;

      pragma[nomagic]
      Type inferInvocationTypeDefault(Invocation call, ResolutionContext ctx, TypePath path) {
        result =
          InvocationMatching::inferAccessType(call, ctx,
            InvocationMatchingInput::getReturnPosition(), path)
      }

      /**
       * Gets the contextually inferred type of call argument `n` at `path`. For more info,
       * see the QL doc of `InputSig3::inferInvocationArgumentTypeContextual`.
       */
      pragma[nomagic]
      Type inferInvocationArgumentTypeContextualDefault(
        Invocation call, ResolutionContext ctx, int pos, AstNode n, TypePath path
      ) {
        n = call.getArgument(pos) and
        result = InvocationMatching::inferAccessType(call, ctx, pos, path) and
        ContextualTyping::hasUnknownType(n)
      }

      /**
       * A matching configuration for resolving types of member expressions like `x.field`.
       */
      private module MemberAccessMatchingInput implements MatchingInputSig {
        private newtype TDeclarationPosition =
          TReceiverPosition() or
          TMemberPos()

        class DeclarationPosition extends TDeclarationPosition {
          predicate isReceiver() { this = TReceiverPosition() }

          predicate isMember() { this = TMemberPos() }

          string toString() {
            this.isReceiver() and
            result = "receiver"
            or
            this.isMember() and
            result = "member"
          }
        }

        final private class MemberFinal = Member;

        class Declaration extends MemberFinal {
          TypeParameter getTypeParameter(int pos) { none() }

          Type getDeclaredType(DeclarationPosition dpos, TypePath path) {
            dpos.isReceiver() and
            result = this.getDeclaringType(path)
            or
            dpos.isMember() and
            result = this.getType().getTypeAt(path)
          }

          abstract string toString();

          abstract Location getLocation();
        }

        class AccessPosition = DeclarationPosition;

        final private class MemberAccessFinal = MemberAccess;

        class Access extends MemberAccessFinal {
          Type getTypeArgument(int pos, TypePath path) { none() }

          Type getInferredType(AccessPosition apos, TypePath path) {
            apos.isReceiver() and
            result = inferMemberAccessReceiverType(this, path)
            or
            apos.isMember() and
            result = inferType(this, path)
          }

          Declaration getTarget() { result = this.getMember() }
        }

        predicate accessDeclarationPositionMatch(AccessPosition apos, DeclarationPosition dpos) {
          apos = dpos
        }
      }

      private module MemberAccessMatching = Matching<MemberAccessMatchingInput>;

      pragma[nomagic]
      private Type inferMemberAccessType(MemberAccess ma, TypePath path) {
        result =
          MemberAccessMatching::inferAccessType(ma,
            any(MemberAccessMatchingInput::DeclarationPosition pos | pos.isMember()), path)
      }

      /**
       * Gets the contextually inferred type of member access receiver `n` at `path`.
       * For more info, see the QL doc of `InputSig3::inferMemberAccessReceiverTypeContextual`.
       */
      pragma[nomagic]
      Type inferMemberAccessReceiverTypeContextualDefault(
        MemberAccess ma, AstNode receiver, TypePath path
      ) {
        result =
          MemberAccessMatching::inferAccessType(ma,
            any(MemberAccessMatchingInput::DeclarationPosition pos | pos.isReceiver()), path) and
        receiver = ma.getReceiver() and
        ContextualTyping::hasUnknownType(receiver)
      }

      /**
       * Gets the inferred root type of `n`, if any.
       */
      Type inferType(AstNode n) { result = inferType(n, TypePath::nil()) }

      /**
       * The cached stage of this module.
       *
       * Should not be exposed.
       */
      cached
      module CachedStage {
        /** Reference to the cached stage of this module. */
        cached
        predicate ref() { any() }

        /** Reverse references to the predicates that reference `ref()`. */
        cached
        predicate revRef() {
          any()
          or
          cacheRevRef()
          or
          (exists(inferTypeCertain(_, _)) implies any())
          or
          (exists(inferType(_, _)) implies any())
        }
      }

      /**
       * Provides consistency checks, including those from `Make2::Consistency`.
       */
      module Consistency {
        import Consistency2

        query predicate nonUniqueCertainType(AstNode n, TypePath path) {
          strictcount(inferTypeCertain(n, path)) > 1
        }

        /**
         * Checks that `Input3::inferType` is an alias for `inferType`.
         */
        query predicate inferTypeMismatch(AstNode n, TypePath path, Type t) {
          inferType(n, path) = t and
          not Input3::inferTypeForDefaults(n, path) = t
          or
          Input3::inferTypeForDefaults(n, path) = t and
          not inferType(n, path) = t
        }
      }

      /** Provides various debugging predicates. */
      module Debug {
        pragma[nomagic]
        predicate atLimit(AstNode n) {
          exists(TypePath path0 |
            exists(inferType(n, path0)) and path0.length() >= getTypePathLimit()
          )
        }

        Type inferTypeForNodeAtLimit(AstNode n, TypePath path) {
          result = inferType(n, path) and
          atLimit(n)
        }

        predicate countTypesForNodeAtLimit(AstNode n, int c) {
          c = strictcount(Type t, TypePath path | t = inferTypeForNodeAtLimit(n, path))
        }

        pragma[nomagic]
        private int countTypesAtPath(AstNode n, TypePath path, Type t) {
          t = inferType(n, path) and
          result = strictcount(Type t0 | t0 = inferType(n, path))
        }

        predicate maxTypes(AstNode n, TypePath path, Type t, int c) {
          c = countTypesAtPath(n, path, t) and
          c = max(countTypesAtPath(_, _, _))
        }

        pragma[nomagic]
        private predicate typePathLength(AstNode n, TypePath path, Type t, int len) {
          t = inferType(n, path) and
          len = path.length()
        }

        predicate maxTypePath(AstNode n, TypePath path, Type t, int len) {
          typePathLength(n, path, t, len) and
          len = max(int i | typePathLength(_, _, _, i))
        }

        pragma[nomagic]
        private int countTypePaths(AstNode n, TypePath path, Type t) {
          t = inferType(n, path) and
          result = strictcount(TypePath path0, Type t0 | t0 = inferType(n, path0))
        }

        predicate maxTypePaths(AstNode n, TypePath path, Type t, int c) {
          c = countTypePaths(n, path, t) and
          c = max(countTypePaths(_, _, _))
        }
      }
    }
  }
}
