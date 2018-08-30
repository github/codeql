/**
 * @name GetLibraryAnnotationElement
 */
import default

from Class cl, Annotation ann, AnnotationType anntp, AnnotationElement anne
where cl.fromSource() and
      ann = cl.getAnAnnotation() and
      anntp = ann.getType() and
      anne = anntp.getAnAnnotationElement()
select cl, ann, anntp.getQualifiedName(), anne.getName()
