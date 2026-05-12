"use strict";
/*
 * MIT License
 *
 * Copyright (c) 2021 alex-pinkus
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
const PRECS = {
  multiplication: 11,
  addition: 10,
  infix_operations: 9,
  nil_coalescing: 8,
  check: 7,
  prefix_operations: 7,
  comparison: 6,
  postfix_operations: 6,
  equality: 5,
  conjunction: 4,
  disjunction: 3,
  block: 2,
  loop: 1,
  keypath: 1,
  parameter_pack: 1,
  control_transfer: 0,
  as: -1,
  tuple: -1,
  if: -1,
  switch: -1,
  do: -1,
  fully_open_range: -1,
  range: -1,
  navigation: -1,
  expr: -1,
  ty: -1,
  call: -2,
  ternary: -2,
  try: -2,
  call_suffix: -2,
  range_suffix: -2,
  ternary_binary_suffix: -2,
  await: -2,
  assignment: -3,
  comment: -3,
  lambda: -3,
  regex: -4,
};

const DYNAMIC_PRECS = {
  call: 1,
};

const DEC_DIGITS = token(sep1(/[0-9]+/, /_+/));
const HEX_DIGITS = token(sep1(/[0-9a-fA-F]+/, /_+/));
const OCT_DIGITS = token(sep1(/[0-7]+/, /_+/));
const BIN_DIGITS = token(sep1(/[01]+/, /_+/));
const REAL_EXPONENT = token(seq(/[eE]/, optional(/[+-]/), DEC_DIGITS));
const HEX_REAL_EXPONENT = token(seq(/[pP]/, optional(/[+-]/), DEC_DIGITS));

var LEXICAL_IDENTIFIER;

if (tree_sitter_version_supports_emoji()) {
  LEXICAL_IDENTIFIER =
    /[_\p{XID_Start}\p{Emoji}&&[^0-9#*]](\p{EMod}|\x{FE0F}\x{20E3}?)?([_\p{XID_Continue}\p{Emoji}\x{200D}](\p{EMod}|\x{FE0F}\x{20E3}?)?)*/;
} else {
  LEXICAL_IDENTIFIER = /[_\p{XID_Start}][_\p{XID_Continue}]*/;
}

