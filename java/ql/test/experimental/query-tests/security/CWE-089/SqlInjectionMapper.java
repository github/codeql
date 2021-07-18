import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

@Mapper
@Repository
public interface SqlInjectionMapper {

	List<Test> bad1(String name);

	List<Test> bad2(String name);

	List<Test> bad3(String name);

	void bad4(Test test);

	void bad5(Test test);

	List<Test> good1(Integer id);
}
