import java.util.List;
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

	public List<Test> bad3(String name) {
		List<Test> result = sqlInjectionMapper.bad3(name);
		return result;
	}

	public void bad4(Test test) {
		sqlInjectionMapper.bad4(test);
	}

	public void bad5(Test test) {
		sqlInjectionMapper.bad5(test);
	}

	public List<Test> good1(Integer id) {
		List<Test> result = sqlInjectionMapper.good1(id);
		return result;
	}
}