module.exports = grammar({
  name: "swift",
  supertypes: ($) => [
    $.expression,
    $.unannotated_type,
    $.global_declaration,
    $.type_level_declaration,
    $.local_declaration,
    $.protocol_member_declaration,
  ],
  conflicts: ($) => [
    // @Type(... could either be an annotation constructor invocation or an annotated expression
    [$.attribute],
    [$._attribute_argument],
    // Is `foo { ... }` a constructor invocation or function invocation?
    [$.simple_user_type, $.expression],
    // To support nested types A.B not being interpreted as `(navigation_expression ... (type_identifier)) (navigation_suffix)`
    [$.user_type],
    // How to tell the difference between Foo.bar(with:and:), and Foo.bar(with: smth, and: other)? You need GLR
    [$.value_argument],
    // { (foo, bar) ...
    [$.expression, $.lambda_parameter],
    [$._primary_expression, $.lambda_parameter],
    // (start: start, end: end)
    [$._tuple_type_item_identifier, $.tuple_expression],
    // After a `{` in a function or switch context, it's ambigous whether we're starting a set of local statements or
    // applying some modifiers to a capture or pattern.
    [$.modifiers],
    // `+(...)` is ambigously either "call the function produced by a reference to the operator `+`" or "use the unary
    // operator `+` on the result of the parenthetical expression."
    [$._additive_operator, $._prefix_unary_operator],
    [$.referenceable_operator, $._prefix_unary_operator],
    // `{ [self, b, c] ...` could be a capture list or an array literal depending on what else happens.
    [$.capture_list_item, $.expression],
    [$.capture_list_item, $.expression, $.simple_user_type],
    [$._primary_expression, $.capture_list_item],
    // a ? b : c () could be calling c(), or it could be calling a function that's produced by the result of
    // `(a ? b : c)`. We have a small hack to force it to be the former of these by intentionally introducing a
    // conflict.
    [$.call_suffix, $.expr_hack_at_ternary_binary_call_suffix],
    // try {expression} is a bit magic and applies quite broadly: `try foo()` and `try foo { }` show that this is right
    // associative, and `try foo ? bar() : baz` even more so. But it doesn't always win: something like
    // `if try foo { } ...` should award its braces to the `if`. In order to make this actually happen, we need to parse
    // all the options and pick the best one that doesn't error out.
    [$.try_expression, $._unary_expression],
    [$.try_expression, $.expression],
    // await {expression} has the same special cases as `try`.
    [$.await_expression, $._unary_expression],
    [$.await_expression, $.expression],
    // In a computed property, when you see an @attribute, it's not yet clear if that's going to be for a
    // locally-declared class or a getter / setter specifier.
    [
      $._local_property_declaration,
      $._local_typealias_declaration,
      $._local_function_declaration,
      $._local_class_declaration,
      $.computed_getter,
      $.computed_modify,
      $.computed_setter,
    ],
    // The `class` modifier is legal in many of the same positions that a class declaration itself would be.
    [$._bodyless_function_declaration, $.property_modifier],
    [$.init_declaration, $.property_modifier],
    // Patterns, man
    [$._navigable_type_expression, $._case_pattern],
    [$._no_expr_pattern_already_bound, $._binding_pattern_no_expr],

    // On encountering a closure starting with `{ @Foo ...`, we don't yet know if that attribute applies to the closure
    // type or to a declaration within the closure. What a mess! We just have to hope that if we keep going, only one of
    // those will parse (because there will be an `in` or a `let`).
    [
      $._lambda_type_declaration,
      $._local_property_declaration,
      $._local_typealias_declaration,
      $._local_function_declaration,
      $._local_class_declaration,
    ],

    // We want `foo() { }` to be treated as one function call, but we _also_ want `if foo() { ... }` to be treated as a
    // full if-statement. This means we have to treat it as a conflict rather than purely a left or right associative
    // construct, and let the parser realize that the second expression won't parse properly with the `{ ... }` as a
    // lambda.
    [$.constructor_suffix],
    [$.call_suffix],

    // `actor` is allowed to be an identifier, even though it is also a locally permitted declaration. If we encounter
    // it, the only way to know what it's meant to be is to keep going.
    [$._modifierless_class_declaration, $.property_modifier],
    [$._fn_call_lambda_arguments],

    // `borrowing` and `consuming` are legal as identifiers, but are also legal modifiers
    [$.parameter_modifiers],

    // These are keywords sometimes, but simple identifiers other times, and it just depends on the rest of their usage.
    [$._contextual_simple_identifier, $._modifierless_class_declaration],
    [$._contextual_simple_identifier, $.property_behavior_modifier],
    [$._contextual_simple_identifier, $.parameter_modifier],
    [$._contextual_simple_identifier, $.type_parameter_pack],
    [$._contextual_simple_identifier, $.type_pack_expansion],
    [$._contextual_simple_identifier, $.visibility_modifier],
  ],
  extras: ($) => [
    $.comment,
    $.multiline_comment,
    /\s+/, // Whitespace
  ],
  externals: ($) => [
    // Comments and raw strings are parsed in a custom scanner because they require us to carry forward state to
    // maintain symmetry. For instance, parsing a multiline comment requires us to increment a counter whenever we see
    // `/*`, and decrement it whenever we see `*/`. A standard grammar would only be able to exit the comment at the
    // first `*/` (like C does). Similarly, when you start a string with `##"`, you're required to include the same
    // number of `#` symbols to end it.
    $.multiline_comment,
    $.raw_str_part,
    $.raw_str_continuing_indicator,
    $.raw_str_end_part,
    // Because Swift doesn't have explicit semicolons, we also do some whitespace handling in a custom scanner. Line
    // breaks are _sometimes_ meaningful as the end of a statement: try to write `let foo: Foo let bar: Bar`, for
    // instance and the compiler will complain, but add either a newline or a semicolon and it's fine. We borrow the
    // idea from the Kotlin grammar that a newline is sometimes a "semicolon". By including `\n` in both `_semi` and
    // an anonymous `whitespace` extras, we _should_ be able to let the parser decide if a newline is meaningful. If the
    // parser sees something like `foo.bar(1\n)`, it knows that a "semicolon" would not be valid there, so it parses
    // that as whitespace. On the other hand, `let foo: Foo\n let bar: Bar` has a meaningful newline.
    // Unfortunately, we can't simply stop at that. There are some expressions and statements that remain valid if you
    // end them early, but are expected to be parsed across multiple lines. One particular nefarious example is a
    // function declaration, where you might have something like `func foo<A>(args: A) -> Foo throws where A: Hashable`.
    // This would still be a valid declaration even if it ended after the `)`, the `Foo`, or the `throws`, so a grammar
    // that simply interprets a newline as "sometimes a semi" would parse those incorrectly.
    // To solve that case, our custom scanner must do a bit of extra lookahead itself. If we're about to generate a
    // `_semi`, we advance a bit further to see if the next non-whitespace token would be one of these other operators.
    // If so, we ignore the `_semi` and just produce the operator; if not, we produce the `_semi` and let the rest of
    // the grammar sort it out. This isn't perfect, but it works well enough most of the time.
    $._implicit_semi,
    $._explicit_semi,
    // Every one of the below operators will suppress a `_semi` if we encounter it after a newline.
    $._arrow_operator_custom,
    $._dot_custom,
    $._conjunction_operator_custom,
    $._disjunction_operator_custom,
    $._nil_coalescing_operator_custom,
    $._eq_custom,
    $._eq_eq_custom,
    $._plus_then_ws,
    $._minus_then_ws,
    $._bang_custom,
    $._throws_keyword,
    $._rethrows_keyword,
    $.default_keyword,
    $.where_keyword,
    $["else"],
    $.catch_keyword,
    $._as_custom,
    $._as_quest_custom,
    $._as_bang_custom,
    $._async_keyword_custom,
    $._custom_operator,
    $._hash_symbol_custom,
    $._directive_if,
    $._directive_elseif,
    $._directive_else,
    $._directive_endif,

    // Fake operator that will never get triggered, but follows the sequence of characters for `try!`. Tracked by the
    // custom scanner so that it can avoid triggering `$.bang` for that case.
    $._fake_try_bang,
  ],
  inline: ($) => [$._locally_permitted_modifiers],
  rules: {
    ////////////////////////////////
    // File Structure
    ////////////////////////////////
    source_file: ($) =>
      seq(
        optional(field("shebang", $.shebang_line)),
        optional(
          seq(
            field("statement", $._top_level_statement),
            repeat(seq($._semi, field("statement", $._top_level_statement))),
            optional($._semi)
          )
        )
      ),
    _semi: ($) => choice($._implicit_semi, $._explicit_semi),
    shebang_line: ($) => seq($._hash_symbol, "!", /[^\r\n]*/),
    ////////////////////////////////
    // Lexical Structure - https://docs.swift.org/swift-book/ReferenceManual/LexicalStructure.html
    ////////////////////////////////
    comment: ($) => token(prec(PRECS.comment, seq("//", /.*/))),
    // Identifiers
    simple_identifier: ($) =>
      choice(
        LEXICAL_IDENTIFIER,
        /`[^\r\n` ]*`/,
        /\$[0-9]+/,
        token(seq("$", LEXICAL_IDENTIFIER)),
        $._contextual_simple_identifier
      ),
    // Keywords that were added after they were already legal as identifiers. `tree-sitter` will prefer exact matches
    // when parsing so unless we explicitly say that these are legal, the parser will interpret them as their keyword.
    _contextual_simple_identifier: ($) =>
      choice(
        "actor",
        "async",
        "each",
        "lazy",
        "repeat",
        "package",
        $._parameter_ownership_modifier
      ),
    identifier: ($) => sep1(field("part", $.simple_identifier), $._dot),
    // Literals
    _basic_literal: ($) =>
      choice(
        $.integer_literal,
        $.hex_literal,
        $.oct_literal,
        $.bin_literal,
        $.real_literal,
        $.boolean_literal,
        $._string_literal,
        $.regex_literal,
        "nil"
      ),
    real_literal: ($) =>
      token(
        choice(
          seq(DEC_DIGITS, REAL_EXPONENT),
          seq(optional(DEC_DIGITS), ".", DEC_DIGITS, optional(REAL_EXPONENT)),
          seq(
            "0x",
            HEX_DIGITS,
            optional(seq(".", HEX_DIGITS)),
            HEX_REAL_EXPONENT
          )
        )
      ),
    integer_literal: ($) => token(seq(optional(/[1-9]/), DEC_DIGITS)),
    hex_literal: ($) => token(seq("0", /[xX]/, HEX_DIGITS)),
    oct_literal: ($) => token(seq("0", /[oO]/, OCT_DIGITS)),
    bin_literal: ($) => token(seq("0", /[bB]/, BIN_DIGITS)),
    boolean_literal: ($) => choice("true", "false"),
    // String literals
    _string_literal: ($) =>
      choice(
        $.line_string_literal,
        $.multi_line_string_literal,
        $.raw_string_literal
      ),
    line_string_literal: ($) =>
      seq(
        '"',
        repeat(choice(field("text", $._line_string_content), $._interpolation)),
        '"'
      ),
    _line_string_content: ($) => choice($.line_str_text, $.str_escaped_char),
    line_str_text: ($) => /[^\\"]+/,
    str_escaped_char: ($) =>
      choice($._escaped_identifier, $._uni_character_literal),
    _uni_character_literal: ($) => seq("\\", "u", /\{[0-9a-fA-F]+\}/),
    multi_line_string_literal: ($) =>
      seq(
        '"""',
        repeat(
          choice(field("text", $._multi_line_string_content), $._interpolation)
        ),
        '"""'
      ),
    raw_string_literal: ($) =>
      seq(
        repeat(
          seq(
            field("text", $.raw_str_part),
            field("interpolation", $.raw_str_interpolation),
            field("continuing", optional($.raw_str_continuing_indicator))
          )
        ),
        field("text", $.raw_str_end_part)
      ),
    raw_str_interpolation: ($) =>
      seq(field("start", $.raw_str_interpolation_start), $._interpolation_contents, ")"),
    raw_str_interpolation_start: ($) => /\\#*\(/,
    _multi_line_string_content: ($) =>
      choice($.multi_line_str_text, $.str_escaped_char, '"'),
    _interpolation: ($) => seq("\\(", $._interpolation_contents, ")"),
    _interpolation_contents: ($) =>
      sep1Opt(
        field(
          "interpolation",
          alias($.value_argument, $.interpolated_expression)
        ),
        ","
      ),
    _escaped_identifier: ($) => /\\[0\\tnr"'\n]/,
    multi_line_str_text: ($) => /[^\\"]+/,
    // Based on https://gitlab.com/woolsweater/tree-sitter-swifter/-/blob/3d47c85bd47ce54cdf2023a9c0e01eb90adfcc1d/grammar.js#L1019
    // But required modifications to hit all of the cases in SE-354
    regex_literal: ($) =>
      choice(
        $._extended_regex_literal,
        $._multiline_regex_literal,
        $._oneline_regex_literal
      ),

    _extended_regex_literal: ($) =>
      seq($._hash_symbol, /\/((\/[^#])|[^\n])+\/#/),

    _multiline_regex_literal: ($) =>
      seq($._hash_symbol, /\/\n/, /(\/[^#]|[^/])*?\n\/#/),

    _oneline_regex_literal: ($) =>
      token(
        prec(
          PRECS.regex,
          seq(
            "/",
            token.immediate(/[^ \t\n]?[^/\n]*[^ \t\n/]/),
            token.immediate("/")
          )
        )
      ),
    ////////////////////////////////
    // Types - https://docs.swift.org/swift-book/ReferenceManual/Types.html
    ////////////////////////////////
    type_annotation: ($) =>
      seq(":", field("type", $._possibly_implicitly_unwrapped_type)),
    _possibly_implicitly_unwrapped_type: ($) =>
      choice($.type, $.implicitly_unwrapped_type),
    implicitly_unwrapped_type: ($) =>
      seq(field("name", $.type), token.immediate("!")),
    type: ($) =>
      prec.right(
        PRECS.ty,
        seq(field("modifiers", optional($.type_modifiers)), field("name", $.unannotated_type))
      ),
    unannotated_type: ($) =>
      prec.right(
        PRECS.ty,
        choice(
          $.user_type,
          $.tuple_type,
          $.function_type,
          $.array_type,
          $.dictionary_type,
          $.optional_type,
          $.metatype,
          $.opaque_type,
          $.existential_type,
          $.protocol_composition_type,
          $.type_parameter_pack,
          $.type_pack_expansion,
          $.suppressed_constraint
        )
      ),
    // The grammar just calls this whole thing a `type-identifier` but that's a bit confusing.
    user_type: ($) => sep1(field("part", $.simple_user_type), $._dot),
    simple_user_type: ($) =>
      prec.right(
        PRECS.ty,
        seq(
          field("name", alias($.simple_identifier, $.type_identifier)),
          field("arguments", optional($.type_arguments))
        )
      ),
    tuple_type: ($) =>
      choice(
        seq(
          "(",
          optional(sep1Opt(field("element", $.tuple_type_item), ",")),
          ")"
        ),
        field("element", alias($._parenthesized_type, $.tuple_type_item))
      ),
    tuple_type_item: ($) =>
      prec(
        PRECS.expr,
        seq(
          optional($._tuple_type_item_identifier),
          field("modifiers", optional($.parameter_modifiers)),
          field("type", $.type)
        )
      ),
    _tuple_type_item_identifier: ($) =>
      prec(
        PRECS.expr,
        seq(
          optional($.wildcard_pattern),
          field("name", $.simple_identifier),
          ":"
        )
      ),
    function_type: ($) =>
      seq(
        field("params", choice($.tuple_type, $.unannotated_type)),
        field("async", optional($._async_keyword)),
        field("throws", optional(choice($.throws_clause, $.throws))),
        $._arrow_operator,
        field("return_type", $.type)
      ),
    array_type: ($) => seq("[", field("element", $.type), "]"),
    dictionary_type: ($) =>
      seq("[", field("key", $.type), ":", field("value", $.type), "]"),
    optional_type: ($) =>
      prec.left(
        seq(
          field(
            "wrapped",
            choice($.user_type, $.tuple_type, $.array_type, $.dictionary_type)
          ),
          repeat1(alias($._immediate_quest, "?"))
        )
      ),
    metatype: ($) => seq(field("name", $.unannotated_type), ".", choice("Type", "Protocol")),
    _quest: ($) => "?",
    _immediate_quest: ($) => token.immediate("?"),
    opaque_type: ($) => prec.right(seq("some", field("name", $.unannotated_type))),
    existential_type: ($) => prec.right(seq("any", field("name", $.unannotated_type))),
    type_parameter_pack: ($) => prec.left(seq("each", field("name", $.unannotated_type))),
    type_pack_expansion: ($) => prec.left(seq("repeat", field("name", $.unannotated_type))),
    protocol_composition_type: ($) =>
      prec.left(
        seq(
          field("type", $.unannotated_type),
          repeat1(seq("&", prec.right(field("type", $.unannotated_type))))
        )
      ),
    suppressed_constraint: ($) =>
      prec.right(
        seq(
          "~",
          field("suppressed", alias($.simple_identifier, $.type_identifier))
        )
      ),
    ////////////////////////////////
    // Expressions - https://docs.swift.org/swift-book/ReferenceManual/Expressions.html
    ////////////////////////////////
    expression: ($) =>
      prec(
        PRECS.expr,
        choice(
          $.simple_identifier,
          $._unary_expression,
          $._binary_expression,
          $.ternary_expression,
          $._primary_expression,
          $.if_statement,
          $.switch_statement,
          $.assignment,
          $.value_parameter_pack,
          $.value_pack_expansion,
          $.optional_chain_marker
        )
      ),
    optional_chain_marker: ($) =>
      seq(field("expr", $.expression), alias($._immediate_quest, "?")),
    // Unary expressions
    _unary_expression: ($) =>
      choice(
        $.postfix_expression,
        $.call_expression,
        $.macro_invocation,
        $.constructor_expression,
        $.navigation_expression,
        $.prefix_expression,
        $.as_expression,
        $.selector_expression,
        $.open_start_range_expression,
        $.open_end_range_expression,
        $.directive,
        $.diagnostic
      ),
    postfix_expression: ($) =>
      prec.left(
        PRECS.postfix_operations,
        seq(
          field("target", $.expression),
          field("operation", $._postfix_unary_operator)
        )
      ),
    constructor_expression: ($) =>
      prec(
        PRECS.call,
        seq(
          field(
            "constructed_type",
            choice($.array_type, $.dictionary_type, $.user_type)
          ),
          field("suffix", $.constructor_suffix)
        )
      ),
    _parenthesized_type: ($) =>
      seq(
        "(",
        choice($.opaque_type, $.existential_type, $.dictionary_type),
        ")"
      ),
    navigation_expression: ($) =>
      prec.left(
        PRECS.navigation,
        seq(
          field(
            "target",
            choice(
              $._navigable_type_expression,
              $.expression,
              $._parenthesized_type
            )
          ),
          field("suffix", $.navigation_suffix)
        )
      ),
    _navigable_type_expression: ($) =>
      choice($.user_type, $.array_type, $.dictionary_type),
    open_start_range_expression: ($) =>
      prec.right(
        PRECS.range,
        seq(
          $._range_operator,
          prec.right(PRECS.range_suffix, field("end", $.expression))
        )
      ),
    _range_operator: ($) =>
      choice($._open_ended_range_operator, $._three_dot_operator),
    open_end_range_expression: ($) =>
      prec.right(
        PRECS.range,
        seq(field("start", $.expression), $._three_dot_operator)
      ),
    prefix_expression: ($) =>
      prec.left(
        PRECS.prefix_operations,
        seq(
          field("operation", $._prefix_unary_operator),
          field(
            "target",
            choice(
              $.expression,
              alias(choice("async", "if", "switch"), $.expression)
            )
          )
        )
      ),
    as_expression: ($) =>
      prec.left(
        PRECS.as,
        seq(field("expr", $.expression), field("operator", $.as_operator), field("type", $.type))
      ),
    selector_expression: ($) =>
      seq(
        $._hash_symbol,
        "selector",
        "(",
        optional(choice("getter:", "setter:")),
        field("expr", $.expression),
        ")"
      ),
    // Binary expressions
    _binary_expression: ($) =>
      choice(
        $.multiplicative_expression,
        $.additive_expression,
        $.range_expression,
        $.infix_expression,
        $.nil_coalescing_expression,
        $.check_expression,
        $.equality_expression,
        $.comparison_expression,
        $.conjunction_expression,
        $.disjunction_expression,
        $.bitwise_operation
      ),
    multiplicative_expression: ($) =>
      prec.left(
        PRECS.multiplication,
        seq(
          field("lhs", $.expression),
          field("op", $._multiplicative_operator),
          field("rhs", $.expression)
        )
      ),
    additive_expression: ($) =>
      prec.left(
        PRECS.addition,
        seq(
          field("lhs", $.expression),
          field("op", $._additive_operator),
          field("rhs", $.expression)
        )
      ),
    range_expression: ($) =>
      prec.right(
        PRECS.range,
        seq(
          field("start", $.expression),
          field("op", $._range_operator),
          field("end", $._expr_hack_at_ternary_binary_suffix)
        )
      ),
    infix_expression: ($) =>
      prec.left(
        PRECS.infix_operations,
        seq(
          field("lhs", $.expression),
          field("op", $.custom_operator),
          field("rhs", $._expr_hack_at_ternary_binary_suffix)
        )
      ),
    nil_coalescing_expression: ($) =>
      prec.right(
        PRECS.nil_coalescing,
        seq(
          field("value", $.expression),
          $._nil_coalescing_operator,
          field("if_nil", $._expr_hack_at_ternary_binary_suffix)
        )
      ),
    check_expression: ($) =>
      prec.left(
        PRECS.check,
        seq(
          field("target", $.expression),
          field("op", $._is_operator),
          field("type", $.type)
        )
      ),
    comparison_expression: ($) =>
      prec.left(
        seq(
          field("lhs", $.expression),
          field("op", $._comparison_operator),
          field("rhs", $._expr_hack_at_ternary_binary_suffix)
        )
      ),
    equality_expression: ($) =>
      prec.left(
        PRECS.equality,
        seq(
          field("lhs", $.expression),
          field("op", $._equality_operator),
          field("rhs", $._expr_hack_at_ternary_binary_suffix)
        )
      ),
    conjunction_expression: ($) =>
      prec.left(
        PRECS.conjunction,
        seq(
          field("lhs", $.expression),
          field("op", $._conjunction_operator),
          field("rhs", $._expr_hack_at_ternary_binary_suffix)
        )
      ),
    disjunction_expression: ($) =>
      prec.left(
        PRECS.disjunction,
        seq(
          field("lhs", $.expression),
          field("op", $._disjunction_operator),
          field("rhs", $._expr_hack_at_ternary_binary_suffix)
        )
      ),
    bitwise_operation: ($) =>
      prec.left(
        seq(
          field("lhs", $.expression),
          field("op", $._bitwise_binary_operator),
          field("rhs", $._expr_hack_at_ternary_binary_suffix)
        )
      ),
    custom_operator: ($) => choice(token(/[\/]+[*]+/), $._custom_operator),
    // Suffixes
    navigation_suffix: ($) =>
      seq(
        $._dot,
        field("suffix", choice($.simple_identifier, $.integer_literal))
      ),
    call_suffix: ($) =>
      prec(
        PRECS.call_suffix,
        choice(
          field("arguments", $.value_arguments),
          prec.dynamic(-1, $._fn_call_lambda_arguments), // Prefer to treat `foo() { }` as one call not two
          seq(field("arguments", $.value_arguments), $._fn_call_lambda_arguments)
        )
      ),
    constructor_suffix: ($) =>
      prec(
        PRECS.call_suffix,
        choice(
          field("arguments", alias($._constructor_value_arguments, $.value_arguments)),
          prec.dynamic(-1, $._fn_call_lambda_arguments), // As above
          seq(
            field("arguments", alias($._constructor_value_arguments, $.value_arguments)),
            $._fn_call_lambda_arguments
          )
        )
      ),
    _constructor_value_arguments: ($) =>
      seq("(", optional(sep1Opt(field("argument", $.value_argument), ",")), ")"),
    _fn_call_lambda_arguments: ($) =>
      sep1(field("lambda", $.lambda_literal), seq(field("name", $.simple_identifier), ":")),
    type_arguments: ($) => prec.left(seq("<", sep1Opt(field("argument", $.type), ","), ">")),
    value_arguments: ($) =>
      seq(
        choice(
          seq("(", optional(sep1Opt(field("argument", $.value_argument), ",")), ")"),
          seq("[", optional(sep1Opt(field("argument", $.value_argument), ",")), "]")
        )
      ),
    value_argument_label: ($) =>
      prec.left(
        field("name", choice(
          $.simple_identifier,
          // We don't rely on $._contextual_simple_identifier here because
          // these don't usually fall into that category.
          alias("if", $.simple_identifier),
          alias("switch", $.simple_identifier)
        ))
      ),
    value_argument: ($) =>
      prec.left(
        seq(
          field("type_modifiers", optional($.type_modifiers)),
          choice(
            repeat1(
              seq(field("reference_specifier", $.value_argument_label), ":")
            ),
            seq(
              optional(seq(field("name", $.value_argument_label), ":")),
              field("value", $.expression)
            )
          )
        )
      ),
    try_expression: ($) =>
      prec.right(
        PRECS["try"],
        seq(
          field("operator", $.try_operator),
          field(
            "expr",
            choice(
              // Prefer direct calls, e.g. `try foo()`, over indirect like `try a ? b() : c`. This allows us to have
              // left associativity for the direct calls, which is technically wrong but is the only way to resolve the
              // ambiguity of `if foo { ... }` in the correct direction.
              prec.right(-2, $.expression),
              prec.left(0, $._binary_expression),
              prec.left(0, $.call_expression),
              // Similarly special case the ternary expression, where `try` may come earlier than it is actually needed.
              // When the parser just encounters some identifier after a `try`, it should prefer the `call_expression` (so
              // this should be lower in priority than that), but when we encounter an ambiguous expression that might be
              // either `try (foo() ? ...)` or `(try foo()) ? ...`, we should prefer the former. We accomplish that by
              // giving it a _static precedence_ of -1 but a _dynamic precedence_ of 1.
              prec.dynamic(1, prec.left(-1, $.ternary_expression))
            )
          )
        )
      ),
    await_expression: ($) =>
      prec.right(
        PRECS.await,
        seq(
          $._await_operator,
          field(
            "expr",
            choice(
              // Prefer direct calls over indirect (same as with `try`).
              prec.right(-2, $.expression),
              prec.left(0, $.call_expression),
              // Special case ternary to `await` the whole thing (same as with `try`).
              prec.dynamic(1, prec.left(-1, $.ternary_expression))
            )
          )
        )
      ),
    _await_operator: ($) => alias("await", "await"),
    ternary_expression: ($) =>
      prec.right(
        PRECS.ternary,
        seq(
          field("condition", $.expression),
          $._quest,
          field("if_true", $.expression),
          ":",
          field("if_false", $._expr_hack_at_ternary_binary_suffix)
        )
      ),
    _expr_hack_at_ternary_binary_suffix: ($) =>
      prec.left(
        PRECS.ternary_binary_suffix,
        choice(
          $.expression,
          alias($.expr_hack_at_ternary_binary_call, $.call_expression)
        )
      ),
    expr_hack_at_ternary_binary_call: ($) =>
      seq(
        field("function", $.expression),
        field("suffix", alias($.expr_hack_at_ternary_binary_call_suffix, $.call_suffix))
      ),
    expr_hack_at_ternary_binary_call_suffix: ($) =>
      prec(PRECS.call_suffix, field("arguments", $.value_arguments)),
    call_expression: ($) =>
      prec(
        PRECS.call,
        prec.dynamic(DYNAMIC_PRECS.call, seq(field("function", $.expression), field("suffix", $.call_suffix)))
      ),
    macro_invocation: ($) =>
      prec(
        PRECS.call,
        prec.dynamic(
          DYNAMIC_PRECS.call,
          seq(
            $._hash_symbol,
            field("name", $.simple_identifier),
            field("type_parameters", optional($.type_parameters)),
            field("suffix", $.call_suffix)
          )
        )
      ),
    _primary_expression: ($) =>
      choice(
        $.tuple_expression,
        $._basic_literal,
        $.lambda_literal,
        $.special_literal,
        $.playground_literal,
        $.array_literal,
        $.dictionary_literal,
        $.self_expression,
        $.super_expression,
        $.try_expression,
        $.await_expression,
        $.referenceable_operator,
        $.key_path_expression,
        $.key_path_string_expression,
        prec.right(
          PRECS.fully_open_range,
          alias($._three_dot_operator, $.fully_open_range)
        )
      ),
    tuple_expression: ($) =>
      prec.right(
        PRECS.tuple,
        seq(
          "(",
          sep1Opt(
            seq(
              optional(seq(field("name", $.simple_identifier), ":")),
              field("value", $.expression)
            ),
            ","
          ),
          ")"
        )
      ),
    array_literal: ($) =>
      seq("[", optional(sep1Opt(field("element", $.expression), ",")), "]"),
    dictionary_literal: ($) =>
      seq(
        "[",
        choice(":", sep1Opt($._dictionary_literal_item, ",")),
        optional(","),
        "]"
      ),
    _dictionary_literal_item: ($) =>
      seq(field("key", $.expression), ":", field("value", $.expression)),
    special_literal: ($) =>
      seq(
        $._hash_symbol,
        choice(
          "file",
          "fileID",
          "filePath",
          "line",
          "column",
          "function",
          "dsohandle"
        )
      ),
    playground_literal: ($) =>
      seq(
        $._hash_symbol,
        choice("colorLiteral", "fileLiteral", "imageLiteral"),
        "(",
        sep1Opt(seq(field("name", $.simple_identifier), ":", field("value", $.expression)), ","),
        ")"
      ),
    lambda_literal: ($) =>
      prec.left(
        PRECS.lambda,
        seq(
          choice("{", "^{"),
          optional($._lambda_type_declaration),
          field("body", optional($.statements)),
          "}"
        )
      ),
    _lambda_type_declaration: ($) =>
      seq(
        repeat(field("attribute", $.attribute)),
        prec(PRECS.expr, optional(field("captures", $.capture_list))),
        optional(field("type", $.lambda_function_type)),
        "in"
      ),
    capture_list: ($) => seq("[", sep1Opt(field("item", $.capture_list_item), ","), "]"),
    capture_list_item: ($) =>
      choice(
        field("name", $.self_expression),
        prec(
          PRECS.expr,
          seq(
            field("ownership", optional($.ownership_modifier)),
            field("name", $.simple_identifier),
            optional(seq($._equal_sign, field("value", $.expression)))
          )
        )
      ),
    lambda_function_type: ($) =>
      prec(
        PRECS.expr,
        seq(
          choice(
            field("params", $.lambda_function_type_parameters),
            seq("(", field("params", optional($.lambda_function_type_parameters)), ")")
          ),
          field("async", optional($._async_keyword)),
          field("throws", optional(choice($.throws_clause, $.throws))),
          optional(
            seq(
              $._arrow_operator,
              field("return_type", $._possibly_implicitly_unwrapped_type)
            )
          )
        )
      ),
    lambda_function_type_parameters: ($) => sep1Opt(field("parameter", $.lambda_parameter), ","),
    lambda_parameter: ($) =>
      seq(
        choice(
          field("name", $.self_expression),
          prec(PRECS.expr, field("name", $.simple_identifier)),
          prec(
            PRECS.expr,
            seq(
              optional(field("external_name", $.simple_identifier)),
              field("name", $.simple_identifier),
              ":",
              field("modifiers", optional($.parameter_modifiers)),
              field("type", $._possibly_implicitly_unwrapped_type)
            )
          )
        )
      ),
    self_expression: ($) => "self",
    super_expression: ($) => seq("super"),
    _else_options: ($) => choice($._block, field("else_branch", $.if_statement)),
    if_statement: ($) =>
      prec.right(
        PRECS["if"],
        seq(
          "if",
          sep1(field("condition", $.if_condition), ","),
          $._block,
          optional(seq(field("else_keyword", $["else"]), $._else_options))
        )
      ),
    if_condition: ($) =>
      field("kind", choice($.if_let_binding, $.expression, $.availability_condition)),
    if_let_binding: ($) =>
      seq(
        $._direct_or_indirect_binding,
        optional(seq($._equal_sign, field("value", $.expression))),
        field("where", optional($.where_clause))
      ),
    guard_statement: ($) =>
      prec.right(
        PRECS["if"],
        seq(
          "guard",
          sep1(field("condition", $.if_condition), ","),
          field("else_keyword", $["else"]),
          $._block
        )
      ),
    switch_statement: ($) =>
      prec.right(
        PRECS["switch"],
        seq(
          "switch",
          field("expr", $.expression),
          "{",
          repeat(field("entry", $.switch_entry)),
          "}"
        )
      ),
    switch_entry: ($) =>
      seq(
        optional($.modifiers),
        choice(
          seq(
            "case",
            seq(
              $.switch_pattern,
              optional(seq($.where_keyword, $.expression))
            ),
            repeat(seq(",", $.switch_pattern))
          ),
          $.default_keyword
        ),
        ":",
        $.statements,
        optional("fallthrough")
      ),
    switch_pattern: ($) => field("pattern", alias($._binding_pattern_with_expr, $.pattern)),
    do_statement: ($) =>
      prec.right(PRECS["do"], seq("do", $._block, repeat(field("catch", $.catch_block)))),
    catch_block: ($) =>
      seq(
        field("keyword", $.catch_keyword),
        field("error", optional(alias($._binding_pattern_no_expr, $.pattern))),
        field("where", optional($.where_clause)),
        $._block
      ),
    where_clause: ($) => prec.left(seq(field("keyword", $.where_keyword), field("expr", $.expression))),
    key_path_expression: ($) =>
      prec.right(
        PRECS.keypath,
        seq(
          "\\",
          field("type", optional(
            choice($.simple_user_type, $.array_type, $.dictionary_type)
          )),
          repeat(seq(".", field("component", $.key_path_component)))
        )
      ),
    key_path_string_expression: ($) =>
      prec.left(seq($._hash_symbol, "keyPath", "(", field("expr", $.expression), ")")),
    key_path_component: ($) =>
      prec.left(
        choice(
          seq(field("name", $.simple_identifier), repeat(field("postfix", $.key_path_postfix))),
          repeat1(field("postfix", $.key_path_postfix))
        )
      ),
    key_path_postfix: ($) =>
      choice(
        "?",
        field("force_unwrap", $.bang),
        "self",
        seq("[", optional(sep1(field("argument", $.value_argument), ",")), "]")
      ),
    try_operator: ($) =>
      prec.right(
        seq("try", choice(optional($._try_operator_type), $._fake_try_bang))
      ),
    _try_operator_type: ($) =>
      choice(token.immediate("!"), token.immediate("?")),
    _assignment_and_operator: ($) =>
      choice("+=", "-=", "*=", "/=", "%=", $._equal_sign),
    _equality_operator: ($) => choice("!=", "!==", $._eq_eq, "==="),
    _comparison_operator: ($) => choice("<", ">", "<=", ">="),
    _three_dot_operator: ($) => alias("...", "..."), // Weird alias to satisfy highlight queries
    _open_ended_range_operator: ($) => alias("..<", "..<"),
    _is_operator: ($) => "is",
    _additive_operator: ($) =>
      choice(
        alias($._plus_then_ws, "+"),
        alias($._minus_then_ws, "-"),
        "+",
        "-"
      ),
    // The `/` operator conflicts with a regex literal (which itself appears to conflict with a
    // comment, for some reason), so we must give it equivalent token precedence.
    _multiplicative_operator: ($) =>
      choice("*", alias(token(prec(PRECS.regex, "/")), "/"), "%"),
    as_operator: ($) => choice($._as, $._as_quest, $._as_bang),
    _prefix_unary_operator: ($) =>
      prec.right(
        choice(
          "++",
          "--",
          "-",
          "+",
          $.bang,
          "&",
          "~",
          $._dot,
          $.custom_operator
        )
      ),
    _bitwise_binary_operator: ($) => choice("&", "|", "^", "<<", ">>"),
    _postfix_unary_operator: ($) => choice("++", "--", $.bang),
    directly_assignable_expression: ($) => field("expr", $.expression),

    ////////////////////////////////
    // Statements - https://docs.swift.org/swift-book/ReferenceManual/Statements.html
    ////////////////////////////////
    statements: ($) =>
      prec.left(
        // Left precedence is required in switch statements
        seq(
          field("statement", $._local_statement),
          repeat(seq($._semi, field("statement", $._local_statement))),
          optional($._semi)
        )
      ),
    _local_statement: ($) =>
      choice(
        $.expression,
        $.local_declaration,
        $._labeled_statement,
        $.control_transfer_statement
      ),
    _top_level_statement: ($) =>
      choice(
        $.expression,
        $.global_declaration,
        $._labeled_statement,
        $._throw_statement
      ),
    _block: ($) => prec(PRECS.block, seq("{", field("body", optional($.statements)), "}")),
    _labeled_statement: ($) =>
      seq(
        optional($.statement_label),
        choice(
          $.for_statement,
          $.while_statement,
          $.repeat_while_statement,
          $.do_statement,
          $.if_statement,
          $.guard_statement,
          $.switch_statement
        )
      ),
    statement_label: ($) => token(/[a-zA-Z_][a-zA-Z_0-9]*:/),
    for_statement: ($) =>
      prec(
        PRECS.loop,
        seq(
          "for",
          field("try", optional($.try_operator)),
          optional($._await_operator),
          field("item", alias($._binding_pattern_no_expr, $.pattern)),
          field("type", optional($.type_annotation)),
          "in",
          field("collection", $._for_statement_collection),
          field("where", optional($.where_clause)),
          $._block
        )
      ),
    _for_statement_collection: ($) =>
      // If this expression has "await", this triggers some special-cased logic to prefer function calls. We prefer
      // the opposite, though, since function calls may contain trailing code blocks, which are undesirable here.
      //
      // To fix that, we simply undo the special casing by defining our own `await_expression`.
      choice($.expression, alias($.for_statement_await, $.await_expression)),
    for_statement_await: ($) => seq($._await_operator, field("expr", $.expression)),

    while_statement: ($) =>
      prec(
        PRECS.loop,
        seq(
          "while",
          sep1(field("condition", $.if_condition), ","),
          "{",
          field("body", optional($.statements)),
          "}"
        )
      ),
    repeat_while_statement: ($) =>
      prec(
        PRECS.loop,
        seq(
          "repeat",
          "{",
          field("body", optional($.statements)),
          "}",
          // Make sure we make it to the `while` before assuming this is a parameter pack.
          repeat($._implicit_semi),
          "while",
          sep1(field("condition", $.if_condition), ",")
        )
      ),
    control_transfer_statement: ($) =>
      choice(
        prec.right(
          PRECS.control_transfer,
          seq(field("kind", $.throw_keyword), field("result", $.expression))
        ),
        prec.right(
          PRECS.control_transfer,
          seq(
            field("kind", $._optionally_valueful_control_keyword),
            field("result", optional($.expression))
          )
        )
      ),
    _throw_statement: ($) => seq($.throw_keyword, $.expression),
    throw_keyword: ($) => "throw",
    _optionally_valueful_control_keyword: ($) =>
      choice("return", "continue", "break", "yield"),
    assignment: ($) =>
      prec.left(
        PRECS.assignment,
        seq(
          field("target", $.directly_assignable_expression),
          field("operator", $._assignment_and_operator),
          field("result", $.expression)
        )
      ),
    value_parameter_pack: ($) =>
      prec.left(PRECS.parameter_pack, seq("each", field("expr", $.expression))),
    value_pack_expansion: ($) =>
      prec.left(PRECS.parameter_pack, seq("repeat", field("expr", $.expression))),
    availability_condition: ($) =>
      seq(
        $._hash_symbol,
        choice("available", "unavailable"),
        "(",
        sep1Opt($._availability_argument, ","),
        ")"
      ),
    _availability_argument: ($) =>
      choice(seq(field("platform", $.identifier), sep1(field("version", $.integer_literal), ".")), "*"),
    ////////////////////////////////
    // Declarations - https://docs.swift.org/swift-book/ReferenceManual/Declarations.html
    ////////////////////////////////
    global_declaration: ($) =>
      choice(
        $.import_declaration,
        $.property_declaration,
        $.typealias_declaration,
        $.function_declaration,
        $.init_declaration,
        $.class_declaration,
        $.protocol_declaration,
        $.operator_declaration,
        $.precedence_group_declaration,
        $.associatedtype_declaration,
        $.macro_declaration
      ),
    type_level_declaration: ($) =>
      choice(
        $.import_declaration,
        $.property_declaration,
        $.typealias_declaration,
        $.function_declaration,
        $.init_declaration,
        $.class_declaration,
        $.protocol_declaration,
        $.deinit_declaration,
        $.subscript_declaration,
        $.operator_declaration,
        $.precedence_group_declaration,
        $.associatedtype_declaration
      ),
    local_declaration: ($) =>
      choice(
        alias($._local_property_declaration, $.property_declaration),
        alias($._local_typealias_declaration, $.typealias_declaration),
        alias($._local_function_declaration, $.function_declaration),
        alias($._local_class_declaration, $.class_declaration)
      ),
    _local_property_declaration: ($) =>
      seq(
        field("modifiers", optional($._locally_permitted_modifiers)),
        $._modifierless_property_declaration
      ),
    _local_typealias_declaration: ($) =>
      seq(
        field("modifiers", optional($._locally_permitted_modifiers)),
        $._modifierless_typealias_declaration
      ),
    _local_function_declaration: ($) =>
      seq(
        field("modifiers", optional($._locally_permitted_modifiers)),
        $._modifierless_function_declaration
      ),
    _local_class_declaration: ($) =>
      seq(
        field("modifiers", optional($._locally_permitted_modifiers)),
        $._modifierless_class_declaration
      ),
    import_declaration: ($) =>
      seq(
        field("modifiers", optional($.modifiers)),
        "import",
        optional($._import_kind),
        field("name", $.identifier)
      ),
    _import_kind: ($) =>
      choice(
        "typealias",
        "struct",
        "class",
        "enum",
        "protocol",
        "let",
        "var",
        "func"
      ),
    protocol_property_declaration: ($) =>
      prec.right(
        seq(
          field("modifiers", optional($.modifiers)),
          field("name", alias($._binding_kind_and_pattern, $.pattern)),
          field("type", optional($.type_annotation)),
          field("type_constraints", optional($.type_constraints)),
          field("requirements", $.protocol_property_requirements)
        )
      ),
    protocol_property_requirements: ($) =>
      seq("{", repeat(field("accessor", choice($.getter_specifier, $.setter_specifier))), "}"),
    property_declaration: ($) =>
      seq(field("modifiers", optional($.modifiers)), $._modifierless_property_declaration),
    _modifierless_property_declaration: ($) =>
      prec.right(
        seq(
          $._possibly_async_binding_pattern_kind,
          sep1($._single_modifierless_property_declaration, ",")
        )
      ),
    _single_modifierless_property_declaration: ($) =>
      prec.left(
        seq(
          field("name", alias($._no_expr_pattern_already_bound, $.pattern)),
          optional($.type_annotation),
          optional($.type_constraints),
          optional(
            choice(
              $._expression_with_willset_didset,
              $._expression_without_willset_didset,
              $.willset_didset_block,
              field("computed_value", $.computed_property)
            )
          )
        )
      ),
    _expression_with_willset_didset: ($) =>
      prec.dynamic(
        1,
        seq(
          $._equal_sign,
          field("value", $.expression),
          $.willset_didset_block
        )
      ),
    _expression_without_willset_didset: ($) =>
      seq($._equal_sign, field("value", $.expression)),
    willset_didset_block: ($) =>
      choice(
        seq("{", field("willset", $.willset_clause), field("didset", optional($.didset_clause)), "}"),
        seq("{", field("didset", $.didset_clause), field("willset", optional($.willset_clause)), "}")
      ),
    willset_clause: ($) =>
      seq(
        field("modifiers", optional($.modifiers)),
        "willSet",
        optional(seq("(", field("parameter", $.simple_identifier), ")")),
        $._block
      ),
    didset_clause: ($) =>
      seq(
        field("modifiers", optional($.modifiers)),
        "didSet",
        optional(seq("(", field("parameter", $.simple_identifier), ")")),
        $._block
      ),
    typealias_declaration: ($) =>
      seq(field("modifiers", optional($.modifiers)), $._modifierless_typealias_declaration),
    _modifierless_typealias_declaration: ($) =>
      seq(
        "typealias",
        field("name", alias($.simple_identifier, $.type_identifier)),
        field("type_parameters", optional($.type_parameters)),
        $._equal_sign,
        field("value", $.type)
      ),
    function_declaration: ($) =>
      prec.right(
        seq($._bodyless_function_declaration, field("body", $.function_body))
      ),
    _modifierless_function_declaration: ($) =>
      prec.right(
        seq(
          $._modifierless_function_declaration_no_body,
          field("body", $.function_body)
        )
      ),
    _bodyless_function_declaration: ($) =>
      seq(
        field("modifiers", optional($.modifiers)),
        optional("class"), // XXX: This should be possible in non-last position, but that creates parsing ambiguity
        $._modifierless_function_declaration_no_body
      ),
    _modifierless_function_declaration_no_body: ($) =>
      prec.right(
        seq(
          $._non_constructor_function_decl,
          field("type_parameters", optional($.type_parameters)),
          $._function_value_parameters,
          field("async", optional($._async_keyword)),
          field("throws", optional(choice($.throws_clause, $.throws))),
          optional(
            seq(
              $._arrow_operator,
              field("return_type", $._possibly_implicitly_unwrapped_type)
            )
          ),
          field("type_constraints", optional($.type_constraints))
        )
      ),
    function_body: ($) => $._block,
    macro_declaration: ($) =>
      seq(
        $._macro_head,
        $.simple_identifier,
        optional($.type_parameters),
        $._macro_signature,
        optional(field("definition", $.macro_definition)),
        optional($.type_constraints)
      ),
    _macro_head: ($) => seq(optional($.modifiers), "macro"),
    _macro_signature: ($) =>
      seq(
        $._function_value_parameters,
        optional(seq($._arrow_operator, $.unannotated_type))
      ),
    macro_definition: ($) =>
      seq(
        $._equal_sign,
        field("body", choice($.expression, $.external_macro_definition))
      ),

    external_macro_definition: ($) =>
      seq($._hash_symbol, "externalMacro", field("arguments", $.value_arguments)),

    class_declaration: ($) =>
      seq(field("modifiers", optional($.modifiers)), $._modifierless_class_declaration),
    _modifierless_class_declaration: ($) =>
      prec.right(
        choice(
          seq(
            field("declaration_kind", choice("class", "struct", "actor")),
            field("name", alias($.simple_identifier, $.type_identifier)),
            field("type_parameters", optional($.type_parameters)),
            optional(seq(":", $._inheritance_specifiers)),
            field("type_constraints", optional($.type_constraints)),
            field("body", $.class_body)
          ),
          seq(
            field("declaration_kind", "extension"),
            field("name", $.unannotated_type),
            field("type_parameters", optional($.type_parameters)),
            optional(seq(":", $._inheritance_specifiers)),
            field("type_constraints", optional($.type_constraints)),
            field("body", $.class_body)
          ),
          seq(
            optional("indirect"),
            field("declaration_kind", "enum"),
            field("name", alias($.simple_identifier, $.type_identifier)),
            field("type_parameters", optional($.type_parameters)),
            optional(seq(":", $._inheritance_specifiers)),
            field("type_constraints", optional($.type_constraints)),
            field("body", $.enum_class_body)
          )
        )
      ),
    class_body: ($) => seq("{", optional($._class_member_declarations), "}"),
    _inheritance_specifiers: ($) =>
      prec.left(sep1($._annotated_inheritance_specifier, choice(",", "&"))),
    _annotated_inheritance_specifier: ($) =>
      seq(repeat(field("attribute", $.attribute)), field("inherits", $.inheritance_specifier)),
    inheritance_specifier: ($) =>
      prec.left(
        field(
          "inherits_from",
          choice($.user_type, $.function_type, $.suppressed_constraint)
        )
      ),
    type_parameters: ($) =>
      seq(
        "<",
        sep1Opt(field("parameter", $.type_parameter), ","),
        field("constraints", optional($.type_constraints)),
        ">"
      ),
    type_parameter: ($) =>
      seq(
        field("modifiers", optional($.type_parameter_modifiers)),
        field("name", $._type_parameter_possibly_packed),
        optional(seq(":", field("type", $.type)))
      ),
    _type_parameter_possibly_packed: ($) =>
      choice(
        alias($.simple_identifier, $.type_identifier),
        $.type_parameter_pack
      ),

    type_constraints: ($) =>
      prec.right(seq(field("keyword", $.where_keyword), sep1Opt(field("constraint", $.type_constraint), ","))),
    type_constraint: ($) =>
      field("constraint", choice($.inheritance_constraint, $.equality_constraint)),
    inheritance_constraint: ($) =>
      seq(
        repeat(field("attribute", $.attribute)),
        field("constrained_type", $._constrained_type),
        ":",
        field("inherits_from", $._possibly_implicitly_unwrapped_type)
      ),
    equality_constraint: ($) =>
      seq(
        repeat(field("attribute", $.attribute)),
        field("constrained_type", $._constrained_type),
        choice($._equal_sign, $._eq_eq),
        field("must_equal", $.type)
      ),
    _constrained_type: ($) => choice($.identifier, $.nested_type_identifier),
    nested_type_identifier: ($) =>
      seq(
        field("base", $.unannotated_type),
        optional(seq(".", sep1(field("member", $.simple_identifier), ".")))
      ),
    _class_member_separator: ($) => choice($._semi, $.multiline_comment),
    _class_member_declarations: ($) =>
      seq(
        sep1(field("member", $.type_level_declaration), $._class_member_separator),
        optional($._class_member_separator)
      ),
    _function_value_parameters: ($) =>
      repeat1(
        seq("(", optional(sep1Opt($._function_value_parameter, ",")), ")")
      ),
    _function_value_parameter: ($) =>
      seq(
        field("attribute", optional($.attribute)),
        field("parameter", $.parameter),
        optional(seq($._equal_sign, field("default_value", $.expression)))
      ),
    parameter: ($) =>
      seq(
        optional(field("external_name", $.simple_identifier)),
        field("name", $.simple_identifier),
        ":",
        field("modifiers", optional($.parameter_modifiers)),
        field("type", $._possibly_implicitly_unwrapped_type),
        optional($._three_dot_operator)
      ),
    _non_constructor_function_decl: ($) =>
      seq(
        "func",
        field("name", choice($.simple_identifier, $.referenceable_operator))
      ),
    referenceable_operator: ($) =>
      field("operator", choice(
        $.custom_operator,
        $._comparison_operator,
        $._additive_operator,
        $._multiplicative_operator,
        $._equality_operator,
        $._assignment_and_operator,
        "++",
        "--",
        $.bang,
        "~",
        "|",
        "^",
        "<<",
        ">>",
        "&"
      )),
    // Hide the fact that certain symbols come from the custom scanner by aliasing them to their
    // string variants. This keeps us from having to see them in the syntax tree (which would be
    // noisy) but allows callers to refer to them as nodes by their text form like with any
    // operator.
    _equal_sign: ($) => alias($._eq_custom, "="),
    _eq_eq: ($) => alias($._eq_eq_custom, "=="),
    _dot: ($) => alias($._dot_custom, "."),
    _arrow_operator: ($) => alias($._arrow_operator_custom, "->"),
    _conjunction_operator: ($) => alias($._conjunction_operator_custom, "&&"),
    _disjunction_operator: ($) => alias($._disjunction_operator_custom, "||"),
    _nil_coalescing_operator: ($) =>
      alias($._nil_coalescing_operator_custom, "??"),
    _as: ($) => alias($._as_custom, "as"),
    _as_quest: ($) => alias($._as_quest_custom, "as?"),
    _as_bang: ($) => alias($._as_bang_custom, "as!"),
    _hash_symbol: ($) => alias($._hash_symbol_custom, "#"),
    bang: ($) => choice($._bang_custom, "!"),
    _async_keyword: ($) => alias($._async_keyword_custom, "async"),
    _async_modifier: ($) => token("async"),
    throws: ($) => choice($._throws_keyword, $._rethrows_keyword),
    throws_clause: ($) =>
      seq($._throws_keyword, "(", field("type", $.unannotated_type), ")"),
    enum_class_body: ($) =>
      seq("{", repeat(field("member", choice($.enum_entry, $.type_level_declaration))), "}"),
    enum_entry: ($) =>
      seq(
        field("modifiers", optional($.modifiers)),
        optional("indirect"),
        "case",
        sep1(
          seq(
            field("name", $.simple_identifier),
            optional($._enum_entry_suffix)
          ),
          ","
        ),
        optional(";")
      ),
    _enum_entry_suffix: ($) =>
      choice(
        field("data_contents", $.enum_type_parameters),
        seq($._equal_sign, field("raw_value", $.expression))
      ),
    enum_type_parameters: ($) =>
      seq(
        "(",
        optional(sep1(field("parameter", $.enum_type_parameter), ",")),
        ")"
      ),
    enum_type_parameter: ($) =>
      seq(
        optional(
          seq(optional(field("external_name", $.wildcard_pattern)), field("name", $.simple_identifier), ":")
        ),
        field("type", $.type),
        optional(seq($._equal_sign, field("default_value", $.expression)))
      ),
    protocol_declaration: ($) =>
      prec.right(
        seq(
          field("modifiers", optional($.modifiers)),
          field("declaration_kind", "protocol"),
          field("name", alias($.simple_identifier, $.type_identifier)),
          field("type_parameters", optional($.type_parameters)),
          optional(seq(":", $._inheritance_specifiers)),
          field("type_constraints", optional($.type_constraints)),
          field("body", $.protocol_body)
        )
      ),
    protocol_body: ($) =>
      seq("{", optional($._protocol_member_declarations), "}"),
    _protocol_member_declarations: ($) =>
      seq(sep1(field("member", $.protocol_member_declaration), $._semi), optional($._semi)),
    protocol_member_declaration: ($) =>
      choice(
        $.protocol_function_declaration,
        $.init_declaration,
        $.deinit_declaration,
        $.protocol_property_declaration,
        $.typealias_declaration,
        $.associatedtype_declaration,
        $.subscript_declaration
      ),
    protocol_function_declaration: ($) =>
      seq(
        $._bodyless_function_declaration,
        optional(field("body", $.function_body))
      ),
    init_declaration: ($) =>
      prec.right(
        seq(
          field("modifiers", optional($.modifiers)),
          optional("class"),
          field("name", "init"),
          optional(choice($._quest, field("bang", $.bang))),
          field("type_parameters", optional($.type_parameters)),
          $._function_value_parameters,
          field("async", optional($._async_keyword)),
          field("throws", optional(choice($.throws_clause, $.throws))),
          field("type_constraints", optional($.type_constraints)),
          optional(field("body", $.function_body))
        )
      ),
    deinit_declaration: ($) =>
      prec.right(
        seq(field("modifiers", optional($.modifiers)), "deinit", field("body", $.function_body))
      ),
    subscript_declaration: ($) =>
      prec.right(
        seq(
          field("modifiers", optional($.modifiers)),
          "subscript",
          field("type_parameters", optional($.type_parameters)),
          $._function_value_parameters,
          optional(
            seq(
              $._arrow_operator,
              field("return_type", $._possibly_implicitly_unwrapped_type)
            )
          ),
          field("type_constraints", optional($.type_constraints)),
          field("body", $.computed_property)
        )
      ),
    computed_property: ($) =>
      seq(
        "{",
        choice(
          field("body", optional($.statements)),
          repeat(
            field("accessor", choice($.computed_getter, $.computed_setter, $.computed_modify))
          )
        ),
        "}"
      ),
    computed_getter: ($) =>
      seq(repeat(field("attribute", $.attribute)), field("specifier", $.getter_specifier), optional($._block)),
    computed_modify: ($) =>
      seq(repeat(field("attribute", $.attribute)), field("specifier", $.modify_specifier), optional($._block)),
    computed_setter: ($) =>
      seq(
        repeat(field("attribute", $.attribute)),
        field("specifier", $.setter_specifier),
        optional(seq("(", field("parameter", $.simple_identifier), ")")),
        optional($._block)
      ),
    getter_specifier: ($) =>
      seq(field("mutation", optional($.mutation_modifier)), "get", optional($._getter_effects)),
    setter_specifier: ($) => seq(field("mutation", optional($.mutation_modifier)), "set"),
    modify_specifier: ($) => seq(field("mutation", optional($.mutation_modifier)), "_modify"),
    _getter_effects: ($) =>
      repeat1(field("effect", choice(alias($._async_keyword, $.async_keyword), $.throws_clause, $.throws))),
    operator_declaration: ($) =>
      seq(
        field("kind", choice("prefix", "infix", "postfix")),
        "operator",
        field("name", $.referenceable_operator),
        optional(seq(":", field("precedence_group", $.simple_identifier))),
        field("body", optional($.deprecated_operator_declaration_body))
      ),
    // The Swift compiler no longer accepts these, but some very old code still uses it.
    deprecated_operator_declaration_body: ($) =>
      seq("{", repeat(field("entry", choice($.simple_identifier, $._basic_literal))), "}"),
    precedence_group_declaration: ($) =>
      seq(
        "precedencegroup",
        field("name", $.simple_identifier),
        "{",
        field("attributes", optional($.precedence_group_attributes)),
        "}"
      ),
    precedence_group_attributes: ($) => repeat1(field("attribute", $.precedence_group_attribute)),
    precedence_group_attribute: ($) =>
      seq(
        field("name", $.simple_identifier),
        ":",
        field("value", choice($.simple_identifier, $.boolean_literal))
      ),
    associatedtype_declaration: ($) =>
      seq(
        field("modifiers", optional($.modifiers)),
        "associatedtype",
        field("name", alias($.simple_identifier, $.type_identifier)),
        optional(seq(":", field("must_inherit", $.type))),
        field("type_constraints", optional($.type_constraints)),
        optional(seq($._equal_sign, field("default_value", $.type)))
      ),
    ////////////////////////////////
    // Attributes - https://docs.swift.org/swift-book/ReferenceManual/Attributes.html
    ////////////////////////////////
    attribute: ($) =>
      seq(
        "@",
        field("name", $.user_type),
        // attribute arguments are a mess of special cases, maybe this is good enough?
        optional(seq("(", sep1Opt($._attribute_argument, ","), ")"))
      ),
    _attribute_argument: ($) =>
      choice(
        // labeled function parameters, used in custom property wrappers
        seq(field("argument_name", $.simple_identifier), ":", field("argument", $.expression)),
        // Unlabeled function parameters, simple identifiers, or `*`
        field("argument", $.expression),
        // References to param names (used in `@objc(foo:bar:)`)
        repeat1(seq(field("param_ref", $.simple_identifier), ":")),
        // Version restrictions (iOS 3.4.5, Swift 5.0.0)
        seq(repeat1(field("platform", $.simple_identifier)), sep1(field("version", $.integer_literal), "."))
      ),
    ////////////////////////////////
    // Patterns - https://docs.swift.org/swift-book/ReferenceManual/Patterns.html
    ////////////////////////////////
    _universally_allowed_pattern: ($) =>
      choice(
        $.wildcard_pattern,
        $._tuple_pattern,
        $._type_casting_pattern,
        $._case_pattern
      ),
    _bound_identifier: ($) => field("bound_identifier", $.simple_identifier),

    _binding_pattern_no_expr: ($) =>
      seq(
        choice(
          $._universally_allowed_pattern,
          $._binding_pattern,
          $._bound_identifier
        ),
        optional($._quest)
      ),
    _no_expr_pattern_already_bound: ($) =>
      seq(
        choice($._universally_allowed_pattern, $._bound_identifier),
        optional($._quest)
      ),
    _binding_pattern_with_expr: ($) =>
      seq(
        choice(
          $._universally_allowed_pattern,
          $._binding_pattern,
          $.expression
        ),
        optional($._quest)
      ),
    _non_binding_pattern_with_expr: ($) =>
      seq(
        choice($._universally_allowed_pattern, $.expression),
        optional($._quest)
      ),
    _direct_or_indirect_binding: ($) =>
      seq(
        choice(
          field("pattern", alias($._binding_kind_and_pattern, $.pattern)),
          seq("case", field("pattern", alias($._binding_pattern_no_expr, $.pattern)))
        ),
        field("type", optional($.type_annotation))
      ),
    value_binding_pattern: ($) => field("mutability", choice("var", "let")),
    _possibly_async_binding_pattern_kind: ($) =>
      seq(optional($._async_modifier), $.value_binding_pattern),
    _binding_kind_and_pattern: ($) =>
      seq(
        $._possibly_async_binding_pattern_kind,
        $._no_expr_pattern_already_bound
      ),
    wildcard_pattern: ($) => "_",
    _tuple_pattern_item: ($) =>
      choice(
        seq(
          $.simple_identifier,
          seq(":", alias($._binding_pattern_with_expr, $.pattern))
        ),
        alias($._binding_pattern_with_expr, $.pattern)
      ),
    _tuple_pattern: ($) => seq("(", sep1Opt($._tuple_pattern_item, ","), ")"),
    _case_pattern: ($) =>
      seq(
        optional("case"),
        optional($.user_type), // XXX this should just be _type but that creates ambiguity
        $._dot,
        $.simple_identifier,
        optional($._tuple_pattern)
      ),
    _type_casting_pattern: ($) =>
      choice(
        seq("is", $.type),
        seq(alias($._binding_pattern_no_expr, $.pattern), $._as, $.type)
      ),
    _binding_pattern: ($) =>
      seq(
        seq(optional("case"), $.value_binding_pattern),
        $._no_expr_pattern_already_bound
      ),

    // ==========
    // Modifiers
    // ==========
    modifiers: ($) =>
      repeat1(
        prec.left(
          field("modifier", choice($._non_local_scope_modifier, $._locally_permitted_modifiers))
        )
      ),
    _locally_permitted_modifiers: ($) =>
      repeat1(choice($.attribute, $._locally_permitted_modifier)),
    parameter_modifiers: ($) => repeat1(field("modifier", $.parameter_modifier)),
    _modifier: ($) =>
      choice($._non_local_scope_modifier, $._locally_permitted_modifier),
    _non_local_scope_modifier: ($) =>
      choice(
        $.member_modifier,
        $.visibility_modifier,
        $.function_modifier,
        $.mutation_modifier,
        $.property_modifier,
        $.parameter_modifier
      ),
    _locally_permitted_modifier: ($) =>
      choice(
        $.ownership_modifier,
        $.inheritance_modifier,
        $.property_behavior_modifier
      ),
    property_behavior_modifier: ($) => "lazy",
    type_modifiers: ($) => repeat1(field("attribute", $.attribute)),
    member_modifier: ($) =>
      choice("override", "convenience", "required", "nonisolated"),
    visibility_modifier: ($) =>
      seq(
        choice(
          "public",
          "private",
          "internal",
          "fileprivate",
          "open",
          "package"
        ),
        optional(seq("(", "set", ")"))
      ),
    type_parameter_modifiers: ($) => repeat1(field("attribute", $.attribute)),
    function_modifier: ($) => choice("infix", "postfix", "prefix"),
    mutation_modifier: ($) => choice("mutating", "nonmutating"),
    property_modifier: ($) =>
      choice("static", "dynamic", "optional", "class", "distributed"),
    inheritance_modifier: ($) => choice("final"),
    parameter_modifier: ($) =>
      choice(
        "inout",
        "@escaping",
        "@autoclosure",
        $._parameter_ownership_modifier
      ),
    ownership_modifier: ($) =>
      choice("weak", "unowned", "unowned(safe)", "unowned(unsafe)"),
    _parameter_ownership_modifier: ($) => choice("borrowing", "consuming"),
    use_site_target: ($) =>
      seq(
        choice(
          "property",
          "get",
          "set",
          "receiver",
          "param",
          "setparam",
          "delegate"
        ),
        ":"
      ),
    directive: ($) =>
      prec.right(
        PRECS.comment,
        choice(
          seq(alias($._directive_if, "#if"), field("condition", $.compilation_condition)),
          seq(alias($._directive_elseif, "#elseif"), field("condition", $.compilation_condition)),
          seq(alias($._directive_else, "#else")),
          seq(alias($._directive_endif, "#endif"))
        )
      ),
    compilation_condition: ($) =>
      prec.right(
        choice(
          seq("os", "(", field("name", $.simple_identifier), ")"),
          seq("arch", "(", field("name", $.simple_identifier), ")"),
          seq(
            "swift",
            "(",
            $._comparison_operator,
            sep1(field("version", $.integer_literal), "."),
            ")"
          ),
          seq(
            "compiler",
            "(",
            $._comparison_operator,
            sep1(field("version", $.integer_literal), "."),
            ")"
          ),
          seq("canImport", "(", sep1(field("name", $.simple_identifier), "."), ")"),
          seq("targetEnvironment", "(", field("name", $.simple_identifier), ")"),
          field("value", $.boolean_literal),
          field("name", $.simple_identifier),
          seq("(", field("inner", $.compilation_condition), ")"),
          seq("!", field("operand", $.compilation_condition)),
          seq(
            field("lhs", $.compilation_condition),
            $._conjunction_operator,
            field("rhs", $.compilation_condition)
          ),
          seq(
            field("lhs", $.compilation_condition),
            $._disjunction_operator,
            field("rhs", $.compilation_condition)
          )
        )
      ),
    diagnostic: ($) =>
      prec(
        PRECS.comment,
        seq(
          $._hash_symbol,
          choice(
            // Using regexes here, rather than actually validating the string literal, because complex string literals
            // cannot be used inside `token()` and we need that to ensure we get the right precedence.
            seq(/error([^\r\n]*)/),
            seq(/warning([^\r\n]*)/),
            seq(/sourceLocation([^\r\n]*)/)
          )
        )
      ),
    // Dumping ground for any nodes that used to exist in the grammar, but have since been removed for whatever
    // reason.
    // Neovim applies updates non-atomically to the parser and the queries. Meanwhile, `tree-sitter` rejects any query
    // that contains any unrecognized nodes. Putting those two facts together, we see that we must never remove nodes
    // that once existed.
    unused_for_backward_compatibility: ($) =>
      choice(alias("unused1", "try?"), alias("unused2", "try!")),
  },
});
function sep1(rule, separator) {
  return seq(rule, repeat(seq(separator, rule)));
}
function sep1Opt(rule, separator) {
  return seq(rule, repeat(seq(separator, rule)), optional(separator));
}

function tree_sitter_version_supports_emoji() {
  try {
    return (
      TREE_SITTER_CLI_VERSION_MAJOR > 0 ||
      TREE_SITTER_CLI_VERSION_MINOR > 20 ||
      TREE_SITTER_CLI_VERSION_PATCH >= 5
    );
  } catch (err) {
    if (err instanceof ReferenceError) {
      return false;
    } else {
      throw err;
    }
  }
}
