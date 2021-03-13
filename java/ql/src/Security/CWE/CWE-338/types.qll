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

abstract class JavaStdlibInsecureRandomType extends RefType {}

class ThreadLocalRandomType extends JavaStdlibInsecureRandomType {
  ThreadLocalRandomType() {
    this.hasQualifiedName("java.util.concurrent", "ThreadLocalRandom")
  }
}

class RandomType extends JavaStdlibInsecureRandomType {
  RandomType() {
    this.hasQualifiedName("java.util", "Random")
  }
}

class SplittableRandomType extends JavaStdlibInsecureRandomType {
  SplittableRandomType() {
    this.hasQualifiedName("java.util", "SplittableRandom")
  }
}

abstract class JavaStdlibInsecureRandomTypeKnownCreation extends Expr {}

class ThreadLocalRandomInstanceMethodAccess extends MethodAccess, JavaStdlibInsecureRandomTypeKnownCreation {
  ThreadLocalRandomInstanceMethodAccess() {
    this.getMethod().hasName("current") and 
    this.getMethod().isStatic() and 
    this.getMethod().getDeclaringType() instanceof ThreadLocalRandomType
  }
}

class RandomCreationExp extends ClassInstanceExpr, JavaStdlibInsecureRandomTypeKnownCreation {
  RandomCreationExp() {
    this.getConstructedType() instanceof JavaStdlibInsecureRandomType
  }
}
