package com.semmle.jcorn;

import com.semmle.js.ast.Position;
import java.util.regex.Matcher;

/// locutil.js
public class Locutil {
  /**
   * The `getLineInfo` function is mostly useful when the `locations` option is off (for performance
   * reasons) and you want to find the line/column position for a given character offset. `input`
   * should be the code string that the offset refers into.
   */
  public static Position getLineInfo(String input, int offset) {
    Matcher lineBreakG = Whitespace.lineBreakG.matcher(input);
    for (int line = 1, cur = 0; ; ) {
      if (lineBreakG.find(cur) && lineBreakG.start() < offset) {
        ++line;
        cur = lineBreakG.end();
      } else {
        return new Position(line, offset - cur, offset);
      }
    }
  }
}
