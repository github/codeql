#include "tree_sitter/parser.h"

#if defined(__GNUC__) || defined(__clang__)
#pragma GCC diagnostic ignored "-Wmissing-field-initializers"
#endif

#define LANGUAGE_VERSION 14
#define STATE_COUNT 20
#define LARGE_STATE_COUNT 2
#define SYMBOL_COUNT 15
#define ALIAS_COUNT 0
#define TOKEN_COUNT 8
#define EXTERNAL_TOKEN_COUNT 0
#define FIELD_COUNT 6
#define MAX_ALIAS_SEQUENCE_LENGTH 4
#define PRODUCTION_ID_COUNT 14

enum ts_symbol_identifiers {
  anon_sym_today_COLON = 1,
  anon_sym_file_COLON = 2,
  anon_sym_LF = 3,
  anon_sym_last_modified_COLON = 4,
  sym_date = 5,
  sym_filename = 6,
  sym_number = 7,
  sym_blame_info = 8,
  sym__today = 9,
  sym_file_entry = 10,
  sym_blame_entry = 11,
  aux_sym_blame_info_repeat1 = 12,
  aux_sym_file_entry_repeat1 = 13,
  aux_sym_blame_entry_repeat1 = 14,
};

static const char * const ts_symbol_names[] = {
  [ts_builtin_sym_end] = "end",
  [anon_sym_today_COLON] = "today:",
  [anon_sym_file_COLON] = "file: ",
  [anon_sym_LF] = "\n",
  [anon_sym_last_modified_COLON] = "last_modified:",
  [sym_date] = "date",
  [sym_filename] = "filename",
  [sym_number] = "number",
  [sym_blame_info] = "blame_info",
  [sym__today] = "_today",
  [sym_file_entry] = "file_entry",
  [sym_blame_entry] = "blame_entry",
  [aux_sym_blame_info_repeat1] = "blame_info_repeat1",
  [aux_sym_file_entry_repeat1] = "file_entry_repeat1",
  [aux_sym_blame_entry_repeat1] = "blame_entry_repeat1",
};

static const TSSymbol ts_symbol_map[] = {
  [ts_builtin_sym_end] = ts_builtin_sym_end,
  [anon_sym_today_COLON] = anon_sym_today_COLON,
  [anon_sym_file_COLON] = anon_sym_file_COLON,
  [anon_sym_LF] = anon_sym_LF,
  [anon_sym_last_modified_COLON] = anon_sym_last_modified_COLON,
  [sym_date] = sym_date,
  [sym_filename] = sym_filename,
  [sym_number] = sym_number,
  [sym_blame_info] = sym_blame_info,
  [sym__today] = sym__today,
  [sym_file_entry] = sym_file_entry,
  [sym_blame_entry] = sym_blame_entry,
  [aux_sym_blame_info_repeat1] = aux_sym_blame_info_repeat1,
  [aux_sym_file_entry_repeat1] = aux_sym_file_entry_repeat1,
  [aux_sym_blame_entry_repeat1] = aux_sym_blame_entry_repeat1,
};

static const TSSymbolMetadata ts_symbol_metadata[] = {
  [ts_builtin_sym_end] = {
    .visible = false,
    .named = true,
  },
  [anon_sym_today_COLON] = {
    .visible = true,
    .named = false,
  },
  [anon_sym_file_COLON] = {
    .visible = true,
    .named = false,
  },
  [anon_sym_LF] = {
    .visible = true,
    .named = false,
  },
  [anon_sym_last_modified_COLON] = {
    .visible = true,
    .named = false,
  },
  [sym_date] = {
    .visible = true,
    .named = true,
  },
  [sym_filename] = {
    .visible = true,
    .named = true,
  },
  [sym_number] = {
    .visible = true,
    .named = true,
  },
  [sym_blame_info] = {
    .visible = true,
    .named = true,
  },
  [sym__today] = {
    .visible = false,
    .named = true,
  },
  [sym_file_entry] = {
    .visible = true,
    .named = true,
  },
  [sym_blame_entry] = {
    .visible = true,
    .named = true,
  },
  [aux_sym_blame_info_repeat1] = {
    .visible = false,
    .named = false,
  },
  [aux_sym_file_entry_repeat1] = {
    .visible = false,
    .named = false,
  },
  [aux_sym_blame_entry_repeat1] = {
    .visible = false,
    .named = false,
  },
};

