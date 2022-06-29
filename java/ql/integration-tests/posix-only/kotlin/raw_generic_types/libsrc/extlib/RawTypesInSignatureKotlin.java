package extlib;

class ContainerKotlin<T> { }

public class RawTypesInSignatureKotlin {

  public GenericTypeKotlin directReturn() { return null; }

  public void directParameter(GenericTypeKotlin param) { }

  public ContainerKotlin<GenericTypeKotlin> genericParamReturn() { return null; }

  public void genericParamParameter(ContainerKotlin<GenericTypeKotlin> param) { }

  public ContainerKotlin<? extends GenericTypeKotlin> genericParamExtendsReturn() { return null; }

  public void genericParamExtendsParameter(ContainerKotlin<? extends GenericTypeKotlin> param) { }

  public ContainerKotlin<? super GenericTypeKotlin> genericParamSuperReturn() { return null; }

  public void genericParamSuperParameter(ContainerKotlin<? super GenericTypeKotlin> param) { }

}
