import org.apache.logging.log4j.Logger;

interface TokenSequenceParserConstants {
  /** Literal token values. */
  String[] tokenImage = {
    "<EOF>",
  };
}

public class TokenSequenceParserTest implements TokenSequenceParserConstants {
    void test(String password) {
        Logger logger = null;

        logger.info("When parsing found this: " + tokenImage[0]); // Safe
    }

}

class ParseExceptionTest extends Exception {
    String[] tokenImage;

    void test() {
        Logger logger = null;

        logger.info("When parsing found this: " + tokenImage[0]); // Safe
    }
}
