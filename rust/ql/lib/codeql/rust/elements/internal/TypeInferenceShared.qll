/** Provides shared functionality for computing type inference in QL. */

private import codeql.util.Location

signature module InputSig1<LocationSig Location> {
  class Type {
    TypeParameter getATypeParameter();

    string toString();

    Location getLocation();
  }

  class TypeParameter extends Type {
    int getPosition();
  }

  int getTypeParameterId(TypeParameter tp);

  bindingset[this]
  class TypeArgPos {
    bindingset[this]
    string toString();
  }

  bindingset[this]
  class TypeParamPos {
    bindingset[this]
    string toString();
  }

  bindingset[apos]
  bindingset[ppos]
  predicate typeParamArgPosMatch(TypeParamPos ppos, TypeArgPos apos);

  class Expr {
    string toString();

    Location getLocation();
  }
}

module Make1<LocationSig Location, InputSig1<Location> Input1> {
  private import Input1
  private import codeql.util.DenseRank

  final private class ExprFinal = Expr;

  private module DenseRankInput implements DenseRankInputSig {
    class Ranked = TypeParameter;

    predicate getRank = getTypeParameterId/1;
  }

  private int getTypeParameterRank(TypeParameter tp) {
    tp = DenseRank<DenseRankInput>::denseRank(result)
  }

  /** Gets the singleton type path `i`. */
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
   * Paths are represented in left-to-right order, for example, a path `0.1` into the
   * type `C1<C2<A,B>,C3<C,D>>` points at the type `B`.
   *
   * Type paths are used to represent constructed types without using a `newtype`, which
   * makes it practically feasible to do type inference in mutual recursion with call
   * resolution.
   *
   * As an example, the type above can be represented by the following set of tuples
   *
   * `TypePath` | `Type`
   * ---------- | ------
   * `""`       | ``C1``
   * `"0"`      | ``C2``
   * `"0.0"`    | `A`
   * `"0.1"`    | `B`
   * `"1"`      | ``C3``
   * `"1.0"`    | `C`
   * `"1.1"`    | `D`
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

    /** Holds if this path starts with `prefix`, followed by `i`. */
    bindingset[this]
    predicate endsWith(TypePath prefix, TypeParameter i) {
      decodeTypePathComponent(this, i) and
      prefix.isEmpty()
      or
      exists(int last |
        last = max(this.indexOf(".")) and
        prefix = this.prefix(last) and
        decodeTypePathComponent(this.suffix(last + 1), i)
      )
    }

