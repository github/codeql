import semmle.code.java.frameworks.j2objc.J2ObjC

from OCNIComment ocni
select ocni.getFile().getStem(), ocni.getLocation().getStartLine(),
  ocni.getLocation().getStartColumn(), ocni.getLocation().getEndLine(),
  ocni.getLocation().getEndColumn(), ocni.toString(), ocni.getAQlClass()
