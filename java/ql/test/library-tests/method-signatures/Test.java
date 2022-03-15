import java.lang.annotation.*;

public class Test {

  @Target({ElementType.METHOD, ElementType.FIELD, ElementType.PARAMETER, ElementType.LOCAL_VARIABLE, ElementType.TYPE_USE})
  @interface NotNull { }

  class Inner { }

  public void annotations(@NotNull byte[] b1, byte @NotNull [] b2, @NotNull String s, Class<@NotNull String> c, @NotNull Test.Inner ti, Class<? extends @NotNull String> wc, Class<String>[] classes, @NotNull byte b, @NotNull String[] sArray, String @NotNull [] sArray2) { }

}