enum ts_field_identifiers {
  field_blame_entry = 1,
  field_date = 2,
  field_file_entry = 3,
  field_file_name = 4,
  field_line = 5,
  field_today = 6,
};

static const char * const ts_field_names[] = {
  [0] = NULL,
  [field_blame_entry] = "blame_entry",
  [field_date] = "date",
  [field_file_entry] = "file_entry",
  [field_file_name] = "file_name",
  [field_line] = "line",
  [field_today] = "today",
};

static const TSFieldMapSlice ts_field_map_slices[PRODUCTION_ID_COUNT] = {
  [1] = {.index = 0, .length = 1},
  [2] = {.index = 1, .length = 1},
  [3] = {.index = 2, .length = 1},
  [4] = {.index = 3, .length = 2},
  [5] = {.index = 5, .length = 2},
  [6] = {.index = 7, .length = 1},
  [7] = {.index = 8, .length = 1},
  [8] = {.index = 9, .length = 2},
  [9] = {.index = 11, .length = 1},
  [10] = {.index = 12, .length = 2},
  [11] = {.index = 14, .length = 1},
  [12] = {.index = 15, .length = 2},
  [13] = {.index = 17, .length = 2},
};

static const TSFieldMapEntry ts_field_map_entries[] = {
  [0] =
    {field_today, 0, .inherited = true},
  [1] =
    {field_today, 1},
  [2] =
    {field_file_entry, 0},
  [3] =
    {field_file_entry, 1, .inherited = true},
    {field_today, 0, .inherited = true},
  [5] =
    {field_file_entry, 0, .inherited = true},
    {field_file_entry, 1, .inherited = true},
  [7] =
    {field_file_name, 1},
  [8] =
    {field_blame_entry, 0},
  [9] =
    {field_blame_entry, 3, .inherited = true},
    {field_file_name, 1},
  [11] =
    {field_date, 1},
  [12] =
    {field_blame_entry, 0, .inherited = true},
    {field_blame_entry, 1, .inherited = true},
  [14] =
    {field_line, 0},
  [15] =
    {field_date, 1},
    {field_line, 2, .inherited = true},
  [17] =
    {field_line, 0, .inherited = true},
    {field_line, 1, .inherited = true},
};

static const TSSymbol ts_alias_sequences[PRODUCTION_ID_COUNT][MAX_ALIAS_SEQUENCE_LENGTH] = {
  [0] = {0},
};

static const uint16_t ts_non_terminal_alias_map[] = {
  0,
};

static const TSStateId ts_primary_state_ids[STATE_COUNT] = {
  [0] = 0,
  [1] = 1,
  [2] = 2,
  [3] = 3,
  [4] = 4,
  [5] = 5,
  [6] = 6,
  [7] = 7,
  [8] = 8,
  [9] = 9,
  [10] = 10,
  [11] = 11,
  [12] = 12,
  [13] = 13,
  [14] = 14,
  [15] = 15,
  [16] = 16,
  [17] = 17,
  [18] = 18,
  [19] = 19,
};

