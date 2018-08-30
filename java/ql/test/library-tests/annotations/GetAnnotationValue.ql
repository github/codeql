/**
 * @name GetAnnotationValue
 */
import default

from Annotatable a, string key
where a.fromSource()
select a, key, a.getAnAnnotation().getValue(key)
