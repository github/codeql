class TokenKind extends @token_kind {
  string toString() { none() }

  string getDescription() { none() }

  int getValue() { none() }
}

class Ampersand extends @ampersand, TokenKind {
  override int getValue() { result = 28 }

  override string getDescription() { result = "The invocation operator '&'." }

  override string toString() { result = "Ampersand" }
}

class And extends @and, TokenKind {
  override int getValue() { result = 53 }

  override string getDescription() { result = "The logical and operator '-and'." }

  override string toString() { result = "And" }
}

class AndAnd extends @andAnd, TokenKind {
  override int getValue() { result = 26 }

  override string getDescription() { result = "The (unimplemented) operator '&&'." }

  override string toString() { result = "AndAnd" }
}

class As extends @as, TokenKind {
  override int getValue() { result = 94 }

  override string getDescription() { result = "The type conversion operator '-as'." }

  override string toString() { result = "As" }
}

class Assembly extends @assembly, TokenKind {
  override int getValue() { result = 165 }

  override string getDescription() { result = "The 'assembly' keyword" }

  override string toString() { result = "Assembly" }
}

class AtCurly extends @atCurly, TokenKind {
  override int getValue() { result = 23 }

  override string getDescription() { result = "The opening token of a hash expression '@{'." }

  override string toString() { result = "AtCurly" }
}

class AtParen extends @atParen, TokenKind {
  override int getValue() { result = 22 }

  override string getDescription() { result = "The opening token of an array expression '@('." }

  override string toString() { result = "AtParen" }
}

class Band extends @band, TokenKind {
  override int getValue() { result = 56 }

  override string getDescription() { result = "The bitwise and operator '-band'." }

  override string toString() { result = "Band" }
}

class Base extends @base, TokenKind {
  override int getValue() { result = 168 }

  override string getDescription() { result = "The 'base' keyword" }

  override string toString() { result = "Base" }
}

class Begin extends @begin, TokenKind {
  override int getValue() { result = 119 }

  override string getDescription() { result = "The 'begin' keyword." }

  override string toString() { result = "Begin" }
}

class Bnot extends @bnot, TokenKind {
  override int getValue() { result = 52 }

  override string getDescription() { result = "The bitwise not operator '-bnot'." }

  override string toString() { result = "Bnot" }
}

class Bor extends @bor, TokenKind {
  override int getValue() { result = 57 }

  override string getDescription() { result = "The bitwise or operator '-bor'." }

  override string toString() { result = "Bor" }
}

class Break extends @break, TokenKind {
  override int getValue() { result = 120 }

  override string getDescription() { result = "The 'break' keyword." }

  override string toString() { result = "Break" }
}

class Bxor extends @bxor, TokenKind {
  override int getValue() { result = 58 }

  override string getDescription() { result = "The bitwise exclusive or operator '-xor'." }

  override string toString() { result = "Bxor" }
}

class Catch extends @catch, TokenKind {
  override int getValue() { result = 121 }

  override string getDescription() { result = "The 'catch' keyword." }

  override string toString() { result = "Catch" }
}

class Ccontains extends @ccontains, TokenKind {
  override int getValue() { result = 87 }

  override string getDescription() { result = "The case sensitive contains operator '-ccontains'." }

  override string toString() { result = "Ccontains" }
}

class Ceq extends @ceq, TokenKind {
  override int getValue() { result = 76 }

  override string getDescription() { result = "The case sensitive equal operator '-ceq'." }

  override string toString() { result = "Ceq" }
}

class Cge extends @cge, TokenKind {
  override int getValue() { result = 78 }

  override string getDescription() {
    result = "The case sensitive greater than or equal operator '-cge'."
  }

  override string toString() { result = "Cge" }
}

class Cgt extends @cgt, TokenKind {
  override int getValue() { result = 79 }

  override string getDescription() { result = "The case sensitive greater than operator '-cgt'." }

  override string toString() { result = "Cgt" }
}

class Cin extends @cin, TokenKind {
  override int getValue() { result = 89 }

  override string getDescription() { result = "The case sensitive in operator '-cin'." }

  override string toString() { result = "Cin" }
}

