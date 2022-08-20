public class MybatisXmlSqlTaintedInParamExample {
    @GetMapping("/getUserByUsername")
    public User getUserByUsername(String username){
        return userDao.getUserByUsername(username);
    }
}

public class UserDAOImpl {
    @Override
    public User getUserByUsername(String username) {
        return userMapper.getUserByUsername(username);
    }
}

@Mapper
public interface UserMapper {
    User getUserByUsername(String username);
} 

Mapper.xml
/**
 * bad example
 */
<select id="getUserByUsername" resultMap="BaseResultMap">
    select
        <include refid="BaseColumnList"></include>
    from userentity
    where username = ${username}
</select>

/**
 * good example
 */
<select id="getUserByUsername" resultMap="BaseResultMap">
    select
        <include refid="BaseColumnList"></include>
    from userentity
    where username = #{username}
</select>
