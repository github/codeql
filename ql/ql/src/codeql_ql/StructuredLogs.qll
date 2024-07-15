private import ql
private import codeql_ql.ast.internal.TreeSitter
private import experimental.RA

/** Gets a timestamp corresponding to the number of seconds since the date Semmle was founded. */
bindingset[d, h, m, s, ms]
private float getTimestamp(date d, int h, int m, int s, int ms) {
  result = (("2006-12-28".toDate().daysTo(d) * 24 + h) * 60 + m) * 60 + s + ms / 1000.0
}

bindingset[str]
private float stringToTimestamp(string str) {
  exists(string r, date d, int h, int m, int s, int ms |
    r = "(\\d{4}-\\d{2}-\\d{2})T(\\d{2}):(\\d{2}):(\\d{2})\\.(\\d{3})Z"
  |
    d = str.regexpCapture(r, 1).toDate() and
    h = str.regexpCapture(r, 2).toInt() and
    m = str.regexpCapture(r, 3).toInt() and
    s = str.regexpCapture(r, 4).toInt() and
    ms = str.regexpCapture(r, 5).toInt() and
    result = getTimestamp(d, h, m, s, ms)
  )
}

bindingset[s]
private Predicate getPredicateFromPosition(string s) {
  exists(string r, string filepath, int startline | r = "(.*):(\\d+),(\\d+)-(\\d+),(\\d+)" |
    filepath = s.regexpCapture(r, 1) and
    startline = s.regexpCapture(r, 2).toInt() and
    result.hasLocationInfo(filepath, startline, _, _, _)
  )
}

pragma[nomagic]
private string getJsonStringComponent(JSON::String s, int i) {
  result = s.getChild(i).(JSON::Token).getValue()
}

pragma[nomagic]
private string getJsonString(JSON::String s) {
  result = concat(string c, int i | c = getJsonStringComponent(s, i) | c order by i)
}

class Object extends JSON::Object {
  JSON::UnderscoreValue getValue(string key) {
    exists(JSON::Pair p | p = this.getChild(_) |
      key = getJsonString(p.getKey()) and
      result = p.getValue()
    )
  }

  string getString(string key) { result = getJsonString(this.getValue(key)) }

  int getNumber(string key) { result = this.getValue(key).(JSON::Number).getValue().toInt() }

  float getFloat(string key) { result = this.getValue(key).(JSON::Number).getValue().toFloat() }

  Array getArray(string key) { result = this.getValue(key) }

  Object getObject(string key) { result = this.getValue(key) }

  string getType() { result = this.getString("type") }

  int getEventId() { result = this.getNumber("event_id") }

  string getTime() { result = this.getString("time") }

  float getTimestamp() { result = stringToTimestamp(this.getTime()) }
}

class Array extends JSON::Array {
  Object getObject(int i) { result = this.getChild(i) }

  string getString(int i) { result = getJsonString(this.getChild(i)) }

  int getNumber(int i) { result = this.getChild(i).(JSON::Number).getValue().toInt() }

  float getFloat(int i) { result = this.getChild(i).(JSON::Number).getValue().toFloat() }

  Array getArray(int i) { result = this.getChild(i) }

  int getLength() { result = count(this.getChild(_)) }
}

/**
 * Gets the i'th non-negative number in `a`.
 *
 * This is needed because the evaluator log is padded with -1s in some cases.
 */
pragma[nomagic]
private float getRankedFloat(Array a, int i) {
  result = rank[i + 1](int j, float f | f = a.getFloat(j) and f >= 0 | f order by j)
}

private string getRankedLine(Array a, int i) {
  result = rank[i + 1](int j, string s | s = a.getString(j) and s != "" | s order by j)
}

module EvaluatorLog {
  class Entry extends Object { }

  class LogHeader extends Entry {
    LogHeader() { this.getType() = "LOG_HEADER" }

    string getCodeQLVersion() { result = this.getString("codeqlVersion") }

    string getLogVersion() { result = this.getString("logVersion") }
  }

  class QueryStarted extends Entry {
    QueryStarted() { this.getType() = "QUERY_STARTED" }

    string getQueryName() { result = this.getString("queryName") }

    int getStage(int i) { result = this.getArray("stage").getNumber(i) }
  }

  class PredicateStarted extends Entry {
    PredicateStarted() { this.getType() = "PREDICATE_STARTED" }

    string getPredicateName() { result = this.getString("predicateName") }

    string getPosition() { result = this.getString("position") }

    string getPredicateType() { result = this.getString("predicateType") }

    int getQueryCausingWork() { result = this.getNumber("queryCausingWork") }

