private import javascript
private import semmle.javascript.internal.NameResolution::NameResolution
private import semmle.javascript.internal.UnderlyingTypes
private import semmle.javascript.dataflow.internal.sharedlib.SummaryTypeTracker as SummaryTypeTracker

module TypeResolution {
  predicate trackClassValue = ValueFlow::TrackNode<ClassDefinition>::track/1;

  predicate trackType = TypeFlow::TrackNode<TypeDefinition>::track/1;

  Node trackFunctionType(Function fun) {
    result = fun
    or
    exists(Node mid | mid = trackFunctionType(fun) |
      TypeFlow::step(mid, result)
      or
      UnderlyingTypes::underlyingTypeStep(mid, result)
    )
  }

  predicate trackFunctionValue = ValueFlow::TrackNode<Function>::track/1;

  /**
   * Gets the representative for the type containing the given member.
   *
   * For non-static members this is simply the enclosing type declaration.
   *
   * For static members we use the class's `Variable` as representative for the type of the class object.
   */
  private Node getMemberBase(MemberDeclaration member) {
    if member.isStatic()
    then result = member.getDeclaringClass().getVariable()
    else result = member.getDeclaringType()
  }

  /**
   * Holds if `host` is a type with a `content` of type `memberType`, not counting inherited members.
   */
  private predicate typeOwnMember(Node host, DataFlow::Content content, Node memberType) {
    exists(MemberDeclaration decl | host = getMemberBase(decl) |
      exists(FieldDeclaration field |
        decl = field and
        content.asPropertyName() = field.getName() and
        memberType = field.getTypeAnnotation()
      )
      or
      exists(MethodDeclaration method |
        decl = method and
        content.asPropertyName() = method.getName()
      |
        not method instanceof AccessorMethodDeclaration and
        memberType = method.getBody() // use the Function as representative for the function type
        or
        method instanceof GetterMethodDeclaration and
        memberType = method.getBody().getReturnTypeAnnotation()
      )
      or
      decl instanceof IndexSignature and
      memberType = decl.(IndexSignature).getBody().getReturnTypeAnnotation() and
      content.isUnknownArrayElement()
    )
    or
    // Ad-hoc support for array types. We don't support generics in general currently, we just special-case arrays and promises.
    content.isUnknownArrayElement() and
    (
      memberType = host.(ArrayTypeExpr).getElementType()
      or
      exists(GenericTypeExpr type |
        host = type and
        type.getTypeAccess().(LocalTypeAccess).getName() = ["Array", "ReadonlyArray"] and
        memberType = type.getTypeArgument(0)
      )
      or
      exists(JSDocAppliedTypeExpr type |
        host = type and
        type.getHead().(JSDocLocalTypeAccess).getName() = "Array" and
        memberType = type.getArgument(0)
      )
    )
    or
    content.isPromiseValue() and
    memberType = unwrapPromiseType(host)
  }

  /**
   * Holds if `host` is a type with a `content` of type `memberType`, possible due to inheritance.
   */
  private predicate typeMember(Node host, DataFlow::Content content, Node memberType) {
    typeOwnMember(host, content, memberType)
    or
    // Inherit members from base types
    not typeOwnMember(host, content, _) and
    exists(ClassOrInterface baseType | typeMember(baseType, content, memberType) |
      host.(ClassDefinition).getSuperClass() = trackClassValue(baseType)
      or
      host.(ClassOrInterface).getASuperInterface() = trackType(baseType)
    )
  }

  /**
   * Holds `use` refers to `host`, and `host` has type members.
   *
   * Currently steps through unions and intersections, which acts as a basic
   * approximation to the unions/intersection of objects.
   */
  private predicate typeMemberHostReaches(Node host, Node use) {
    typeMember(host, _, _) and
    use = host
    or
    exists(Node mid | typeMemberHostReaches(host, mid) |
      TypeFlow::step(mid, use)
      or
      UnderlyingTypes::underlyingTypeStep(mid, use)
    )
  }

  /**
   * Holds if there is a read from from `object` to `member` that reads `contents`.
   */
  private predicate valueReadStep(Node object, DataFlow::ContentSet contents, Node member) {
    member.(PropAccess).accesses(object, contents.asPropertyName())
    or
    object.(ObjectPattern).getPropertyPatternByName(contents.asPropertyName()).getValuePattern() =
      member
    or
    member.(AwaitExpr).getOperand() = object and
    contents = DataFlow::ContentSet::promiseValue()
    or
    SummaryTypeTracker::basicLoadStep(object.(AST::ValueNode).flow(),
      member.(AST::ValueNode).flow(), contents)
  }

