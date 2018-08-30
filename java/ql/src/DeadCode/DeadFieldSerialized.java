@XmlRootElement
public class SerializableClass {
	@XmlAttribute
	private String field;

	public void setField(String field) {
		this.field = field;
	}
}