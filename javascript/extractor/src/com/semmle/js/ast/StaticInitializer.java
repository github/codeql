package com.semmle.js.ast;

/**
 * A static initializer block in a class.
 * E.g. 
 * ```TypeScript
 * class Foo {
 *  static bar : number;
 *  static {
 *   Foo.bar = 42;
 *  }
 * }
 */
public class StaticInitializer extends MemberDefinition<Expression> {
  private final BlockStatement body;

  public StaticInitializer(SourceLocation loc, BlockStatement body) {
    super("StaticInitializer", loc, DeclarationFlags.static_, null, null);
    this.body = body;
  }

  /**
   * Gets the body of this static initializer.
   * @return The body of this static initializer.
   */
  public BlockStatement getBody() {
    return body;
  }

  @Override
  public boolean isConcrete() {
    return false;
  }


  @Override
  public <C, R> R accept(Visitor<C, R> v, C c) {
    return v.visit(this, c);
  }
}