  predicate callTarget(InvokeExpr call, Function target) {
    exists(ClassDefinition cls |
      valueHasType(call.(NewExpr).getCallee(), trackClassValue(cls)) and
      target = cls.getConstructor().getBody()
    )
    or
    valueHasType(call.getCallee(), trackFunctionValue(target))
    or
    valueHasType(call.getCallee(), trackFunctionType(target)) and
    (
      call instanceof NewExpr and
      target = any(ConstructorTypeExpr t).getFunction()
      or
      call instanceof CallExpr and
      target = any(PlainFunctionTypeExpr t).getFunction()
    )
    or
    exists(InterfaceDefinition interface, CallSignature sig |
      valueHasType(call.getCallee(), trackType(interface)) and
      sig = interface.getACallSignature() and
      target = sig.getBody()
    |
      call instanceof NewExpr and
      sig instanceof ConstructorCallSignature
      or
      call instanceof CallExpr and
      sig instanceof FunctionCallSignature
    )
  }

  private predicate functionReturnType(Function func, Node returnType) {
    returnType = func.getReturnTypeAnnotation()
    or
    not exists(func.getReturnTypeAnnotation()) and
    exists(Function functionType |
      contextualType(func, trackFunctionType(functionType)) and
      returnType = functionType.getReturnTypeAnnotation()
    )
  }

  bindingset[name]
  private predicate isPromiseTypeName(string name) {
    name.regexpMatch(".?(Promise|Thenable)(Like)?")
  }

  private Node unwrapPromiseType(Node promiseType) {
    exists(GenericTypeExpr type |
      promiseType = type and
      isPromiseTypeName(type.getTypeAccess().(LocalTypeAccess).getName()) and
      result = type.getTypeArgument(0)
    )
    or
    exists(JSDocAppliedTypeExpr type |
      promiseType = type and
      isPromiseTypeName(type.getHead().(JSDocLocalTypeAccess).getName()) and
      result = type.getArgument(0)
    )
  }

  predicate contextualType(Node value, Node type) {
    exists(LocalVariableLike v |
      type = v.getADeclaration().getTypeAnnotation() and
      value = v.getAnAssignedExpr()
    )
    or
    exists(InvokeExpr call, Function target, int i |
      callTarget(call, target) and
      value = call.getArgument(i) and
      type = target.getParameter(i).getTypeAnnotation()
    )
    or
    exists(Function lambda, Node returnType |
      value = lambda.getAReturnedExpr() and
      functionReturnType(lambda, returnType)
    |
      not lambda.isAsyncOrGenerator() and
      type = returnType
      or
      lambda.isAsync() and
      type = unwrapPromiseType(returnType)
    )
    or
    exists(ObjectExpr object, Node objectType, Node host, string name |
      contextualType(object, objectType) and
      typeMemberHostReaches(host, objectType) and
      typeMember(host, any(DataFlow::Content c | c.asPropertyName() = name), type) and
      value = object.getPropertyByName(name).getInit()
    )
    or
    exists(ArrayExpr array, Node arrayType, Node host |
      contextualType(array, arrayType) and
      typeMemberHostReaches(host, arrayType) and
      typeMember(host, any(DataFlow::Content c | c.isUnknownArrayElement()), type) and
      value = array.getAnElement()
    )
  }

  /**
   * Holds if `value` has the given `type`.
   */
  predicate valueHasType(Node value, Node type) {
    value.(BindingPattern).getTypeAnnotation() = type
    or
    value.(TypeAssertion).getTypeAnnotation() = type
    or
    exists(VarDecl decl |
      // ValueFlow::step is restricted to variables with at most one assignment. Allow the type annotation
      // of a variable to propagate to its uses, even if the variable has multiple assignments.
      type = decl.getTypeAnnotation() and
      value = decl.getVariable().(LocalVariableLike).getAnAccess()
    )
    or
    exists(MemberDeclaration member |
      value.(ThisExpr).getBindingContainer() = member.getInit() and
      type = getMemberBase(member)
    )
    or
    exists(ClassDefinition cls |
      value = cls and
      type = cls.getVariable()
    )
    or
    exists(FunctionDeclStmt fun |
      value = fun and
      type = fun.getVariable()
    )
    or
    exists(Function target | callTarget(value, target) |
      type = target.getReturnTypeAnnotation()
      or
      exists(ClassDefinition cls |
        target = cls.getConstructor().getBody() and
        type = cls
      )
    )
    or
    // Contextual typing for parameters
    exists(Function lambda, Function functionType, int i |
      contextualType(lambda, trackFunctionType(functionType))
      or
      exists(InterfaceDefinition interface |
        contextualType(lambda, trackType(interface)) and
        functionType = interface.getACallSignature().getBody()
      )
    |
      value = lambda.getParameter(i) and
      not exists(value.(Parameter).getTypeAnnotation()) and
      type = functionType.getParameter(i).getTypeAnnotation()
    )
    or
    exists(Node mid | valueHasType(mid, type) | ValueFlow::step(mid, value))
    or
    exists(Node mid, Node midType, DataFlow::ContentSet contents, Node host |
      valueReadStep(mid, contents, value) and
      valueHasType(mid, midType) and
      typeMemberHostReaches(host, midType) and
      typeMember(host, contents.getAReadContent(), type)
    )
  }

