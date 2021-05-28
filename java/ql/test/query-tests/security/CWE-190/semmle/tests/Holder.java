// Semmle test case for CWE-190: Integer Overflow or Wraparound
// https://cwe.mitre.org/data/definitions/190.html
package test.cwe190.semmle.tests;

public class Holder {
	public int dat;

	public Holder(int d) {
		dat = d;
	}

	public void setData(int d) {
		dat = d;
	}

	public int getData() {
		return dat;
	}
}
