import org.apache.logging.log4j.Logger;

class Test {
    void test(String password, String authToken, String username, String nullToken, String stringTokenizer) {
        Logger logger = null;

        logger.info("User's password is: " + password); // $ hasTaintFlow
        logger.error("Auth failed for: " + authToken); // $ hasTaintFlow
        logger.error("Auth failed for: " + username); // Safe
        logger.error("Auth failed for: " + nullToken); // Safe
        logger.error("Auth failed for: " + stringTokenizer); // Safe
    }
}
