import org.apache.logging.log4j.Logger;

class Test {
    void test(String password, String authToken, String username, String nullToken, String stringTokenizer) {
        Logger logger = null;

        logger.info("User's password is: " + password); // $ Alert
        logger.error("Auth failed for: " + authToken); // $ Alert
        logger.error("Auth failed for: " + username); // Safe
        logger.error("Auth failed for: " + nullToken); // Safe
        logger.error("Auth failed for: " + stringTokenizer); // Safe
        logger.error("Auth failed for: " + authToken.substring(4) + "..."); // Safe
        logger.error("Auth failed for: " + authToken.substring(0,4) + "..."); // Safe
        logger.error("Auth failed for: " + authToken.substring(1,5) + "..."); // $ Alert
        logger.error("Auth failed for: " + authToken.substring(0,8) + "..."); // $ Alert
    }
}
