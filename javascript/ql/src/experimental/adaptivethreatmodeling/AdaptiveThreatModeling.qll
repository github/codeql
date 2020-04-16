external private predicate adaptiveThreatModelingModels(
  string modelChecksum, string modelLanguage, string modelName, string modelType
);

private import javascript as raw
private import raw::DataFlow as DataFlow
import ATMConfig

module ATMEmbeddings {
  private import CodeToFeatures::DatabaseFeatures as DatabaseFeatures

  class Entity = DatabaseFeatures::Entity;

  /* Currently the only label is a label marking an embedding as derived from an entity in the current database. */
  private newtype TEmbeddingLabel = TEntityLabel(Entity entity)

  /**
   * An abstract label that can be used to mark an embedding with the object from which it has been
   * derived.
   */
  abstract class EmbeddingLabel extends TEmbeddingLabel {
    abstract string toString();
  }

  /**
   * A label marking an embedding as derived from an entity in the current database, i.e. the
   * database we're running the query on.
   */
  class EntityLabel extends EmbeddingLabel {
    private Entity entity;

    EntityLabel() { this = TEntityLabel(entity) }

    Entity getEntity() { result = entity }

    override string toString() { result = "EntityLabel(" + entity.toString() + ")" }
  }

  /**
   * `entities` relation suitable for passing to the `codeEmbedding` HOP.
   *
   * The `codeEmbedding` HOP expects an entities relation with eight columns, while
   * `DatabaseFeatures` generates one with nine columns.
   */
  predicate entities(
    Entity entity, string entityName, string entityType, string path, int startLine,
    int startColumn, int endLine, int endColumn
  ) {
    DatabaseFeatures::entities(entity, entityName, entityType, path, startLine, startColumn,
      endLine, endColumn, _)
  }

  private predicate databaseEmbeddingsByEntity(
    Entity entity, int embeddingIndex, float embeddingValue
  ) =
    codeEmbedding(entities/8, DatabaseFeatures::astNodes/5, DatabaseFeatures::nodeAttributes/2,
      modelChecksum/0)(entity, embeddingIndex, embeddingValue)

  /** Embeddings for each entity in the current database. */
  predicate databaseEmbeddings(EntityLabel label, int embeddingIndex, float embeddingValue) {
    exists(Entity entity |
      databaseEmbeddingsByEntity(entity, embeddingIndex, embeddingValue) and
      label.getEntity() = entity
    )
  }

  /** Checksum of the model that should be used. */
  string modelChecksum() { adaptiveThreatModelingModels(result, "javascript", _, _) }
}

private module ATMEmbeddingsDebugging {
  query predicate databaseEmbeddingsDebug = ATMEmbeddings::databaseEmbeddings/3;

  query predicate modelChecksumDebug = ATMEmbeddings::modelChecksum/0;
}

private ATMConfig getCfg() { any() }

/**
 * This module provides functionality that takes a sink and provides an entity that encloses that
 * sink and is suitable for similarity analysis.
 */
module SinkToEntity {
  private import CodeToFeatures

  private raw::Function getNamedEnclosingFunction(raw::Function f) {
    if not exists(f.getName())
    then result = getNamedEnclosingFunction(f.getEnclosingContainer())
    else result = f
  }

  private raw::Function nodeToNamedFunction(DataFlow::Node node) {
    result = getNamedEnclosingFunction(node.getContainer())
  }

  /**
   * We use the innermost named function that encloses a sink, if one exists.
   * Otherwise, we use the innermost function that encloses the sink.
   */
  private raw::Function sinkToFunction(DataFlow::Node sink) {
    if exists(raw::Function f | f = nodeToNamedFunction(sink))
    then result = nodeToNamedFunction(sink)
    else result = sink.getContainer()
  }

  private DatabaseFeatures::Entity getFirstExtractedEntity(raw::Function e) {
    if
      DatabaseFeatures::entities(result, _, _, _, _, _, _, _, _) and
      result.getDefinedFunction() = e
    then any()
    else result = getFirstExtractedEntity(e.getEnclosingContainer())
  }

  /** Get an entity enclosing the sink that is suitable for similarity analysis. */
  DatabaseFeatures::Entity getEntityForSink(DataFlow::Node sink) {
    result = getFirstExtractedEntity(sinkToFunction(sink))
  }
}

/**
 * This module provides functionality that takes an entity and provides sink candidates within
 * that entity.
 */
module EntityToSinkCandidate {
  private import CodeToFeatures

  /** Get a sink candidate enclosed within the specified entity. */
  DataFlow::Node getASinkCandidate(DatabaseFeatures::Entity entity) {
    getCfg().isEffectiveSink(result) and
    result.getContainer().getEnclosingContainer*() = entity.getDefinedFunction()
  }
}

// To debug the EntityToSinkCandidate module, import this module by adding
// "import EntityToSinkCandidateDebugging" to the top-level.
module EntityToSinkCandidateDebugging {
  private import CodeToFeatures

  query predicate databaseSinks(DataFlow::Node sink) {
    exists(DatabaseFeatures::Entity entity |
      DatabaseFeatures::entities(entity, _, _, _, _, _, _, _, _) and
      sink = EntityToSinkCandidate::getASinkCandidate(entity)
    )
  }
}

