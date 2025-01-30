/**
 * Provides shared functionality for computing type inference in QL.
 *
 * The code examples in this file uses C# syntax, but the concepts should
 * carry over to other languages as well.
 *
 * The library is initialized in two phases: `Make1`, which constructs
 * the `TypePath` type, and `Make2`, which (using `TypePath` in the input
 * signature) constructs the rest of the library.
 */

private import codeql.util.Location

/** Provides the input to `Make1`. */
signature module InputSig1<LocationSig Location> {
  /** A type without type arguments. */
  class Type {
    /** Gets a type parameter of this type, if any. */
    TypeParameter getATypeParameter();

    /** Gets a textual representation of this type. */
    string toString();

    /** Gets the location of this type. */
    Location getLocation();
  }

  /** A type parameter. */
  class TypeParameter extends Type {
    /**
     * Gets the position of this type parameter.
     *
     * This predicate is only used to make the `toString` representation of
     * `TypePath`s less verbose.
     */
    int getPosition();
  }

  /**
   * Gets the unique identifier of type parameter `tp`.
   *
   * This is used to represent type paths as strings, made up of `.`-separated
   * type parameter identifiers.
   */
  int getTypeParameterId(TypeParameter tp);

  /** A type argument position, for example an integer. */
  bindingset[this]
  class TypeArgumentPosition {
    /** Gets the textual representation of this type argument. */
    bindingset[this]
    string toString();
  }

  /** A type parameter position, for example an integer. */
  bindingset[this]
  class TypeParameterPosition {
    /** Gets the textual representation of this type parameter. */
    bindingset[this]
    string toString();
  }

  /** Holds if `apos` and `ppos` match. */
  bindingset[apos]
  bindingset[ppos]
  predicate typeArgumentParameterPositionMatch(TypeArgumentPosition apos, TypeParameterPosition ppos);
}

module Make1<LocationSig Location, InputSig1<Location> Input1> {
  private import Input1
  private import codeql.util.DenseRank

  private module DenseRankInput implements DenseRankInputSig {
    class Ranked = TypeParameter;

    predicate getRank = getTypeParameterId/1;
  }

  private int getTypeParameterRank(TypeParameter tp) {
    tp = DenseRank<DenseRankInput>::denseRank(result)
  }

  /** Gets the singleton type path `tp`. */
  bindingset[tp]
  TypePath typePath(TypeParameter tp) { result = getTypeParameterRank(tp).toString() }

  bindingset[s]
  private predicate decodeTypePathComponent(string s, TypeParameter tp) {
    getTypeParameterRank(tp) = s.toInt()
  }

  final private class String = string;

  /**
   * A path into a type.
   *
   * Paths are represented in left-to-right order, for example, a path `"0.1"` into the
   * type `C1<C2<A,B>,C3<C,D>>` points at the type `B`.
   *
   * Type paths are used to represent constructed types without using a `newtype`, which
   * makes it practically feasible to do type inference in mutual recursion with call
   * resolution.
   *
   * As an example, the type above can be represented by the following set of tuples
   *
   * `TypePath` | `Type`
   * ---------- | --------
   * `""`       | ``C1`2``
   * `"0"`      | ``C2`2``
   * `"0.0"`    | `A`
   * `"0.1"`    | `B`
   * `"1"`      | ``C3`2``
   * `"1.0"`    | `C`
   * `"1.1"`    | `D`
   *
   * Note that while we write type paths using type parameter positions (e.g. `"0.1"`),
   * the actual implementation uses unique type parameter identifiers, in order to not
   * mix up type parameters from different types.
   */
  class TypePath extends String {
    bindingset[this]
    TypePath() { exists(this) }

    bindingset[this]
    private TypeParameter getTypeParameter(int i) {
      exists(string s |
        s = this.splitAt(".", i) and
        decodeTypePathComponent(s, result)
      )
    }

    bindingset[this]
    string toString() {
      result =
        concat(int i, TypeParameter tp |
          tp = this.getTypeParameter(i)
        |
          tp.getPosition().toString(), "." order by i
        )
    }

    /** Holds if this type path is empty. */
    predicate isEmpty() { this = "" }

    /** Gets the path obtained by appending `suffix` onto this path. */
    bindingset[suffix, result]
    bindingset[this, result]
    bindingset[this, suffix]
    TypePath append(TypePath suffix) {
      if this.isEmpty()
      then result = suffix
      else
        if suffix.isEmpty()
        then result = this
        else result = this + "." + suffix
    }

    /** Holds if this path starts with `prefix`, followed by `tp`. */
    bindingset[this]
    predicate endsWith(TypePath prefix, TypeParameter tp) {
      decodeTypePathComponent(this, tp) and
      prefix.isEmpty()
      or
      exists(int last |
        last = max(this.indexOf(".")) and
        prefix = this.prefix(last) and
        decodeTypePathComponent(this.suffix(last + 1), tp)
      )
    }