static bool ts_lex(TSLexer *lexer, TSStateId state) {
  START_LEXER();
  eof = lexer->eof(lexer);
  switch (state) {
    case 0:
      if (eof) ADVANCE(37);
      if (lookahead == 'f') ADVANCE(18);
      if (lookahead == 'l') ADVANCE(10);
      if (lookahead == 't') ADVANCE(23);
      if (('\t' <= lookahead && lookahead <= '\r') ||
          lookahead == ' ') SKIP(0);
      if (('0' <= lookahead && lookahead <= '9')) ADVANCE(48);
      END_STATE();
    case 1:
      if (lookahead == '\n') ADVANCE(40);
      if (('\t' <= lookahead && lookahead <= '\r') ||
          lookahead == ' ') SKIP(1);
      END_STATE();
    case 2:
      if (lookahead == ' ') ADVANCE(39);
      END_STATE();
    case 3:
      if (lookahead == ' ') ADVANCE(43);
      if (('\t' <= lookahead && lookahead <= '\r')) SKIP(3);
      if (('-' <= lookahead && lookahead <= '9') ||
          ('A' <= lookahead && lookahead <= 'Z') ||
          lookahead == '_' ||
          ('a' <= lookahead && lookahead <= 'z')) ADVANCE(44);
      END_STATE();
    case 4:
      if (lookahead == '-') ADVANCE(31);
      END_STATE();
    case 5:
      if (lookahead == '-') ADVANCE(32);
      END_STATE();
    case 6:
      if (lookahead == ':') ADVANCE(2);
      END_STATE();
    case 7:
      if (lookahead == ':') ADVANCE(38);
      END_STATE();
    case 8:
      if (lookahead == ':') ADVANCE(41);
      END_STATE();
    case 9:
      if (lookahead == '_') ADVANCE(22);
      END_STATE();
    case 10:
      if (lookahead == 'a') ADVANCE(25);
      END_STATE();
    case 11:
      if (lookahead == 'a') ADVANCE(27);
      END_STATE();
    case 12:
      if (lookahead == 'd') ADVANCE(19);
      END_STATE();
    case 13:
      if (lookahead == 'd') ADVANCE(11);
      END_STATE();
    case 14:
      if (lookahead == 'd') ADVANCE(8);
      END_STATE();
    case 15:
      if (lookahead == 'e') ADVANCE(6);
      END_STATE();
    case 16:
      if (lookahead == 'e') ADVANCE(14);
      END_STATE();
    case 17:
      if (lookahead == 'f') ADVANCE(20);
      END_STATE();
    case 18:
      if (lookahead == 'i') ADVANCE(21);
      END_STATE();
    case 19:
      if (lookahead == 'i') ADVANCE(17);
      END_STATE();
    case 20:
      if (lookahead == 'i') ADVANCE(16);
      END_STATE();
    case 21:
      if (lookahead == 'l') ADVANCE(15);
      END_STATE();
    case 22:
      if (lookahead == 'm') ADVANCE(24);
      END_STATE();
    case 23:
      if (lookahead == 'o') ADVANCE(13);
      END_STATE();
    case 24:
      if (lookahead == 'o') ADVANCE(12);
      END_STATE();
    case 25:
      if (lookahead == 's') ADVANCE(26);
      END_STATE();
    case 26:
      if (lookahead == 't') ADVANCE(9);
      END_STATE();
    case 27:
      if (lookahead == 'y') ADVANCE(7);
      END_STATE();
    case 28:
      if (('\t' <= lookahead && lookahead <= '\r') ||
          lookahead == ' ') SKIP(28);
      if (('0' <= lookahead && lookahead <= '9')) ADVANCE(35);
      END_STATE();
    case 29:
      if (('0' <= lookahead && lookahead <= '9')) ADVANCE(5);
      END_STATE();
    case 30:
      if (('0' <= lookahead && lookahead <= '9')) ADVANCE(42);
      END_STATE();
    case 31:
      if (('0' <= lookahead && lookahead <= '9')) ADVANCE(29);
      END_STATE();
    case 32:
      if (('0' <= lookahead && lookahead <= '9')) ADVANCE(30);
      END_STATE();
    case 33:
      if (('0' <= lookahead && lookahead <= '9')) ADVANCE(4);
      END_STATE();
    case 34:
      if (('0' <= lookahead && lookahead <= '9')) ADVANCE(33);
      END_STATE();
    case 35:
      if (('0' <= lookahead && lookahead <= '9')) ADVANCE(34);
      END_STATE();
    case 36:
      if (eof) ADVANCE(37);
      if (lookahead == 'f') ADVANCE(18);
      if (lookahead == 'l') ADVANCE(10);
      if (('\t' <= lookahead && lookahead <= '\r') ||
          lookahead == ' ') SKIP(36);
      if (('0' <= lookahead && lookahead <= '9')) ADVANCE(49);
      END_STATE();
    case 37:
      ACCEPT_TOKEN(ts_builtin_sym_end);
      END_STATE();
    case 38:
      ACCEPT_TOKEN(anon_sym_today_COLON);
      END_STATE();
    case 39:
      ACCEPT_TOKEN(anon_sym_file_COLON);
      END_STATE();
    case 40:
      ACCEPT_TOKEN(anon_sym_LF);
      if (lookahead == '\n') ADVANCE(40);
      END_STATE();
    case 41:
      ACCEPT_TOKEN(anon_sym_last_modified_COLON);
      END_STATE();
    case 42:
      ACCEPT_TOKEN(sym_date);
      END_STATE();
    case 43:
      ACCEPT_TOKEN(sym_filename);
      if (lookahead == ' ') ADVANCE(43);
      if (('-' <= lookahead && lookahead <= '9') ||
          ('A' <= lookahead && lookahead <= 'Z') ||
          lookahead == '_' ||
          ('a' <= lookahead && lookahead <= 'z')) ADVANCE(44);
      END_STATE();
    case 44:
      ACCEPT_TOKEN(sym_filename);
      if (lookahead == ' ' ||
          ('-' <= lookahead && lookahead <= '9') ||
          ('A' <= lookahead && lookahead <= 'Z') ||
          lookahead == '_' ||
          ('a' <= lookahead && lookahead <= 'z')) ADVANCE(44);
      END_STATE();
    case 45:
      ACCEPT_TOKEN(sym_number);
      if (lookahead == '-') ADVANCE(31);
      if (('0' <= lookahead && lookahead <= '9')) ADVANCE(49);
      END_STATE();
    case 46:
      ACCEPT_TOKEN(sym_number);
      if (('0' <= lookahead && lookahead <= '9')) ADVANCE(45);
      END_STATE();
    case 47:
      ACCEPT_TOKEN(sym_number);
      if (('0' <= lookahead && lookahead <= '9')) ADVANCE(46);
      END_STATE();
    case 48:
      ACCEPT_TOKEN(sym_number);
      if (('0' <= lookahead && lookahead <= '9')) ADVANCE(47);
      END_STATE();
    case 49:
      ACCEPT_TOKEN(sym_number);
      if (('0' <= lookahead && lookahead <= '9')) ADVANCE(49);
      END_STATE();
    default:
      return false;
  }
}

