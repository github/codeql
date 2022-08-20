import java.io.*;
import java.lang.annotation.*;

public class InefficientOutputStreamAnnotations {

  @Target({ElementType.METHOD, ElementType.FIELD, ElementType.PARAMETER, ElementType.LOCAL_VARIABLE, ElementType.TYPE_USE})
  @interface NotNull { }

  public static void test() {

        OutputStream stream = new OutputStream() {
          @Override
          public void write(int b) throws IOException {
            OutputStream otherStream = null;
            otherStream.write(1);            
          }
          @Override
          public void write(byte @NotNull [] b, int off, int len) throws IOException { // GOOD: even with the annotation @NotNull, this overrides write(byte[], int, int).
          }
        };

  }

}
