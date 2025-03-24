private import javascript
private import semmle.javascript.internal.NameResolution::NameResolution
private import semmle.javascript.dataflow.internal.sharedlib.SummaryTypeTracker as SummaryTypeTracker

module TypeResolution {
  predicate trackClassValue = ValueFlow::TrackNode<ClassDefinition>::track/1;

  predicate trackType = TypeFlow::TrackNode<TypeDefinition>::track/1;

  predicate trackFunctionType = TypeFlow::TrackNode<Function>::track/1;

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
   * Holds if `host` is a type with a `content` of type `memberType`.
   */
  private predicate typeMember(Node host, DataFlow::Content content, Node memberType) {
    exists(MemberDeclaration decl | host = getMemberBase(decl) |
      exists(FieldDeclaration field |
        decl = field and
        content.asPropertyName() = field.getName() and
        memberType = field.getTypeAnnotation()
      )
      or
      exists(MethodDeclaration method |
        decl = method and
        content.asPropertyName() = method.getName() and
        memberType = method.getBody() // use the Function as representative for the function type
      )
      or
      decl instanceof IndexSignature and
      memberType = decl.(IndexSignature).getBody().getReturnTypeAnnotation() and
      content.isUnknownArrayElement()
    )
    or
    // Inherit members from base types
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
      mid.(UnionOrIntersectionTypeExpr).getAnElementType() = use
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
    SummaryTypeTracker::basicLoadStep(object.(AST::ValueNode).flow(),
      member.(AST::ValueNode).flow(), contents)
  }

  private predicate callTarget(InvokeExpr call, Function target) {
    exists(ClassDefinition cls |
      valueHasType(call.(NewExpr).getCallee(), trackClassValue(cls)) and
      target = cls.getConstructor().getBody()
    )
    or
    valueHasType(call.(InvokeExpr).getCallee(), trackFunctionValue(target))
    or
    valueHasType(call.(InvokeExpr).getCallee(), trackFunctionType(target)) and
    (
      call instanceof NewExpr and
      target = any(ConstructorTypeExpr t).getFunction()
      or
      call instanceof CallExpr and
      target = any(PlainFunctionTypeExpr t).getFunction()
    )
    or
    exists(InterfaceDefinition interface, CallSignature sig |
      valueHasType(call.(InvokeExpr).getCallee(), trackType(interface)) and
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

  private predicate contextualType(Node value, Node contextualType) {
    exists(InvokeExpr call, Function target, int i |
      callTarget(call, target) and
      value = call.getArgument(i) and
      contextualType = target.getParameter(i).getTypeAnnotation()
    )
  }

  /**
   * Holds if `value` has the given `type`.
   */
  predicate valueHasType(Node value, Node type) {
    value.(BindingPattern).getTypeAnnotation() = type
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
}