static const TSLexMode ts_lex_modes[STATE_COUNT] = {
  [0] = {.lex_state = 0},
  [1] = {.lex_state = 0},
  [2] = {.lex_state = 0},
  [3] = {.lex_state = 0},
  [4] = {.lex_state = 36},
  [5] = {.lex_state = 0},
  [6] = {.lex_state = 36},
  [7] = {.lex_state = 36},
  [8] = {.lex_state = 0},
  [9] = {.lex_state = 0},
  [10] = {.lex_state = 0},
  [11] = {.lex_state = 36},
  [12] = {.lex_state = 0},
  [13] = {.lex_state = 0},
  [14] = {.lex_state = 0},
  [15] = {.lex_state = 28},
  [16] = {.lex_state = 0},
  [17] = {.lex_state = 3},
  [18] = {.lex_state = 1},
  [19] = {.lex_state = 28},
};

static const uint16_t ts_parse_table[LARGE_STATE_COUNT][SYMBOL_COUNT] = {
  [0] = {
    [ts_builtin_sym_end] = ACTIONS(1),
    [anon_sym_today_COLON] = ACTIONS(1),
    [anon_sym_file_COLON] = ACTIONS(1),
    [anon_sym_last_modified_COLON] = ACTIONS(1),
    [sym_date] = ACTIONS(1),
    [sym_number] = ACTIONS(1),
  },
  [1] = {
    [sym_blame_info] = STATE(16),
    [sym__today] = STATE(8),
    [anon_sym_today_COLON] = ACTIONS(3),
  },
};

