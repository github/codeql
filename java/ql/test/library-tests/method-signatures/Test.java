import java.lang.annotation.*;
import java.util.function.Function;

public class Test {

  @Target({ElementType.METHOD, ElementType.FIELD, ElementType.PARAMETER, ElementType.LOCAL_VARIABLE, ElementType.TYPE_USE})
  @interface NotNull { }

  class Inner { }

  public void annotations(@NotNull byte[] b1, byte @NotNull [] b2, @NotNull String s, Class<@NotNull String> c, @NotNull Test.Inner ti, Class<? extends @NotNull String> wc, Class<String>[] classes, @NotNull byte b, @NotNull String[] sArray, String @NotNull [] sArray2) { }

  public <T, R> R typeVariables(Function<? super T, ? extends R> f) {
    return null;
  }

  @SafeVarargs
  static <E> void varargs(E... elements) { }

  @SafeVarargs
  static <E extends Number> void varargsWithBound(E... elements) { }
}