    /** Holds if this path starts with `tp`, followed by `suffix`. */
    bindingset[this]
    predicate startsWith(TypeParameter tp, TypePath suffix) {
      decodeTypePathComponent(this, tp) and
      suffix.isEmpty()
      or
      exists(int first |
        first = min(this.indexOf(".")) and
        suffix = this.suffix(first + 1) and
        decodeTypePathComponent(this.prefix(first), tp)
      )
    }
  }

  /** Provides the input to `Make2`. */
  signature module InputSig2 {
    /** A type mention. */
    class TypeMention {
      /**
       * Gets the type being mentioned at `path` inside this type mention.
       *
       * For example, in
       *
       * ```csharp
       * C<int> xs = ...
       * ```
       *
       * the type mention in the declaration of `xs` resolves to the following
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
     * Gets a base type mention of `t`, if any. For example, in
     *
     * ```csharp
     * class C<T> : Base<T> { }
     * ```
     *
     * the class ``C`1`` has the base type mention of `Base<T>`.
     */
    TypeMention getABaseTypeMention(Type t);
  }

  module Make2<InputSig2 Input2> {
    private import Input2

    pragma[nomagic]
    private Type resolveTypeMentionRoot(TypeMention tm) { result = tm.resolveTypeAt("") }

    /** Provides logic related to base types. */
    private module BaseTypes {
      /**
       * Holds if `baseMention` is a (transitive) base type mention of `sub`,
       * and type parameter `tp` (belonging to `sub`) is mentioned (implicitly)
       * at `path` inside the type that `baseMention` resolves to.
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
       * ```
       *
       * - `T3` is mentioned at `0.0` for immediate base type `Base` of `Mid`,
       * - `T4` is mentioned at `0.0` for immediate base type `Mid` of `Sub`, and
       * - `T4` is mentioned at `0.0.0` for transitive base type `Base` of `Sub`.
       */
      pragma[nomagic]
      predicate baseTypeMentionHasTypeParameterAt(
        Type sub, TypeMention baseMention, TypePath path, TypeParameter tp
      ) {
        exists(TypeMention immediateBaseMention, TypePath pathToTypeParam |
          tp = sub.getATypeParameter() and
          immediateBaseMention = getABaseTypeMention(sub) and
          tp = immediateBaseMention.resolveTypeAt(pathToTypeParam)
        |
          // immediate base class
          baseMention = immediateBaseMention and
          path = pathToTypeParam
          or
          // transitive base class
          exists(Type immediateBase, TypePath prefix, TypePath suffix, TypeParameter mid |
            /*
             * Example:
             *
             * - `prefix = "0.0"`,
             * - `pathToTypeParam = "0.0"`,
             * - `suffix = "0"`,
             * - `path = "0.0.0"`
             *
             * ```csharp
             * class C<T1> { }
             *
             * class Base<T2> { }
             *
             * class Mid<T3> : Base<C<T3>> { }
             * //    ^^^ `immediateBase`
             * //        ^^ `mid`
             * //              ^^^^^^^^^^^ `baseMention`
             *
             * class Sub<T4> : Mid<C<T4>> { }
             * //    ^^^ `sub`
             * //        ^^ `tp`
             * //              ^^^^^^^^^^ `immediateBaseMention`
             * ```
             */

            immediateBase = resolveTypeMentionRoot(immediateBaseMention) and
            baseTypeMentionHasTypeParameterAt(immediateBase, baseMention, prefix, mid) and
            pathToTypeParam.startsWith(mid, suffix) and
            path = prefix.append(suffix)
          )
        )
      }

      /**
       * Holds if `baseMention` is a (transitive) base type mention of `sub`, and
       * non-type-parameter `t` is mentioned (implicitly) at `path` inside `base`.
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
       * ```
       *
       * - ``C`1`` is mentioned at `0` for immediate base type `Base` of `Mid`,
       * - ``C`1`` is mentioned at `0` for immediate base type `Mid` of `Sub`, and
       * - ``C`1`` is mentioned at `0` and `0.0` for transitive base type `Base` of `Sub`.
       */
      pragma[nomagic]
      predicate baseTypeMentionHasNonTypeParameterAt(
        Type sub, TypeMention baseMention, TypePath path, Type t
      ) {
        not t instanceof TypeParameter and
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
               * - `prefix = "0.0"`,
               * - `path0 = "0"`,
               * - `suffix = ""`,
               * - `path = "0.0"`
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
              path0.startsWith(tp, suffix) and
              path = prefix.append(suffix)
            )
          )
        )
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

        /** Gets the type parameter at position `ppos` of this declaration, if any. */
        TypeParameter getTypeParameter(TypeParameterPosition ppos);

        /**
         * Gets the declared type of this declaration at `path` for position `dpos`.
         *
         * For example, if this declaration is the method `int M(bool b)`,
         * then the declared type at parameter position `0` is `bool` and the
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
         * Gets the explicit type at `path` for the type argument at position
         * `apos` of this access, if any.
         *
         * For example, in a method call like `M<int>()`, `int` is an explicit
         * type argument at position `0`.
         */
        Type getExplicitTypeArgument(TypeArgumentPosition apos, TypePath path);

        /**
         * Gets the resolved type at `path` for the position `apos` of this access.
         *
         * For example, if this access is the method call `M(42)`, then the resolved
         * type at argument position `0` is `int`.
         */
        Type getResolvedType(AccessPosition apos, TypePath path);

        /** Gets the declaration that this access targets. */
        Declaration getTarget();
      }

