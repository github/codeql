// Semmle test case for CWE-676: Use of Potentially Dangerous Function
// http://cwe.mitre.org/data/definitions/676.html
package test.cwe676.semmle.tests;

class Test {
	private Thread worker;

	public Test(Thread worker) {
		this.worker = worker;
	}
	
	public void quit() {
		// Stop
		worker.stop(); // BAD: Thread.stop can result in corrupted data
	}
}
