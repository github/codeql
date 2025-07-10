import java.util.HashMap;
import java.io.StringReader;
import javax.servlet.http.HttpServletRequest;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import com.cedarsoftware.util.io.JsonReader;
import com.esotericsoftware.yamlbeans.YamlReader;
import org.ho.yaml.Yaml;
import org.ho.yaml.YamlConfig;
import org.exolab.castor.xml.Unmarshaller;
import com.caucho.hessian.io.Hessian2Input;
import com.caucho.hessian.io.HessianInput;
import com.caucho.burlap.io.BurlapInput;
import com.caucho.hessian.io.Hessian2Input;
import com.caucho.hessian.io.HessianInput;
import java.io.ByteArrayInputStream;

@Controller
public class C {

	@GetMapping(value = "jyaml")
	public void bad1(HttpServletRequest request) throws Exception {
		String data = request.getParameter("data");
		Yaml.load(data);  // $unsafeDeserialization
		Yaml.loadStream(data);  // $unsafeDeserialization
		Yaml.loadStreamOfType(data, Object.class);  // $unsafeDeserialization
		Yaml.loadType(data, Object.class);  // $unsafeDeserialization

		org.ho.yaml.YamlConfig yamlConfig = new YamlConfig();
		yamlConfig.load(data);  // $unsafeDeserialization
		yamlConfig.loadStream(data);  // $unsafeDeserialization
		yamlConfig.loadStreamOfType(data, Object.class);  // $unsafeDeserialization
		yamlConfig.loadType(data, Object.class);  // $unsafeDeserialization
	}

	@GetMapping(value = "jsonio")
	public void bad2(HttpServletRequest request) {
		String data = request.getParameter("data");

		HashMap hashMap = new HashMap();
		hashMap.put("USE_MAPS", true);

		JsonReader.jsonToJava(data); // $unsafeDeserialization

		JsonReader jr = new JsonReader(data, null);
		jr.readObject(); // $unsafeDeserialization
	}

	@GetMapping(value = "yamlbeans")
	public void bad3(HttpServletRequest request) throws Exception {
		String data = request.getParameter("data");
		YamlReader r = new YamlReader(data);
		r.read(); // $unsafeDeserialization
		r.read(Object.class); // $unsafeDeserialization
		r.read(Object.class, Object.class); // $unsafeDeserialization
	}

        @GetMapping(value = "hessian")
	public void bad4(HttpServletRequest request) throws Exception {
		byte[] bytes = request.getParameter("data").getBytes();
		ByteArrayInputStream bis = new ByteArrayInputStream(bytes);
		HessianInput hessianInput = new HessianInput(bis);
		hessianInput.readObject(); // $unsafeDeserialization
		hessianInput.readObject(Object.class); // $unsafeDeserialization
	}

	@GetMapping(value = "hessian2")
	public void bad5(HttpServletRequest request) throws Exception {
		byte[] bytes = request.getParameter("data").getBytes();
		ByteArrayInputStream bis = new ByteArrayInputStream(bytes);
		Hessian2Input hessianInput = new Hessian2Input(bis);
		hessianInput.readObject(); // $unsafeDeserialization
		hessianInput.readObject(Object.class); // $unsafeDeserialization
	}

    @GetMapping(value = "castor")
	public void bad6(HttpServletRequest request) throws Exception {
		Unmarshaller unmarshaller = new Unmarshaller();
		unmarshaller.unmarshal(new StringReader(request.getParameter("data"))); // $unsafeDeserialization
	}

    @GetMapping(value = "burlap")
	public void bad7(HttpServletRequest request) throws Exception {
		byte[] serializedData = request.getParameter("data").getBytes();
		ByteArrayInputStream is = new ByteArrayInputStream(serializedData);
		BurlapInput burlapInput = new BurlapInput(is);
		burlapInput.readObject(); // $unsafeDeserialization

        BurlapInput burlapInput1 = new BurlapInput();
		burlapInput1.init(is);
		burlapInput1.readObject(); // $unsafeDeserialization
	}

	@GetMapping(value = "jsonio1")
	public void good1(HttpServletRequest request) {
		String data = request.getParameter("data");

		HashMap hashMap = new HashMap();
		hashMap.put("USE_MAPS", true);

		JsonReader.jsonToJava(data, hashMap); //good
	}

	@GetMapping(value = "jsonio2")
	public void good2(HttpServletRequest request) {
		String data = request.getParameter("data");

		HashMap hashMap = new HashMap();
		hashMap.put("USE_MAPS", true);

		JsonReader jr1 = new JsonReader(data, hashMap); //good
		jr1.readObject();
	}
}
