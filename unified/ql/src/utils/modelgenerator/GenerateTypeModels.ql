/**
 * @name Generate type models
 * @description Generates `typeModel` and `summaryModel` rows (of kind `type`) from `.swiftinterface`
 *              files, describing how to obtain instances of the types used by existing models.
 * @kind table
 * @id unified/utils/modelgenerator/generate-type-models
 * @tags modelgenerator
 */

private import codeql.unified.internal.mad.TypeModelGenerator as TypeModelGenerator

query predicate typeModel = TypeModelGenerator::typeModel/3;

query predicate summaryModel = TypeModelGenerator::summaryModel/5;
