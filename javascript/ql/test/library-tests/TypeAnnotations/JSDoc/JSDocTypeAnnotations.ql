import javascript

query TypeAnnotation test_isString() { result.isString() }

query TypeAnnotation test_isNumber() { result.isNumber() }

query TypeAnnotation test_QualifiedName(string name) { result.hasQualifiedName(name) }

query TypeAnnotation test_ParameterType(Parameter p) { result = p.getTypeAnnotation() }

query TypeAnnotation test_VarType(VarDecl decl) { result = decl.getTypeAnnotation() }

query TypeAnnotation test_ReturnType(Function f) { result = f.getReturnTypeAnnotation() }
