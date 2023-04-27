// Generated automatically from javax.jdo.datastore.Sequence for testing purposes

package javax.jdo.datastore;


public interface Sequence
{
    Object current();
    Object next();
    String getName();
    long currentValue();
    long nextValue();
    void allocate(int p0);
}
