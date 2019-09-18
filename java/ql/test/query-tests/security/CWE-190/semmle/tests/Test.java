// Semmle test case for CWE-190: Integer Overflow or Wraparound
// http://cwe.mitre.org/data/definitions/190.html
package test.cwe190.semmle.tests;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.IOException;
import java.security.SecureRandom;
import java.util.HashMap;

class Test {
	public static void main(String[] args) {

		// IntMultToLong
		{
			int timeInSeconds = 1000000;

			// BAD: result of multiplication will be too large for
			// int, and will overflow before being stored in the long
			long timeInNanos = timeInSeconds * 1000000000;
		}

		{
			int timeInSeconds = 1000000;

			// BAD
			long timeInNanos = timeInSeconds * 1000000000 + 4;
		}

		{
			int timeInSeconds = 1000000;

			// BAD
			long timeInNanos = true ? timeInSeconds * 1000000000 + 4 : 0;
		}

		{
			long timeInSeconds = 10000000L;

			// same problem, but with longs; not reported as the conversion to double is not sufficient indication of a large number
			double timeInNanos = timeInSeconds * 10000000L;
		}

		{
			int timeInSeconds = 1000000;

			// GOOD: one of the arguments is cast to long before multiplication
			// so the multiplication will take place in the long
			long timeInNanos = (long) timeInSeconds * 1000000000;
		}

		{
			int timeInSeconds = 1;

			// GOOD: both arguments are constants that are small
			// enough to allow the multiplication in int without
			// overflow
			long timeInNanos = timeInSeconds * 1000000000;
		}

		// InformationLoss
		{
			int i = 0;
			while (i < 1000000) {
				// BAD: getLargeNumber is implicitly narrowed to an integer
				// which will result in overflows if it is large
				i += getLargeNumber();
			}
		}

		{
			long i = 0;
			while (i < 1000000) {
				// GOOD: i is a long, so no narrowing occurs
				i += getLargeNumber();
			}
		}

		{
			int i = 0;
			long j = 100;

			// FALSE POSITIVE: the query check purely based on the type, it
			// can't try to
			// determine whether the value may in fact always be in bounds
			i += j;
		}

		// ArithmeticWithExtremeValues
		{
			int i = 0;
			i = Integer.MAX_VALUE;
			int j = 0;
			// BAD: overflow
			j = i + 1;
		}

		{
			int i = 0;
			i = Integer.MAX_VALUE;
			int j = 0;
			i = 0;
			// GOOD: reassigned before usage
			j = i + 1;
		}

		{
			long i = Long.MIN_VALUE;
			// BAD: overflow
			long j = i - 1;
		}

		{
			long i = Long.MAX_VALUE;
			// GOOD: no overflow
			long j = i - 1;
		}

		{
			int i = Integer.MAX_VALUE;
			// GOOD: no overflow
			long j = (long) i - 1;
		}

		{
			int i = Integer.MAX_VALUE;
			// GOOD: guarded
			if (i < Integer.MAX_VALUE) {
				long j = i + 1;
			}
		}

		{
			int i = Integer.MAX_VALUE;
			if (i < Integer.MAX_VALUE) {
				// BAD: reassigned after guard
				i = Integer.MAX_VALUE;
				long j = i + 1;
			}
		}

		{
			int i = Integer.MAX_VALUE;
			// BAD: guarded the wrong way
			if (i > Integer.MIN_VALUE) {
				long j = i + 1;
			}
		}

		{
			int i = Integer.MAX_VALUE;
			// GOOD: The query can detect custom guards.

			if (properlyBounded(i)) {
				long j = i + 1;
			}
		}

		{
			byte b = Byte.MAX_VALUE;
			// GOOD: extreme byte value is widened to type int, thus avoiding
			// overflow
			// (see binary numeric promotions in JLS 5.6.2)
			int i = b + 1;
		}

		{
			short s = Short.MAX_VALUE;
			// GOOD: extreme short value is widened to type int, thus avoiding
			// overflow
			// (see binary numeric promotions in JLS 5.6.2)
			int i = s + 1;
		}

		{
			int i = Integer.MAX_VALUE;
			// GOOD: extreme int value is widened to type long, thus avoiding
			// overflow
			// (see binary numeric promotions in JLS 5.6.2)
			long l = i + 1L;
		}

		{
			byte b = Byte.MAX_VALUE;
			// BAD: extreme byte value is widened to type int, but subsequently
			// cast to narrower type byte
			byte widenedThenNarrowed = (byte) (b + 1);
		}

		{
			short s = Short.MAX_VALUE;
			// BAD: extreme short value is widened to type int, but subsequently
			// cast to narrower type short
			short widenedThenNarrowed = (short) (s + 1);
		}

		{
			int i = Integer.MAX_VALUE;
			// BAD: extreme int value is widened to type long, but subsequently
			// cast to narrower type int
			int widenedThenNarrowed = (int) (i + 1L);
		}

		// ArithmeticUncontrolled
		int data = (new java.security.SecureRandom()).nextInt();

		{
			// BAD: may overflow if data is large
			int output = data + 1;
		}

		{
			// GOOD: guarded
			if (data < Integer.MAX_VALUE) {
				int output = data + 1;
			}
		}

		{
			// guard against underflow
			if (data > Integer.MIN_VALUE) {
				int stillLarge = data - 1;
				// FALSE NEGATIVE: stillLarge could still be very large, even
				// after
				// it has had arithmetic done on it
				int output = stillLarge + 100;
			}
		}

		{
			// GOOD: uncontrolled int value is widened to type long, thus
			// avoiding overflow
			// (see binary numeric promotions in JLS 5.6.2)
			long widened = data + 10L;
		}

		{
			// BAD: uncontrolled int value is widened to type long, but
			// subsequently cast to narrower type int
			int widenedThenNarrowed = (int) (data + 10L);
		}
	}

	public static long getLargeNumber() {
		return Long.MAX_VALUE / 2;
	}

	public static boolean properlyBounded(int i) {
		return i < Integer.MAX_VALUE;
	}
}
