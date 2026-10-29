import java

class RelevantAnnotation extends Annotation {
  RelevantAnnotation() {
    this.getCompilationUnit().hasName("AnnotationValues") and this.getCompilationUnit().fromSource()
  }
}

query Expr value(RelevantAnnotation a, string name) { result = a.getValue(name) }

query EnumConstant enumConstantValue(RelevantAnnotation a, string name) {
  result = a.getEnumConstantValue(name)
}

query string stringValue(RelevantAnnotation a, string name) { result = a.getStringValue(name) }

query int intValue(RelevantAnnotation a, string name) { result = a.getIntValue(name) }

query boolean booleanValue(RelevantAnnotation a, string name) { result = a.getBooleanValue(name) }

query Type typeValue(RelevantAnnotation a, string name) { result = a.getTypeValue(name) }

query Expr arrayValue(RelevantAnnotation a, string name, int index) {
  result = a.getArrayValue(name, index)
}

query EnumConstant enumConstantArrayValue(RelevantAnnotation a, string name) {
  result = a.getAnEnumConstantArrayValue(name)
}

query string stringArrayValue(RelevantAnnotation a, string name) {
  result = a.getAStringArrayValue(name)
}

query int intArrayValue(RelevantAnnotation a, string name) { result = a.getAnIntArrayValue(name) }

query Type typeArrayValue(RelevantAnnotation a, string name) { result = a.getATypeArrayValue(name) }
