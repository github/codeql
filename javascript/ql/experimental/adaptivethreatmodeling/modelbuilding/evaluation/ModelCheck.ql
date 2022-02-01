/**
 * ModelCheck.ql
 *
 * Returns checksums of ATM models.
 */

/**
 * The `availableMlModels` template predicate.
 *
 * This is populated by the evaluator with metadata for the available machine learning models.
 */
external predicate availableMlModels(
  string modelChecksum, string modelLanguage, string modelName, string modelType
);

select any(string checksum | availableMlModels(checksum, "javascript", _, _))
