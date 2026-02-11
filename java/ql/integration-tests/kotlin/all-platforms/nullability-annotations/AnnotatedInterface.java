import org.jetbrains.annotations.*;
import zpkg.A;

public interface AnnotatedInterface {

  public @A @NotNull String notNullAnnotated(@A @NotNull String param);

  public @A @Nullable String nullableAnnotated(@A @Nullable String param);

}
