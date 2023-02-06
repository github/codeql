import org.springframework.data.repository.CrudRepository;

class Struct {
  public String field;
  public Struct(String f){
    this.field = f;
  }
}

public class Test {
  String source() { return null; }
  void sink(Object o) {}

  void testCrudRepository(CrudRepository<Struct, Integer> cr) {
    Struct s = new Struct(source());
    s = cr.save(s);
    sink(s.field); //$hasValueFlow
  }
}