    string getRAHash() { result = this.getString("raHash") }

    Object getRA() { result = this.getValue("ra") }

    string getDependency(string key) { result = this.getObject("dependencies").getString(key) }
  }

  class PipelineStarted extends Entry {
    PipelineStarted() { this.getType() = "PIPELINE_STARTED" }

    int getPredicateStartEvent() { result = this.getNumber("predicateStartEvent") }

    string getRAReference() { result = this.getString("raReference") }
  }

  class PipelineCompleted extends Entry {
    PipelineCompleted() { this.getType() = "PIPELINE_COMPLETED" }

    int getStartEvent() { result = this.getNumber("startEvent") }

    string getRAReference() { result = this.getString("raReference") }

    float getCount(int i) { result = getRankedFloat(this.getArray("counts"), i) }

    float getDuplicationPercentage(int i) {
      result = getRankedFloat(this.getArray("duplicationPercentages"), i)
    }

    float getResultSize() { result = this.getFloat("resultSize") }
  }

  class PredicateCompleted extends Entry {
    PredicateCompleted() { this.getType() = "PREDICATE_COMPLETED" }

    int getStartEvent() { result = this.getNumber("startEvent") }

    float getResultSize() { result = this.getFloat("resultSize") }
  }

  class QueryCompleted extends Entry {
    QueryCompleted() { this.getType() = "QUERY_COMPLETED" }

    int getStartEvent() { result = this.getNumber("startEvent") }

    string getTerminationType() { result = this.getString("terminationType") }
  }

  class LogFooter extends Entry {
    LogFooter() { this.getType() = "LOG_FOOTER" }
  }

  class CacheLookup extends Entry {
    CacheLookup() { this.getType() = "CACHE_LOOKUP" }

    float getRelationSize() { result = this.getFloat("relationSize") }
  }

  class SentinelEmpty extends Entry {
    SentinelEmpty() { this.getType() = "SENTINEL_EMPTY" }
  }
}

module KindPredicatesLog {
  class SummaryHeader extends Object {
    SummaryHeader() { exists(this.getString("summaryLogVersion")) }

    string getSummaryLogVersion() { result = this.getString("summaryLogVersion") }

    string getCodeqlVersion() { result = this.getString("codeqlVersion") }

    private string getStartTimeString() { result = this.getString("startTime") }

    predicate hasStartTime(
      int year, string month, int day, int hours, int minute, int second, int millisecond
    ) {
      exists(string s, string r |
        s = this.getStartTimeString() and
        r = "(\\d{4})-(\\d{2})-(\\d{2})T(\\d{2}):(\\d{2}):(\\d{2})\\.(\\d{3})Z"
      |
        year = s.regexpCapture(r, 1).toInt() and
        month = s.regexpCapture(r, 2) and
        day = s.regexpCapture(r, 3).toInt() and
        hours = s.regexpCapture(r, 4).toInt() and
        minute = s.regexpCapture(r, 5).toInt() and
        second = s.regexpCapture(r, 6).toInt() and
        millisecond = s.regexpCapture(r, 7).toInt()
      )
    }
  }

  class AppearsAs extends Object {
    SummaryEvent event;

    AppearsAs() { event.getObject("appearsAs") = this }

    SummaryEvent getSummaryEvent() { result = event }

    PredicateName getAPredicateName() { result.getAppearsAs() = this }
  }

  class PredicateName extends Object {
    AppearsAs appearsAs;

    PredicateName() { pragma[only_bind_out](appearsAs.getObject(_)) = this }

    AppearsAs getAppearsAs() { result = appearsAs }

    Query getAQuery() { result.getPredicateName() = this }
  }

  class Query extends Array {
    PredicateName predicateName;

    Query() { this = predicateName.getArray(_) }

    PredicateName getPredicateName() { result = predicateName }
  }

  class SummaryEvent extends Object {
    string evaluationStrategy;

    SummaryEvent() { evaluationStrategy = this.getString("evaluationStrategy") }

    string getEvaluationStrategy() { result = evaluationStrategy }

    string getRAHash() { result = this.getString("raHash") }

    string getPredicateName() { result = this.getString("predicateName") }

    string getCompletionTimeString() { result = this.getString("completionTime") }

    AppearsAs getAppearsAs() { result = this.getObject("appearsAs") }

    int getMillis() { result = this.getNumber("millis") }

    PipeLineRuns getPipelineRuns() { result = this.getArray("pipelineRuns") }

    pragma[nomagic]
    float getDeltaSize(int i) { result = getRankedFloat(this.getArray("deltaSizes"), i) }

