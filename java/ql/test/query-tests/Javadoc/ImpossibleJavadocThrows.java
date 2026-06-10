import java.lang.InterruptedException;
import java.lang.Exception;
import java.lang.RuntimeException;

class ImpossibleJavadocThrows {
	
	/**
	 * 
	 * @throws InterruptedException // $ Alert
	 */
	public void bad1() {
	}
	
	/**
	 * 
	 * @exception Exception // $ Alert
	 */
	public void bad2() {
	}
	
	/**
	 * 
	 * @throws InterruptedException
	 */
	public void goodDeclared() throws Exception{
	}
	
	/**
	 * 
	 * @exception RuntimeException
	 */
	public void goodUnchecked(){
	}
}
