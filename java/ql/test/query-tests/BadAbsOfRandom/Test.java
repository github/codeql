import java.util.Random;
import java.util.concurrent.ThreadLocalRandom;
import org.apache.commons.lang3.RandomUtils;

public class Test {

  public static void test() {

    Random r = new Random();
    Math.abs(r.nextInt());
    Math.abs(r.nextLong());
    Math.abs(r.nextInt(100)); // GOOD: random value already has a restricted range

    Math.abs(RandomUtils.nextInt());
    Math.abs(RandomUtils.nextLong());
    Math.abs(RandomUtils.nextInt(1, 10)); // GOOD: random value already has a restricted range
    Math.abs(RandomUtils.nextLong(1, 10)); // GOOD: random value already has a restricted range

    ThreadLocalRandom tlr = ThreadLocalRandom.current();
    Math.abs(tlr.nextInt());
    Math.abs(tlr.nextLong());
    Math.abs(tlr.nextInt(10)); // GOOD: random value already has a restricted range
    Math.abs(tlr.nextLong(10)); // GOOD: random value already has a restricted range
    Math.abs(tlr.nextInt(1, 10)); // GOOD: random value already has a restricted range
    Math.abs(tlr.nextLong(1, 10)); // GOOD: random value already has a restricted range

  }

}
