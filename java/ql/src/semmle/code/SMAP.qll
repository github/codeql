import java

predicate smap(File inputFile, int inLine, File outputFile, int outLineStart, int outLineEnd) {
  exists(
    string defaultStratum, int inputFileNum, int inStart, int inCount, int outStart, int outIncr,
    int n
  |
    smap_header(outputFile, _, defaultStratum) and
    smap_files(outputFile, defaultStratum, inputFileNum, _, inputFile) and
    smap_lines(outputFile, defaultStratum, inputFileNum, inStart, inCount, outStart, outIncr) and
    inLine in [inStart .. inStart + inCount - 1] and
    outLineStart = outStart + n * outIncr and
    outLineEnd = (n + 1) * outIncr - 1 + outStart and
    n = inLine - inStart
  )
}

predicate smap(File inputFile, int inLine, File outputFile, int outLine) {
  exists(int outLineStart, int outLineEnd |
    smap(inputFile, inLine, outputFile, outLineStart, outLineEnd) and
    outLine in [outLineStart .. outLineEnd]
  )
}

predicate hasSmapLocationInfo(
  string inputPath, int isl, int isc, int iel, int iec, string outputPath, int osl, int oel
) {
  exists(File inputFile, File outputFile |
    inputPath = inputFile.getAbsolutePath() and
    outputPath = outputFile.getAbsolutePath() and
    smap(inputFile, isl, outputFile, osl) and
    smap(inputFile, iel - 1, outputFile, oel) and
    isc = 1 and
    iec = 0
  )
}
