/** Provides functionality for inferring types. */

private import rust
private import PathResolution

/** Gets the singleton type path `i`. */
bindingset[i]
private TypePath typePath(int i) { result = i.toString() }

bindingset[s]
private predicate decodeTypePathComponent(string s, int i) { i = s.toInt() }

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
class TypePath extends string {
  bindingset[this]
  TypePath() { exists(this) }

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
  predicate endsWith(TypePath prefix, int i) {
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
  predicate startsWith(int i, TypePath suffix) {
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

private predicate letStmtTyped(LetStmt let, Pat pat, TypeRepr t) {
  pat = let.getPat() and
  t = let.getTypeRepr() and
  not t instanceof InferTypeRepr
}

private predicate selfParamTyped(SelfParam p, TypeRepr t) {
  t = p.getTypeRepr() and
  not t instanceof InferTypeRepr
}

private predicate paramTyped(Param p, Pat pat, TypeRepr t) {
  pat = p.getPat() and
  t = p.getTypeRepr() and
  not t instanceof InferTypeRepr
}

private predicate isTargetTyped(AstNode n) {
  exists(Variable v |
    n = v.getPat() and
    not letStmtTyped(_, n, _) and
    not paramTyped(_, n, _)
  )
  or
  n = any(SelfParam self | not selfParamTyped(self, _))
}

// todo: add more cases
private newtype TType =
  TStruct(Struct s) or
  TEnum(Enum e) or
  TTrait(Trait t) or
  TArrayType() or // todo: add size?
  TRefType() or // todo: add mut, lifetime?
  TTypeParameter(TypeParam t)

/** A type without type arguments. */
abstract class Type extends TType {
  pragma[nomagic]
  abstract Function getMethod(string name);

  pragma[nomagic]
  abstract RecordField getRecordField(string name);

  pragma[nomagic]
  abstract TupleField getTupleField(int i);

  abstract string toString();

  abstract Location getLocation();
}

class StructType extends Type, TStruct {
  private Struct struct;

  StructType() { this = TStruct(struct) }

  override Function getMethod(string name) {
    // todo: assumes all `impl` blocks are in scope
    exists(ImplItemNode i |
      struct = i.resolveSelfTy() and
      result = i.getASuccessor(name)
    )
  }

  override RecordField getRecordField(string name) { result = struct.getRecordField(name) }

  override TupleField getTupleField(int i) { result = struct.getTupleField(i) }

  override string toString() { result = struct.toString() }

  override Location getLocation() { result = struct.getLocation() }
}

class EnumType extends Type, TEnum {
  private Enum enum;

  EnumType() { this = TEnum(enum) }

  override Function getMethod(string name) {
    // todo: assumes all `impl` blocks are in scope
    exists(ImplItemNode i |
      enum = i.resolveSelfTy() and
      result = i.getASuccessor(name)
    )
  }

  override RecordField getRecordField(string name) { none() }

  override TupleField getTupleField(int i) { none() }

  override string toString() { result = enum.toString() }

  override Location getLocation() { result = enum.getLocation() }
}

class TraitType extends Type, TTrait {
  private TraitItemNode trait;

  TraitType() { this = TTrait(trait) }

  override Function getMethod(string name) { result = trait.getASuccessor(name) }

  override RecordField getRecordField(string name) { none() }

  override TupleField getTupleField(int i) { none() }

  override string toString() { result = trait.toString() }

  override Location getLocation() { result = trait.getLocation() }
}

class ArrayType extends Type, TArrayType {
  ArrayType() { this = TArrayType() }

  override Function getMethod(string name) { none() }

  override RecordField getRecordField(string name) { none() }

  override TupleField getTupleField(int i) { none() }

  override string toString() { result = "[]" }

  override Location getLocation() { result instanceof EmptyLocation }
}

class RefType extends Type, TRefType {
  RefType() { this = TRefType() }

  override Function getMethod(string name) { none() }

  override RecordField getRecordField(string name) { none() }

  override TupleField getTupleField(int i) { none() }

  override string toString() { result = "&" }

  override Location getLocation() { result instanceof EmptyLocation }
}

class TypeParameter extends Type, TTypeParameter {
  private TypeParam typeParam;

  TypeParameter() { this = TTypeParameter(typeParam) }

  pragma[nomagic]
  private TypeRepr_ getABound() { result = typeParam.getTypeBoundList().getABound().getTypeRepr() }

  override Function getMethod(string name) {
    result = this.getABound().resolveTypeAt("").getMethod(name)
  }

  override RecordField getRecordField(string name) { none() }

  override TupleField getTupleField(int i) { none() }

  override string toString() { result = typeParam.toString() }

  override Location getLocation() { result = typeParam.getLocation() }
}

/** A `TypeRepr` or a `Path`. */
abstract private class TypeReprOrPath extends AstNode {
  /** Gets the `i`th type argument, if any. */
  abstract TypeRepr_ getTypeReprArgument(int i);

  /** Gets the type that this node resolves to. */
  abstract Type resolveType();

  /** Gets the node at `path`. */
  private TypeReprOrPath getTypeReprAt(TypePath path) {
    path.isEmpty() and
    result = this
    or
    exists(int i, TypeReprOrPath arg, TypePath suffix |
      arg = this.getTypeReprArgument(i) and
      result = arg.getTypeReprAt(suffix) and
      path = typePath(i).append(suffix)
    )
  }

  /** Gets the type that the sub node at `path` resolves to. */
  Type resolveTypeAt(TypePath path) { result = this.getTypeReprAt(path).resolveType() }
}

private class TypeRepr_ extends TypeReprOrPath, TypeRepr {
  override TypeRepr_ getTypeReprArgument(int i) {
    result = this.(ArrayTypeRepr).getElementTypeRepr() and
    i = 0
    or
    result = this.(RefTypeRepr).getTypeRepr() and
    i = 0
    or
    result = this.(PathTypeRepr).getPath().(Path_).getTypeReprArgument(i)
  }

  override Type resolveType() {
    this instanceof ArrayTypeRepr and
    result = TArrayType()
    or
    this instanceof RefTypeRepr and
    result = TRefType()
    or
    result = this.(PathTypeRepr).getPath().(Path_).resolveType()
  }
}

private class Path_ extends TypeReprOrPath, Path {
  override TypeRepr_ getTypeReprArgument(int i) {
    exists(GenericArgList args |
      args = this.getPart().getGenericArgList() and
      result =
        rank[i + 1](TypeRepr_ res, int j |
          res = args.getGenericArg(j).(TypeArg).getTypeRepr()
        |
          res order by j
        )
    )
  }

  override Type resolveType() {
    exists(ItemNode i | i = resolvePath(this) |
      result = TStruct(i)
      or
      result = TEnum(i)
      or
      result = TTrait(i)
      or
      result = TTypeParameter(i)
      or
      result = i.(TypeAlias).getTypeRepr().(TypeRepr_).resolveType()
    )
  }
}

private Type resolveVariableType(AstNode n, TypePath path) {
  exists(TypeRepr_ t | letStmtTyped(_, n, t) or selfParamTyped(n, t) or paramTyped(_, n, t) |
    result = t.resolveTypeAt(path)
  )
  or
  exists(Variable v |
    result = resolveType([v.getPat().(AstNode), v.getSelfParam()], path) and
    n = v.getAnAccess()
  )
}

pragma[nomagic]
private Type resolveSelfType(Impl i, TypePath path) {
  result = i.getSelfTy().(TypeRepr_).resolveTypeAt(path)
}

pragma[nomagic]
private Type resolveTargetTyped(AstNode n, TypePath path) {
  isTargetTyped(n) and
  (
    exists(LetStmt let |
      let.getPat() = n and
      result = resolveType(let.getInitializer(), path)
    )
    or
    exists(ImplItemNode i, Function f, SelfParam p, TypePath suffix, Type res |
      n = p and
      res = resolveSelfType(i, suffix) and
      f = i.getASuccessor(_) and
      p = f.getParamList().getSelfParam()
    |
      if p.isRef()
      then
        path.isEmpty() and
        result = TRefType()
        or
        path = typePath(0).append(suffix) and
        result = res
      else (
        path = suffix and
        result = res
      )
    )
  )
}

private Type resolveRecordExprType(RecordExpr re, TypePath path) {
  result = re.getPath().(Path_).resolveTypeAt(path)
}

pragma[nomagic]
private Type resolveFunctionReturnType(Function f, TypePath path) {
  result = f.getRetType().getTypeRepr().(TypeRepr_).resolveTypeAt(path) and
  not result instanceof TypeParameter
}

pragma[nomagic]
private Type resolvePathExprType(PathExpr pe, TypePath path) {
  exists(ItemNode i | i = resolvePath(pe.getPath()) |
    result = resolveFunctionReturnType(i, path)
    or
    exists(Enum e |
      i = e.getVariantList().getAVariant() and
      result = TEnum(e) and
      path.isEmpty()
    )
  )
  or
  result = pe.getPath().(Path_).resolveTypeAt(path)
}

pragma[nomagic]
private Type resolveCallExprType(CallExpr ce, TypePath path) {
  result = resolvePathExprType(ce.getFunction(), path)
}

pragma[nomagic]
Function resolveMethodCallExpr(MethodCallExpr mce) {
  exists(Type t, string name |
    t = resolveType(mce.getReceiver()) and
    name = mce.getNameRef().getText() and
    if t = TRefType()
    then
      // for reference types, lookup the method in the type being referenced
      result = resolveType(mce.getReceiver(), "0").getMethod(name)
    else result = t.getMethod(name)
  )
}

pragma[nomagic]
private Type resolveMethodCallExprType(MethodCallExpr mce, TypePath path) {
  exists(Function f |
    f = resolveMethodCallExpr(mce) and
    result = resolveFunctionReturnType(f, path)
  )
}

pragma[nomagic]
RecordField resolveRecordFieldExpr(FieldExpr fe) {
  exists(Type t, string name |
    t = resolveType(fe.getExpr()) and
    name = fe.getNameRef().getText() and
    if t = TRefType()
    then
      // for reference types, lookup the method in the type being referenced
      result = resolveType(fe.getExpr(), "0").getRecordField(name)
    else result = t.getRecordField(name)
  )
}

pragma[nomagic]
TupleField resolveTupleFieldExpr(FieldExpr fe) {
  exists(Type t, int i |
    t = resolveType(fe.getExpr()) and
    i = fe.getNameRef().getText().toInt() and
    if t = TRefType()
    then
      // for reference types, lookup the method in the type being referenced
      result = resolveType(fe.getExpr(), "0").getTupleField(i)
    else result = t.getTupleField(i)
  )
}

pragma[nomagic]
private Type resolveFieldExprType(FieldExpr fe, TypePath path) {
  exists(RecordField f |
    f = resolveRecordFieldExpr(fe) and
    result = f.getTypeRepr().(TypeRepr_).resolveTypeAt(path)
  )
  or
  exists(TupleField f |
    f = resolveTupleFieldExpr(fe) and
    result = f.getTypeRepr().(TypeRepr_).resolveTypeAt(path)
  )
}

pragma[nomagic]
private Type resolveRefExprType(RefExpr re, TypePath path) {
  exists(re) and
  path.isEmpty() and
  result = TRefType()
  or
  exists(TypePath suffix |
    result = resolveType(re.getExpr(), suffix) and
    path = typePath(0).append(suffix)
  )
}

Type resolveType(AstNode n, TypePath path) {
  result = resolveVariableType(n, path)
  or
  result = resolveTargetTyped(n, path)
  or
  result = resolveRecordExprType(n, path)
  or
  result = resolvePathExprType(n, path)
  or
  result = resolveCallExprType(n, path)
  or
  result = resolveMethodCallExprType(n, path)
  or
  result = resolveFieldExprType(n, path)
  or
  result = resolveRefExprType(n, path)
}

Type resolveType(AstNode n) { result = resolveType(n, "") }
