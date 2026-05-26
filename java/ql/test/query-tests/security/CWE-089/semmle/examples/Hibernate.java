import org.hibernate.Session;
import org.hibernate.SharedSessionContract;
import org.hibernate.query.QueryProducer;

public class Hibernate {

  public static String source() { return null; }

  public static void test(
      Session session, SharedSessionContract sharedSessionContract, QueryProducer queryProducer) {
    session.createQuery(source()); // $ sqlInjection
    session.createSQLQuery(source()); // $ sqlInjection

    sharedSessionContract.createQuery(source()); // $ sqlInjection
    sharedSessionContract.createSQLQuery(source()); // $ sqlInjection

    queryProducer.createNativeQuery(source()); // $ sqlInjection
    queryProducer.createNativeMutationQuery(source()); // $ sqlInjection
    queryProducer.createQuery(source()); // $ sqlInjection
    queryProducer.createMutationQuery(source()); // $ sqlInjection
    queryProducer.createSelectionQuery(source()); // $ sqlInjection
    queryProducer.createSelectionQuery(source(), Object.class); // $ sqlInjection
    queryProducer.createSQLQuery(source()); // $ sqlInjection
  }
}
