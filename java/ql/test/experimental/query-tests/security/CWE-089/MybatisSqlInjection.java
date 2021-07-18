import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class MybatisSqlInjection {

	@Autowired
	private MybatisSqlInjectionService mybatisSqlInjectionService;

	@GetMapping(value = "bad1")
	public List<Test> bad1(String name) {
		List<Test> result = mybatisSqlInjectionService.bad1(name);
		return result;
	}

	@GetMapping(value = "bad2")
	public List<Test> bad2(String name) {
		List<Test> result = mybatisSqlInjectionService.bad2(name);
		return result;
	}

	@GetMapping(value = "bad3")
	public List<Test> bad3(String name) {
		List<Test> result = mybatisSqlInjectionService.bad3(name);
		return result;
	}

	@RequestMapping(value = "bad4", method = RequestMethod.POST, produces = "application/json")
	public void bad4(@RequestBody Test test) {
		mybatisSqlInjectionService.bad4(test);
	}

	@RequestMapping(value = "bad5", method = RequestMethod.PUT, produces = "application/json")
	public void bad5(@RequestBody Test test) {
		mybatisSqlInjectionService.bad5(test);
	}

	@GetMapping(value = "good1")
	public List<Test> good1(Integer id) {
		List<Test> result = mybatisSqlInjectionService.good1(id);
		return result;
	}
}
