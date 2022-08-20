import java.util.List;
import java.util.Map;
import java.util.HashMap;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.SelectProvider;
import org.apache.ibatis.annotations.DeleteProvider;
import org.apache.ibatis.annotations.UpdateProvider;
import org.apache.ibatis.annotations.InsertProvider;

@Mapper
@Repository
public interface SqlInjectionMapper {

	List<Test> bad1(String name);

	List<Test> bad2(@Param("orderby") String name);

	List<Test> bad3(Test test);

	void bad4(@Param("test") Test test);

	void bad5(Test test);

	void bad6(Map<String, String> params);

	void bad7(List<String> params);

	void bad8(String[] params);

	@Select({"select * from test", "where id = ${name}"})
	public Test bad9(HashMap<String, Object> map);

	List<Test> good1(Integer id);

	//using providers
	@SelectProvider(
		type = MyBatisProvider.class,
		method = "badSelect"
	)
	String badSelect(String input);

	@DeleteProvider(
		type = MyBatisProvider.class,
		method = "badDelete"
	)
	void badDelete(String input);

	@UpdateProvider(
		type = MyBatisProvider.class,
		method = "badUpdate"
	)
	void badUpdate(String input);

	@InsertProvider(
		type = MyBatisProvider.class,
		method = "badInsert"
	)
	void badInsert(String input);
}
