import semmle.code.java.JDKAnnotations

from SuppressWarningsAnnotation swa
select swa, swa.getASuppressedWarning()
