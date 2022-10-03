import java

query JavadocElement getAChild(JavadocParent javadocParent) { result = javadocParent.getAChild() }

from JavadocParent javadocParent
select javadocParent, javadocParent.getJavadoc()