class Class extends @class, TokenKind {
  override int getValue() { result = 122 }

  override string getDescription() { result = "The 'class' keyword." }

  override string toString() { result = "Class" }
}

class Cle extends @cle, TokenKind {
  override int getValue() { result = 81 }

  override string getDescription() {
    result = "The case sensitive less than or equal operator '-cle'."
  }

  override string toString() { result = "Cle" }
}

class Clean extends @clean, TokenKind {
  override int getValue() { result = 170 }

  override string getDescription() { result = "The 'clean' keyword." }

  override string toString() { result = "Clean" }
}

class Clike extends @clike, TokenKind {
  override int getValue() { result = 82 }

  override string getDescription() { result = "The case sensitive like operator '-clike'." }

  override string toString() { result = "Clike" }
}

class Clt extends @clt, TokenKind {
  override int getValue() { result = 80 }

  override string getDescription() { result = "The case sensitive less than operator '-clt'." }

  override string toString() { result = "Clt" }
}

class Cmatch extends @cmatch, TokenKind {
  override int getValue() { result = 84 }

  override string getDescription() { result = "The case sensitive match operator '-cmatch'." }

  override string toString() { result = "Cmatch" }
}

class Cne extends @cne, TokenKind {
  override int getValue() { result = 77 }

  override string getDescription() { result = "The case sensitive not equal operator '-cne'." }

  override string toString() { result = "Cne" }
}

class Cnotcontains extends @cnotcontains, TokenKind {
  override int getValue() { result = 88 }

  override string getDescription() {
    result = "The case sensitive not contains operator '-cnotcontains'."
  }

  override string toString() { result = "Cnotcontains" }
}

class Cnotin extends @cnotin, TokenKind {
  override int getValue() { result = 90 }

  override string getDescription() { result = "The case sensitive not in operator '-notin'." }

  override string toString() { result = "Cnotin" }
}

class Cnotlike extends @cnotlike, TokenKind {
  override int getValue() { result = 83 }

  override string getDescription() { result = "The case sensitive notlike operator '-cnotlike'." }

  override string toString() { result = "Cnotlike" }
}

class Cnotmatch extends @cnotmatch, TokenKind {
  override int getValue() { result = 85 }

  override string getDescription() {
    result = "The case sensitive not match operator '-cnotmatch'."
  }

  override string toString() { result = "Cnotmatch" }
}

class Colon extends @colon, TokenKind {
  override int getValue() { result = 99 }

  override string getDescription() {
    result =
      "The PS class base class and implemented interfaces operator ':'. Also used in base class ctor calls."
  }

  override string toString() { result = "Colon" }
}

class ColonColon extends @colonColon, TokenKind {
  override int getValue() { result = 34 }

  override string getDescription() { result = "The static member access operator '::'." }

  override string toString() { result = "ColonColon" }
}

class Comma extends @comma, TokenKind {
  override int getValue() { result = 30 }

  override string getDescription() { result = "The unary or binary array operator ','." }

  override string toString() { result = "Comma" }
}

class CommandToken extends @command_token, TokenKind {
  override int getValue() { result = 166 }

  override string getDescription() { result = "The 'command' keyword" }

  override string toString() { result = "Command" }
}

class Comment extends @comment, TokenKind {
  override int getValue() { result = 10 }

  override string getDescription() { result = "A single line comment, or a delimited comment." }

  override string toString() { result = "Comment" }
}

class Configuration extends @configuration, TokenKind {
  override int getValue() { result = 155 }

  override string getDescription() { result = "The 'configuration' keyword" }

  override string toString() { result = "Configuration" }
}

class Continue extends @continue, TokenKind {
  override int getValue() { result = 123 }

  override string getDescription() { result = "The 'continue' keyword." }

  override string toString() { result = "Continue" }
}

class Creplace extends @creplace, TokenKind {
  override int getValue() { result = 86 }

  override string getDescription() { result = "The case sensitive replace operator '-creplace'." }

  override string toString() { result = "Creplace" }
}

class Csplit extends @csplit, TokenKind {
  override int getValue() { result = 91 }

  override string getDescription() { result = "The case sensitive split operator '-csplit'." }

