import java
import semmle.code.java.frameworks.JaxWS
import semmle.code.java.security.XSS
import TestUtilities.InlineExpectationsTest

class JaxRsTest extends InlineExpectationsTest {
  JaxRsTest() { this = "JaxRsTest" }

  override string getARelevantTag() {
    result =
      [
        "ResourceMethod", "RootResourceClass", "NonRootResourceClass",
        "ResourceMethodOnResourceClass", "InjectableConstructor", "InjectableField",
        "InjectionAnnotation", "ResponseDeclaration", "ResponseBuilderDeclaration",
        "ClientDeclaration", "BeanParamConstructor", "MessageBodyReaderDeclaration",
        "MessageBodyReaderReadFromCall", "MessageBodyReaderReadCall", "ProducesAnnotation",
        "ConsumesAnnotation"
      ]
  }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "ResourceMethod" and
    exists(JaxRsResourceMethod resourceMethod |
      resourceMethod.getLocation() = location and
      element = resourceMethod.toString() and
      if exists(resourceMethod.getProducesAnnotation())
      then
        value =
          getContentTypeString(resourceMethod.getProducesAnnotation().getADeclaredContentTypeExpr()) and
        value != ""
      else
        // Filter out empty strings that stem from using stubs.
        // If we built the test against the real JAR then the field
        // access against e.g. MediaType.APPLICATION_JSON wouldn't
        // be a CompileTimeConstantExpr at all, whereas in the stubs
        // it is and is defined empty.
        value = ""
    )
    or
    tag = "RootResourceClass" and
    exists(JaxRsResourceClass resourceClass |
      resourceClass.isRootResource() and
      resourceClass.getLocation() = location and
      element = resourceClass.toString() and
      value = ""
    )
    or
    tag = "NonRootResourceClass" and
    exists(JaxRsResourceClass resourceClass |
      not resourceClass.isRootResource() and
      resourceClass.getLocation() = location and
      element = resourceClass.toString() and
      value = ""
    )
    or
    tag = "ResourceMethodOnResourceClass" and
    exists(JaxRsResourceMethod resourceMethod |
      resourceMethod = any(JaxRsResourceClass resourceClass).getAResourceMethod()
    |
      resourceMethod.getLocation() = location and
      element = resourceMethod.toString() and
      value = ""
    )
    or
    tag = "InjectableConstructor" and
    exists(Constructor cons |
      cons = any(JaxRsResourceClass resourceClass).getAnInjectableConstructor()
    |
      cons.getLocation() = location and
      element = cons.toString() and
      value = ""
    )
    or
    tag = "InjectableField" and
    exists(Field field | field = any(JaxRsResourceClass resourceClass).getAnInjectableField() |
      field.getLocation() = location and
      element = field.toString() and
      value = ""
    )
    or
    tag = "InjectionAnnotation" and
    exists(JaxRsInjectionAnnotation injectionAnnotation |
      injectionAnnotation.getLocation() = location and
      element = injectionAnnotation.toString() and
      value = ""
    )
    or
    tag = "ResponseDeclaration" and
    exists(LocalVariableDecl decl |
      decl.getType() instanceof JaxRsResponse and
      decl.getLocation() = location and
      element = decl.toString() and
      value = ""
    )
    or
    tag = "ResponseBuilderDeclaration" and
    exists(LocalVariableDecl decl |
      decl.getType() instanceof JaxRsResponseBuilder and
      decl.getLocation() = location and
      element = decl.toString() and
      value = ""
    )
    or
    tag = "ClientDeclaration" and
    exists(LocalVariableDecl decl |
      decl.getType() instanceof JaxRsClient and
      decl.getLocation() = location and
      element = decl.toString() and
      value = ""
    )
    or
    tag = "BeanParamConstructor" and
    exists(JaxRsBeanParamConstructor cons |
      cons.getLocation() = location and
      element = cons.toString() and
      value = ""
    )
    or
    tag = "MessageBodyReaderDeclaration" and
    exists(LocalVariableDecl decl |
      decl.getType().(RefType).getSourceDeclaration() instanceof MessageBodyReader and
      decl.getLocation() = location and
      element = decl.toString() and
      value = ""
    )
    or
    tag = "MessageBodyReaderReadFromCall" and
    exists(MethodAccess ma |
      ma.getMethod() instanceof MessageBodyReaderReadFrom and
      ma.getLocation() = location and
      element = ma.toString() and
      value = ""
    )
    or
    tag = "MessageBodyReaderReadCall" and
    exists(MethodAccess ma |
      ma.getMethod() instanceof MessageBodyReaderRead and
      ma.getLocation() = location and
      element = ma.toString() and
      value = ""
    )
    or
    tag = "ProducesAnnotation" and
    exists(JaxRSProducesAnnotation producesAnnotation |
      producesAnnotation.getLocation() = location and
      element = producesAnnotation.toString() and
      value = getContentTypeString(producesAnnotation.getADeclaredContentTypeExpr()) and
      value != ""
      // Filter out empty strings that stem from using stubs.
      // If we built the test against the real JAR then the field
      // access against e.g. MediaType.APPLICATION_JSON wouldn't
      // be a CompileTimeConstantExpr at all, whereas in the stubs
      // it is and is defined empty.
    )
    or
    tag = "ConsumesAnnotation" and
    exists(JaxRSConsumesAnnotation consumesAnnotation |
      consumesAnnotation.getLocation() = location and
      element = consumesAnnotation.toString() and
      value = ""
    )
    or
    tag = "XssSink" and
    exists(XssSink xssSink |
      xssSink.getLocation() = location and
      element = xssSink.toString() and
      value = ""
    )
  }
}
