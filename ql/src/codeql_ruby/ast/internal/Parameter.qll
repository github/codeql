private import codeql_ruby.AST
private import TreeSitter
private import codeql_ruby.ast.internal.AST
private import codeql_ruby.ast.internal.Variable
private import codeql_ruby.ast.internal.Method
private import codeql_ruby.ast.internal.Pattern
private import codeql.Locations

module Parameter {
  class Range extends AstNode::Range {
    private int pos;

    Range() {
      this = any(Generated::BlockParameters bp).getChild(pos)
      or
      this = any(Generated::MethodParameters mp).getChild(pos)
      or
      this = any(Generated::LambdaParameters lp).getChild(pos)
    }

    final int getPosition() { result = pos }

    LocalVariable getAVariable() { none() }

    override string toString() { none() }
  }
}

module NamedParameter {
  abstract class Range extends Parameter::Range {
    abstract string getName();

    abstract LocalVariable getVariable();

    override LocalVariable getAVariable() { result = this.getVariable() }
  }
}

module SimpleParameter {
  class Range extends NamedParameter::Range, PatternParameter::Range, VariablePattern::Range {
    final override string getName() { result = this.getVariableName() }

    final override LocalVariable getVariable() { result = TLocalVariable(_, _, this) }

    final override LocalVariable getAVariable() { result = this.getVariable() }

    final override string toString() { result = this.getName() }
  }
}

module PatternParameter {
  class Range extends Parameter::Range, Pattern::Range {
    override LocalVariable getAVariable() { result = this.(Pattern::Range).getAVariable() }

    override string toString() { none() }
  }
}

module TuplePatternParameter {
  class Range extends PatternParameter::Range, TuplePattern::Range {
    override LocalVariable getAVariable() { result = TuplePattern::Range.super.getAVariable() }

    override string toString() { result = TuplePattern::Range.super.toString() }
  }
}

module BlockParameter {
  class Range extends NamedParameter::Range, @block_parameter {
    final override Generated::BlockParameter generated;

    final override string getName() { result = generated.getName().getValue() }

    final override LocalVariable getVariable() {
      result = TLocalVariable(_, _, generated.getName())
    }

    final override string toString() { result = "&" + this.getName() }
  }
}

module HashSplatParameter {
  class Range extends NamedParameter::Range, @hash_splat_parameter {
    final override Generated::HashSplatParameter generated;

    final override LocalVariable getVariable() {
      result = TLocalVariable(_, _, generated.getName())
    }

    final override string toString() { result = "**" + this.getName() }

    final override string getName() { result = generated.getName().getValue() }
  }
}

module KeywordParameter {
  class Range extends NamedParameter::Range, @keyword_parameter {
    final override Generated::KeywordParameter generated;

    final override LocalVariable getVariable() {
      result = TLocalVariable(_, _, generated.getName())
    }

    final Generated::AstNode getDefaultValue() { result = generated.getValue() }

    final override string toString() { result = this.getName() }

    final override string getName() { result = generated.getName().getValue() }
  }
}

module OptionalParameter {
  class Range extends NamedParameter::Range, @optional_parameter {
    final override Generated::OptionalParameter generated;

    final override LocalVariable getVariable() {
      result = TLocalVariable(_, _, generated.getName())
    }

    final Generated::AstNode getDefaultValue() { result = generated.getValue() }

    final override string toString() { result = this.getName() }

    final override string getName() { result = generated.getName().getValue() }
  }
}

module SplatParameter {
  class Range extends NamedParameter::Range, @splat_parameter {
    final override Generated::SplatParameter generated;

    final override LocalVariable getVariable() {
      result = TLocalVariable(_, _, generated.getName())
    }

    final override string toString() { result = "*" + this.getName() }

    final override string getName() { result = generated.getName().getValue() }
  }
}