  override string toString() { result = "Csplit" }
}

class Data extends @data, TokenKind {
  override int getValue() { result = 124 }

  override string getDescription() { result = "The 'data' keyword." }

  override string toString() { result = "Data" }
}

class Default extends @default, TokenKind {
  override int getValue() { result = 169 }

  override string getDescription() { result = "The 'default' keyword" }

  override string toString() { result = "Default" }
}

class Define extends @define, TokenKind {
  override int getValue() { result = 125 }

  override string getDescription() { result = "The (unimplemented) 'define' keyword." }

  override string toString() { result = "Define" }
}

class Divide extends @divide, TokenKind {
  override int getValue() { result = 38 }

  override string getDescription() { result = "The division operator '/'." }

  override string toString() { result = "Divide" }
}

class DivideEquals extends @divideEquals, TokenKind {
  override int getValue() { result = 46 }

  override string getDescription() { result = "The division assignment operator '/='." }

  override string toString() { result = "DivideEquals" }
}

class Do extends @do, TokenKind {
  override int getValue() { result = 126 }

  override string getDescription() { result = "The 'do' keyword." }

  override string toString() { result = "Do" }
}

class DollarParen extends @dollarParen, TokenKind {
  override int getValue() { result = 24 }

  override string getDescription() { result = "The opening token of a sub-expression '$('." }

  override string toString() { result = "DollarParen" }
}

class Dot extends @dot, TokenKind {
  override int getValue() { result = 35 }

  override string getDescription() {
    result = "The instance member access or dot source invocation operator '.'."
  }

  override string toString() { result = "Dot" }
}

class DotDot extends @dotDot, TokenKind {
  override int getValue() { result = 33 }

  override string getDescription() { result = "The range operator '..'." }

  override string toString() { result = "DotDot" }
}

class DynamicKeyword extends @dynamicKeyword, TokenKind {
  override int getValue() { result = 156 }

  override string getDescription() { result = "The token kind for dynamic keywords" }

  override string toString() { result = "DynamicKeyword" }
}

class Dynamicparam extends @dynamicparam, TokenKind {
  override int getValue() { result = 127 }

  override string getDescription() { result = "The 'dynamicparam' keyword." }

  override string toString() { result = "Dynamicparam" }
}

class Else extends @else, TokenKind {
  override int getValue() { result = 128 }

  override string getDescription() { result = "The 'else' keyword." }

  override string toString() { result = "Else" }
}

class ElseIf extends @elseIf, TokenKind {
  override int getValue() { result = 129 }

  override string getDescription() { result = "The 'elseif' keyword." }

  override string toString() { result = "ElseIf" }
}

class End extends @end, TokenKind {
  override int getValue() { result = 130 }

  override string getDescription() { result = "The 'end' keyword." }

  override string toString() { result = "End" }
}

class EndOfInput extends @endOfInput, TokenKind {
  override int getValue() { result = 11 }

  override string getDescription() { result = "Marks the end of the input script or file." }

  override string toString() { result = "EndOfInput" }
}

class Enum extends @enum, TokenKind {
  override int getValue() { result = 161 }

  override string getDescription() { result = "The 'enum' keyword" }

  override string toString() { result = "Enum" }
}

class Equals extends @equals, TokenKind {
  override int getValue() { result = 42 }

  override string getDescription() { result = "The assignment operator '='." }

  override string toString() { result = "Equals" }
}

class Exclaim extends @exclaim, TokenKind {
  override int getValue() { result = 36 }

  override string getDescription() { result = "The logical not operator '!'." }

  override string toString() { result = "Exclaim" }
}

class Exit extends @exit, TokenKind {
  override int getValue() { result = 131 }

  override string getDescription() { result = "The 'exit' keyword." }

  override string toString() { result = "Exit" }
}

class Filter extends @filter, TokenKind {
  override int getValue() { result = 132 }

  override string getDescription() { result = "The 'filter' keyword." }

  override string toString() { result = "Filter" }
}

class Finally extends @finally, TokenKind {
  override int getValue() { result = 133 }

  override string getDescription() { result = "The 'finally' keyword." }

  override string toString() { result = "Finally" }
}

