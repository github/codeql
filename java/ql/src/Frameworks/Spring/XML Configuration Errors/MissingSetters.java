// bean class
public class ContentService {
	private TransactionHelper helper;

	// This method does not match the property in the bean file.
	public void setHelper(TransactionHelper helper) {
		this.helper = helper;
	}
}
