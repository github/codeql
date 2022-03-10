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

}