class For extends @for, TokenKind {
  override int getValue() { result = 134 }

  override string getDescription() { result = "The 'for' keyword." }

  override string toString() { result = "For" }
}

class Foreach extends @foreach, TokenKind {
  override int getValue() { result = 135 }

  override string getDescription() { result = "The 'foreach' keyword." }

  override string toString() { result = "Foreach" }
}

class Format extends @format, TokenKind {
  override int getValue() { result = 50 }

  override string getDescription() { result = "The string format operator '-f'." }

  override string toString() { result = "Format" }
}

class From extends @from, TokenKind {
  override int getValue() { result = 136 }

  override string getDescription() { result = "The (unimplemented) 'from' keyword." }

  override string toString() { result = "From" }
}

class Function extends @function, TokenKind {
  override int getValue() { result = 137 }

  override string getDescription() { result = "The 'function' keyword." }

  override string toString() { result = "Function" }
}

class Generic extends @generic, TokenKind {
  override int getValue() { result = 7 }

  override string getDescription() {
    result =
      "A token that is only valid as a command name, command argument, function name, or configuration name. It may contain characters not allowed in identifiers. Tokens with this kind are always instances of StringLiteralToken or StringExpandableToken if the token contains variable references or subexpressions."
  }

  override string toString() { result = "Generic" }
}

class HereStringExpandable extends @hereStringExpandable, TokenKind {
  override int getValue() { result = 15 }

  override string getDescription() {
    result =
      "A double quoted here string literal. Tokens with this kind are always instances of StringExpandableToken. even if there are no nested tokens to expand."
  }

  override string toString() { result = "HereStringExpandable" }
}

class HereStringLiteral extends @hereStringLiteral, TokenKind {
  override int getValue() { result = 14 }

  override string getDescription() {
    result =
      "A single quoted here string literal. Tokens with this kind are always instances of StringLiteralToken."
  }

  override string toString() { result = "HereStringLiteral" }
}

class Hidden extends @hidden, TokenKind {
  override int getValue() { result = 167 }

  override string getDescription() { result = "The 'hidden' keyword" }

  override string toString() { result = "Hidden" }
}

class Icontains extends @icontains, TokenKind {
  override int getValue() { result = 71 }

  override string getDescription() {
    result = "The case insensitive contains operator '-icontains' or '-contains'."
  }

  override string toString() { result = "Icontains" }
}

class Identifier extends @identifier, TokenKind {
  override int getValue() { result = 6 }

  override string getDescription() {
    result =
      "A simple identifier, always begins with a letter or '', and is followed by letters, numbers, or ''."
  }

  override string toString() { result = "Identifier" }
}

class Ieq extends @ieq, TokenKind {
  override int getValue() { result = 60 }

  override string getDescription() {
    result = "The case insensitive equal operator '-ieq' or '-eq'."
  }

  override string toString() { result = "Ieq" }
}

class If extends @if, TokenKind {
  override int getValue() { result = 138 }

  override string getDescription() { result = "The 'if' keyword." }

  override string toString() { result = "If" }
}

class Ige extends @ige, TokenKind {
  override int getValue() { result = 62 }

  override string getDescription() {
    result = "The case insensitive greater than or equal operator '-ige' or '-ge'."
  }

  override string toString() { result = "Ige" }
}

class Igt extends @igt, TokenKind {
  override int getValue() { result = 63 }

  override string getDescription() {
    result = "The case insensitive greater than operator '-igt' or '-gt'."
  }

  override string toString() { result = "Igt" }
}

class Iin extends @iin, TokenKind {
  override int getValue() { result = 73 }

  override string getDescription() { result = "The case insensitive in operator '-iin' or '-in'." }

  override string toString() { result = "Iin" }
}

class Ile extends @ile, TokenKind {
  override int getValue() { result = 65 }

  override string getDescription() {
    result = "The case insensitive less than or equal operator '-ile' or '-le'."
  }

  override string toString() { result = "Ile" }
}

class Ilike extends @ilike, TokenKind {
  override int getValue() { result = 66 }

  override string getDescription() {
    result = "The case insensitive like operator '-ilike' or '-like'."
  }

  override string toString() { result = "Ilike" }
}