      /** Holds if `apos` and `dpos` match. */
      bindingset[apos]
      bindingset[dpos]
      predicate accessDeclarationPositionMatch(AccessPosition apos, DeclarationPosition dpos);

      /**
       * Holds if matching a resolved type `t` at `path` inside an access at `apos`
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
       * the resolved type of `42` is `int`, but it should be adjusted to `int?`
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
     */
    module Matching<MatchingInputSig Input> {
      private import Input

      pragma[nomagic]
      private predicate accessTypeUnadjusted(
        Access a, AccessPosition apos, Declaration target, TypePath path, Type t
      ) {
        target = a.getTarget() and
        t = a.getResolvedType(apos, path)
      }

      pragma[nomagic]
      private predicate accessType(
        Access a, AccessPosition apos, Declaration target, TypePath path, Type t
      ) {
        exists(TypePath path0, Type t0 |
          accessTypeUnadjusted(a, apos, target, path0, t0) and
          adjustAccessType(apos, target, path0, t0, path, t)
        )
      }

      bindingset[a, target]
      pragma[inline_late]
      private Type explicitTypeArgument(
        Access a, Declaration target, TypeParameter tp, TypePath path
      ) {
        exists(TypeArgumentPosition apos, TypeParameterPosition ppos |
          result = a.getExplicitTypeArgument(apos, path) and
          tp = target.getTypeParameter(ppos) and
          typeArgumentParameterPositionMatch(apos, ppos)
        )
      }

      /**
       * Holds if the type `t` at `path` of `a` at position `apos` matches the type
       * parameter `tp` of `target` at position `dpos`.
       */
      pragma[nomagic]
      private predicate typeMatch(
        Access a, AccessPosition apos, Declaration target, DeclarationPosition dpos, TypePath path,
        Type t, TypeParameter tp
      ) {
        exists(TypePath pathToTypeParam |
          accessType(a, apos, target, pathToTypeParam.append(path), t) and
          tp = target.getDeclaredType(dpos, pathToTypeParam) and
          not exists(explicitTypeArgument(a, target, tp, _)) and
          accessDeclarationPositionMatch(apos, dpos)
        )
      }

      private module AccessBaseType {
        private predicate relevantAccess(Access a, AccessPosition apos) {
          exists(Declaration target |
            accessType(a, apos, target, _, _) and
            target.getDeclaredType(_, _) instanceof TypeParameter
          )
        }

        pragma[nomagic]
        private Type resolveRootType(Access a, AccessPosition apos) {
          relevantAccess(a, apos) and
          result = a.getResolvedType(apos, "")
        }

        pragma[nomagic]
        private Type resolveTypeAt(Access a, AccessPosition apos, TypeParameter tp, TypePath suffix) {
          relevantAccess(a, apos) and
          exists(TypePath path0 |
            result = a.getResolvedType(apos, path0) and
            path0.startsWith(tp, suffix)
          )
        }

        /**
         * Holds if `baseMention` is a (transitive) base type mention of the type of
         * `a` at position `apos`, and `t` is mentioned (implicitly) at `path` inside
         * `base`. For example, in
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
         * new Sub<int>().ToString();
         * ```
         *
         * for the node `new Sub<int>()`, which is the receiver of a method call, we
         * have:
         *
         * `baseMention` | `path`    | `t`
         * ------------- | --------- | ---
         * `Mid<C<T4>>`  | `"0"`     | ``C`1``
         * `Mid<C<T4>>`  | `"0.1"`   | `int`
         * `Base<C<T3>>` | `"0"`     | ``C`1``
         * `Base<C<T3>>` | `"0.0"`   | ``C`1``
         * `Base<C<T3>>` | `"0.0.1"` | `int`
         */
        pragma[nomagic]
        predicate hasBaseTypeMention(
          Access a, AccessPosition apos, TypeMention baseMention, TypePath path, Type t
        ) {
          exists(Type sub | sub = resolveRootType(a, apos) |
            baseTypeMentionHasNonTypeParameterAt(sub, baseMention, path, t)
            or
            exists(TypePath prefix, TypePath suffix, TypeParameter i |
              baseTypeMentionHasTypeParameterAt(sub, baseMention, prefix, i) and
              t = resolveTypeAt(a, apos, i, suffix) and
              path = prefix.append(suffix)
            )
          )
        }
      }

