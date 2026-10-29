import java.io.Serializable;

public class Test implements Serializable {

	private Integer id;

	private String name;

	private String pass;

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getPass() {
		return pass;
	}

	public void setPass(String pass) {
		this.pass = pass;
	}

	@Override
	public String toString() {
		return "Test{" +
				"id=" + id +
				", name='" + name + '\'' +
				", pass='" + pass + '\'' +
				'}';
	}
}