class Ilt extends @ilt, TokenKind {
  override int getValue() { result = 64 }

  override string getDescription() {
    result = "The case insensitive less than operator '-ilt' or '-lt'."
  }

  override string toString() { result = "Ilt" }
}

class Imatch extends @imatch, TokenKind {
  override int getValue() { result = 68 }

  override string getDescription() {
    result = "The case insensitive match operator '-imatch' or '-match'."
  }

  override string toString() { result = "Imatch" }
}

class In extends @in, TokenKind {
  override int getValue() { result = 139 }

  override string getDescription() { result = "The 'in' keyword." }

  override string toString() { result = "In" }
}

class Ine extends @ine, TokenKind {
  override int getValue() { result = 61 }

  override string getDescription() {
    result = "The case insensitive not equal operator '-ine' or '-ne'."
  }

  override string toString() { result = "Ine" }
}

class InlineScript extends @inlineScript, TokenKind {
  override int getValue() { result = 154 }

  override string getDescription() { result = "The 'InlineScript' keyword" }

  override string toString() { result = "InlineScript" }
}

class Inotcontains extends @inotcontains, TokenKind {
  override int getValue() { result = 72 }

  override string getDescription() {
    result = "The case insensitive notcontains operator '-inotcontains' or '-notcontains'."
  }

  override string toString() { result = "Inotcontains" }
}

class Inotin extends @inotin, TokenKind {
  override int getValue() { result = 74 }

  override string getDescription() {
    result = "The case insensitive notin operator '-inotin' or '-notin'"
  }

  override string toString() { result = "Inotin" }
}

class Inotlike extends @inotlike, TokenKind {
  override int getValue() { result = 67 }

  override string getDescription() {
    result = "The case insensitive not like operator '-inotlike' or '-notlike'."
  }

  override string toString() { result = "Inotlike" }
}

class Inotmatch extends @inotmatch, TokenKind {
  override int getValue() { result = 69 }

  override string getDescription() {
    result = "The case insensitive not match operator '-inotmatch' or '-notmatch'."
  }

  override string toString() { result = "Inotmatch" }
}

class Interface extends @interface, TokenKind {
  override int getValue() { result = 160 }

  override string getDescription() { result = "The 'interface' keyword" }

  override string toString() { result = "Interface" }
}

class Ireplace extends @ireplace, TokenKind {
  override int getValue() { result = 70 }

  override string getDescription() {
    result = "The case insensitive replace operator '-ireplace' or '-replace'."
  }

  override string toString() { result = "Ireplace" }
}

class Is extends @is, TokenKind {
  override int getValue() { result = 92 }

  override string getDescription() { result = "The type test operator '-is'." }

  override string toString() { result = "Is" }
}

class IsNot extends @isNot, TokenKind {
  override int getValue() { result = 93 }

  override string getDescription() { result = "The type test operator '-isnot'." }

  override string toString() { result = "IsNot" }
}

class Isplit extends @isplit, TokenKind {
  override int getValue() { result = 75 }

  override string getDescription() {
    result = "The case insensitive split operator '-isplit' or '-split'."
  }

  override string toString() { result = "Isplit" }
}

class Join extends @join, TokenKind {
  override int getValue() { result = 59 }

  override string getDescription() { result = "The join operator '-join'." }

  override string toString() { result = "Join" }
}

class Label extends @label, TokenKind {
  override int getValue() { result = 5 }

  override string getDescription() {
    result =
      "A label token - always begins with ':', followed by the label name. Tokens with this kind are always instances of LabelToken."
  }

  override string toString() { result = "Label" }
}

class LBracket extends @lBracket, TokenKind {
  override int getValue() { result = 20 }

  override string getDescription() { result = "The opening square brace token '['." }

  override string toString() { result = "LBracket" }
}

class LCurly extends @lCurly, TokenKind {
  override int getValue() { result = 18 }

  override string getDescription() { result = "The opening curly brace token '{'." }

  override string toString() { result = "LCurly" }
}

class LineContinuation extends @lineContinuation, TokenKind {
  override int getValue() { result = 9 }

  override string getDescription() {
    result = "A line continuation (backtick followed by newline)."
  }