module ATM {
  import ATMEmbeddings

  private int getNumberOfSinkSemSearchResults() { result = 100000000 }

  private predicate sinkSemSearchResults(
    EmbeddingLabel searchLabel, EmbeddingLabel resultLabel, float score
  ) =
    semanticSearch(sinkQueryEmbeddings/3, databaseEmbeddings/3, getNumberOfSinkSemSearchResults/0)(searchLabel,
      resultLabel, score)

  /** `DataFlow::Configuration` for adaptive threat modeling (ATM). */
  class Configuration extends raw::TaintTracking::Configuration {
    Configuration() { this = "AdaptiveThreatModeling" }

    override predicate isSource(DataFlow::Node source) {
      // Is an existing source
      getCfg().isKnownSource(source)
    }

    override predicate isSource(DataFlow::Node source, DataFlow::FlowLabel lbl) {
      // Is an existing source
      getCfg().isKnownSource(source, lbl)
    }

    override predicate isSink(DataFlow::Node sink) {
      // Is in a result entity that is similar to a known sink-containing entity according to
      // semantic search
      exists(Entity resultEntity, EntityLabel resultLabel |
        sinkSemSearchResults(_, resultLabel, _) and
        sink = EntityToSinkCandidate::getASinkCandidate(resultEntity) and
        resultLabel.getEntity() = resultEntity
      )
      or
      // Is an existing sink
      getCfg().isKnownSource(sink)
    }

    override predicate isSink(DataFlow::Node sink, DataFlow::FlowLabel lbl) {
      // Is in a result entity that is similar to a known sink-containing entity according to
      // semantic search
      exists(DataFlow::Node originalSink, EntityLabel seedLabel, EntityLabel resultLabel |
        getCfg().isKnownSink(originalSink, lbl) and
        seedLabel.getEntity() = SinkToEntity::getEntityForSink(sink) and
        sinkSemSearchResults(seedLabel, resultLabel, _) and
        sink = EntityToSinkCandidate::getASinkCandidate(resultLabel.getEntity())
      )
      or
      // Is an existing sink
      getCfg().isKnownSink(sink, lbl)
    }

    override predicate isSanitizer(DataFlow::Node node) {
      super.isSanitizer(node) or
      getCfg().isSanitizer(node)
    }

    override predicate isSanitizerGuard(raw::TaintTracking::SanitizerGuardNode guard) {
      super.isSanitizerGuard(guard) or
      getCfg().isSanitizerGuard(guard)
    }

    override predicate isAdditionalTaintStep(DataFlow::Node src, DataFlow::Node trg) {
      getCfg().isAdditionalTaintStep(src, trg)
    }

    override predicate isAdditionalFlowStep(
      DataFlow::Node src, DataFlow::Node trg, DataFlow::FlowLabel inlbl, DataFlow::FlowLabel outlbl
    ) {
      getCfg().isAdditionalFlowStep(src, trg, inlbl, outlbl)
    }
  }

  private Entity getSeedSinkEntity() {
    exists(DataFlow::Node sink |
      (getCfg().isKnownSink(sink) or getCfg().isKnownSink(sink, _)) and
      result = SinkToEntity::getEntityForSink(sink)
    )
  }

  private predicate sinkQueryEmbeddings(
    EmbeddingLabel label, int embeddingIndex, float embeddingValue
  ) {
    label.(EntityLabel).getEntity() = getSeedSinkEntity() and
    databaseEmbeddings(label, embeddingIndex, embeddingValue)
  }

  /**
   * EXPERIMENTAL. This API may change in the future.
   *
   * This module contains informational predicates about the results returned by adaptive threat
   * modeling (ATM).
   */
  module ResultsInfo {
    /**
     * Holds if the node `source` is a source in the standard security query.
     */
    private predicate isSourceASeed(DataFlow::Node source) {
      getCfg().isKnownSource(source) or getCfg().isKnownSource(source, _)
    }

    /**
     * Holds if the node `sink` is a sink in the standard security query.
     */
    private predicate isSinkASeed(DataFlow::Node sink) {
      getCfg().isKnownSink(sink) or getCfg().isKnownSink(sink, _)
    }

    private float scoreForSink(DataFlow::Node sink) {
      if isSinkASeed(sink)
      then result = 1.0
      else
        result =
          max(float score |
            exists(ATMEmbeddings::EntityLabel entityLabel |
              sinkSemSearchResults(_, entityLabel, score) and
              sink = EntityToSinkCandidate::getASinkCandidate(entityLabel.getEntity())
            )
          )
    }

    /**
     * EXPERIMENTAL. This API may change in the future.
     *
     * Returns the score for the flow between the source `source` and the `sink` sink in the
     * boosted query.
     */
    float scoreForFlow(DataFlow::Node source, DataFlow::Node sink) { result = scoreForSink(sink) }

