import java.util.List;
import java.util.Map;
import java.util.HashMap;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class MybatisSqlInjectionService {

	@Autowired
	private SqlInjectionMapper sqlInjectionMapper;

	public List<Test> bad1(String name) {
		List<Test> result = sqlInjectionMapper.bad1(name);
		return result;
	}

	public List<Test> bad2(String name) {
		List<Test> result = sqlInjectionMapper.bad2(name);
		return result;
	}

	public List<Test> bad3(Test test) {
		List<Test> result = sqlInjectionMapper.bad3(test);
		return result;
	}

	public void bad4(Test test) {
		sqlInjectionMapper.bad4(test);
	}

	public void bad5(Test test) {
		sqlInjectionMapper.bad5(test);
	}

	public void bad6(Map<String, String> params) {
		sqlInjectionMapper.bad6(params);
	}

	public void bad7(List<String> params) {
		sqlInjectionMapper.bad7(params);
	}

	public void bad8(String[] params) {
		sqlInjectionMapper.bad8(params);
	}

	public void bad9(String name) {
		HashMap hashMap = new HashMap();
		hashMap.put("name", name);
		sqlInjectionMapper.bad9(hashMap);
	}

	public List<Test> good1(Integer id) {
		List<Test> result = sqlInjectionMapper.good1(id);
		return result;
	}
}
