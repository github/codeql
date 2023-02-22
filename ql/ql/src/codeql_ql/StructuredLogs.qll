private import ql
private import codeql_ql.ast.internal.TreeSitter

class Object extends JSON::Object {
  JSON::Value getValue(string key) {
    exists(JSON::Pair p | p = this.getChild(_) |
      key = p.getKey().(JSON::String).getChild().getValue() and
      result = p.getValue()
    )
  }

  string getString(string key) { result = this.getValue(key).(JSON::String).getChild().getValue() }

  int getNumber(string key) { result = this.getValue(key).(JSON::Number).getValue().toInt() }

  Array getArray(string key) { result = this.getValue(key) }

  Object getObject(string key) { result = this.getValue(key) }

  string getType() { result = this.getString("type") }

  int getEventId() { result = this.getNumber("event_id") }

  string getTime() { result = this.getString("time") }
}

class Array extends JSON::Array {
  Object getObject(int i) { result = this.getChild(i) }

  string getString(int i) { result = this.getChild(i).(JSON::String).getChild().getValue() }

  int getNumber(int i) { result = this.getChild(i).(JSON::Number).getValue().toInt() }

  Array getArray(int i) { result = this.getChild(i) }
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

    int getCount(int i) { result = this.getArray("counts").getNumber(i) }

    int getDuplicationPercentage(int i) {
      result = this.getArray("duplicationPercentages").getNumber(i)
    }

    int getResultSize() { result = this.getNumber("resultSize") }
  }

  class PredicateCompleted extends Entry {
    PredicateCompleted() { this.getType() = "PREDICATE_COMPLETED" }

    int getStartEvent() { result = this.getNumber("startEvent") }

    int getResultSize() { result = this.getNumber("resultSize") }
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

    int getRelationSize() { result = this.getNumber("relationSize") }
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

    string getRaHash() { result = this.getString("raHash") }

    string getPredicateName() { result = this.getString("predicateName") }

    string getCompletionTimeString() { result = this.getString("completionTime") }

    AppearsAs getAppearsAs() { result = this.getObject("appearsAs") }

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

    int getResultSize() { result = this.getNumber("resultSize") }
  }

  class SentinelEmpty extends SummaryEvent {
    SentinelEmpty() { evaluationStrategy = "SENTINEL_EMPTY" }
  }

  class PipeLineRun extends Object {
    PipeLineRuns runs;
    int index;

    PipeLineRun() { runs.getObject(index) = this }

    PipeLineRuns getArray() { result = runs }

    string getRaReference() { result = this.getString("raReference") }

    Array getCounts() { result = this.getArray("counts") }

    Array getDuplicationPercentages() { result = this.getArray("duplicationPercentages") }
  }

  class PipeLineRuns extends Array {
    SummaryEvent event;

    PipeLineRuns() { event.getArray("pipelineRuns") = this }

    SummaryEvent getEvent() { result = event }

    PipeLineRun getRun(int i) { result = this.getObject(i) }
  }

  class ComputeSimple extends SummaryEvent {
    ComputeSimple() { evaluationStrategy = "COMPUTE_SIMPLE" }

    PipeLineRun getPipelineRun() { result.getArray() = this.getArray("pipelineRuns") }
  }

  class ComputeRecursive extends SummaryEvent {
    ComputeRecursive() { evaluationStrategy = "COMPUTE_RECURSIVE" }
  }

  class InLayer extends SummaryEvent {
    InLayer() { evaluationStrategy = "IN_LAYER" }
  }

  class ComputedExtensional extends SummaryEvent {
    ComputedExtensional() { evaluationStrategy = "COMPUTED_EXTENSIONAL" }
  }

  class Extensional extends SummaryEvent {
    Extensional() { evaluationStrategy = "EXTENSIONAL" }
  }
}

// Stuff to test whether we've covered all event types
private File logFile() { result = any(EvaluatorLog::LogHeader h).getLocation().getFile() }

private Object missing() {
  result =
    any(Object o |
      o.getLocation().getFile() = logFile() and
      not o instanceof EvaluatorLog::Entry and
      not exists(o.getParent().getParent()) // don't count nested objects
    )
}
