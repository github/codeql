import org.apache.logging.log4j.Logger;

class Test {
    void test(String password, String authToken, String username, String nullToken, String stringTokenizer) {
        Logger logger = null;
        int zero = 0;
        int four = 4;
        short zeroS = 0;
        long fourL = 4L;

        logger.info("User's password is: " + password); // $ Alert
        logger.error("Auth failed for: " + authToken); // $ Alert
        logger.error("Auth failed for: " + username); // Safe
        logger.error("Auth failed for: " + nullToken); // Safe
        logger.error("Auth failed for: " + stringTokenizer); // Safe
        logger.error("Auth failed for: " + authToken.substring(4) + "..."); // Safe
        logger.error("Auth failed for: " + authToken.substring(four) + "..."); // Safe
        logger.error("Auth failed for: " + authToken.substring(0,4) + "..."); // Safe
        logger.error("Auth failed for: " + authToken.substring(zero,four) + "..."); // Safe
        logger.error("Auth failed for: " + authToken.substring((int)zeroS,(int)fourL) + "..."); // Safe
        logger.error("Auth failed for: " + authToken.substring(1,5) + "..."); // $ Alert
        logger.error("Auth failed for: " + authToken.substring(0,8) + "..."); // $ Alert
    }

    // Tests for false positive exclusions: variables with "token" or "secret" in the name
    // that do not hold sensitive data.
    void testFalsePositiveExclusions(
        String nextToken, String pageToken, String continuationToken, String cursorToken,
        String tokenType, String tokenEndpoint, String tokenCount, String tokenUrl,
        String tokenIndex, String tokenLength, String tokenName, String tokenId,
        String secretName, String secretId, String secretVersion, String secretArn,
        String secretPath, String secretType,
        String secretManager, String secretProperties
    ) {
        Logger logger = null;
        // Pagination/iteration tokens (e.g., AWS SDK, GCP, Azure pagination cursors)
        logger.info("cursor: " + nextToken); // Safe
        logger.info("cursor: " + pageToken); // Safe
        logger.info("cursor: " + continuationToken); // Safe
        logger.info("cursor: " + cursorToken); // Safe
        // Token metadata (e.g., OAuth token type, OIDC discovery endpoint)
        logger.info("type: " + tokenType); // Safe
        logger.info("endpoint: " + tokenEndpoint); // Safe
        logger.info("count: " + tokenCount); // Safe
        logger.info("url: " + tokenUrl); // Safe
        logger.info("index: " + tokenIndex); // Safe
        logger.info("length: " + tokenLength); // Safe
        logger.info("name: " + tokenName); // Safe
        logger.info("id: " + tokenId); // Safe
        // Secret metadata (e.g., K8s secret name, AWS Secrets Manager identifiers)
        logger.info("name: " + secretName); // Safe
        logger.info("id: " + secretId); // Safe
        logger.info("version: " + secretVersion); // Safe
        logger.info("arn: " + secretArn); // Safe
        logger.info("path: " + secretPath); // Safe
        logger.info("type: " + secretType); // Safe
        logger.info("manager: " + secretManager); // Safe
        logger.info("properties: " + secretProperties); // Safe
    }

    // These should still be flagged as sensitive
    void testTruePositives(String accessToken, String clientSecret, String apiSecret,
                           String sessionToken, String bearerToken, String secretKey,
                           String refreshToken, String secretValue) {
        Logger logger = null;
        logger.info("token: " + accessToken); // $ Alert
        logger.info("secret: " + clientSecret); // $ Alert
        logger.info("secret: " + apiSecret); // $ Alert
        logger.info("token: " + sessionToken); // $ Alert
        logger.info("token: " + bearerToken); // $ Alert
        logger.info("key: " + secretKey); // $ Alert
        logger.info("token: " + refreshToken); // $ Alert
        logger.info("value: " + secretValue); // $ Alert
    }
}
