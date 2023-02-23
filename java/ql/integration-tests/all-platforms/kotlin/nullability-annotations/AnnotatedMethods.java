import org.jetbrains.annotations.*;
import zpkg.A;

public class AnnotatedMethods implements AnnotatedInterface {

  public @A @NotNull String notNullAnnotated(@A @NotNull String param) { return param; }

  public @A @Nullable String nullableAnnotated(@A @Nullable String param) { return param; }

}