    /**
     * Pad a score returned from `scoreForFlow` to a particular length by adding a decimal point
     * if one does not already exist, and "0"s after that decimal point.
     *
     * Note that this predicate must itself define an upper bound on `length`, so that it has a
     * finite number of results. Currently this is defined as 12.
     */
    private string paddedScore(float score, int length) {
      // In this definition, we must restrict the values that `length` and `score` can take on so that the
      // predicate has a finite number of results.
      score = scoreForFlow(_, _) and
      length = result.length() and
      (
        // We need to make sure the padded score contains a "." so lexically sorting the padded scores is
        // equivalent to numerically sorting the scores.
        score.toString().charAt(_) = "." and
        result = score.toString()
        or
        not score.toString().charAt(_) = "." and
        result = score.toString() + "."
      )
      or
      result = paddedScore(score, length - 1) + "0" and
      length <= 12
    }

    /**
     * EXPERIMENTAL. This API may change in the future.
     *
     * Return a string representing the score of the flow between `source` and `sink` in the
     * boosted query.
     *
     * The returned string is a fixed length, such that lexically sorting the strings returned by
     * this predicate gives the same sort order as numerically sorting the scores of the flows.
     */
    string scoreStringForFlow(DataFlow::Node source, DataFlow::Node sink) {
      exists(float score |
        score = scoreForFlow(source, sink) and
        (
          // A length of 12 is equivalent to 10 decimal places.
          score.toString().length() >= 12 and
          result = score.toString().substring(0, 12)
          or
          score.toString().length() < 12 and
          result = paddedScore(score, 12)
        )
      )
    }

    private ATMEmbeddings::EmbeddingLabel bestSearchLabelsForSink(DataFlow::Node sink) {
      exists(ATMEmbeddings::EntityLabel resultLabel |
        sinkSemSearchResults(result, resultLabel, scoreForSink(sink)) and
        sink = EntityToSinkCandidate::getASinkCandidate(resultLabel.getEntity())
      )
    }

    private newtype TEndpointOrigins =
      TOrigins(boolean isKnown, boolean isSimilarToKnown) {
        isKnown = [true, false] and isSimilarToKnown = [true, false]
      }

    /**
     * EXPERIMENTAL. This API may change in the future.
     *
     * A class representing the origins of an endpoint.
     */
    class EndpointOrigins extends TEndpointOrigins {
      /**
       * EXPERIMENTAL. This API may change in the future.
       *
       * Whether the endpoint is a known endpoint in the database.
       */
      boolean isKnown;
      /**
       * EXPERIMENTAL. This API may change in the future.
       *
       * Whether the endpoint is a predicted endpoint that is near to a known endpoint in
       * the database.
       */
      boolean isSimilarToKnown;

      EndpointOrigins() { this = TOrigins(isKnown, isSimilarToKnown) }

      /**
       * EXPERIMENTAL. This API may change in the future.
       *
       * A string listing the origins of a predicted endpoint.
       *
       * Origins include:
       *
       * - `known`: The endpoint is a known endpoint in the database.
       * - `similar_to_known`: The endpoint is a predicted endpoint that is similar to a known
       * endpoint in the database.
       */
      string listOfOriginComponents() {
        // Ensure that this predicate has exactly one result.
        result =
          any(string x | if isKnown = true then x = "known" else x = "") +
            any(string x | if isKnown = true and isSimilarToKnown = true then x = "," else x = "") +
            any(string x | if isSimilarToKnown = true then x = "similar_to_known" else x = "")
      }

      string toString() { result = "EndpointOrigins(" + listOfOriginComponents() + ")" }
    }

    /**
     * EXPERIMENTAL. This API may change in the future.
     *
     * The highest-scoring origins of the source.
     */
    EndpointOrigins originsForSource(DataFlow::Node source) {
      result =
        TOrigins(any(boolean b | if isSourceASeed(source) then b = true else b = false), false)
    }

    /**
     * EXPERIMENTAL. This API may change in the future.
     *
     * The highest-scoring origins of the sink.
     */
    EndpointOrigins originsForSink(DataFlow::Node sink) {
      result =
        TOrigins(any(boolean b | if isSinkASeed(sink) then b = true else b = false),
          any(boolean b |
            if
              not isSinkASeed(sink) and
              exists(ATMEmbeddings::EntityLabel label | label = bestSearchLabelsForSink(sink))
            then b = true
            else b = false
          ))
    }

    /**
     * EXPERIMENTAL. This API may change in the future.
     *
     * Indicates whether the flow from source to sink is likely to be reported by the base security
     * query.
     *
     * Currently this is a heuristic: it ignores potential differences in the definitions of
     * additional flow steps.
     */
    predicate isFlowLikelyInBaseQuery(DataFlow::Node source, DataFlow::Node sink) {
      isSourceASeed(source) and isSinkASeed(sink)
    }
  }

  // To debug the ATM module, import this module by adding "import ATM::Debugging" to the top-level.
  module Debugging {
    query predicate sinkSemSearchResultsDebug = sinkSemSearchResults/3;

    query predicate atmSources(DataFlow::Node source) {
      any(ATM::Configuration cfg).isSource(source)
    }

    query predicate atmSinks(DataFlow::Node sink) { any(ATM::Configuration cfg).isSink(sink) }
  }
}
