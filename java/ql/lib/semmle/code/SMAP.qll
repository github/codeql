/**
 * Provides classes and predicates for working with SMAP files (see JSR-045).
 */

import java

/**
 * Holds if there exists a mapping between an SMAP input file and line
 * and a corresponding SMAP output file and line range.
 */
private predicate smap(File inputFile, int inLine, File outputFile, int outLineStart, int outLineEnd) {
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

/**
 * Holds if there exists a mapping between an SMAP input file and line
 * and a corresponding SMAP output file and line.
 */
pragma[nomagic]
private predicate smap(File inputFile, int inLine, File outputFile, int outLine) {
  exists(int outLineStart, int outLineEnd |
    smap(inputFile, inLine, outputFile, outLineStart, outLineEnd) and
    outLine in [outLineStart .. outLineEnd]
  )
}

/**
 * Holds if an SMAP input location (with path, line and column information)
 * has a corresponding SMAP output location (with path and line information).
 *
 * For example, an SMAP input location may be a location within a JSP file,
 * which may have a corresponding SMAP output location in generated Java code.
 */
predicate hasSmapLocationInfo(
  string inputPath, int isl, int isc, int iel, int iec, string outputPath, int osl, int oel
) {
  exists(File inputFile, File outputFile |
    inputPath = inputFile.getAbsolutePath() and
    outputPath = outputFile.getAbsolutePath() and
    locations_default(_, outputFile, osl, _, oel, _) and
    smap(inputFile, isl, outputFile, osl) and
    smap(inputFile, iel - 1, outputFile, oel) and
    isc = 1 and
    iec = 1
  )
}
