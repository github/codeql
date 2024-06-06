import ast

module BuildlessTypes<BuildlessASTSig AST> {
  module A = Buildless<AST>;

  private newtype TType =
    TBuiltinType(string name) { name = ["int", "char"] }
    or
    TUserType(string fqn) { exists(A::SourceTypeDefinition d | d.getName() = fqn) }
    //or
    //TPointerType(Type type) { exists(A::SourcePointer p | p.getType() = type) }
    //or
    //TConstType(Type type) { exists(A::SourceConst c | c.getType() = type) }

  class Type extends TType {
    string toString() { result = this.getName() }

    abstract string getName();
    Location getLocation() { none() }
  }

  class BuiltinType extends Type, TBuiltinType {
    override string getName() { this = TBuiltinType(result) }
  }

  class UserType extends Type, TUserType
  {
    override string getName() { this = TUserType(result) }

    override Location getLocation() { exists(A::SourceTypeDefinition d | this.getName() = d.getName() | result = d.getLocation()) }
  }
}

module TestTypes = BuildlessTypes<CompiledAST>;
