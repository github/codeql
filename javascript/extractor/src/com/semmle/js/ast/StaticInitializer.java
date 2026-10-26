package com.semmle.js.ast;

/**
 * A static initializer block in a class. E.g. ```TypeScript class Foo { static
 * bar : number; static { Foo.bar = 42; } }
 */
public class StaticInitializer extends MemberDefinition<BlockStatement> {
  public StaticInitializer(SourceLocation loc, BlockStatement body) {
    super("StaticInitializer", loc, DeclarationFlags.static_, null, body);
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
