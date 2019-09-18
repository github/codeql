package com.semmle.js.ast;

import com.semmle.ts.ast.ITypeExpression;
import com.semmle.ts.ast.TypeParameter;
import java.util.Collections;
import java.util.List;

/**
 * A class expression as in
 *
 * <pre>
 * let ColouredPoint = class extends Point {
 *   constructor(x, y, colour) {
 *     super(x, y);
 *     this.colour = colour;
 *   }
 * };
 * </pre>
 */
public class ClassExpression extends Expression {
  private final AClass klass;

  public ClassExpression(SourceLocation loc, Identifier id, Expression superClass, ClassBody body) {
    this(loc, id, Collections.emptyList(), superClass, Collections.emptyList(), body);
  }

  public ClassExpression(
      SourceLocation loc,
      Identifier id,
      List<TypeParameter> typeParameters,
      Expression superClass,
      List<ITypeExpression> superInterfaces,
      ClassBody body) {
    this(loc, new AClass(id, typeParameters, superClass, superInterfaces, body));
  }

  public ClassExpression(SourceLocation loc, AClass klass) {
    super("ClassExpression", loc);
    this.klass = klass;
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

  public Iterable<Decorator> getDecorators() {
    return klass.getDecorators();
  }
}
