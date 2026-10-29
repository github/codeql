function nextToken(reader){
  var c = reader.read(), token = null;

  if (c) {
    switch(c) {
    case "/":
      if(reader.peek() == "*")
        token = commentToken(reader, c, startLine, startCol);
      else
        token = charToken(reader, c, startLine, startCol);
      break;
    case '"':
    case "'":
      token = stringToken(c, startLine, startCol);
      break;
    default:
      token = charToken(reader, c, startLine, startCol);
    }
  }

  return token;
}