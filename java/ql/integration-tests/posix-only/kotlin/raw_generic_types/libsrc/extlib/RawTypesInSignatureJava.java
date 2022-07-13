package extlib;

class ContainerJava<T> { }

public class RawTypesInSignatureJava {

  public GenericTypeJava directReturn() { return null; }

  public void directParameter(GenericTypeJava param) { }

  public ContainerJava<GenericTypeJava> genericParamReturn() { return null; }

  public void genericParamParameter(ContainerJava<GenericTypeJava> param) { }

  public ContainerJava<? extends GenericTypeJava> genericParamExtendsReturn() { return null; }

  public void genericParamExtendsParameter(ContainerJava<? extends GenericTypeJava> param) { }

  public ContainerJava<? super GenericTypeJava> genericParamSuperReturn() { return null; }

  public void genericParamSuperParameter(ContainerJava<? super GenericTypeJava> param) { }

}
