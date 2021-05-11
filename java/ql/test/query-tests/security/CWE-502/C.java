import java.util.HashMap;
<<<<<<< HEAD
<<<<<<< HEAD
import java.io.StringReader;
=======
>>>>>>> 6738bf5186... Add UnsafeDeserialization sink
=======
import java.io.StringReader;
>>>>>>> 9e39c222ae... Increase castor and burlap detection
import javax.servlet.http.HttpServletRequest;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import com.cedarsoftware.util.io.JsonReader;
import com.esotericsoftware.yamlbeans.YamlReader;
import org.ho.yaml.Yaml;
import org.ho.yaml.YamlConfig;
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 9e39c222ae... Increase castor and burlap detection
import org.exolab.castor.xml.Unmarshaller;
import com.caucho.hessian.io.Hessian2Input;
import com.caucho.hessian.io.HessianInput;
import com.caucho.burlap.io.BurlapInput;
<<<<<<< HEAD
=======
import com.caucho.hessian.io.Hessian2Input;
import com.caucho.hessian.io.HessianInput;
>>>>>>> 6738bf5186... Add UnsafeDeserialization sink
=======
>>>>>>> 9e39c222ae... Increase castor and burlap detection
import java.io.ByteArrayInputStream;

@Controller
public class C {

	@GetMapping(value = "jyaml")
	public void bad1(HttpServletRequest request) throws Exception {
		String data = request.getParameter("data");
		Yaml.load(data);  //bad
		Yaml.loadStream(data);  //bad
		Yaml.loadStreamOfType(data, Object.class);  //bad
		Yaml.loadType(data, Object.class);  //good

		org.ho.yaml.YamlConfig yamlConfig = new YamlConfig();
		yamlConfig.load(data);  //bad
		yamlConfig.loadStream(data);  //bad
		yamlConfig.loadStreamOfType(data, Object.class);  //bad
		yamlConfig.loadType(data, Object.class);  //good
	}

	@GetMapping(value = "jsonio")
	public void bad2(HttpServletRequest request) {
		String data = request.getParameter("data");

		HashMap hashMap = new HashMap();
		hashMap.put("USE_MAPS", true);

		JsonReader.jsonToJava(data); //bad

		JsonReader.jsonToJava(data, hashMap); //good

		JsonReader jr = new JsonReader(data, null); //bad
		jr.readObject();

		JsonReader jr1 = new JsonReader(data, hashMap); //good
		jr1.readObject();
	}

	@GetMapping(value = "yamlbeans")
	public void bad3(HttpServletRequest request) throws Exception {
		String data = request.getParameter("data");
		YamlReader r = new YamlReader(data);
		r.read(); //bad
		r.read(Object.class); //bad
		r.read(Object.class, Object.class); //bad
	}

        @GetMapping(value = "hessian")
	public void bad4(HttpServletRequest request) throws Exception {
		byte[] bytes = request.getParameter("data").getBytes();
		ByteArrayInputStream bis = new ByteArrayInputStream(bytes);
		HessianInput hessianInput = new HessianInput(bis);
		hessianInput.readObject(); //bad
		hessianInput.readObject(Object.class); //bad
	}

	@GetMapping(value = "hessian2")
	public void bad5(HttpServletRequest request) throws Exception {
		byte[] bytes = request.getParameter("data").getBytes();
		ByteArrayInputStream bis = new ByteArrayInputStream(bytes);
		Hessian2Input hessianInput = new Hessian2Input(bis);
		hessianInput.readObject(); //bad
		hessianInput.readObject(Object.class); //bad
	}
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 9e39c222ae... Increase castor and burlap detection
    
    @GetMapping(value = "castor")
	public void bad6(HttpServletRequest request) throws Exception {
		Unmarshaller unmarshaller = new Unmarshaller();
		unmarshaller.unmarshal(new StringReader(request.getParameter("data"))); //bad
	}

    @GetMapping(value = "burlap")
	public void bad7(HttpServletRequest request) throws Exception {
		byte[] serializedData = request.getParameter("data").getBytes();
		ByteArrayInputStream is = new ByteArrayInputStream(serializedData);
		BurlapInput burlapInput = new BurlapInput(is);
		burlapInput.readObject(); //bad

        BurlapInput burlapInput1 = new BurlapInput();
		burlapInput1.init(is);
		burlapInput1.readObject(); //bad
	}
<<<<<<< HEAD
=======
>>>>>>> 6738bf5186... Add UnsafeDeserialization sink
=======
>>>>>>> 9e39c222ae... Increase castor and burlap detection
}
