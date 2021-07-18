/**
 * This library models Apache FreeMarker template engine
 */

import java
import semmle.code.java.dataflow.DataFlow2
import semmle.code.java.dataflow.DataFlow3

module Freemarker {
  class FreemarkerConfiguration extends RefType {
    FreemarkerConfiguration() { this.hasQualifiedName("freemarker.core", "Configurable") }
  }

  class TemplateClassResolver extends RefType {
    TemplateClassResolver() { this.hasQualifiedName("freemarker.core", "TemplateClassResolver") }
  }

  class FreemarkerTemplate extends RefType {
    FreemarkerTemplate() { this.hasQualifiedName("freemarker.template", "Template") }
  }

  // https://github.com/sanluan/PublicCMS/blob/d617de930d78e5ca17357614c1209ce410eae403/publiccms-parent/publiccms-core/src/main/java/com/publiccms/logic/component/site/DirectiveComponent.java
  // https://github.com/Rekoe/Rk_Cms/blob/999854b156e4d7c8627095066e8f80f053645528/src/main/java/com/rekoe/service/FileService.java
  class FreeMarkerConfigurer extends RefType {
    FreeMarkerConfigurer() {
      exists(string package |
        this.hasQualifiedName(package, "FreeMarkerConfigurer") and
        package.matches("%freemarker%")
      )
    }
  }

  // https://github.com/hibernate/hibernate-tools/blob/71fa3dae6ac1ac1b9c59f4fef5ba056c5ac36b34/orm/src/main/java/org/hibernate/tool/internal/export/common/TemplateHelper.java
  class FreemarkerTemplateConfiguration extends RefType {
    FreemarkerTemplateConfiguration() {
      this.hasQualifiedName("freemarker.template", "Configuration")
    }
  }

  class FreemarkerStringTemplateLoader extends RefType {
    FreemarkerStringTemplateLoader() {
      this.hasQualifiedName("freemarker.cache", "StringTemplateLoader")
    }
  }

  Expr getAllowNothingResolverExpr() {
    exists(Field f |
      result = f.getAnAccess() and
      f.hasName("ALLOWS_NOTHING_RESOLVER") and
      f.getDeclaringType() instanceof TemplateClassResolver
    )
  }

  class FreemarkerSetClassResolver extends MethodAccess {
    FreemarkerSetClassResolver() {
      exists(Method m |
        m = this.getMethod() and
        m.getDeclaringType() instanceof FreemarkerConfiguration and
        m.hasName("setNewBuiltinClassResolver") and
        m.getAParameter().getAnArgument() = getAllowNothingResolverExpr()
      )
    }
  }

  class FreemarkerSetAPIBuiltinEnabled extends MethodAccess {
    FreemarkerSetAPIBuiltinEnabled() {
      exists(Method m |
        m = this.getMethod() and
        m.getDeclaringType() instanceof FreemarkerConfiguration and
        m.hasName("setAPIBuiltinEnabled") and
        m.getAParameter().getAnArgument().(BooleanLiteral).getBooleanValue() = true
      )
    }
  }

  class GetConfigurationCall extends MethodAccess {
    GetConfigurationCall() {
      exists(Method m |
        m = this.getMethod() and
        m.getDeclaringType() instanceof FreeMarkerConfigurer and
        m.hasName("getConfiguration")
      )
    }
  }

  class SafeFreemarkerConfiguration extends DataFlow2::Configuration {
    SafeFreemarkerConfiguration() { this = "SafeFreemarkerConfiguration" }

    override predicate isSource(DataFlow2::Node src) {
      src.asExpr() instanceof FreemarkerTemplateConfigurationSource
    }

    override predicate isSink(DataFlow2::Node sink) {
      sink.asExpr() = any(FreemarkerSetClassResolver r).getQualifier()
    }
    // override int fieldFlowBranchLimit() { result = 0 }
  }

  class UnsafeFreemarkerConfiguration extends DataFlow3::Configuration {
    UnsafeFreemarkerConfiguration() { this = "UnsafeFreemarkerConfiguration" }

    override predicate isSource(DataFlow3::Node src) {
      src.asExpr() instanceof FreemarkerTemplateConfigurationSource
    }

    override predicate isSink(DataFlow3::Node sink) {
      sink.asExpr() = any(FreemarkerSetAPIBuiltinEnabled r).getQualifier()
    }
    // override int fieldFlowBranchLimit() { result = 0 }
  }

  class FreemarkerTemplateConfigurationSource extends Expr {
    FreemarkerTemplateConfigurationSource() {
      this.(ClassInstanceExpr).getConstructedType() instanceof FreemarkerTemplateConfiguration
      or
      this instanceof GetConfigurationCall
    }

    predicate isSafe() {
      exists(SafeFreemarkerConfiguration safeConfig |
        safeConfig
            .hasFlow(DataFlow2::exprNode(this),
              DataFlow2::exprNode(any(FreemarkerSetClassResolver r).getQualifier()))
      ) and
      not exists(UnsafeFreemarkerConfiguration unsafeConfig |
        unsafeConfig
            .hasFlow(DataFlow3::exprNode(this),
              DataFlow3::exprNode(any(FreemarkerSetAPIBuiltinEnabled r).getQualifier()))
      )
    }
  }

  /**
   * Template created using new expr
   * `Template t = new Template("name", templateStr, cfg);`
   * ref: https://freemarker.apache.org/docs/api/index.html Class Template
   */
  class NewTemplate extends ClassInstanceExpr {
    NewTemplate() { this.getConstructedType() instanceof FreemarkerTemplate }

    predicate isReaderArg(int index) {
      this.getConstructor()
          .getParameter(index)
          .getType()
          .(RefType)
          .hasQualifiedName("java.io", "Reader")
    }

    Expr getSink() {
      // All constructors accept java.io.Reader as template source string.
      exists(int index |
        isReaderArg(index) and
        result = this.getArgument(index)
      )
      or
      // in one case constructor accepts java.lang.String as second arg instead of java.io.Reader
      this.getNumArgument() = 3 and
      not isReaderArg(1) and
      result = this.getArgument(1)
    }
  }

  /**
   * Pass the template via StringTemplateLoader.
   * `StringTemplateLoader stringLoader = new StringTemplateLoader();`
   * `stringLoader.putTemplate("myTemplate", templateStr);`
   */
  class FreemarkerPutTemplate extends MethodAccess {
    FreemarkerPutTemplate() {
      exists(Method m |
        m = this.getMethod() and
        m.getDeclaringType() instanceof FreemarkerStringTemplateLoader and
        m.hasName("putTemplate")
      )
    }

    Expr getSink() { result = this.getArgument(1) }
  }
}
