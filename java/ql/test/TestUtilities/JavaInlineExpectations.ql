import java

external predicate queryResults(string relation, int row, int column, string data);

string actualLines() {
  exists(int i |
    queryResults("#select", i, _, _) and
    result =
      " | " +
        concat(int j, string cell | queryResults("#select", i, j, cell) | cell, " | " order by j) +
        " | "
  )
}

predicate parsedExpectedResults(string filename, int line, string content) {
  exists(Javadoc doc |
    isEolComment(doc) and
    filename = doc.getLocation().getFile().getBaseName() and
    line = doc.getLocation().getStartLine() and
    line = doc.getLocation().getEndLine() and
    content = doc.getChild(0).getText().trim()
  )
}

predicate expectError(string filename, int line) {
  exists(string content |
    parsedExpectedResults(filename, line, content) and content.indexOf("NOT OK") = 0
  )
}

predicate expectPass(string filename, int line) {
  exists(string content |
    parsedExpectedResults(filename, line, content) and content.indexOf("OK") = 0
  )
}

predicate parsedActualResults(string filename, int line, int colStart, int colEnd, string content) {
  exists(string s, string posString, string lineString |
    s = actualLines() and
    posString = s.substring(s.indexOf("|", 0, 0) + 1, s.indexOf("|", 1, 0)).trim() and
    filename = posString.substring(0, posString.indexOf(":", 0, 0)) and
    lineString = posString.substring(posString.indexOf(":", 0, 0) + 1, posString.indexOf(":", 1, 0)) and
    lineString = posString.substring(posString.indexOf(":", 2, 0) + 1, posString.indexOf(":", 3, 0)) and
    colStart =
      posString.substring(posString.indexOf(":", 1, 0) + 1, posString.indexOf(":", 2, 0)).toInt() and
    colEnd = posString.substring(posString.indexOf(":", 3, 0) + 1, posString.length()).toInt() and
    line = lineString.toInt() and
    content = s.substring(s.indexOf("|", 2, 0) + 1, s.indexOf("|", 3, 0)).trim()
  )
}

predicate actualExpectedDiff(string type, string position, string error) {
  exists(string filename, int line, int colStart, int colEnd |
    parsedActualResults(filename, line, colStart, colEnd, error) and
    expectPass(filename, line) and
    type = "unexpected alert" and
    position = filename + ":" + line + ":" + colStart + ":" + line + ":" + colEnd
  )
  or
  exists(string filename, int line |
    expectError(filename, line) and
    not parsedActualResults(filename, line, _, _, _) and
    type = "expected alert" and
    position = filename + ":" + line and
    parsedExpectedResults(filename, line, error)
  )
  or
  exists(string filename, int line, string content |
    parsedExpectedResults(filename, line, content) and
    not expectPass(filename, line) and
    not expectError(filename, line) and
    type = "invalid inline expectation" and
    position = filename + ":" + line and
    error = content
  )
}

from int line, string position, int column, string content
where
  position = rank[line](string p | actualExpectedDiff(_, p, _) | p) and
  (
    column = 0 and content = position
    or
    column = 1 and actualExpectedDiff(content, position, _)
    or
    column = 2 and actualExpectedDiff(_, position, content)
  )
select "#select", line, column, content
