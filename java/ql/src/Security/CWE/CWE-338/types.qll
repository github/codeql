import java

class UUIDCreationExp extends ClassInstanceExpr {
  UUIDCreationExp() { this.getConstructedType() instanceof TypeUUID }
}

class ApacheRandomStringUtilsType extends RefType {
  ApacheRandomStringUtilsType() {
    this.hasQualifiedName("org.apache.commons.lang", "RandomStringUtils") or
    this.hasQualifiedName("org.apache.commons.lang3", "RandomStringUtils")
  }
}

class ApacheRandomStringGeneratorType extends RefType {
  ApacheRandomStringGeneratorType() {
    this.hasQualifiedName("org.apache.commons.text", "RandomStringGenerator")
  }

  Method getGenerateMethod() {
    exists(Method m |
      m.getDeclaringType() = this and
      m.hasName("generate") and
      m = result
    )
  }
}

class ApacheRandomStringGeneratorBuilderType extends RefType {
  ApacheRandomStringGeneratorBuilderType() {
    this.hasQualifiedName("org.apache.commons.text", "RandomStringGenerator$Builder")
  }
}

class ApacheRandomStringGeneratorBuilderUsingRandomMethod extends Method {
  ApacheRandomStringGeneratorBuilderUsingRandomMethod() {
    this.getDeclaringType() instanceof ApacheRandomStringGeneratorBuilderType and
    this.hasName("usingRandom")
  }
}

class ApacheTextRandomProviderType extends RefType {
  ApacheTextRandomProviderType() {
    this.hasQualifiedName("org.apache.commons.text", "TextRandomProvider")
  }
}

class JavaStdlibInsecureRandomType extends RefType {
  JavaStdlibInsecureRandomType() {
    this.hasQualifiedName("java.util.concurrent", "ThreadLocalRandom") or
    this.hasQualifiedName("java.util", "Random")
  }
}
