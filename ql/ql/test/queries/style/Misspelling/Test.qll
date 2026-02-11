/**
 * A string that's deliberately mispelled (and so is that last word).
 */
class PublicallyAccessible extends string {
  int numOccurences; // should be 'occurrences'

  PublicallyAccessible() { this = "publically" and numOccurences = 123 }

  // should be argument
  predicate hasAgrument() { none() }

  int getNum() { result = numOccurences }
}

/**
 * A class whose name contains a British-English spelling.
 * And here's the word 'colour'.
 */
class AnalysedInt extends int {
  AnalysedInt() { this = 7 }

  // 'analyses' should not be flagged
  int numAnalyses() { result = 1 }
}
