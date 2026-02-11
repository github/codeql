package extlib;

public class TypeParamVisibility<T> {

  public class VisibleBecauseInner<S> { }

  public class VisibleBecauseInnerIndirectContainer {

    public class VisibleBecauseInnerIndirect<S> { }

  }

  public static class NotVisibleBecauseStatic<S> { }

  public static class NotVisibleBecauseStaticIndirectContainer {

    public class NotVisibleBecauseStaticIndirect<S> { }

  }

  public VisibleBecauseInner<String> getVisibleBecauseInner() { return new VisibleBecauseInner<String>(); }

  public VisibleBecauseInnerIndirectContainer.VisibleBecauseInnerIndirect<String> getVisibleBecauseInnerIndirect() { return (new VisibleBecauseInnerIndirectContainer()).new VisibleBecauseInnerIndirect<String>(); }

  public NotVisibleBecauseStatic<String> getNotVisibleBecauseStatic() { return new NotVisibleBecauseStatic(); }

  public NotVisibleBecauseStaticIndirectContainer.NotVisibleBecauseStaticIndirect<String> getNotVisibleBecauseStaticIndirect() { return (new NotVisibleBecauseStaticIndirectContainer()).new NotVisibleBecauseStaticIndirect<String>(); }

}
