import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class MyBatisService {

	@Autowired
	private MyBatisMapper myBatisMapper;

	public void bad7(String name) {
		myBatisMapper.bad7(name);
	}

	public void badDelete(String input) {
		myBatisMapper.badDelete(input);
	}

	public void badUpdate(String input) {
		myBatisMapper.badUpdate(input);
	}

	public void badInsert(String input) {
		myBatisMapper.badInsert(input);
	}

	public void bad8(int id){
		myBatisMapper.bad8(id);
	}

	public void bad9(String user){
		myBatisMapper.bad9(user);
	}

	public void bad10(String user){
		myBatisMapper.bad10(user);
	}
}