    predicate hasCompletionTime(
      int year, string month, int day, int hours, int minute, int second, int millisecond
    ) {
      exists(string s, string r |
        s = this.getCompletionTimeString() and
        r = "(\\d{4})-(\\d{2})-(\\d{2})T(\\d{2}):(\\d{2}):(\\d{2})\\.(\\d{3})Z"
      |
        year = s.regexpCapture(r, 1).toInt() and
        month = s.regexpCapture(r, 2) and
        day = s.regexpCapture(r, 3).toInt() and
        hours = s.regexpCapture(r, 4).toInt() and
        minute = s.regexpCapture(r, 5).toInt() and
        second = s.regexpCapture(r, 6).toInt() and
        millisecond = s.regexpCapture(r, 7).toInt()
      )
    }

    float getCompletionTime() { result = stringToTimestamp(this.getCompletionTimeString()) }

    float getResultSize() { result = this.getFloat("resultSize") }

    string getAnOrdering() { exists(this.getRA().getPipeLine(result)) }

    override string toString() {
      if exists(this.getPredicateName())
      then result = this.getPredicateName()
      else result = "<Summary event>"
    }

    RA getRA() { result = this.getObject("ra") }
  }

  class PipeLine extends Array {
    RA ra;
    string raReference;

    RA getRA() { result = ra }

    string getRAReference() { result = raReference }

    PipeLine() { this = ra.getArray(raReference) }

    string getLineOfRA(int n) { result = getRankedLine(this, n) }

    RAExpr getExpr(int n) { result.getPredicate() = this and result.getLine() = n }
  }

  class RA extends Object {
    SummaryEvent evt;

    SummaryEvent getEvent() { result = evt }

    RA() { evt.getObject("ra") = this }

    PipeLine getPipeLine(string name) { result = this.getArray(name) }

    PipeLine getPipeLine() { result = this.getPipeLine("pipeline") }
  }

  class SentinelEmpty extends SummaryEvent {
    SentinelEmpty() { evaluationStrategy = "SENTINEL_EMPTY" }
  }

  class PipeLineRun extends Object {
    PipeLineRuns runs;

    PipeLineRun() { runs.getObject(_) = this }

    PipeLineRuns getArray() { result = runs }

    string getRAReference() { result = this.getString("raReference") }

    PipeLine getPipeLine() {
      exists(SummaryEvent evt | runs.getEvent() = evt |
        result = evt.getRA().getPipeLine(pragma[only_bind_into](this.getRAReference()))
      )
    }

    float getCount(int i, string raLine) {
      result = this.getCount(i) and
      raLine = this.getPipeLine().getLineOfRA(pragma[only_bind_into](i))
    }

    float getCountAndExpr(int i, RAExpr raExpr) {
      result = this.getCount(i) and
      raExpr.getPredicate() = this.getPipeLine() and
      raExpr.getLine() = i
    }

    Array getCounts() { result = this.getArray("counts") }

    float getCount(int i) { result = getRankedFloat(this.getArray("counts"), i) }

    Array getDuplicationPercentage() { result = this.getArray("duplicationPercentages") }

    float getDuplicationPercentage(int i) {
      result = getRankedFloat(this.getArray("duplicationPercentages"), i)
    }
  }

  class PipeLineRuns extends Array {
    SummaryEvent event;

    PipeLineRuns() { event.getArray("pipelineRuns") = this }

    SummaryEvent getEvent() { result = event }

    PipeLineRun getRun(int i) { result = this.getObject(i) }
  }

  class Depencencies extends Object {
    SummaryEvent event;

    Depencencies() { event.getObject("dependencies") = this }

    SummaryEvent getEvent() { result = event }

    predicate hasEntry(string name, string hash) { this.getString(name) = hash }

    SummaryEvent getADependency() { this.getString(_) = result.getRAHash() }
  }

  class ComputeSimple extends SummaryEvent {
    ComputeSimple() { evaluationStrategy = "COMPUTE_SIMPLE" }

    Depencencies getDependencies() { result = this.getObject("dependencies") }

    PipeLineRun getPipelineRun() { result.getArray() = this.getArray("pipelineRuns") }

    string getPosition() { result = this.getString("position") }

    Predicate getPredicate() { result = getPredicateFromPosition(this.getPosition()) }

    /**
     * Gets the RA for this event. Unlike recursive predicates, a COMPUTE_SIMPLE
     * event only has one pipeline ordering (and it's named "pipeline").
     */
    PipeLine getPipeLine() { result = this.getObject("ra").getArray("pipeline") }
  }

