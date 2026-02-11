import jakarta.persistence.EntityManager;

public class JakartaPersistence {

  public static String source() { return null; }

  public static void test(EntityManager entityManager) {

    entityManager.createNativeQuery(source()); // $ sqlInjection

  }

}