    /** Holds if this path starts with `i`, followed by `suffix`. */
    bindingset[this]
    predicate startsWith(TypeParameter i, TypePath suffix) {
      decodeTypePathComponent(this, i) and
      suffix.isEmpty()
      or
      exists(int first |
        first = min(this.indexOf(".")) and
        suffix = this.suffix(first + 1) and
        decodeTypePathComponent(this.prefix(first), i)
      )
    }
  }

  signature module InputSig2 {
    class TypeMention {
      Type resolveTypeAt(TypePath path);

      string toString();

      Location getLocation();
    }

    TypeMention getABaseTypeMention(Type t);

    Type resolveExprType(Expr e, TypePath path);
  }

  module Make2<InputSig2 Input2> {
    private import Input2

    pragma[nomagic]
    private Type resolveTypeMentionRoot(TypeMention tm) {
      result = tm.resolveTypeAt(any(TypePath empty | empty.isEmpty()))
    }

    /**
     * Provides the parameterized module `ArgBaseType` for computing base types
     * of arguments.
     */
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
      private predicate baseTypeMentionHasTypeParameterAt(
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
            // Example (using the classes defined in the QL doc):
            // - `sub = Sub`,
            // - `immmediateBaseMention = Mid<C<T4>>`
            // - `immmediateBase = Mid`,
            // - `baseMention = Base<C<T3>>`,
            // - `prefix = "0.0"`,
            // - `mid = T3`,
            // - `pathToTypeParam = "0.0"`,
            // - `suffix = "0"`,
            // - `path = "0.0.0"`,
            // - `tp = T4`.
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
       * - `C` is mentioned at `0` for immediate base type `Base` of `Mid`,
       * - `C` is mentioned at `0` for immediate base type `Mid` of `Sub`, and
       * - `C` is mentioned at `0` and `0.0` for transitive base type `Base` of `Sub`.
       */
      pragma[nomagic]
      private predicate baseTypeMentionHasNonTypeParameterAt(
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
              // Example (using the classes defined in the QL doc):
              // - `sub = Sub`,
              // - `immmediateBaseMention = Mid<C<T4>>`
              // - `immmediateBase = Mid`,
              // - `baseMention = Base<C<T3>>`,
              // - `prefix = "0.0"`,
              // - `tp = T3`,
              // - `path0 = "0"`,
              // - `t = C`,
              // - `suffix = ""`,
              // - `path = "0.0"`.
              baseTypeMentionHasTypeParameterAt(immediateBase, baseMention, prefix, tp) and
              t = immediateBaseMention.resolveTypeAt(path0) and
              path0.startsWith(tp, suffix) and
              path = prefix.append(suffix)
            )
          )
        )
      }

      signature module ArgBaseTypeInputSig {
        class Arg extends ExprFinal;
      }

      module ArgBaseType<ArgBaseTypeInputSig Input> {
        pragma[nomagic]
        private Type resolveRootType(Input::Arg arg) { result = resolveExprType(arg, "") }

        pragma[nomagic]
        private Type resolveTypeAt(Input::Arg arg, TypeParameter tp, TypePath suffix) {
          exists(TypePath path0 |
            result = resolveExprType(arg, path0) and
            path0.startsWith(tp, suffix)
          )
        }

        /**
         * Holds if `baseMention` is a (transitive) base type mention of the type of
         * `arg`, and `t` is mentioned (implicitly) at `path` inside `base`. For example,
         * in
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
         * new Sub<int>();
         * ```
         *
         * for the node `new Sub<int>()`:
         *
         * - `C` is mentioned at `0` for immediate base type `Mid`,
         * - `int` is mentioned at `0.1` for immediate base type `Mid`,
         * - `C` is mentioned at `0` and `0.0` for transitive base type `Base`, and
         * - `int` is mentioned at `0.0.1` for transitive base type `Base`.
         */
        pragma[nomagic]
        predicate hasBaseType(Input::Arg arg, TypeMention baseMention, TypePath path, Type t) {
          exists(Type sub | sub = resolveRootType(arg) |
            baseTypeMentionHasNonTypeParameterAt(sub, baseMention, path, t)
            or
            exists(TypePath prefix, TypePath suffix, TypeParameter i |
              baseTypeMentionHasTypeParameterAt(sub, baseMention, prefix, i) and
              t = resolveTypeAt(arg, i, suffix) and
              path = prefix.append(suffix)
            )
          )
        }
      }
    }

    private import BaseTypes

    /** Provides the input to `Matching`. */
    signature module MatchingInputSig {
      /** A declaration, for example a method. */
      class Decl {
        string toString();

        Location getLocation();

        TypeParameter getTypeParameter(TypeParamPos ppos);
      }

      /** An access that targets a declaration, for example a method call. */
      class Access {
        string toString();

        Location getLocation();

        Type getExplicitTypeArgument(TypeArgPos apos, TypePath path);
      }

      bindingset[this]
      class ArgPos {
        bindingset[this]
        string toString();
      }

      bindingset[this]
      class ParamPos {
        bindingset[this]
        string toString();
      }

      bindingset[apos]
      bindingset[ppos]
      predicate paramArgPosMatch(ParamPos ppos, ArgPos apos);

      predicate target(Access a, Decl target);

      Expr getArg(Access a, ArgPos apos);

      predicate parameterType(Decl decl, ParamPos ppos, TypePath path, Type t);
    }

    module Matching<MatchingInputSig Input> {
      private import Input

      pragma[nomagic]
      private predicate argumentType(Access a, ArgPos apos, Decl target, TypePath path, Type t) {
        target(a, target) and
        exists(Expr arg |
          arg = getArg(a, apos) and
          t = resolveExprType(arg, path)
        )
      }

      bindingset[a, target]
      pragma[inline_late]
      private Type explicitTypeArgument(Access a, Decl target, TypeParameter tp, TypePath path) {
        exists(TypeArgPos apos, TypeParamPos ppos |
          result = a.getExplicitTypeArgument(apos, path) and
          tp = target.getTypeParameter(ppos) and
          typeParamArgPosMatch(ppos, apos)
        )
      }

      /**
       * Holds if the type `t` at `path` of `a` at position `pos` matches the type parameter
       * of `target` at the same position.
       */
      pragma[nomagic]
      private predicate typeMatch(
        Access a, ArgPos apos, Decl target, ParamPos ppos, TypePath path, Type t, TypeParameter tp
      ) {
        exists(TypePath pathToTypeParam |
          argumentType(a, apos, target, pathToTypeParam.append(path), t) and
          parameterType(target, ppos, pathToTypeParam, tp) and
          not exists(explicitTypeArgument(a, target, tp, _)) and
          paramArgPosMatch(ppos, apos)
        )
      }

      predicate declType(Decl decl, ParamPos at, TypePath path, Type t) {
        parameterType(decl, at, path, t)
      }

      private module ArgBaseTypeInput implements ArgBaseTypeInputSig {
        class Arg extends ExprFinal {
          Arg() {
            exists(Access a, ArgPos apos, Decl target |
              this = getArg(a, apos) and
              argumentType(a, apos, target, _, _) and
              declType(target, _, _, any(TypeParameter tp))
            )
          }
        }
      }

      pragma[nomagic]
      private predicate argumentBaseTypeAt(
        Access a, ArgPos apos, Decl target, Type base, TypePath path, Type t
      ) {
        exists(TypeMention tm |
          target(a, target) and
          ArgBaseType<ArgBaseTypeInput>::hasBaseType(getArg(a, apos), tm, path, t) and
          base = resolveTypeMentionRoot(tm)
        )
      }

      pragma[nomagic]
      private predicate parameterBaseType(Decl decl, ParamPos ppos, Type base, TypePath path, Type t) {
        parameterType(decl, ppos, path, t) and
        path.startsWith(base.getATypeParameter(), _)
      }

      /**
       * Holds if the (transitive) base type `t` at `path` (which is somewhere inside `base`)
       * of `a` at position `pos` matches the type parameter of `target` at the same position.
       */
      pragma[nomagic]
      private predicate baseTypeMatch(
        Access a, ArgPos apos, Decl target, ParamPos ppos, Type base, TypePath path, Type t,
        TypeParameter tp
      ) {
        exists(TypePath pathToTypeParam |
          argumentBaseTypeAt(a, apos, target, base, pathToTypeParam.append(path), t) and
          parameterBaseType(target, ppos, base, pathToTypeParam, tp) and
          not exists(explicitTypeArgument(a, target, tp, _)) and
          paramArgPosMatch(ppos, apos) and
          // do not allow `pathToTypeParam` to be empty in this case, as we will match
          // against the actual type and not one of the base types
          not pathToTypeParam.isEmpty()
        )
      }

      pragma[nomagic]
      private predicate explicitTypeMatch(
        Access a, Decl target, TypePath path, Type t, TypeParameter tp
      ) {
        target(a, target) and
        t = explicitTypeArgument(a, target, tp, path)
        // exists(int i |
        //   t = a.getExplicitTypeArgument(pragma[only_bind_into](i), path) and
        //   target(a, target) and
        //   tp = target.getTypeParameter(pragma[only_bind_into](i))
        // )
      }

      pragma[nomagic]
      private predicate implicitTypeMatch(
        Access a, Decl target, TypePath path, Type t, TypeParameter tp
      ) {
        typeMatch(a, _, target, _, path, t, tp)
        or
        baseTypeMatch(a, _, target, _, _, path, t, tp)
      }

      pragma[inline]
      private predicate typeMatch(Access a, Decl target, TypePath path, Type t, TypeParameter tp) {
        explicitTypeMatch(a, target, path, t, tp)
        or
        implicitTypeMatch(a, target, path, t, tp)
      }

      pragma[nomagic]
      private Type resolveAccess(Access a, ArgPos apos, ParamPos ppos, TypePath path) {
        paramArgPosMatch(ppos, apos) and
        (
          exists(Decl target, TypePath prefix, TypeParameter tp, TypePath suffix |
            declType(target, pragma[only_bind_into](ppos), prefix, tp) and
            typeMatch(a, target, suffix, result, tp) and
            path = prefix.append(suffix)
          )
          or
          exists(Decl target |
            declType(target, pragma[only_bind_into](ppos), path, result) and
            target(a, target) and
            not result instanceof TypeParameter
          )
        )
      }

      pragma[nomagic]
      Type resolveArgType(Expr arg, ArgPos apos, ParamPos ppos, TypePath path) {
        exists(Access a |
          arg = getArg(a, apos) and
          result = resolveAccess(a, apos, ppos, path)
        )
      }
    }
  }
}
