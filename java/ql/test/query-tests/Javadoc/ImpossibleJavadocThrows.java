import java.lang.InterruptedException;
import java.lang.Exception;
import java.lang.RuntimeException;

class ImpossibleJavadocThrows {
	
	/**
	 * 
	 * @throws InterruptedException
	 */
	public void bad1() {
	}
	
	/**
	 * 
	 * @exception Exception
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