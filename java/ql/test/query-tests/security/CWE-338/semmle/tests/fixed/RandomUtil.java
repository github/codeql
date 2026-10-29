package test.cwe338.cwe.examples.fixed;

import org.apache.commons.lang3.RandomStringUtils;

import java.security.SecureRandom;

/**
 * Utility class for generating random Strings.
 */
public final class RandomUtil {
    private static final SecureRandom SECURE_RANDOM = new SecureRandom();

    private static final int DEF_COUNT = 20;

    static {
        SECURE_RANDOM.nextBytes(new byte[64]);
    }

    private RandomUtil() {
    }

    private static String generateRandomAlphanumericString() {
        return RandomStringUtils.random(DEF_COUNT, 0, 0, true, true, null, SECURE_RANDOM);
    }

    /**
     * Generate a password.
     *
     * @return the generated password.
     */
    public static String generatePassword() {
        return generateRandomAlphanumericString();
    }

    /**
     * Generate an activation key.
     *
     * @return the generated activation key.
     */
    public static String generateActivationKey() {
        return generateRandomAlphanumericString();
    }

    /**
     * Generate a reset key.
     *
     * @return the generated reset key.
     */
    public static String generateResetKey() {
        return generateRandomAlphanumericString();
    }

    /**
     * Generate a unique series to validate a persistent token, used in the
     * authentication remember-me mechanism.
     *
     * @return the generated series data.
     */
    public static String generateSeriesData() {
        return generateRandomAlphanumericString();
    }

    /**
     * Generate a persistent token, used in the authentication remember-me mechanism.
     *
     * @return the generated token data.
     */
    public static String generateTokenData() {
        return generateRandomAlphanumericString();
    }
}
