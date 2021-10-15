import javascript

Token getATokenAtLine(File file, int line) {
  result.getFile() = file and
  result.getLocation().getStartLine() = line
}

bindingset[line]
string getTokenStringAtLine(File file, int line) {
  result =
    concat(Token tok |
      tok = getATokenAtLine(file, line)
    |
      tok.toString().replaceAll(" ", "~") + " " order by tok.getLocation().getStartColumn()
    )
}

from File file, int line
where exists(CallExpr call | call.getFile() = file and call.getLocation().getStartLine() = line)
select file.getBaseName() + ":" + line, getTokenStringAtLine(file, line)
