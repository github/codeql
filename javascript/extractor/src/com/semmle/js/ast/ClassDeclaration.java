package com.semmle.js.ast;

import com.semmle.ts.ast.ITypeExpression;
import com.semmle.ts.ast.TypeParameter;
import java.util.Collections;
import java.util.List;

/**
 * A class declaration such as
 *
 * <pre>
 * class ColouredPoint extends Point {
 *   constructor(x, y, colour) {
 *     super(x, y);
 *     this.colour = colour;
 *   }
 * }
 * </pre>
 */
public class ClassDeclaration extends Statement {
  private final AClass klass;
  private final boolean hasDeclareKeyword;
  private final boolean hasAbstractKeyword;

  public ClassDeclaration(
      SourceLocation loc, Identifier id, Expression superClass, ClassBody body) {
    this(loc, id, Collections.emptyList(), superClass, Collections.emptyList(), body, false, false);
  }

  public ClassDeclaration(
      SourceLocation loc,
      Identifier id,
      List<TypeParameter> typeParameters,
      Expression superClass,
      List<ITypeExpression> superInterfaces,
      ClassBody body,
      boolean hasDeclareKeyword,
      boolean hasAbstractKeyword) {
    this(
        loc,
        new AClass(id, typeParameters, superClass, superInterfaces, body),
        hasDeclareKeyword,
        hasAbstractKeyword);
  }

  public ClassDeclaration(
      SourceLocation loc, AClass klass, boolean hasDeclareKeyword, boolean hasAbstractKeyword) {
    super("ClassDeclaration", loc);
    this.klass = klass;
    this.hasDeclareKeyword = hasDeclareKeyword;
    this.hasAbstractKeyword = hasAbstractKeyword;
  }

  public AClass getClassDef() {
    return klass;
  }

  @Override
  public <C, R> R accept(Visitor<C, R> v, C c) {
    return v.visit(this, c);
  }

  public void addDecorators(List<Decorator> decorators) {
    klass.addDecorators(decorators);
  }

  public List<Decorator> getDecorators() {
    return klass.getDecorators();
  }

  public boolean hasDeclareKeyword() {
    return hasDeclareKeyword;
  }

  public boolean hasAbstractKeyword() {
    return hasAbstractKeyword;
  }
}