  signature predicate nodeSig(Node node);

  /**
   * Tracks types that have a certain property, in the sense that:
   * - an intersection type has the property if any member has the property
   * - a union type has the property if all its members have the property
   */
  module TrackMustProp<nodeSig/1 directlyHasProperty> {
    predicate hasProperty(Node node) {
      directlyHasProperty(node)
      or
      exists(Node mid |
        hasProperty(mid) and
        TypeFlow::step(mid, node)
      )
      or
      unionHasProp(node)
      or
      hasProperty(node.(IntersectionTypeExpr).getAnElementType())
      or
      exists(ConditionalTypeExpr cond |
        node = cond and
        hasProperty(cond.getTrueType()) and
        hasProperty(cond.getFalseType())
      )
    }

    private predicate unionHasProp(UnionTypeExpr node, int n) {
      hasProperty(node.getElementType(0)) and n = 1
      or
      unionHasProp(node, n - 1) and
      hasProperty(node.getElementType(n - 1))
    }

    private predicate unionHasProp(UnionTypeExpr node) {
      unionHasProp(node, node.getNumElementType())
    }
  }

  module ValueHasProperty<nodeSig/1 typeHasProperty> {
    predicate valueHasProperty(Node value) {
      exists(Node type |
        valueHasType(value, type) and
        typeHasProperty(type)
      )
    }
  }

  private predicate isSanitizingPrimitiveTypeBase(Node node) {
    node.(TypeExpr).isNumbery()
    or
    node.(TypeExpr).isBooleany()
    or
    node.(TypeExpr).isNull()
    or
    node.(TypeExpr).isUndefined()
    or
    node.(TypeExpr).isVoid()
    or
    node.(TypeExpr).isNever()
    or
    node instanceof LiteralTypeExpr
    or
    node = any(EnumMember m).getIdentifier() // enum members are constant
    or
    node instanceof EnumDeclaration // enums are unions of constants
  }

  /**
   * Holds if `node` refers to a type that is considered untaintable (if actually enforced at runtime).
   *
   * Specifically, the types `number`, `boolean`, `null`, `undefined`, `void`, `never`, as well as literal types (`"foo"`)
   * and enums and enum members have this property.
   */
  predicate isSanitizingPrimitiveType =
    TrackMustProp<isSanitizingPrimitiveTypeBase/1>::hasProperty/1;

  /**
   * Holds if `value` has a type that is considered untaintable (if actually enforced at runtime).
   *
   * See `isSanitizingPrimitiveType`.
   */
  predicate valueHasSanitizingPrimitiveType =
    ValueHasProperty<isSanitizingPrimitiveType/1>::valueHasProperty/1;

  private predicate isPromiseBase(Node node) { exists(unwrapPromiseType(node)) }

  /**
   * Holds if the given type is a Promise object. Does not hold for unions unless all parts of the union are promises.
   */
  predicate isPromiseType = TrackMustProp<isPromiseBase/1>::hasProperty/1;

  /**
   * Holds if the given value has a type that implied it is a Promise object. Does not hold for unions unless all parts of the union are promises.
   */
  predicate valueHasPromiseType = ValueHasProperty<isPromiseType/1>::valueHasProperty/1;

  /**
   * Holds if `type` contains `string` or `any`, possibly wrapped in a promise.
   */
  predicate hasUnderlyingStringOrAnyType(Node type) {
    type.(TypeAnnotation).isStringy()
    or
    type.(TypeAnnotation).isAny()
    or
    type instanceof StringLiteralTypeExpr
    or
    type instanceof TemplateLiteralTypeExpr
    or
    exists(Node mid | hasUnderlyingStringOrAnyType(mid) |
      TypeFlow::step(mid, type)
      or
      UnderlyingTypes::underlyingTypeStep(mid, type)
      or
      type = unwrapPromiseType(mid)
    )
  }
}
