package org.jlleitschuh.bad.random;

import org.apache.commons.lang.RandomStringUtils; // or org.apache.commons.lang3.RandomStringUtils
import org.apache.commons.text.CharacterPredicates;
import org.apache.commons.text.RandomStringGenerator;

import java.nio.charset.Charset;
import java.security.SecureRandom;
import java.util.Random;
import java.util.UUID;
import java.util.concurrent.ThreadLocalRandom;

public class PredictableRandomNumberGenerator {
    private static final Random RANDOM = new Random();
    private static final SecureRandom SECURE_RANDOM = new SecureRandom();

    public static String generatePasswordResetTokenJavaBad() {
        byte[] array = new byte[30];
        // BAD!
        RANDOM.nextBytes(array);
        return new String(array, Charset.defaultCharset());
    }

    public static String generatePasswordResetTokenJavaGood() {
        byte[] array = new byte[30];
        // GOOD!
        SECURE_RANDOM.nextBytes(array);
        return new String(array, Charset.defaultCharset());
    }

    public static String generateSecretBad() {
        final char[] CHARS = "abcdefghijklmnopqrstuvwxyz".toCharArray();
        StringBuilder builder = new StringBuilder(30);
        for (int i = 0; i < 30; i++) {
            // BAD!
            char c = CHARS[RANDOM.nextInt(CHARS.length)];
            builder.append(c);
        }
        return builder.toString();
    }

    public static String generateSecretGood() {
        final char[] CHARS = "abcdefghijklmnopqrstuvwxyz".toCharArray();
        StringBuilder builder = new StringBuilder(30);
        for (int i = 0; i < 30; i++) {
            // GOOD!
            char c = CHARS[SECURE_RANDOM.nextInt(CHARS.length)];
            builder.append(c);
        }
        return builder.toString();
    }


    public static String generateSessionTokenJavaBad() {
        // BAD!
        return Long.toHexString(RANDOM.nextLong());
    }

    public static String generateSessionTokenJavaGood() {
        // GOOD!
        return Long.toHexString(SECURE_RANDOM.nextLong());
    }

    public static String generatePasswordResetTokenApacheCommonsBad() {
        // BAD!
        return RandomStringUtils.randomAscii(30);
    }

    public static String generatePasswordResetTokenApacheCommonsGood() {
        // GOOD!
        return RandomStringUtils.random(
            30,
            32,
            127,
            false,
            false,
            null,
            SECURE_RANDOM
        );
    }

    // BAD!
    private static RandomStringGenerator STRING_GENERATOR =
        new RandomStringGenerator.Builder()
            .withinRange('0', 'z')
            .filteredBy(CharacterPredicates.LETTERS, CharacterPredicates.DIGITS)
            .build();

    public static String generatePasswordResetTokenApacheTextBad() {
        // GOOD!
        return STRING_GENERATOR.generate(30);
    }

    // GOOD!
    private static RandomStringGenerator SECURE_STRING_GENERATOR =
        new RandomStringGenerator.Builder()
            .usingRandom(SECURE_RANDOM::nextInt) // Notice! Using Secure Random Number Generator
            .withinRange('0', 'z')
            .filteredBy(CharacterPredicates.LETTERS, CharacterPredicates.DIGITS)
            .build();

    public static String generatePasswordResetTokenApacheTextGood() {
        // GOOD!
        return SECURE_STRING_GENERATOR.generate(30);
    }

    /**
     * This is a real example from a vulnerability in the web server library Ratpack.
     * See: CVE-2019-11808
     */
    public static UUID generateSessionTokenBad() {
        // Thread local values uses a seed of a bitwise OR of System.currentTimeMillis() and System.nanoTime()
        // at ThreadLocalRandom classload time.
        // IE. If you know the launch time of the application, you can predict the seed.
        ThreadLocalRandom random = ThreadLocalRandom.current();
        // Bad!
        return new UUID(random.nextLong(), random.nextLong());
    }

    public static UUID generateSessionTokenGood() {
        // GOOD!
        // Uses SecureRandom internally.
        return UUID.randomUUID();
    }

}
