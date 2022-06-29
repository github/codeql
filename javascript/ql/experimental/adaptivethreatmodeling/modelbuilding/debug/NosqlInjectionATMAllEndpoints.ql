import experimental.adaptivethreatmodeling.FeaturizationConfig
import experimental.adaptivethreatmodeling.NosqlInjectionATM
import experimental.adaptivethreatmodeling.EndpointFeatures
import experimental.adaptivethreatmodeling.EndpointScoring
private import javascript
private import semmle.javascript.filters.ClassifyFiles as ClassifyFiles

/** Holds if the file should be excluded from end-to-end evaluation. */
predicate isFileExcluded(File file) {
  // Ignore files that are outside the root folder of the analyzed source location.
  //
  // If the file doesn't have a relative path, then the source file is located outside the root
  // folder of the analyzed source location, meaning that the files are additional files added to
  // the database like standard library files that we would like to ignore.
  not exists(file.getRelativePath())
  or
  // Ignore files based on their path.
  exists(string ignorePattern, string separator |
    ignorePattern =
      // Exclude test files
      "(tests?|test[_-]?case|" +
        // Exclude library files
        //
        // - The Bower and npm package managers store packages in bower_components and node_modules
        // folders respectively.
        // - Specific exclusion for end-to-end: `applications/examples/static/epydoc` contains
        //   library code from Epydoc.
        "3rd[_-]?party|bower_components|extern(s|al)?|node_modules|resources|third[_-]?party|_?vendor|"
        + "applications" + separator + "examples" + separator + "static" + separator + "epydoc|" +
        // Exclude generated code
        "gen|\\.?generated|" +
        // Exclude benchmarks
        "benchmarks?|" +
        // Exclude documentation
        "docs?|documentation)" and
    separator = "(\\/|\\.)" and
    exists(
      file.getRelativePath()
          .toLowerCase()
          .regexpFind(separator + ignorePattern + separator + "|" + "^" + ignorePattern + separator +
              "|" + separator + ignorePattern + "$", _, _)
    )
  )
  or
  // Ignore externs, generated, library, and test files.
  ClassifyFiles::classify(file, ["externs", "generated", "library", "test"])
}

class FunctionArgumentFeaturizationConfig extends FeaturizationConfig {
  FunctionArgumentFeaturizationConfig() { this = "FunctionArgumentFeaturization" }

  override DataFlow::Node getAnEndpointToFeaturize() {
    exists(DataFlow::CallNode call | result = call.getAnArgument())
  }
}

from
  DataFlow::Node sink, float score, int type, string filePathSink, int startLineSink,
  int endLineSink, int startColumnSink, int endColumnSink
where
  ModelScoring::endpointScores(sink, type, score) and
  not isFileExcluded(sink.getFile()) and
  sink.hasLocationInfo(filePathSink, startLineSink, startColumnSink, endLineSink, endColumnSink) and
  type = 2
select sink, startLineSink, startColumnSink, endLineSink, endColumnSink, filePathSink, type, score
  order by score desc