  /** Gets the `index`'th event that's evaluated by `recursive`. */
  private SummaryEvent layerEventRank(ComputeRecursive recursive, int index) {
    result =
      rank[index + 1](SummaryEvent cand, int startline, string filepath |
        (
          cand = recursive
          or
          cand.(InLayer).getComputeRecursiveEvent() = recursive
        ) and
        cand.getLocation().hasLocationInfo(filepath, startline, _, _, _)
      |
        cand order by filepath, startline
      )
  }

  /**
   * Gets the first predicate that's evaluated in an iteration
   * of the SCC computation rooted at `recursive`.
   */
  SummaryEvent firstPredicate(ComputeRecursive recursive) { result = layerEventRank(recursive, 0) }

  /**
   * Gets the last predicate that's evaluated in an iteration
   * of the SCC computation rooted at `recursive`.
   */
  SummaryEvent lastPredicate(ComputeRecursive recursive) {
    exists(int n |
      result = layerEventRank(recursive, n) and
      not exists(layerEventRank(recursive, n + 1))
    )
  }

  /**
   * Holds if the predicate represented by `next` was evaluated after the
   * predicate represented by `prev` in the SCC computation rooted at `recursive`.
   */
  predicate successor(ComputeRecursive recursive, SummaryEvent prev, InLayer next) {
    exists(int index |
      layerEventRank(recursive, index) = prev and
      layerEventRank(recursive, index + 1) = next
    )
  }

  bindingset[this]
  signature class ResultSig;

  /**
   * A signature for generically traversing a SCC computation.
   */
  signature module Fold<ResultSig R> {
    /**
     * Gets the base case for the fold. That is, the initial value that
     * is produced from the first evaluation of the first IN_LAYER event
     * in the recursive evaluation.
     */
    bindingset[run]
    R base(PipeLineRun run);

    /**
     * Gets the recursive case for the fold. That is, `r` is the accumulation
     * of the previous evaluations, and `run` is the pipeline of the next IN_LAYER
     * event that is evaluated.
     */
    bindingset[run, r]
    R fold(PipeLineRun run, R r);
  }

  module Iterate<ResultSig R, Fold<R> F> {
    private R iterate(ComputeRecursive recursive, int iteration, InLayer pred) {
      // Case: The first iteration
      iteration = 0 and
      (
        // Subcase: The first predicate in the first iteration
        pred = firstPredicate(recursive) and
        result = F::base(pred.getPipelineRuns().getRun(0))
        or
        // Subcase: The predicate has a predecessor
        exists(InLayer pred0, R r |
          successor(recursive, pred0, pred) and
          r = iterate(recursive, 0, pred0) and
          result = F::fold(pred.getPipelineRuns().getRun(0), r)
        )
      )
      or
      // Case: Not the first iteration
      iteration > 0 and
      (
        // Subcase: The first predicate in the iteration
        pred = firstPredicate(recursive) and
        exists(InLayer last, R r |
          last = lastPredicate(recursive) and
          r = iterate(recursive, iteration - 1, last) and
          result = F::fold(pred.getPipelineRuns().getRun(iteration), r)
        )
        or
        // Subcase: The predicate has a predecessor in the same iteration
        exists(InLayer pred0, R r |
          successor(recursive, pred0, pred) and
          r = iterate(recursive, iteration, pred0) and
          result = F::fold(pred.getPipelineRuns().getRun(iteration), r)
        )
      )
    }

    R iterate(ComputeRecursive recursive) {
      exists(int iteration, InLayer pred |
        pred = lastPredicate(recursive) and
        result = iterate(recursive, iteration, pred) and
        not exists(iterate(recursive, iteration + 1, pred))
      )
    }
  }

  class ComputeRecursive extends SummaryEvent {
    ComputeRecursive() { evaluationStrategy = "COMPUTE_RECURSIVE" }

    Depencencies getDependencies() { result = this.getObject("dependencies") }
  }

  class InLayer extends SummaryEvent {
    InLayer() { evaluationStrategy = "IN_LAYER" }

    string getMainHash() { result = this.getString("mainHash") }

    ComputeRecursive getComputeRecursiveEvent() { result.getRAHash() = this.getMainHash() }

    Array getPredicateIterationMillis() { result = this.getArray("predicateIterationMillis") }

    float getPredicateIterationMillis(int i) {
      result = getRankedFloat(this.getArray("predicateIterationMillis"), i)
    }
  }

  class ComputedExtensional extends SummaryEvent {
    ComputedExtensional() { evaluationStrategy = "COMPUTED_EXTENSIONAL" }
  }

  class Extensional extends SummaryEvent {
    Extensional() { evaluationStrategy = "EXTENSIONAL" }
  }

  class RAExpr = RAParser<PipeLine>::RAExpr;
}