  override string toString() { result = "LineContinuation" }
}

class LParen extends @lParen, TokenKind {
  override int getValue() { result = 16 }

  override string getDescription() { result = "The opening parenthesis token '('." }

  override string toString() { result = "LParen" }
}

class Minus extends @minus, TokenKind {
  override int getValue() { result = 41 }

  override string getDescription() { result = "The substraction operator '-'." }

  override string toString() { result = "Minus" }
}

class MinusEquals extends @minusEquals, TokenKind {
  override int getValue() { result = 44 }

  override string getDescription() { result = "The subtraction assignment operator '-='." }

  override string toString() { result = "MinusEquals" }
}

class MinusMinus extends @minusMinus, TokenKind {
  override int getValue() { result = 31 }

  override string getDescription() { result = "The pre-decrement operator '--'." }

  override string toString() { result = "MinusMinus" }
}

class Module extends @module, TokenKind {
  override int getValue() { result = 163 }

  override string getDescription() { result = "The 'module' keyword" }

  override string toString() { result = "Module" }
}

class Multiply extends @multiply, TokenKind {
  override int getValue() { result = 37 }

  override string getDescription() { result = "The multiplication operator '*'." }

  override string toString() { result = "Multiply" }
}

class MultiplyEquals extends @multiplyEquals, TokenKind {
  override int getValue() { result = 45 }

  override string getDescription() { result = "The multiplication assignment operator '*='." }

  override string toString() { result = "MultiplyEquals" }
}

class Namespace extends @namespace, TokenKind {
  override int getValue() { result = 162 }

  override string getDescription() { result = "The 'namespace' keyword" }

  override string toString() { result = "Namespace" }
}

class NewLine extends @newLine, TokenKind {
  override int getValue() { result = 8 }

  override string getDescription() { result = "A newline (one of '\n', '\r', or '\r\n')." }

  override string toString() { result = "NewLine" }
}

class Not extends @not, TokenKind {
  override int getValue() { result = 51 }

  override string getDescription() { result = "The logical not operator '-not'." }

  override string toString() { result = "Not" }
}

class Number extends @number, TokenKind {
  override int getValue() { result = 4 }

  override string getDescription() {
    result =
      "Any numerical literal token. Tokens with this kind are always instances of NumberToken."
  }

  override string toString() { result = "Number" }
}

class Or extends @or, TokenKind {
  override int getValue() { result = 54 }

  override string getDescription() { result = "The logical or operator '-or'." }

  override string toString() { result = "Or" }
}

class OrOr extends @orOr, TokenKind {
  override int getValue() { result = 27 }

  override string getDescription() { result = "The (unimplemented) operator '||'." }

  override string toString() { result = "OrOr" }
}

class Parallel extends @parallel, TokenKind {
  override int getValue() { result = 152 }

  override string getDescription() { result = "The 'parallel' keyword." }

  override string toString() { result = "Parallel" }
}

class Param extends @param, TokenKind {
  override int getValue() { result = 140 }

  override string getDescription() { result = "The 'param' keyword." }

  override string toString() { result = "Param" }
}

class ParameterToken extends @parameter_token, TokenKind {
  override int getValue() { result = 3 }

  override string getDescription() {
    result =
      "A parameter to a command, always begins with a dash ('-'), followed by the parameter name. Tokens with this kind are always instances of ParameterToken."
  }

  override string toString() { result = "Parameter" }
}

class Pipe extends @pipe, TokenKind {
  override int getValue() { result = 29 }

  override string getDescription() { result = "The pipe operator '|'." }

  override string toString() { result = "Pipe" }
}

class Plus extends @plus, TokenKind {
  override int getValue() { result = 40 }

  override string getDescription() { result = "The addition operator '+'." }

  override string toString() { result = "Plus" }
}

class PlusEquals extends @plusEquals, TokenKind {
  override int getValue() { result = 43 }

  override string getDescription() { result = "The addition assignment operator '+='." }

  override string toString() { result = "PlusEquals" }
}

class PlusPlus extends @plusPlus, TokenKind {
  override int getValue() { result = 32 }

  override string getDescription() { result = "The pre-increment operator '++'." }

