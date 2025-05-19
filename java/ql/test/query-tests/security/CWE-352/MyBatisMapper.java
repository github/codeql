import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;
import org.apache.ibatis.annotations.DeleteProvider;
import org.apache.ibatis.annotations.UpdateProvider;
import org.apache.ibatis.annotations.InsertProvider;
import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Update;
import org.apache.ibatis.annotations.Insert;

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

	@Delete("DELETE FROM users WHERE id = #{id}")
   	boolean bad8(int id);

	@Insert("INSERT INTO users (id, name) VALUES(#{id}, #{name})")
   	void bad9(String user);

	@Update("UPDATE users SET name = #{name} WHERE id = #{id}")
   	boolean bad10(String user);
}
