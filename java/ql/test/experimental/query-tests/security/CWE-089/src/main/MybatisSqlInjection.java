import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class MybatisSqlInjection {

	@Autowired
	private MybatisSqlInjectionService mybatisSqlInjectionService;

	@GetMapping(value = "msi1")
	public List<Test> bad1(@RequestParam String name) {
		List<Test> result = mybatisSqlInjectionService.bad1(name);
		return result;
	}

	@GetMapping(value = "msi2")
	public List<Test> bad2(@RequestParam String name) {
		List<Test> result = mybatisSqlInjectionService.bad2(name);
		return result;
	}

	@GetMapping(value = "msi3")
	public List<Test> bad3(@ModelAttribute Test test) {
		List<Test> result = mybatisSqlInjectionService.bad3(test);
		return result;
	}

	@RequestMapping(value = "msi4", method = RequestMethod.POST, produces = "application/json")
	public void bad4(@RequestBody Test test) {
		mybatisSqlInjectionService.bad4(test);
	}

	@RequestMapping(value = "msi5", method = RequestMethod.PUT, produces = "application/json")
	public void bad5(@RequestBody Test test) {
		mybatisSqlInjectionService.bad5(test);
	}

	@RequestMapping(value = "msi6", method = RequestMethod.POST, produces = "application/json")
	public void bad6(@RequestBody Map<String, String> params) {
		mybatisSqlInjectionService.bad6(params);
	}

	@RequestMapping(value = "msi7", method = RequestMethod.POST, produces = "application/json")
	public void bad7(@RequestBody List<String> params) {
		mybatisSqlInjectionService.bad7(params);
	}

	@RequestMapping(value = "msi8", method = RequestMethod.POST, produces = "application/json")
	public void bad8(@RequestBody String[] params) {
		mybatisSqlInjectionService.bad8(params);
	}

	@GetMapping(value = "msi9")
	public void bad9(@RequestParam String name) {
		mybatisSqlInjectionService.bad9(name);
	}

	@GetMapping(value = "good1")
	public List<Test> good1(Integer id) {
		List<Test> result = mybatisSqlInjectionService.good1(id);
		return result;
	}
}