  override string toString() { result = "PlusPlus" }
}

class PostfixMinusMinus extends @postfixMinusMinus, TokenKind {
  override int getValue() { result = 96 }

  override string getDescription() { result = "The post-decrement operator '--'." }

  override string toString() { result = "PostfixMinusMinus" }
}

class PostfixPlusPlus extends @postfixPlusPlus, TokenKind {
  override int getValue() { result = 95 }

  override string getDescription() { result = "The post-increment operator '++'." }

  override string toString() { result = "PostfixPlusPlus" }
}

class Private extends @private, TokenKind {
  override int getValue() { result = 158 }

  override string getDescription() { result = "The 'private' keyword" }

  override string toString() { result = "Private" }
}

class Process extends @process, TokenKind {
  override int getValue() { result = 141 }

  override string getDescription() { result = "The 'process' keyword." }

  override string toString() { result = "Process" }
}

class Public extends @public, TokenKind {
  override int getValue() { result = 157 }

  override string getDescription() { result = "The 'public' keyword" }

  override string toString() { result = "Public" }
}

class QuestionDot extends @questionDot, TokenKind {
  override int getValue() { result = 103 }

  override string getDescription() { result = "The null conditional member access operator '?.'." }

  override string toString() { result = "QuestionDot" }
}

class QuestionLBracket extends @questionLBracket, TokenKind {
  override int getValue() { result = 104 }

  override string getDescription() { result = "The null conditional index access operator '?[]'." }

  override string toString() { result = "QuestionLBracket" }
}

class QuestionMark extends @questionMark, TokenKind {
  override int getValue() { result = 100 }

  override string getDescription() { result = "The ternary operator '?'." }

  override string toString() { result = "QuestionMark" }
}

class QuestionQuestion extends @questionQuestion, TokenKind {
  override int getValue() { result = 102 }

  override string getDescription() { result = "The null coalesce operator '??'." }

  override string toString() { result = "QuestionQuestion" }
}

class QuestionQuestionEquals extends @questionQuestionEquals, TokenKind {
  override int getValue() { result = 101 }

  override string getDescription() { result = "The null conditional assignment operator '??='." }

  override string toString() { result = "QuestionQuestionEquals" }
}

class RBracket extends @rBracket, TokenKind {
  override int getValue() { result = 21 }

  override string getDescription() { result = "The closing square brace token ']'." }

  override string toString() { result = "RBracket" }
}

class RCurly extends @rCurly, TokenKind {
  override int getValue() { result = 19 }

  override string getDescription() { result = "The closing curly brace token '}'." }

  override string toString() { result = "RCurly" }
}

class RedirectInStd extends @redirectInStd, TokenKind {
  override int getValue() { result = 49 }

  override string getDescription() {
    result = "The (unimplemented) stdin redirection operator '<'."
  }

  override string toString() { result = "RedirectInStd" }
}

class RedirectionToken extends @redirection_token, TokenKind {
  override int getValue() { result = 48 }

  override string getDescription() { result = "A redirection operator such as '2>&1' or '>>'." }

  override string toString() { result = "Redirection" }
}

class Rem extends @rem, TokenKind {
  override int getValue() { result = 39 }

  override string getDescription() { result = "The modulo division (remainder) operator '%'." }

  override string toString() { result = "Rem" }
}

class RemainderEquals extends @remainderEquals, TokenKind {
  override int getValue() { result = 47 }

  override string getDescription() {
    result = "The modulo division (remainder) assignment operator '%='."
  }

  override string toString() { result = "RemainderEquals" }
}

class Return extends @return, TokenKind {
  override int getValue() { result = 142 }

  override string getDescription() { result = "The 'return' keyword." }

  override string toString() { result = "Return" }
}

class RParen extends @rParen, TokenKind {
  override int getValue() { result = 17 }

  override string getDescription() { result = "The closing parenthesis token ')'." }

  override string toString() { result = "RParen" }
}

class Semi extends @semi, TokenKind {
  override int getValue() { result = 25 }

  override string getDescription() { result = "The statement terminator ';'." }

  override string toString() { result = "Semi" }
}

class Sequence extends @sequence, TokenKind {
  override int getValue() { result = 153 }

