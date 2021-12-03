/**
 * @name Typed expressions
 * @description The number of expressions for which the TypeScript extractor could
 *              extract a type other than 'any'.
 * @kind metric
 * @metricType project
 * @metricAggregate sum
 * @tags meta
 * @id js/meta/typed-expressions
 */

import javascript
import meta.MetaMetrics

predicate isProperType(Type t) { not t instanceof AnyType }

select projectRoot(), count(Expr e | isProperType(e.getType()))