static const uint16_t ts_small_parse_table[] = {
  [0] = 4,
    ACTIONS(7), 1,
      anon_sym_last_modified_COLON,
    STATE(3), 1,
      aux_sym_file_entry_repeat1,
    STATE(12), 1,
      sym_blame_entry,
    ACTIONS(5), 2,
      ts_builtin_sym_end,
      anon_sym_file_COLON,
  [14] = 4,
    ACTIONS(7), 1,
      anon_sym_last_modified_COLON,
    STATE(5), 1,
      aux_sym_file_entry_repeat1,
    STATE(12), 1,
      sym_blame_entry,
    ACTIONS(9), 2,
      ts_builtin_sym_end,
      anon_sym_file_COLON,
  [28] = 3,
    ACTIONS(13), 1,
      sym_number,
    STATE(6), 1,
      aux_sym_blame_entry_repeat1,
    ACTIONS(11), 3,
      ts_builtin_sym_end,
      anon_sym_file_COLON,
      anon_sym_last_modified_COLON,
  [40] = 4,
    ACTIONS(17), 1,
      anon_sym_last_modified_COLON,
    STATE(5), 1,
      aux_sym_file_entry_repeat1,
    STATE(12), 1,
      sym_blame_entry,
    ACTIONS(15), 2,
      ts_builtin_sym_end,
      anon_sym_file_COLON,
  [54] = 3,
    ACTIONS(13), 1,
      sym_number,
    STATE(7), 1,
      aux_sym_blame_entry_repeat1,
    ACTIONS(20), 3,
      ts_builtin_sym_end,
      anon_sym_file_COLON,
      anon_sym_last_modified_COLON,
  [66] = 3,
    ACTIONS(24), 1,
      sym_number,
    STATE(7), 1,
      aux_sym_blame_entry_repeat1,
    ACTIONS(22), 3,
      ts_builtin_sym_end,
      anon_sym_file_COLON,
      anon_sym_last_modified_COLON,
  [78] = 4,
    ACTIONS(27), 1,
      ts_builtin_sym_end,
    ACTIONS(29), 1,
      anon_sym_file_COLON,
    STATE(9), 1,
      aux_sym_blame_info_repeat1,
    STATE(14), 1,
      sym_file_entry,
  [91] = 4,
    ACTIONS(29), 1,
      anon_sym_file_COLON,
    ACTIONS(31), 1,
      ts_builtin_sym_end,
    STATE(10), 1,
      aux_sym_blame_info_repeat1,
    STATE(14), 1,
      sym_file_entry,
  [104] = 4,
    ACTIONS(33), 1,
      ts_builtin_sym_end,
    ACTIONS(35), 1,
      anon_sym_file_COLON,
    STATE(10), 1,
      aux_sym_blame_info_repeat1,
    STATE(14), 1,
      sym_file_entry,
  [117] = 1,
    ACTIONS(38), 4,
      ts_builtin_sym_end,
      anon_sym_file_COLON,
      anon_sym_last_modified_COLON,
      sym_number,
  [124] = 1,
    ACTIONS(40), 3,
      ts_builtin_sym_end,
      anon_sym_file_COLON,
      anon_sym_last_modified_COLON,
  [130] = 1,
    ACTIONS(42), 2,
      ts_builtin_sym_end,
      anon_sym_file_COLON,
  [135] = 1,
    ACTIONS(44), 2,
      ts_builtin_sym_end,
      anon_sym_file_COLON,
  [140] = 1,
    ACTIONS(46), 1,
      sym_date,
  [144] = 1,
    ACTIONS(48), 1,
      ts_builtin_sym_end,
  [148] = 1,
    ACTIONS(50), 1,
      sym_filename,
  [152] = 1,
    ACTIONS(52), 1,
      anon_sym_LF,
  [156] = 1,
    ACTIONS(54), 1,
      sym_date,
};

static const uint32_t ts_small_parse_table_map[] = {
  [SMALL_STATE(2)] = 0,
  [SMALL_STATE(3)] = 14,
  [SMALL_STATE(4)] = 28,
  [SMALL_STATE(5)] = 40,
  [SMALL_STATE(6)] = 54,
  [SMALL_STATE(7)] = 66,
  [SMALL_STATE(8)] = 78,
  [SMALL_STATE(9)] = 91,
  [SMALL_STATE(10)] = 104,
  [SMALL_STATE(11)] = 117,
  [SMALL_STATE(12)] = 124,
  [SMALL_STATE(13)] = 130,
  [SMALL_STATE(14)] = 135,
  [SMALL_STATE(15)] = 140,
  [SMALL_STATE(16)] = 144,
  [SMALL_STATE(17)] = 148,
  [SMALL_STATE(18)] = 152,
  [SMALL_STATE(19)] = 156,
};

