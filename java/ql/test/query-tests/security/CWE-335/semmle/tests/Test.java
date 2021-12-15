// Semmle test case for CWE-335: Use of a predictable seed in a secure random number generator
// http://cwe.mitre.org/data/definitions/335.html
package test.cwe335.semmle.tests;

import java.util.Random;
import java.security.SecureRandom;
import java.math.BigInteger;

class Test {
	public void test() {
		long time1 = System.currentTimeMillis();
		long time2 = System.nanoTime();
		
		// GOOD: We only care about SecureRandom generators.
		Random r = new Random(time1);
		r.nextInt();
		
		// GOOD: SecureRandom initialized with random seed.
		SecureRandom r1 = new SecureRandom();
		byte[] random_seed = new BigInteger(Long.toString(r1.nextLong())).toByteArray();
		SecureRandom r2 = new SecureRandom(random_seed);
		r2.nextInt();
		
		// BAD: SecureRandom initialized with times.
		SecureRandom r_time1 = new SecureRandom(new BigInteger(Long.toString(time1)).toByteArray());
		// BAD: SecureRandom initialized with times.
		SecureRandom r_time2 = new SecureRandom(new BigInteger(Long.toString(time2)).toByteArray());
		r_time1.nextInt(); r_time2.nextInt();
		
		// BAD: SecureRandom initialized with constant value.
		SecureRandom r_const = new SecureRandom(new BigInteger(Long.toString(12345L)).toByteArray());
		r_const.nextInt();
		
		// BAD: SecureRandom's seed set to constant with setSeed.
		SecureRandom r_const_set = new SecureRandom();
		r_const_set.setSeed(12345L);
		r_const_set.nextInt();
		
		// GOOD: SecureRandom self seeded and then seed is supplemented.
		SecureRandom r_selfseed = new SecureRandom();
		r_selfseed.nextInt();
		r_selfseed.setSeed(12345L);
		r_selfseed.nextInt();
		
		// GOOD: SecureRandom seed set to something random.
		SecureRandom r_random_set = new SecureRandom();
		r_random_set.setSeed(random_seed);
		r_random_set.nextInt();
		
		// GOOD: SecureRandom seeded with a bad seed but then seed is supplemented.
		SecureRandom r_suplseed = new SecureRandom();
		r_suplseed.setSeed(12345L);
		r_suplseed.setSeed(random_seed);
		r_suplseed.nextInt();
		
		// GOOD: SecureRandom seeded with composite seed that is partially random.
		SecureRandom r_composite = new SecureRandom();
		r_composite.setSeed(0L + r1.nextLong());
		r_composite.nextInt();
	}
}
