import org.apache.logging.log4j.Logger;

class Test {
    void test(String password) {
        Logger logger = null;

        logger.info("User's password is: " + password); // $ hasTaintFlow
    }

    void test2(String authToken) {
        Logger logger = null;

        logger.error("Auth failed for: " + authToken); // $ hasTaintFlow
    }

    void test3(String username) {
        Logger logger = null;

        logger.error("Auth failed for: " + username); // Safe
    }

    void test4(String nullToken) {
        Logger logger = null;

        logger.error("Auth failed for: " + nullToken); // Safe
    }

}
