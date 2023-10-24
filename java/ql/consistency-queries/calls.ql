import java

from MethodCall ma
// Generally Kotlin calls will always use an explicit qualifier, except for calls
// to the synthetic instance initializer <obinit>, which use an implicit `this`.
where
  not exists(ma.getQualifier()) and
  ma.getFile().isKotlinSourceFile() and
  not ma.getCallee() instanceof InstanceInitializer
select ma
