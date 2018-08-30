import java.io.Serializable;

import javax.xml.bind.annotation.XmlAttribute;

public class SomeFieldsInSerializable implements Serializable {
	public String unusedPublic;
	protected String unusedProtected;
	String unusedDefault;
	private String unusedPrivate;
	private String unusedInitialisedPrivate = "foo";
	
	public transient String unusedTransientPublic;
	protected transient String unusedTransientProtected;
	transient String unusedTransientDefault;
	private transient String unusedTransientPrivate;
	private transient String unusedInitialisedTransientPrivate = "foo";
	
	public String usedPublic;
	protected String usedProtected;
	String usedDefault;
	private String usedPrivate;
	private String usedInitialisedPrivate;
	
	@XmlAttribute
	private String xmlString;
	
	@XmlAttribute
	private transient String transientXMLString;
	
	@Deprecated
	private String deprecatedString;
	
	@Deprecated
	private transient String transientDeprecatedString;
	
	private String use() {
		return usedPublic + usedProtected + usedDefault + usedPrivate + usedInitialisedPrivate;
	}
}