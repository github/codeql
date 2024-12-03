import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;
import org.apache.ibatis.annotations.DeleteProvider;
import org.apache.ibatis.annotations.UpdateProvider;
import org.apache.ibatis.annotations.InsertProvider;

@Mapper
@Repository
public interface MyBatisMapper {

	void bad7(String name);

	//using providers
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
