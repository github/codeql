package com.semmle.jcorn;

import java.util.regex.Pattern;

/// whitespace.js
public class Whitespace {
  public static final String lineBreak = "\r\n?|\n|\u2028|\u2029";
  public static final Pattern lineBreakG = Pattern.compile(lineBreak); // global

  public static boolean isNewLine(int code) {
    return code == 10 || code == 13 || code == 0x2028 || code == 0x2029;
  }

  public static final String nonASCIIwhitespace =
      "\u1680\u180e\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u202f\u205f\u3000\ufeff";

  public static final Pattern skipWhiteSpace =
      Pattern.compile("(?:\\s|//.*|/\\*([^*]|\\*(?!/))*\\*/)*"); // global
  public static final Pattern skipWhiteSpaceNoNewline =
      Pattern.compile("(?:[ \\t\\x0B\\f]|//.*|/\\*([^*]|\\*(?!/))*\\*/)*");
}
