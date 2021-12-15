function getLastLine(input) {
  var lines = [], nextLine;
  while ((nextLine = readNextLine(input)))
    lines.push(nextLine);
  if (!lines.length)
    throw new Error("No lines!");
  return lines[lines.length-1];
}