/**
 * Provides the `ReportStats` module for reporting database quality statistics.
 */
overlay[local?]
module;

signature module StatsSig {
  int getNumberOfOk();

  int getNumberOfNotOk();

  string getOkText();

  string getNotOkText();
}

module ReportStats<StatsSig Stats> {
  predicate numberOfOk(string key, int value) {
    value = Stats::getNumberOfOk() and
    key = "Number of " + Stats::getOkText()
  }

  predicate numberOfNotOk(string key, int value) {
    value = Stats::getNumberOfNotOk() and
    key = "Number of " + Stats::getNotOkText()
  }

  predicate percentageOfOk(string key, float value) {
    value = Stats::getNumberOfOk() * 100.0 / (Stats::getNumberOfOk() + Stats::getNumberOfNotOk()) and
    key = "Percentage of " + Stats::getOkText()
  }

  predicate keyValuePair(string key, float value) {
    numberOfOk(key, value) or
    numberOfNotOk(key, value) or
    percentageOfOk(key, value)
  }
}

/**
 * Stats where each Ok/NotOk occurrence has an associated entity.
 */
signature module EntityStatsSig {
  class Candidate {
    predicate isOk();
  }

  string getOkText();

  string getNotOkText();
}

module EntityReportStats<EntityStatsSig Input> {
  private import Input

  private module StatsInput implements StatsSig {
    int getNumberOfOk() { result = count(Candidate c | c.isOk()) }

    int getNumberOfNotOk() { result = count(Candidate c | not c.isOk()) }

    import Input
  }

  import StatsInput

  private module ScalarReport = ReportStats<StatsInput>;

  import ScalarReport
}