static const TSParseActionEntry ts_parse_actions[] = {
  [0] = {.entry = {.count = 0, .reusable = false}},
  [1] = {.entry = {.count = 1, .reusable = false}}, RECOVER(),
  [3] = {.entry = {.count = 1, .reusable = true}}, SHIFT(15),
  [5] = {.entry = {.count = 1, .reusable = true}}, REDUCE(sym_file_entry, 3, 0, 6),
  [7] = {.entry = {.count = 1, .reusable = true}}, SHIFT(19),
  [9] = {.entry = {.count = 1, .reusable = true}}, REDUCE(sym_file_entry, 4, 0, 8),
  [11] = {.entry = {.count = 1, .reusable = true}}, REDUCE(sym_blame_entry, 2, 0, 9),
  [13] = {.entry = {.count = 1, .reusable = true}}, SHIFT(11),
  [15] = {.entry = {.count = 1, .reusable = true}}, REDUCE(aux_sym_file_entry_repeat1, 2, 0, 10),
  [17] = {.entry = {.count = 2, .reusable = true}}, REDUCE(aux_sym_file_entry_repeat1, 2, 0, 10), SHIFT_REPEAT(19),
  [20] = {.entry = {.count = 1, .reusable = true}}, REDUCE(sym_blame_entry, 3, 0, 12),
  [22] = {.entry = {.count = 1, .reusable = true}}, REDUCE(aux_sym_blame_entry_repeat1, 2, 0, 13),
  [24] = {.entry = {.count = 2, .reusable = true}}, REDUCE(aux_sym_blame_entry_repeat1, 2, 0, 13), SHIFT_REPEAT(11),
  [27] = {.entry = {.count = 1, .reusable = true}}, REDUCE(sym_blame_info, 1, 0, 1),
  [29] = {.entry = {.count = 1, .reusable = true}}, SHIFT(17),
  [31] = {.entry = {.count = 1, .reusable = true}}, REDUCE(sym_blame_info, 2, 0, 4),
  [33] = {.entry = {.count = 1, .reusable = true}}, REDUCE(aux_sym_blame_info_repeat1, 2, 0, 5),
  [35] = {.entry = {.count = 2, .reusable = true}}, REDUCE(aux_sym_blame_info_repeat1, 2, 0, 5), SHIFT_REPEAT(17),
  [38] = {.entry = {.count = 1, .reusable = true}}, REDUCE(aux_sym_blame_entry_repeat1, 1, 0, 11),
  [40] = {.entry = {.count = 1, .reusable = true}}, REDUCE(aux_sym_file_entry_repeat1, 1, 0, 7),
  [42] = {.entry = {.count = 1, .reusable = true}}, REDUCE(sym__today, 2, 0, 2),
  [44] = {.entry = {.count = 1, .reusable = true}}, REDUCE(aux_sym_blame_info_repeat1, 1, 0, 3),
  [46] = {.entry = {.count = 1, .reusable = true}}, SHIFT(13),
  [48] = {.entry = {.count = 1, .reusable = true}},  ACCEPT_INPUT(),
  [50] = {.entry = {.count = 1, .reusable = true}}, SHIFT(18),
  [52] = {.entry = {.count = 1, .reusable = true}}, SHIFT(2),
  [54] = {.entry = {.count = 1, .reusable = true}}, SHIFT(4),
};

#ifdef __cplusplus
extern "C" {
#endif
#ifdef TREE_SITTER_HIDE_SYMBOLS
#define TS_PUBLIC
#elif defined(_WIN32)
#define TS_PUBLIC __declspec(dllexport)
#else
#define TS_PUBLIC __attribute__((visibility("default")))
#endif

TS_PUBLIC const TSLanguage *tree_sitter_blame(void) {
  static const TSLanguage language = {
    .version = LANGUAGE_VERSION,
    .symbol_count = SYMBOL_COUNT,
    .alias_count = ALIAS_COUNT,
    .token_count = TOKEN_COUNT,
    .external_token_count = EXTERNAL_TOKEN_COUNT,
    .state_count = STATE_COUNT,
    .large_state_count = LARGE_STATE_COUNT,
    .production_id_count = PRODUCTION_ID_COUNT,
    .field_count = FIELD_COUNT,
    .max_alias_sequence_length = MAX_ALIAS_SEQUENCE_LENGTH,
    .parse_table = &ts_parse_table[0][0],
    .small_parse_table = ts_small_parse_table,
    .small_parse_table_map = ts_small_parse_table_map,
    .parse_actions = ts_parse_actions,
    .symbol_names = ts_symbol_names,
    .field_names = ts_field_names,
    .field_map_slices = ts_field_map_slices,
    .field_map_entries = ts_field_map_entries,
    .symbol_metadata = ts_symbol_metadata,
    .public_symbol_map = ts_symbol_map,
    .alias_map = ts_non_terminal_alias_map,
    .alias_sequences = &ts_alias_sequences[0][0],
    .lex_modes = ts_lex_modes,
    .lex_fn = ts_lex,
    .primary_state_ids = ts_primary_state_ids,
  };
  return &language;
}
#ifdef __cplusplus
}
#endif