  override string getDescription() { result = "The 'sequence' keyword." }

  override string toString() { result = "Sequence" }
}

class Shl extends @shl, TokenKind {
  override int getValue() { result = 97 }

  override string getDescription() { result = "The shift left operator." }

  override string toString() { result = "Shl" }
}

class Shr extends @shr, TokenKind {
  override int getValue() { result = 98 }

  override string getDescription() { result = "The shift right operator." }

  override string toString() { result = "Shr" }
}

class SplattedVariable extends @splattedVariable, TokenKind {
  override int getValue() { result = 2 }

  override string getDescription() {
    result =
      "A splatted variable token, always begins with '@' and followed by the variable name. Tokens with this kind are always instances of VariableToken."
  }

  override string toString() { result = "SplattedVariable" }
}

class Static extends @static, TokenKind {
  override int getValue() { result = 159 }

  override string getDescription() { result = "The 'static' keyword" }

  override string toString() { result = "Static" }
}

class StringExpandable extends @stringExpandable, TokenKind {
  override int getValue() { result = 13 }

  override string getDescription() {
    result =
      "A double quoted string literal. Tokens with this kind are always instances of StringExpandableToken even if there are no nested tokens to expand."
  }

  override string toString() { result = "StringExpandable" }
}

class StringLiteralToken extends @stringLiteral_token, TokenKind {
  override int getValue() { result = 12 }

  override string getDescription() {
    result =
      "A single quoted string literal. Tokens with this kind are always instances of StringLiteralToken."
  }

  override string toString() { result = "StringLiteral" }
}

class Switch extends @switch, TokenKind {
  override int getValue() { result = 143 }

  override string getDescription() { result = "The 'switch' keyword." }

  override string toString() { result = "Switch" }
}

class Throw extends @throw, TokenKind {
  override int getValue() { result = 144 }

  override string getDescription() { result = "The 'throw' keyword." }

  override string toString() { result = "Throw" }
}

class Trap extends @trap, TokenKind {
  override int getValue() { result = 145 }

  override string getDescription() { result = "The 'trap' keyword." }

  override string toString() { result = "Trap" }
}

class Try extends @try, TokenKind {
  override int getValue() { result = 146 }

  override string getDescription() { result = "The 'try' keyword." }

  override string toString() { result = "Try" }
}

class Type extends @type, TokenKind {
  override int getValue() { result = 164 }

  override string getDescription() { result = "The 'type' keyword" }

  override string toString() { result = "Type" }
}

class Unknown extends @unknown, TokenKind {
  override int getValue() { result = 0 }

  override string getDescription() { result = "An unknown token, signifies an error condition." }

  override string toString() { result = "Unknown" }
}

class Until extends @until, TokenKind {
  override int getValue() { result = 147 }

  override string getDescription() { result = "The 'until' keyword." }

  override string toString() { result = "Until" }
}

class Using extends @using, TokenKind {
  override int getValue() { result = 148 }

  override string getDescription() { result = "The (unimplemented) 'using' keyword." }

  override string toString() { result = "Using" }
}

class Var extends @var, TokenKind {
  override int getValue() { result = 149 }

  override string getDescription() { result = "The (unimplemented) 'var' keyword." }

  override string toString() { result = "Var" }
}

class Variable extends @variable, TokenKind {
  override int getValue() { result = 1 }

  override string getDescription() {
    result =
      "A variable token, always begins with '$' and followed by the variable name, possibly enclose in curly braces. Tokens with this kind are always instances of VariableToken."
  }

  override string toString() { result = "Variable" }
}

class While extends @while, TokenKind {
  override int getValue() { result = 150 }

  override string getDescription() { result = "The 'while' keyword." }

  override string toString() { result = "While" }
}

class Workflow extends @workflow, TokenKind {
  override int getValue() { result = 151 }

  override string getDescription() { result = "The 'workflow' keyword." }

  override string toString() { result = "Workflow" }
}

class Xor extends @xor, TokenKind {
  override int getValue() { result = 55 }

  override string getDescription() { result = "The logical exclusive or operator '-xor'." }

  override string toString() { result = "Xor" }
}
