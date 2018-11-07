var reporter = require('nodeunit').reporters['default'],
    RegExpParser = require('../regexparser').RegExpParser;

function runtest(test, input, expected_output, expected_errors) {
    var parser = new RegExpParser(input),
        actual_output;

    try {
        actual_output = parser.parse();
    } catch(e) {
        test.fail(e.message);
        test.done();
        return;
    }

    expected_errors = expected_errors || [];

    test.deepEqual(actual_output, expected_output);
    test.equal(parser.errors.length, expected_errors.length);
    for (var i=0,n=parser.errors.length; i<n; ++i)
        test.deepEqual(parser.errors[i], expected_errors[i]);
    test.done();
}

var tests = {
    trivial: function(test) {
        runtest(test,
                "t",
                { type: "Constant", value: "t", range: [0, 1] });
    },
    simple: function(test) {
        runtest(test,
                "foo",
                { type: "Sequence",
                  elements:
                  [ { type: "Constant", value: "f", range: [0, 1] },
                    { type: "Constant", value: "o", range: [1, 2] },
                    { type: "Constant", value: "o", range: [2, 3] } ],
                    range: [0, 3] });
    },
    alternatives: function(test) {
        runtest(test,
                "foo|bar",
                { type: 'Disjunction',
                  disjuncts:
                   [ { type: 'Sequence',
                       elements:
                        [ { type: 'Constant', value: 'f', range: [ 0, 1 ] },
                          { type: 'Constant', value: 'o', range: [ 1, 2 ] },
                          { type: 'Constant', value: 'o', range: [ 2, 3 ] } ],
                       range: [0, 3] },
                     { type: 'Sequence',
                       elements:
                        [ { type: 'Constant', value: 'b', range: [ 4, 5 ] },
                          { type: 'Constant', value: 'a', range: [ 5, 6 ] },
                          { type: 'Constant', value: 'r', range: [ 6, 7 ] } ],
                       range: [4, 7] } ],
                    range: [0, 7] });
    },
    opt: function(test) {
        runtest(test,
                "foo?",
                { type: "Sequence",
                  elements:
                  [ { type: "Constant", value: "f", range: [0, 1] },
                    { type: "Constant", value: "o", range: [1, 2] },
                    { type: 'Opt',
                      operand: { type: "Constant", value: "o", range: [2, 3] },
                      greedy: true,
                      range: [2, 4] } ],
                  range: [0, 4] });
    },
    plus: function(test) {
        runtest(test,
                "foo+",
                { type: "Sequence",
                  elements:
                  [ { type: "Constant", value: "f", range: [0, 1] },
                    { type: "Constant", value: "o", range: [1, 2] },
                    { type: 'Plus',
                      operand: { type: "Constant", value: "o", range: [2, 3] },
                      greedy: true,
                      range: [2, 4] } ],
                  range: [0, 4] });
    },
    range: function(test) {
        runtest(test,
                "foo{1,2}",
                { type: "Sequence",
                  elements:
                  [ { type: "Constant", value: "f", range: [0, 1] },
                    { type: "Constant", value: "o", range: [1, 2] },
                    { type: 'Range', lo: 1, hi: 2,
                      operand: { type: "Constant", value: "o", range: [2, 3] },
                      greedy: true,
                      range: [2, 8] } ],
                  range: [0, 8] });
    },
    lrange: function(test) {
        runtest(test,
                "foo{1,}",
                { type: "Sequence",
                  elements:
                  [ { type: "Constant", value: "f", range: [0, 1] },
                    { type: "Constant", value: "o", range: [1, 2] },
                    { type: 'Range', lo: 1, hi: null,
                      operand: { type: "Constant", value: "o", range: [2, 3] },
                      greedy: true,
                      range: [2, 7] } ],
                  range: [0, 7] });
    },
    trange: function(test) {
        runtest(test,
                "foo{1}",
                { type: "Sequence",
                  elements:
                  [ { type: "Constant", value: "f", range: [0, 1] },
                    { type: "Constant", value: "o", range: [1, 2] },
                    { type: 'Range', lo: 1, hi: null,
                      operand: { type: "Constant", value: "o", range: [2, 3] },
                      greedy: true,
                      range: [2, 6] } ],
                  range: [0, 6] });
    },
    lowercase: function(test) {
        runtest(test,
                "[a-z]",
                { type: 'CharacterClass',
                  elements:
                  [ { type: 'CharacterClassRange',
                      left: { type: 'Constant', value: 'a', range: [1, 2] },
                      right: { type: 'Constant', value: 'z', range: [3, 4] },
                      range: [1, 4] } ],
                  inverted: false,
                  range: [0, 5] });
    },
    alpha: function(test) {
        runtest(test,
                "[a-zA-Z]",
                { type: 'CharacterClass',
                  elements:
                  [ { type: 'CharacterClassRange',
                      left: { type: 'Constant', value: 'a', range: [1, 2] },
                      right: { type: 'Constant', value: 'z', range: [3, 4] },
                      range: [1, 4] },
                    { type: 'CharacterClassRange',
                      left: { type: 'Constant', value: 'A', range: [4, 5] },
                      right: { type: 'Constant', value: 'Z', range: [6, 7] },
                      range: [4, 7] }],
                  inverted: false,
                  range: [0, 8] });
    },
    idpart: function(test) {
        runtest(test,
                "[a-zA-Z_]",
                { type: 'CharacterClass',
                  elements:
                  [ { type: 'CharacterClassRange',
                      left: { type: 'Constant', value: 'a', range: [1, 2] },
                      right: { type: 'Constant', value: 'z', range: [3, 4] },
                      range: [1, 4] },
                    { type: 'CharacterClassRange',
                      left: { type: 'Constant', value: 'A', range: [4, 5] },
                      right: { type: 'Constant', value: 'Z', range: [6, 7] },
                      range: [4, 7] },
                    { type: 'Constant', value: '_', range: [7, 8] } ],
                  inverted: false,
                  range: [0, 9] });
    },
    empty_cclass: function(test) {
        runtest(test,
                "[]",
                { type: 'CharacterClass', elements: [], inverted: false, range: [0, 2] });
    },
    universal_cclass: function(test) {
        runtest(test,
                "[^]",
                { type: 'CharacterClass', elements: [], inverted: true, range: [0, 3] });
    },
    dash_cclass: function(test) {
        runtest(test,
                "[-]",
                { type: 'CharacterClass',
                  elements: [
                      { type: 'Constant', value: '-', range: [1, 2] }
                  ],
                  inverted: false,
                  range: [0, 3] });
    },
    ctrlescape: function(test) {
        runtest(test,
                "\\t",
                { type: 'ControlEscape',
                  value: '\t',
                  codepoint: 9,
                  raw: '\\t',
                  range: [0, 2] });
    },
    decescape: function(test) {
        runtest(test,
                "\\0",
                { type: 'DecimalEscape',
                  value: '\0',
                  codepoint: 0,
                  raw: '\\0',
                  range: [0, 2] });
    },
    octescape: function(test) {
        runtest(test,
                "\\012",
                { type: 'OctalEscape',
                  value: '\012',
                  codepoint: 10,
                  raw: '\\012',
                  range: [0, 4] },
                [ { type : 'Error',
                    code: 8,
                   range: [0,4] } ]);
    },
    hexescape: function(test) {
        runtest(test,
                "\\x0a",
                { type: 'HexEscapeSequence',
                  value: '\n',
                  codepoint: 10,
                  raw: '\\x0a',
                  range: [0, 4] });
    },
    HEXescape: function(test) {
        runtest(test,
                "\\x0A",
                { type: 'HexEscapeSequence',
                  value: '\n',
                  codepoint: 10,
                  raw: '\\x0A',
                  range: [0, 4] });
    },
    anchors: function(test) {
        runtest(test,
                "^\\s+$",
                { type: 'Sequence',
                  elements:
                  [ { type: 'Caret', range: [0, 1] },
                    { type: 'Plus',
                      operand:
                      { type: 'CharacterClassEscape',
                        class: 's',
                        raw: '\\s',
                        range: [1, 3] },
                      greedy: true,
                      range: [1, 4] },
                     { type: 'Dollar', range: [4, 5] } ],
                  range: [0, 5] });
    },
    charclass_with_trailing_dash: function(test) {
        runtest(test,
                "[w-]",
                { type: 'CharacterClass',
                  elements:
                  [ { type: 'Constant', value: 'w', range: [1, 2] },
                    { type: 'Constant', value: '-', range: [2, 3] } ],
                  inverted: false,
                  range: [0, 4] });
    },
    confusing_char_class: function(test) {
        runtest(test,
                "[[{]\w+[]}]",
                { type: 'Sequence',
                  elements:
                  [ { type: 'CharacterClass',
                      elements:
                      [ { type: 'Constant', value: '[', range: [1, 2] },
                        { type: 'Constant', value: '{', range: [2, 3] } ],
                      inverted: false,
                      range: [0, 4] },
                    { type: 'Plus',
                      operand: { type: 'Constant', value: 'w', range: [4, 5] },
                      greedy: true,
                      range: [4, 6] },
                    { type: 'CharacterClass',
                      elements: [],
                      inverted: false,
                      range: [ 6, 8 ] },
                    { type: 'Constant', value: '}', range: [8, 9] },
                    { type: 'Constant', value: ']', range: [9, 10] } ],
                  range: [0, 10] },
                [ { type: 'Error',
                    code: 1,
                    range: [8, 9] },
                  { type: 'Error',
                    code: 1,
                    range: [9, 10] } ]);
    },
    backspace: function(test) {
        runtest(test,
                "[\\b]",
                { type: 'CharacterClass',
                  elements:
                  [ { type: 'ControlEscape',
                      value: '\b',
                      codepoint: 8,
                      raw: '\\b',
                      range: [1, 3] } ],
                  inverted: false,
                  range: [0, 4] });
    },
    wordboundary: function(test) {
        runtest(test,
                "\\b",
                { type: 'WordBoundary', range: [0, 2] });
    },
    backref: function(test) {
        runtest(test,
                "(abc)\\1",
                { type: 'Sequence',
                  elements:
                  [ { type: 'Group',
                      capture: true,
                      number: 1,
                      name: null,
                      operand:
                      { type: 'Sequence',
                        elements:
                        [ { type: 'Constant', value: 'a', range: [1, 2] },
                          { type: 'Constant', value: 'b', range: [2, 3] },
                          { type: 'Constant', value: 'c', range: [3, 4] } ],
                          range: [1, 4] },
                      range: [0, 5] },
                    { type: 'BackReference', value: 1, raw: '\\1', range: [5, 7] } ],
                  range: [0, 7] });
    },
    invalid_backref: function(test) {
        runtest(test,
                "\\1",
                { type: 'BackReference', value: 1, raw: '\\1', range: [0, 2] },
                [ { type: 'Error', code: 9, range: [0, 2] } ]);
    },
    nested_groups: function(test) {
        runtest(test,
                "((a))",
                { type: 'Group',
                  capture: true,
                  number: 1,
                  name: null,
                  operand:
                  { type: 'Group',
                    capture: true,
                    number: 2,
                    name: null,
                    operand: { type: 'Constant', value: 'a', range: [ 2, 3 ] },
                    range: [ 1, 4 ] },
                  range: [ 0, 5 ] });
    },
    invalid_hex_escape_in_charclass: function(test) {
        runtest(test,
                "[\\x]+",
                { type: 'Plus',
                  operand:
                  { type: 'CharacterClass',
                    elements:
                    [ { type: 'HexEscapeSequence',
                        value: '\u0000',
                        codepoint: 0,
                        raw: '\\x0',
                        range: [ 1, 3 ] } ],
                    inverted: false,
                    range: [ 0, 4 ] },
                  greedy: true,
                  range: [ 0, 5 ] },
               [ { type: 'Error', code: 3, range: [3,4] },
                 { type: 'Error', code: 3, range: [3,4] } ]);
    },
    unterminated_charclass: function(test) {
        runtest(test,
                "[ab",
                { type: 'CharacterClass',
                  elements:
                  [ { type: 'Constant', value: 'a', range: [ 1, 2 ] },
                    { type: 'Constant', value: 'b', range: [ 2, 3 ] } ],
                  inverted: false,
                  range: [ 0, 3 ] },
                [ { type: 'Error', code: 10, range: [3, 4] } ]);
    },
    decescape_in_charclass: function(test) {
        runtest(test,
                "[\\1]",
                { type: 'CharacterClass',
                  elements:
                  [ { type: 'DecimalEscape',
                      value: '\1',
                      codepoint: 1,
                      raw: '\\1',
                      range: [1, 3] } ],
                  inverted: false,
                  range: [ 0, 4 ] });
    },
    octescape_in_charclass: function(test) {
        runtest(test,
                "[\\012]",
                { type: 'CharacterClass',
                  elements:
                  [ { type: 'OctalEscape',
                      value: '\012',
                      codepoint: 10,
                      raw: '\\012',
                      range: [1, 5] } ],
                  inverted: false,
                  range: [ 0, 6 ] },
                [ { type : 'Error',
                    code: 8,
                   range: [1,5] } ]);
    },
    long_hexescape: function(test) {
    runtest(test,
        "\\u{00000a}b",
        { type: 'Sequence',
          elements:
          [ { type: 'UnicodeEscapeSequence',
              value: '\n',
              codepoint: 10,
              raw: '\\u{00000a}',
              range: [0, 10] },
            { type: 'Constant', value: 'b', range: [ 10, 11 ] } ],
          range: [ 0, 11 ] });
    },
    long_hexescape_incomplete: function(test) {
    runtest(test,
        "\\u{abc",
        { type: 'Sequence',
          elements:
          [ { type: 'UnicodeEscapeSequence',
              value: '\u0000',
              codepoint: 0,
              raw: '\\u{0}',
              range: [ 0, 3 ] },
            { type: 'Constant', value: 'a', range: [ 3, 4 ] },
            { type: 'Constant', value: 'b', range: [ 4, 5 ] },
            { type: 'Constant', value: 'c', range: [ 5, 6 ] } ],
          range: [ 0, 6 ] },
        [ { type: 'Error', code: 6, range: [2, 3] } ]);
    },
    long_hexescape_empty: function(test) {
    runtest(test,
        "\\u{}",
        { type: 'UnicodeEscapeSequence',
          value: '\u0000',
          codepoint: 0,
          raw: '\\u{0}',
          range: [ 0, 4 ] },
        [ { type: 'Error', code: 3, range: [3, 4] } ]);
    },
    long_hexescape_invalid: function(test) {
    runtest(test,
        "\\u{1,}",
        { type: 'Sequence',
          elements:
          [ { type: 'UnicodeEscapeSequence',
              value: '\u0001',
              codepoint: 1,
              raw: '\\u{1}',
              range: [ 0, 4 ] },
            { type: 'Constant', value: ',', range: [ 4, 5 ] },
            { type: 'Constant', value: '}', range: [ 5, 6 ] } ],
          range: [ 0, 6 ] },
        [ { type: 'Error', code: 3, range: [4, 5] },
          { type: 'Error', code: 6, range: [3, 4] },
          { type: 'Error', code: 1, range: [5, 6] } ]);
    },
    named_capture_group: function(test) {
    runtest(test,
        "(?<ws>\\w+)",
        { type: 'Group',
          capture: true,
          number: 1,
          name: 'ws',
          operand:
          { type: 'Plus',
            operand:
            { type: 'CharacterClassEscape',
              class: 'w',
              raw: '\\w',
              range: [ 6, 8 ] },
          greedy: true,
          range: [ 6, 9 ] },
        range: [ 0, 10 ] },
        []);
    },
    named_capture_group_empty_name: function(test) {
    runtest(test,
        "(?<>\\w+)",
        { type: 'Group',
          capture: true,
          number: 1,
          name: '',
          operand:
          { type: 'Plus',
            operand:
            { type: 'CharacterClassEscape',
              class: 'w',
              raw: '\\w',
              range: [ 4, 6 ] },
          greedy: true,
          range: [ 4, 7 ] },
        range: [ 0, 8 ] },
        [ { type: 'Error', code: 11, range: [ 3, 4 ] } ]);
    },
    named_capture_group_missing_rangle: function(test) {
    runtest(test,
        "(?<ws\\w+)",
        { type: 'Group',
          capture: true,
          number: 1,
          name: 'ws',
          operand:
          { type: 'Plus',
            operand:
            { type: 'CharacterClassEscape',
              class: 'w',
              raw: '\\w',
              range: [ 5, 7 ] },
          greedy: true,
          range: [ 5, 8 ] },
        range: [ 0, 9 ] },
        [ { type: 'Error', code: 12, range: [ 4, 5 ] } ]);
    },
    named_capture_group_missing_rparen: function(test) {
    runtest(test,
        "(?<ws>\\w+",
        { type: 'Group',
          capture: true,
          number: 1,
          name: 'ws',
          operand:
          { type: 'Plus',
            operand:
            { type: 'CharacterClassEscape',
              class: 'w',
              raw: '\\w',
              range: [ 6, 8 ] },
          greedy: true,
          range: [ 6, 9 ] },
        range: [ 0, 9 ] },
        [ { type: 'Error', code: 5, range: [ 8, 9 ] } ]);
    },
    named_backref: function(test) {
    runtest(test,
        "\\k<ws>",
        { type: 'NamedBackReference',
          name: 'ws',
          raw: '\\k<ws>',
          range: [ 0, 6 ] },
        []);
    },
    named_backref_empty_name: function(test) {
    runtest(test,
        "\\k<>",
        { type: 'NamedBackReference',
          name: '',
          raw: '\\k<>',
          range: [ 0, 4 ] },
        [ { type: 'Error', code: 11, range: [ 3, 4 ] } ]);
    },
    named_backref_missing_rangle: function(test) {
    runtest(test,
        "\\k<ws",
        { type: 'NamedBackReference',
          name: 'ws',
          raw: '\\k<ws>',
          range: [ 0, 5 ] },
        [ { type: 'Error', code: 12, range: [ 4, 5 ] } ]);
    },
    positive_lookbehind: function(test) {
    runtest(test,
        "(?<=\$)0",
        { type: 'Sequence',
          elements:
          [ { type: 'ZeroWidthPositiveLookbehind',
              operand: { type: 'Dollar', range: [ 4, 5 ] },
              range: [ 0, 6 ] },
            { type: 'Constant', value: '0', range: [ 6, 7 ] } ],
              range: [ 0, 7 ] },
        []);
    },
    negative_lookbehind: function(test) {
    runtest(test,
        "(?<!\$)0",
        { type: 'Sequence',
          elements:
          [ { type: 'ZeroWidthNegativeLookbehind',
              operand: { type: 'Dollar', range: [ 4, 5 ] },
              range: [ 0, 6 ] },
            { type: 'Constant', value: '0', range: [ 6, 7 ] } ],
              range: [ 0, 7 ] },
        []);
    },
    unicode_property_escape: function(test) {
    runtest(test,
        "\\p{Number}",
        { type: 'UnicodePropertyEscape',
          name: 'Number',
          value: null,
          raw: '\\p{Number}',
          range: [ 0, 10 ] },
        []);
    },
    unicode_property_escape_uc: function(test) {
    runtest(test,
        "\\P{Number}",
        { type: 'UnicodePropertyEscape',
          name: 'Number',
          value: null,
          raw: '\\p{Number}',
          range: [ 0, 10 ] },
        []);
    },
    unicode_property_escape_binary: function(test) {
    runtest(test,
        "\\p{Script=Greek}",
        { type: 'UnicodePropertyEscape',
          name: 'Script',
          value: 'Greek',
          raw: '\\p{Script=Greek}',
          range: [ 0, 16 ] },
        []);
    },
    unicode_property_escape_missing_rbrace: function(test) {
    runtest(test,
        "\\p{Number",
        { type: 'UnicodePropertyEscape',
          name: 'Number',
          value: null,
          raw: '\\p{Number}',
          range: [ 0, 9 ] },
        [ { type: 'Error', code: 6, range: [ 8, 9 ] } ]);
    }
};

reporter.run({ "unit tests": tests });
