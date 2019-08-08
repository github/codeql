// Semmle test case for CWE-190: Integer Overflow or Wraparound
// http://cwe.mitre.org/data/definitions/190.html
package test.cwe190.semmle.tests;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

public class ArithmeticTainted {
	public void main(String[] args) {
		BufferedReader readerBuffered;
		InputStreamReader readerInputStream;
		int data;

		try {

			readerInputStream = new InputStreamReader(System.in, "UTF-8");
			readerBuffered = new BufferedReader(readerInputStream);
			String stringNumber = readerBuffered.readLine();
			if (stringNumber != null) {
				data = Integer.parseInt(stringNumber.trim());
			} else {
				data = 0;
			}
		} catch (IOException exceptIO) {
			// fail
			data = 0;
		}

		{
			// BAD: may overflow if input data is very large
			int scaled = data + 10;
		}

		{
			// BAD: guard and then bypass
			if (data > Integer.MIN_VALUE) {
				System.out.println("I'm guarded");
			}
			int output = data - 10;
		}

		{
			// BAD: guard and use after both branches
			if (data < Integer.MAX_VALUE) {
				System.out.println("I'm guarded");
			} else {
				System.out.println("I'm not guarded");
			}
			int output = data + 1;
		}

		{
			// GOOD: use a guard to ensure no overflows occur
			int scaled;
			if (data < Integer.MAX_VALUE / 10 && data > Integer.MIN_VALUE / 10)
				scaled = data * 10;
			else
				scaled = Integer.MAX_VALUE;
		}

		{
			Holder tainted = new Holder(1);
			tainted.setData(data);
			Holder safe = new Holder(1);
			int herring = tainted.getData();
			int ok = safe.getData();
            // GOOD
			int output_ok = ok + 1;
            // BAD
			int output = herring + 1;
		}

		{
			// guard against underflow
			if (data > Integer.MIN_VALUE) {
				int stillTainted = data - 1;
				// FALSE NEGATIVE: stillTainted could still be very large, even
				// after
				// it has had arithmetic done on it
				int output = stillTainted + 100;
			}
		}

		{
			// GOOD: tainted int value is widened to type long, thus avoiding
			// overflow
			// (see binary numeric promotions in JLS 5.6.2)
			long widened = data + 10L;
		}

		{
			// BAD: tainted int value is widened to type long, but subsequently
			// cast to narrower type int
			int widenedThenNarrowed = (int) (data + 10L);
		}

		// The following test case has an arbitrary guard on hashcode
		// because otherwise the return statement causes 'data' to be guarded
		// in the subsequent test cases.
		if (this.hashCode() > 0) {
			// GOOD: guard and return if bad
			if (data < Integer.MAX_VALUE) {
				System.out.println("I'm guarded");
			} else {
				return;
			}
			int output = data + 1;
		}
		
		{
			double x= Double.MAX_VALUE;
			// OK: CWE-190 only pertains to integer arithmetic
			double y = x * 2;
		}

		{
			test(data);
			test2(data);
			test3(data);
			test4(data);
		}
	}

	public static void test(int data) {
		// BAD: may overflow if input data is very large
		data++;
	}
	public static void test2(int data) {
		// BAD: may overflow if input data is very large
		++data;
	}
	public static void test3(int data) {
		// BAD: may underflow if input data is very small
		data--;
	}
	public static void test4(int data) {
		// BAD: may underflow if input data is very small
		--data;
	}
}
