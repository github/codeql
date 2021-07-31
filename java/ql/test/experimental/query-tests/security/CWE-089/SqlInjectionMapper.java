import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

@Mapper
@Repository
public interface SqlInjectionMapper {

	List<Test> bad1(String name);

	List<Test> bad2(@Param("orderby") String name);

	List<Test> bad3(Test test);

	void bad4(@Param("test") Test test);

	void bad5(Test test);

	List<Test> good1(Integer id);
}
