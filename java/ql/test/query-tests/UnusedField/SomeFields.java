import javax.xml.bind.annotation.XmlAttribute;

public class SomeFields {
	public String unusedPublic;
	protected String unusedProtected;
	String unusedDefault;
	private String unusedPrivate;
	private String unusedInitialisedPrivate = "foo";
	
	public String usedPublic;
	protected String usedProtected;
	String usedDefault;
	private String usedPrivate;
	private String usedInitialisedPrivate;
	
	@XmlAttribute
	private String xmlString;
	
	@Deprecated
	private String deprecatedString;
	
	@SuppressWarnings("unused")
	private String unusedStringWithSuppressedWarning;
	
	private String use() {
		return usedPublic + usedProtected + usedDefault + usedPrivate + usedInitialisedPrivate;
	}

	@SuppressWarnings("unused")
	class Inner {
		private int unusedIntWithEnclosingSuppressedWarning;
	}
}