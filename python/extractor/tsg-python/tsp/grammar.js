const PREC = {
  // this resolves a conflict between the usage of ':' in a lambda vs in a
  // typed parameter. In the case of a lambda, we don't allow typed parameters.
  lambda: -2,
  typed_parameter: -1,
  conditional: -1,

  parenthesized_expression: 1,
  parenthesized_list_splat: 1,
  not: 12,
  compare: 2,
  or: 10,
  and: 11,
  bitwise_or: 13,
  bitwise_and: 14,
  xor: 15,
  shift: 16,
  plus: 17,
  times: 18,
  unary: 19,
  power: 20,
  call: 21,
}

module.exports = grammar({
  name: 'python',

  extras: $ => [
    $.comment,
    /[\s\f\uFEFF\u2060\u200B]|\\\r?\n/
  ],

  conflicts: $ => [
    [$.primary_expression, $.pattern],
    [$.primary_expression, $.list_splat_pattern],
    [$.tuple, $.tuple_pattern],
    [$.list, $.list_pattern],
    [$.with_item, $._collection_elements],
  ],

  supertypes: $ => [
    $._simple_statement,
    $._compound_statement,
    $.expression,
    $.primary_expression,
    $.pattern,
    $.parameter,
  ],

  externals: $ => [
    $._newline,
    $._indent,
    $._dedent,
    $._string_start,
    $._string_content,
    $._string_end,
  ],

  inline: $ => [
    $._simple_statement,
    $._compound_statement,
    $._suite,
    $._expressions,
    $._left_hand_side,
    $.keyword_identifier,
  ],

  word: $ => $.identifier,

  rules: {
    module: $ => repeat($._statement),

    _statement: $ => choice(
      $._simple_statements,
      $._compound_statement
    ),

    // Simple statements

    _simple_statements: $ => seq(
      $._simple_statement,
      optional(repeat(seq(
        $._semicolon,
        $._simple_statement
      ))),
      optional($._semicolon),
      $._newline
    ),

    _simple_statement: $ => choice(
      $.future_import_statement,
      $.import_statement,
      $.import_from_statement,
      $.print_statement,
      $.assert_statement,
      $.expression_statement,
      $.return_statement,
      $.delete_statement,
      $.raise_statement,
      $.pass_statement,
      $.break_statement,
      $.continue_statement,
      $.global_statement,
      $.nonlocal_statement,
      $.exec_statement,
      $.type_alias_statement,
    ),

    import_statement: $ => seq(
      'import',
      $._import_list
    ),

    import_prefix: $ => repeat1('.'),

    relative_import: $ => seq(
      $.import_prefix,
      optional(field('name', $.dotted_name))
    ),

    future_import_statement: $ => seq(
      'from',
      '__future__',
      'import',
      choice(
        $._import_list,
        seq('(', $._import_list, ')'),
      )
    ),

    import_from_statement: $ => seq(
      'from',
      field('module_name', choice(
        $.relative_import,
        $.dotted_name
      )),
      'import',
      choice(
        $.wildcard_import,
        $._import_list,
        seq('(', $._import_list, ')')
      )
    ),

    _import_list: $ => seq(
      commaSep1(field('name', choice(
        $.dotted_name,
        $.aliased_import
      ))),
      optional(',')
    ),

    aliased_import: $ => seq(
      field('name', $.dotted_name),
      'as',
      field('alias', $.identifier)
    ),

    wildcard_import: $ => '*',

    print_statement: $ => choice(
      prec(1, seq(
        'print',
        $.chevron,
        repeat(seq(',', field('argument', $.expression))),
        optional(','))
      ),
      prec(-10, seq(
        'print',
        commaSep1(field('argument', $.expression)),
        optional(',')
      ))
    ),

    chevron: $ => seq(
      '>>',
      $.expression
    ),

    assert_statement: $ => seq(
      'assert',
      commaSep1($.expression)
    ),

    expression_statement: $ => choice(
      $.expression,
      $.expression_list,
      $.assignment,
      $.augmented_assignment,
      $.yield
    ),

    named_expression: $ => seq(
      field('name', choice($.identifier, $.keyword_identifier)),
      ':=',
      field('value', $.expression)
    ),

    return_statement: $ => seq(
      'return',
      optional($._expressions)
    ),

    delete_statement: $ => seq(
      'del',
      field('target', $._expressions)
    ),

    _expressions: $ => choice(
      $.expression,
      $.expression_list
    ),

    raise_statement: $ => seq(
      'raise',
      optional($._expressions),
      optional(seq('from', field('cause', $.expression)))
    ),

    pass_statement: $ => prec.left('pass'),
    break_statement: $ => prec.left('break'),
    continue_statement: $ => prec.left('continue'),

    // Compound statements

    _compound_statement: $ => choice(
      $.if_statement,
      $.for_statement,
      $.while_statement,
      $.try_statement,
      $.with_statement,
      $.match_statement,
      $.function_definition,
      $.class_definition,
      $.decorated_definition
    ),

    if_statement: $ => seq(
      'if',
      field('condition', $.expression),
      ':',
      field('consequence', $._suite),
      repeat(field('alternative', $.elif_clause)),
      optional(field('alternative', $.else_clause))
    ),

    elif_clause: $ => seq(
      'elif',
      field('condition', $.expression),
      ':',
      field('consequence', $._suite)
    ),

    else_clause: $ => seq(
      'else',
      ':',
      field('body', $._suite)
    ),

    for_statement: $ => seq(
      optional('async'),
      'for',
      field('left', $._left_hand_side),
      'in',
      field('right', $._expressions),
      ':',
      field('body', $._suite),
      field('alternative', optional($.else_clause))
    ),

    while_statement: $ => seq(
      'while',
      field('condition', $.expression),
      ':',
      field('body', $._suite),
      optional(field('alternative', $.else_clause))
    ),

    try_statement: $ => seq(
      'try',
      ':',
      field('body', $._suite),
      choice(
        seq(
          repeat1($.except_clause),
          optional($.else_clause),
          optional($.finally_clause)
        ),
        seq(
          repeat1($.except_group_clause),
          optional($.else_clause),
          optional($.finally_clause)
        ),
        $.finally_clause
      )
    ),

    except_clause: $ => seq(
      'except',
      optional(seq(
        field('type', $.expression),
        optional(seq(
          choice('as', ','),
          field('alias', $.expression)
        ))
      )),
      ':',
      field('body', $._suite),
    ),

    except_group_clause: $ => seq(
      'except',
      '*',
      seq(
        field('type', $.expression),
        optional(seq(
          'as',
          field('alias', $.expression)
        ))
      ),
      ':',
      field('body', $._suite),
    ),

    finally_clause: $ => seq(
      'finally',
      ':',
      field('body', $._suite),
    ),

    with_statement: $ => seq(
      optional('async'),
      'with',
      $.with_clause,
      ':',
      field('body', $._suite)
    ),

    with_clause: $ => choice(
      commaSep1($.with_item),
      seq('(', commaSep1($.with_item), optional(","), ')')
    ),

    with_item: $ => prec.dynamic(-1, seq(
      field('value', $.expression),
      optional(seq(
        'as',
        field('alias', $.pattern)
      ))
    )),

    match_statement: $ => seq(
      'match',
      field('subject',
        choice(
          $.expression,
          alias($.expression_list, $.tuple),
        )
      ),
      ':',
      field('cases', $.cases)
    ),

    cases: $ => repeat1($.case_block),

    case_block: $ => seq(
      'case',
      field('pattern', $._match_patterns),
      optional(field('guard', $.guard)),
      ':',
      field('body', $._suite)
    ),

    _match_patterns: $ => choice(
      $._match_pattern,
      alias($.open_sequence_match_pattern, $.match_sequence_pattern)
    ),

    open_sequence_match_pattern: $ => open_sequence($._match_maybe_star_pattern),

    _match_pattern: $ => choice(
      $.match_as_pattern,
      $._match_or_pattern
    ),

    match_as_pattern: $ => seq(
      field('pattern', $._match_or_pattern),
      'as',
      field('alias', $.identifier)
    ),

    _match_or_pattern: $ => choice(
      $.match_or_pattern,
      $._closed_pattern
    ),

    match_or_pattern: $ => seq(
      $._closed_pattern,
      '|',
      sep1($._closed_pattern, '|')
    ),

    _closed_pattern: $ => choice(
      $.match_literal_pattern,
      $.match_capture_pattern,
      $.match_wildcard_pattern,
      $.match_value_pattern,
      $.match_group_pattern,
      $.match_sequence_pattern,
      $.match_mapping_pattern,
      $.match_class_pattern
    ),

    match_literal_pattern: $ => choice(
      seq(
        optional(field('prefix_operator', '-')),
        field('real', choice($.integer, $.float)),
        optional(seq(
          field('operator', choice('+', '-')),
          field('imaginary', choice($.integer, $.float))
        ))
      ),
      $.string,
      $.concatenated_string,
      $.none,
      $.true,
      $.false
    ),



    match_capture_pattern: $ => $.identifier,

    match_wildcard_pattern: $ => '_',

    match_value_pattern: $ => seq(
      $.identifier,
      repeat1(seq('.', $.identifier))
    ),

    match_group_pattern: $ => seq(
      '(',
      field('content', $._match_pattern),
      ')'
    ),

    match_sequence_pattern: $ => choice(
      seq('[', optional(seq(commaSep1($._match_maybe_star_pattern), optional(','))), ']'),
      seq('(', optional(open_sequence($._match_maybe_star_pattern)), ')')
    ),

    _match_maybe_star_pattern: $ => choice(
      $._match_pattern,
      $.match_star_pattern
    ),

    match_star_pattern: $ => seq(
      '*',
      field('target', choice($.match_wildcard_pattern, $.match_capture_pattern))
    ),

    match_mapping_pattern: $ => choice(
      seq('{', optional(seq($.match_double_star_pattern, optional(','))), '}'),
      seq(
        '{',
        commaSep1($.match_key_value_pattern),
        optional(seq(',', $.match_double_star_pattern)),
        optional(','),
        '}'
      )
    ),

    match_double_star_pattern: $ => seq(
      '**',
      field('target', $.match_capture_pattern)
    ),

    match_key_value_pattern: $ => seq(
      field('key', choice($.match_literal_pattern, $.match_value_pattern)),
      ':',
      field('value', $._match_pattern)
    ),

    match_class_pattern: $ => seq(
      field('class', $.pattern_class_name),
      choice(
        seq('(', ')'),
        seq('(', seq(commaSep1($.match_positional_pattern), optional(',')), ')'),
        seq('(', seq(commaSep1($.match_keyword_pattern), optional(',')), ')'),
        seq('(', commaSep1($.match_positional_pattern), ',', commaSep1($.match_keyword_pattern), optional(','), ')')
      )),

    pattern_class_name: $ => sep1($.identifier, '.'),

    match_positional_pattern: $ => $._match_pattern,

    match_keyword_pattern: $ => seq(
      field('attribute', $.identifier),
      '=',
      field('value', $._match_pattern)
    ),

    guard: $ => seq(
      'if',
      field('test', $.expression)
    ),

    function_definition: $ => seq(
      optional('async'),
      'def',
      field('name', $.identifier),
      optional(field('type_parameters', $.type_parameters)),
      field('parameters', $.parameters),
      optional(
        seq(
          '->',
          field('return_type', $.type)
        )
      ),
      ':',
      field('body', $._suite)
    ),

    parameters: $ => seq(
      '(',
      optional($._parameters),
      ')'
    ),

    lambda_parameters: $ => $._parameters,

    list_splat: $ => seq(
      '*',
      $.expression,
    ),

    dictionary_splat: $ => seq(
      '**',
      field('value', $.expression),
    ),

    global_statement: $ => seq(
      'global',
      commaSep1($.identifier)
    ),

    nonlocal_statement: $ => seq(
      'nonlocal',
      commaSep1($.identifier)
    ),

    exec_statement: $ => seq(
      'exec',
      field('code', $.string),
      optional(
        seq(
          'in',
          commaSep1($.expression)
        )
      )
    ),

    type_alias_statement: $ => seq(
      'type',
      field('name', $.identifier),
      optional(field('type_parameters', $.type_parameters)),
        '=',
        field('value', $.expression)
      ),

    class_definition: $ => seq(
      'class',
      field('name', $.identifier),
      optional(field('type_parameters', $.type_parameters)),
      field('superclasses', optional($.argument_list)),
      ':',
      field('body', $._suite)
    ),

    type_parameters: $ => seq(
      '[',
      commaSep1(field('type_parameter', $._type_parameter)),
      ']'
    ),

    _type_bound: $ => seq(
      ':',
      field('bound', $.expression)
    ),

    typevar_parameter: $ => seq(
      field('name', $.identifier),
      optional($._type_bound),
      optional($._type_param_default)
    ),

    typevartuple_parameter: $ => seq(
      '*',
      field('name', $.identifier),
      optional($._type_param_default)
    ),

    paramspec_parameter: $ => seq(
      '**',
      field('name', $.identifier),
      optional($._type_param_default),
    ),

    _type_parameter: $ => choice(
        $.typevar_parameter,
        $.typevartuple_parameter,
        $.paramspec_parameter,
    ),

    _type_param_default: $ => seq(
      '=',
      field('default', choice($.list_splat, $.expression))
    ),

    parenthesized_list_splat: $ => prec(PREC.parenthesized_list_splat, seq(
      '(',
      choice(
        alias($.parenthesized_list_splat, $.parenthesized_expression),
        $.list_splat,
      ),
      ')',
    )),

    argument_list: $ => seq(
      '(',
      optional(commaSep1(
        field('element', choice(
          $.expression,
          $.list_splat,
          $.dictionary_splat,
          alias($.parenthesized_list_splat, $.parenthesized_expression),
          $.keyword_argument
        ))
      )),
      optional(','),
      ')'
    ),

    decorated_definition: $ => seq(
      repeat1($.decorator),
      field('definition', choice(
        $.class_definition,
        $.function_definition
      ))
    ),

    decorator: $ => seq(
      '@',
      $.expression,
      $._newline
    ),

    _suite: $ => choice(
      alias($._simple_statements, $.block),
      seq($._indent, $.block),
      alias($._newline, $.block)
    ),

    block: $ => seq(
      repeat($._statement),
      $._dedent
    ),

    expression_list: $ => open_sequence(field('element', choice($.expression, $.list_splat, $.dictionary_splat))),

    dotted_name: $ => sep1($.identifier, '.'),

    // Patterns

    _parameters: $ => seq(
      commaSep1($.parameter),
      optional(',')
    ),

    _patterns: $ => seq(
      commaSep1(field('element', $.pattern)),
      optional(field('trailing_comma', ','))
    ),

    parameter: $ => choice(
      $.identifier,
      $.typed_parameter,
      $.default_parameter,
      $.typed_default_parameter,
      $.list_splat_pattern,
      $.tuple_pattern,
      $.keyword_separator,
      $.positional_separator,
      $.dictionary_splat_pattern
    ),

    pattern: $ => choice(
      $.identifier,
      $.keyword_identifier,
      $.subscript,
      $.attribute,
      $.list_splat_pattern,
      $.tuple_pattern,
      $.list_pattern
    ),

    tuple_pattern: $ => seq(
      '(',
      optional($._patterns),
      ')'
    ),

    list_pattern: $ => seq(
      '[',
      optional($._patterns),
      ']'
    ),

    default_parameter: $ => seq(
      field('name', $.identifier),
      '=',
      field('value', $.expression)
    ),

    typed_default_parameter: $ => prec(PREC.typed_parameter, seq(
      field('name', $.identifier),
      ':',
      field('type', $.type),
      '=',
      field('value', $.expression)
    )),

    list_splat_pattern: $ => seq(
      '*',
      field('vararg', choice($.identifier, $.keyword_identifier, $.subscript, $.attribute))
    ),

    dictionary_splat_pattern: $ => seq(
      '**',
      field('kwarg', choice($.identifier, $.keyword_identifier, $.subscript, $.attribute))
    ),

    // Expressions

    _expression_within_for_in_clause: $ => choice(
      $.expression,
      alias($.lambda_within_for_in_clause, $.lambda)
    ),

    expression: $ => choice(
      $.comparison_operator,
      $.not_operator,
      $.boolean_operator,
      $.lambda,
      $.primary_expression,
      $.conditional_expression,
      $.named_expression
    ),

    primary_expression: $ => choice(
      $.await,
      $.binary_operator,
      $.identifier,
      $.keyword_identifier,
      $.string,
      $.concatenated_string,
      $.integer,
      $.float,
      $.true,
      $.false,
      $.none,
      $.unary_operator,
      $.attribute,
      $.subscript,
      $.call,
      $.list,
      $.list_comprehension,
      $.dictionary,
      $.dictionary_comprehension,
      $.set,
      $.set_comprehension,
      $.tuple,
      $.parenthesized_expression,
      $.generator_expression,
      $.ellipsis
    ),

    not_operator: $ => prec(PREC.not, seq(
      'not',
      field('argument', $.expression)
    )),

    boolean_operator: $ => choice(
      prec.right(PREC.and, seq(
        field('left', $.expression),
        field('operator', 'and'),
        field('right', $.expression)
      )),
      prec.right(PREC.or, seq(
        field('left', $.expression),
        field('operator', 'or'),
        field('right', $.expression)
      ))
    ),

    binary_operator: $ => {
      const table = [
        [prec.left, '+', PREC.plus],
        [prec.left, '-', PREC.plus],
        [prec.left, '*', PREC.times],
        [prec.left, '@', PREC.times],
        [prec.left, '/', PREC.times],
        [prec.left, '%', PREC.times],
        [prec.left, '//', PREC.times],
        [prec.right, '**', PREC.power],
        [prec.left, '|', PREC.bitwise_or],
        [prec.left, '&', PREC.bitwise_and],
        [prec.left, '^', PREC.xor],
        [prec.left, '<<', PREC.shift],
        [prec.left, '>>', PREC.shift],
      ];

      return choice(...table.map(([fn, operator, precedence]) => fn(precedence, seq(
        field('left', $.primary_expression),
        field('operator', operator),
        field('right', $.primary_expression)
      ))));
    },

    unary_operator: $ => prec(PREC.unary, seq(
      field('operator', choice('+', '-', '~')),
      field('argument', $.primary_expression)
    )),

    comparison_operator: $ => prec.left(PREC.compare, seq(
      $.primary_expression,
      repeat1(seq(
        field('operators',
          choice(
            '<',
            '<=',
            '==',
            '!=',
            '>=',
            '>',
            '<>',
            'in',
            alias(seq('not', 'in'), 'not in'),
            'is',
            alias(seq('is', 'not'), 'is not')
          )),
        $.primary_expression
      ))
    )),

    lambda: $ => prec(PREC.lambda, seq(
      'lambda',
      field('parameters', optional($.lambda_parameters)),
      ':',
      field('body', $.expression)
    )),

    lambda_within_for_in_clause: $ => seq(
      'lambda',
      field('parameters', optional($.lambda_parameters)),
      ':',
      field('body', $._expression_within_for_in_clause)
    ),

    assignment: $ => seq(
      field('left', $._left_hand_side),
      choice(
        seq('=', field('right', $._right_hand_side)),
        seq(':', field('type', $.type)),
        seq(':', field('type', $.type), '=', field('right', $._right_hand_side))
      )
    ),

    augmented_assignment: $ => seq(
      field('left', $._left_hand_side),
      field('operator', choice(
        '+=', '-=', '*=', '/=', '@=', '//=', '%=', '**=',
        '>>=', '<<=', '&=', '^=', '|='
      )),
      field('right', $._right_hand_side)
    ),

    _left_hand_side: $ => choice(
      $.pattern,
      $.pattern_list
    ),

    pattern_list: $ => seq(
      field('element', $.pattern),
      choice(
        ',',
        seq(
          repeat1(seq(
            ',',
            field('element', $.pattern)
          )),
          optional(',')
        )
      )
    ),

    _right_hand_side: $ => choice(
      $.expression,
      $.expression_list,
      $.assignment,
      $.augmented_assignment,
      $.yield
    ),

    yield: $ => prec.right(seq(
      'yield',
      choice(
        seq(
          'from',
          $.expression
        ),
        optional($._expressions)
      )
    )),

    attribute: $ => prec(PREC.call, seq(
      field('object', $.primary_expression),
      '.',
      field('attribute', $.identifier)
    )),

    subscript: $ => prec(PREC.call, seq(
      field('value', $.primary_expression),
      '[',
      commaSep1(field('subscript', choice($.list_splat, $.expression, $.slice))),
      optional(','),
      ']'
    )),

    slice: $ => seq(
      optional(field('start', $.expression)),
      ':',
      optional(field('stop', $.expression)),
      optional(seq(':', optional(field('step', $.expression))))
    ),

    ellipsis: $ => '...',

    call: $ => prec(PREC.call, seq(
      field('function', $.primary_expression),
      field('arguments', choice(
        $.generator_expression,
        $.argument_list
      ))
    )),

    typed_parameter: $ => prec(PREC.typed_parameter, seq(
      choice(
        $.identifier,
        $.list_splat_pattern,
        $.dictionary_splat_pattern
      ),
      ':',
      field('type', $.type)
    )),

    type: $ => choice($.list_splat, $.expression),

    keyword_argument: $ => seq(
      field('name', choice($.identifier, $.keyword_identifier)),
      '=',
      field('value', $.expression)
    ),

    // Literals

    list: $ => seq(
      '[',
      optional($._collection_elements),
      ']'
    ),

    set: $ => seq(
      '{',
      $._collection_elements,
      '}'
    ),

    tuple: $ => seq(
      '(',
      optional($._collection_elements),
      ')'
    ),

    dictionary: $ => seq(
      '{',
      optional(commaSep1(field('element', choice($.pair, $.dictionary_splat)))),
      optional(','),
      '}'
    ),

    pair: $ => seq(
      field('key', $.expression),
      ':',
      field('value', $.expression)
    ),

    list_comprehension: $ => seq(
      '[',
      field('body', $.expression),
      $._comprehension_clauses,
      ']'
    ),

    dictionary_comprehension: $ => seq(
      '{',
      field('body', $.pair),
      $._comprehension_clauses,
      '}'
    ),

    set_comprehension: $ => seq(
      '{',
      field('body', $.expression),
      $._comprehension_clauses,
      '}'
    ),

    generator_expression: $ => seq(
      '(',
      field('body', $.expression),
      $._comprehension_clauses,
      ')'
    ),

    _comprehension_clauses: $ => seq(
      $.for_in_clause,
      repeat(choice(
        $.for_in_clause,
        $.if_clause
      ))
    ),

    parenthesized_expression: $ => prec(PREC.parenthesized_expression, seq(
      '(',
      field('inner', choice($.expression, $.yield)),
      ')'
    )),

    _collection_elements: $ => seq(
      commaSep1(field('element', choice(
        $.expression, $.yield, $.list_splat, $.parenthesized_list_splat
      ))),
      optional(field('trailing_comma', ','))
    ),

    for_in_clause: $ => prec.left(seq(
      optional('async'),
      'for',
      field('left', $._left_hand_side),
      'in',
      field('right', commaSep1($._expression_within_for_in_clause)),
      optional(',')
    )),

    if_clause: $ => seq(
      'if',
      $.expression
    ),

    conditional_expression: $ => prec.right(PREC.conditional, seq(
      $.expression,
      'if',
      $.expression,
      'else',
      $.expression
    )),

    concatenated_string: $ => seq(
      $.string,
      repeat1($.string)
    ),


    string: $ => seq(
      field('prefix', alias($._string_start, '"')),
      repeat(choice(
        field('interpolation', $.interpolation),
        field('string_content', $.string_content)
      )),
      field('suffix', alias($._string_end, '"'))
    ),

    string_content: $ => prec.right(0, repeat1(
      choice(
        $._escape_interpolation,
        $.escape_sequence,
        $._not_escape_sequence,
        $._string_content
      ))),

    interpolation: $ => seq(
      token.immediate('{'),
      field('expression', $._f_expression),
      optional('='),
      optional($.type_conversion),
      optional($.format_specifier),
      '}'
    ),

    _f_expression: $ => choice(
      $.expression,
      $.expression_list,
      $.yield,
    ),

    _escape_interpolation: $ => token.immediate(choice('{{', '}}')),

    escape_sequence: $ => token.immediate(prec(1, seq(
      '\\',
      choice(
        /u[a-fA-F\d]{4}/,
        /U[a-fA-F\d]{8}/,
        /x[a-fA-F\d]{2}/,
        /\d{3}/,
        /\r?\n/,
        /['"abfrntv\\]/,
        /N\{[^}]+\}/,
      )
    ))),

    _not_escape_sequence: $ => token.immediate('\\'),

    format_specifier: $ => seq(
      ':',
      repeat(choice(
        token(prec(1, /[^{}\n]+/)),
        alias($.interpolation, $.format_expression)
      ))
    ),

    format_expression: $ => seq('{', $.expression, '}'),

    type_conversion: $ => /![a-z]/,

    integer: $ => token(choice(
      seq(
        choice('0x', '0X'),
        repeat1(/_?[A-Fa-f0-9]+/),
        optional(/[Ll]/)
      ),
      seq(
        choice('0o', '0O'),
        repeat1(/_?[0-7]+/),
        optional(/[Ll]/)
      ),
      seq(
        choice('0b', '0B'),
        repeat1(/_?[0-1]+/),
        optional(/[Ll]/)
      ),
      seq(
        repeat1(/[0-9]+_?/),
        choice(
          optional(/[Ll]/), // long numbers
          optional(/[jJ]/) // complex numbers
        )
      )
    )),

    float: $ => {
      const digits = repeat1(/[0-9]+_?/);
      const exponent = seq(/[eE][\+-]?/, digits)

      return token(seq(
        choice(
          seq(digits, '.', optional(digits), optional(exponent)),
          seq(optional(digits), '.', digits, optional(exponent)),
          seq(digits, exponent)
        ),
        optional(choice(/[Ll]/, /[jJ]/))
      ))
    },

    identifier: $ => /[_\p{XID_Start}][_\p{XID_Continue}]*/,

    keyword_identifier: $ => prec(-3, alias(
      choice(
        'print',
        'exec',
        'async',
        'await',
        'match',
        'type',
      ),
      $.identifier
    )),

    true: $ => 'True',
    false: $ => 'False',
    none: $ => 'None',

    await: $ => prec(PREC.unary, seq(
      'await',
      $.primary_expression
    )),

    comment: $ => token(seq('#', /.*/)),

    positional_separator: $ => '/',
    keyword_separator: $ => '*',

    _semicolon: $ => ';'
  }
})

function commaSep1(rule) {
  return sep1(rule, ',')
}

function sep1(rule, separator) {
  return seq(rule, repeat(seq(separator, rule)))
}

function open_sequence(rule, repeat_rule = rule) {
  return prec.right(seq(
    rule,
    choice(
      ',',
      seq(
        repeat1(seq(
          ',',
          repeat_rule
        )),
        optional(',')
      ),
    )
  ))
}
