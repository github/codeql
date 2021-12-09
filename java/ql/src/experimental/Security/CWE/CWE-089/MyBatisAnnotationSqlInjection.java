import org.apache.ibatis.annotations.Select;

public interface MyBatisAnnotationSqlInjection {

    @Select("select * from test where name = ${name}")
	public Test bad1(String name);

    @Select("select * from test where name = #{name}")
	public Test good1(String name);
}