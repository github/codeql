/**
 * A string that's deliberately mispelled (and so is that last word).
 */ // $ Alert
class PublicallyAccessible extends string { // $ Alert
  int numOccurences; // $ Alert // should be 'occurrences'

  PublicallyAccessible() { this = "publically" and numOccurences = 123 }

  // should be argument
  predicate hasAgrument() { none() } // $ Alert

  int getNum() { result = numOccurences }
}

/**
 * A class whose name contains a British-English spelling.
 * And here's the word 'colour'.
 */ // $ Alert
class AnalysedInt extends int { // $ Alert
  AnalysedInt() { this = 7 }

  // 'analyses' should not be flagged
  int numAnalyses() { result = 1 }
}