      pragma[nomagic]
      private predicate accessBaseType(
        Access a, AccessPosition apos, Declaration target, Type base, TypePath path, Type t
      ) {
        exists(TypeMention tm |
          target = a.getTarget() and
          AccessBaseType::hasBaseTypeMention(a, apos, tm, path, t) and
          base = resolveTypeMentionRoot(tm)
        )
      }

      pragma[nomagic]
      private predicate declarationBaseType(
        Declaration decl, DeclarationPosition dpos, Type base, TypePath path, Type t
      ) {
        t = decl.getDeclaredType(dpos, path) and
        path.startsWith(base.getATypeParameter(), _)
      }

      /**
       * Holds if the (transitive) base type `t` at `path` (which is somewhere inside `base`)
       * of `a` at position `apos` matches the type parameter `tp` of `target` at the position
       * `dpos`.
       *
       * For example, in
       *
       * ```csharp
       * class C<T1> { }
       *
       * class Base<T2> {
       * //    ^^^^ `base`
       * //         ^^ `tp`
       *     public C<T2> Method() { ... }
       * //               ^^^^^^ `target`
       * }
       *
       * class Mid<T3> : Base<C<T3>> { }
       *
       * class Sub<T4> : Mid<C<T4>> { }
       *
       * new Sub<int>().Method();
       * ```
       *
       * we have that for the node `new Sub<int>()`, which is the receiver of a method call:
       *
       * `path`    | `t`
       * --------- | -------
       * `"0"`     | ``C`1``
       * `"0.0"`   | ``C`1``
       * `"0.0.1"` | `int`
       *
       * `apos` is the receiver position, and `dpos` is the position of the implicit `this`
       * parameter.
       */
      pragma[nomagic]
      private predicate baseTypeMatch(
        Access a, AccessPosition apos, Declaration target, DeclarationPosition dpos, Type base,
        TypePath path, Type t, TypeParameter tp
      ) {
        exists(TypePath pathToTypeParam |
          accessBaseType(a, apos, target, base, pathToTypeParam.append(path), t) and
          declarationBaseType(target, dpos, base, pathToTypeParam, tp) and
          not exists(explicitTypeArgument(a, target, tp, _)) and
          accessDeclarationPositionMatch(apos, dpos)
        )
      }

      pragma[nomagic]
      private predicate explicitTypeMatch(
        Access a, Declaration target, TypePath path, Type t, TypeParameter tp
      ) {
        target = a.getTarget() and
        t = explicitTypeArgument(a, target, tp, path)
      }

      pragma[nomagic]
      private predicate implicitTypeMatch(
        Access a, Declaration target, TypePath path, Type t, TypeParameter tp
      ) {
        typeMatch(a, _, target, _, path, t, tp)
        or
        baseTypeMatch(a, _, target, _, _, path, t, tp)
      }

      pragma[inline]
      private predicate typeMatch(
        Access a, Declaration target, TypePath path, Type t, TypeParameter tp
      ) {
        explicitTypeMatch(a, target, path, t, tp)
        or
        implicitTypeMatch(a, target, path, t, tp)
      }

      /**
       * Gets the resolved type of `a` at `path` for position `apos`.
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
       * new Sub<int>().Method();
       * // ^^^^^^^^^^^^^^^^^^^^ a
       * ```
       *
       * we resolve the following types for the return position:
       *
       * `path`      | `t`
       * ----------- | -------
       * `"0"`       | ``C`1``
       * `"0.0"`     | ``C`1``
       * `"0.0.0"`   | ``C`1``
       * `"0.0.0.1"` | `int`
       */
      pragma[nomagic]
      Type resolveAccessType(Access a, AccessPosition apos, TypePath path) {
        exists(DeclarationPosition dpos | accessDeclarationPositionMatch(apos, dpos) |
          exists(Declaration target, TypePath prefix, TypeParameter tp, TypePath suffix |
            tp = target.getDeclaredType(pragma[only_bind_into](dpos), prefix) and
            typeMatch(a, target, suffix, result, tp) and
            path = prefix.append(suffix)
          )
          or
          exists(Declaration target |
            result = target.getDeclaredType(pragma[only_bind_into](dpos), path) and
            target = a.getTarget() and
            not result instanceof TypeParameter
          )
        )
      }
    }

    /** Provides consitency checks. */
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
    }
  }
}
