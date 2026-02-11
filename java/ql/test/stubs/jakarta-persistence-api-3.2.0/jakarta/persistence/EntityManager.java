package jakarta.persistence;

public interface EntityManager extends AutoCloseable {

  Query createNativeQuery(String sqlString);

}
