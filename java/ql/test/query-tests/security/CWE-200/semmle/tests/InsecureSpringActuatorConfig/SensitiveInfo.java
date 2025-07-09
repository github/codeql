import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class SensitiveInfo {
	@RequestMapping
	public void handleLogin(@RequestParam String username, @RequestParam String password) throws Exception {
		if (!username.equals("") && password.equals("")) {
			//Blank processing
		}
	}
}