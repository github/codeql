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
