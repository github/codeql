/*
 * Based on org.mozilla.javascript.json.JsonParser from Rhino.
 *
 * Original licensing information:
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

package com.semmle.js.parser;

import com.semmle.js.ast.Position;
import com.semmle.js.ast.SourceLocation;
import com.semmle.js.ast.json.JSONArray;
import com.semmle.js.ast.json.JSONLiteral;
import com.semmle.js.ast.json.JSONObject;
import com.semmle.js.ast.json.JSONValue;
import com.semmle.util.data.Pair;
import com.semmle.util.exception.Exceptions;
import com.semmle.util.io.WholeIO;
import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class JSONParser {
  public static final Pattern JSON_LINE_ENDING = Pattern.compile("(\r\n|\n|\r)");

  private int line, column;
  private int offset;
  private int length;
  private String src;
  private List<ParseError> recoverableErrors;

  public Pair<JSONValue, List<ParseError>> parseValue(String json) throws ParseError {
    line = 1;
    column = 0;
    offset = 0;
    recoverableErrors = new ArrayList<ParseError>();

    if (json == null) raise("Input string may not be null");
    length = json.length();
    src = json;

    JSONValue value = readValue();
    consumeWhitespace();
    if (offset < length) raise("Expected end of input");

    return Pair.make(value, recoverableErrors);
  }

  private <T> T raise(String msg) throws ParseError {
    throw new ParseError(msg, line, column - 1, offset);
  }

  private char next() throws ParseError {
    if (offset >= length) raise("Unexpected end of input");

    char c = src.charAt(offset++);
    if (c == '\r') {
      if (offset < length && src.charAt(offset) == '\n') {
        ++column;
      } else {
        ++line;
        column = 0;
      }
    } else if (c == '\n') {
      ++line;
      column = 0;
    } else {
      ++column;
    }
    return c;
  }

  private char peek() {
    return offset < length ? src.charAt(offset) : (char) -1;
  }

  private JSONValue readValue() throws ParseError {
    consumeWhitespace();
    while (offset < length) {
      int startoff = offset;
      Position start = getCurPos();
      char c = next();
      switch (c) {
        case '{':
          return readObject(startoff, start);
        case '[':
          return readArray(startoff, start);
        case 't':
          consume("rue");
          return mkLiteral(startoff, start, true);
        case 'f':
          consume("alse");
          return mkLiteral(startoff, start, false);
        case '"':
          return mkLiteral(startoff, start, readString());
        case 'n':
          consume("ull");
          return mkLiteral(startoff, start, null);
        case '1':
        case '2':
        case '3':
        case '4':
        case '5':
        case '6':
        case '7':
        case '8':
        case '9':
        case '0':
        case '-':
          return mkLiteral(startoff, start, readNumber());
        default:
          raise("Unexpected token");
      }
    }
    return raise("Unexpected token");
  }

  private Position getCurPos() {
    return new Position(line, column, offset);
  }

  private JSONLiteral mkLiteral(int startoff, Position start, Object value) {
    int endoff = offset;
    Position end = getCurPos();
    return new JSONLiteral(new SourceLocation(src.substring(startoff, endoff), start, end), value);
  }

  private JSONObject readObject(int startoff, Position start) throws ParseError {
    List<Pair<String, JSONValue>> properties = new ArrayList<Pair<String, JSONValue>>();
    int endoff;
    Position end;

    consumeWhitespace();
    // handle empty object literal case early
    out:
    if (peek() == '}') {
      next();
    } else {
      String id;
      JSONValue value;
      boolean needsComma = false;

      while (offset < length) {
        char c = next();
        switch (c) {
          case '}':
            if (!needsComma) {
              raise("Trailing commas are not allowed in JSON.");
            }
            break out;
          case ',':
            if (!needsComma) {
              raise("Unexpected comma in object literal");
            }
            needsComma = false;
            break;
          case '"':
            if (needsComma) {
              raise("Missing comma in object literal");
            }
            id = readString();
            consumeWhitespace();
            consume(':');
            value = readValue();

            properties.add(Pair.make(id, value));

            needsComma = true;
            break;
          default:
            raise("JSON object property keys must be string literals.");
        }
        consumeWhitespace();
      }
      ++column;
      raise("Unexpected token");
    }
    endoff = offset;
    end = getCurPos();
    return new JSONObject(
        new SourceLocation(src.substring(startoff, endoff), start, end), properties);
  }

  private JSONArray readArray(int startoff, Position start) throws ParseError {
    List<JSONValue> elements = new ArrayList<JSONValue>();
    int endoff;
    Position end;

    consumeWhitespace();
    // handle empty array literal case early
    out:
    if (peek() == ']') {
      next();
    } else {
      boolean needsComma = false;
      while (offset < length) {
        char c = peek();
        switch (c) {
          case ']':
            if (!needsComma) {
              raise("Omitted elements are not allowed in JSON.");
            }
            next();
            break out;
          case ',':
            if (!needsComma) {
              next();
              raise("Omitted elements are not allowed in JSON.");
            }
            needsComma = false;
            next();
            break;
          default:
            if (needsComma) {
              raise("Missing comma in array literal");
            }
            elements.add(readValue());
            needsComma = true;
        }
        consumeWhitespace();
      }
      raise("Unterminated array literal");
    }

    endoff = offset;
    end = getCurPos();
    return new JSONArray(new SourceLocation(src.substring(startoff, endoff), start, end), elements);
  }

  private static final String ESCAPES = "\"\"\\\\//b\bn\nf\fr\rt\t";

  private String readString() throws ParseError {
    /*
     * Optimization: if the source contains no escaped characters, create the
     * string directly from the source text.
     */
    int stringStart = offset;
    while (offset < length) {
      char c = next();
      if (c <= '\u001F') {
        raise("String contains control character");
      } else if (c == '\\') {
        break;
      } else if (c == '"') {
        return src.substring(stringStart, offset - 1);
      }
    }

    /*
     * Slow case: string contains escaped characters.  Copy a maximal sequence
     * of unescaped characters into a temporary buffer, then an escaped
     * character, and repeat until the entire string is consumed.
     */
    StringBuilder b = new StringBuilder();
    while (offset < length) {
      b.append(src, stringStart, offset - 1);
      char c = next();

      int i = ESCAPES.indexOf(c);
      if (i >= 0) {
        b.append(ESCAPES.charAt(i + 1));
      } else if (c == 'u') {
        try {
          String esc = src.substring(offset, offset + 4);
          int code = Integer.parseInt(esc, 16);
          if (code < 0) throw new NumberFormatException();
          b.append((char) code);
          offset += 4;
          column += 4;
        } catch (NumberFormatException nfe) {
          raise("Invalid character escape");
        } catch (IndexOutOfBoundsException ioobe) {
          Exceptions.ignore(ioobe, "Raise semantically more meaningful exception instead.");
          raise("Invalid character escape");
        }
      } else {
        raise("Unexpected character in string literal");
      }

      stringStart = offset;
      while (offset < length) {
        c = next();
        if (c <= '\u001F') {
          raise("String contains control character");
        } else if (c == '\\') {
          break;
        } else if (c == '"') {
          b.append(src, stringStart, offset - 1);
          return b.toString();
        }
      }
    }
    return raise("Unterminated string literal");
  }

  private static final Pattern NUMBER =
      Pattern.compile("-?(0|[1-9][0-9]*)(\\.[0-9]+)?([eE][-+]?[0-9]+)?");

  private Number readNumber() throws ParseError {
    Matcher m = NUMBER.matcher(src);
    if (m.find(offset - 1)) {
      try {
        String matched = m.group();
        // -1 because offset is already one past the start of the number
        int l = matched.length() - 1;
        Double d = Double.valueOf(matched);
        offset += l;
        column += l;
        if (d.longValue() == d) return d.longValue();
        return d;
      } catch (NumberFormatException nfe) {
        Exceptions.ignore(nfe, "A corresponding exception is raised below.");
      }
    }
    return raise("Invalid number literal");
  }

  private void consumeWhitespace() throws ParseError {
    while (offset < length) {
      char c = peek();
      switch (c) {
        case ' ':
        case '\t':
        case '\r':
        case '\n':
          next();
          break;
        case '/':
          if (offset + 1 < length) {
            switch (src.charAt(offset + 1)) {
              case '*':
                skipBlockComment();
                continue;
              case '/':
                skipLineComment();
                continue;
            }
          }
        default:
          return;
      }
    }
  }

  /** Skips the line comment starting at the current position and records a recoverable error. */
  private void skipLineComment() throws ParseError {
    Position pos = new Position(line, column, offset);
    char c;
    next();
    next();
    while ((c = peek()) != '\r' && c != '\n' && c != -1) next();
    recoverableErrors.add(new ParseError("Comments are not legal in JSON.", pos));
  }

  /** Skips the block comment starting at the current position and records a recoverable error. */
  private void skipBlockComment() throws ParseError {
    Position pos = new Position(line, column, offset);
    char c;
    next();
    next();
    do {
      c = peek();
      if (c < 0) raise("Unterminated comment.");
      next();
      if (c == '*' && peek() == '/') {
        next();
        break;
      }
    } while (true);
    recoverableErrors.add(new ParseError("Comments are not legal in JSON.", pos));
  }

  private void consume(char token) throws ParseError {
    char c = next();
    if (c != token) raise("Expected " + token + " found " + c);
  }

  private void consume(String chars) throws ParseError {
    for (int i = 0; i < chars.length(); ++i) consume(chars.charAt(i));
  }

  public static void main(String[] args) throws ParseError {
    JSONParser parser = new JSONParser();
    System.out.println(parser.parseValue(new WholeIO().strictread(new File(args[0]))).fst());
  }
}
