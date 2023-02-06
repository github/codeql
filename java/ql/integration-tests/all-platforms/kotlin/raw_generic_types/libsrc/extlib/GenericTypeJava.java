package extlib;

import java.util.*;

class BoundJava {}

class InheritsGenericJava<T, S extends BoundJava> { }

public class GenericTypeJava<T, S extends BoundJava> extends InheritsGenericJava<T, S> { 
  public static GenericTypeJava getRaw() { return new GenericTypeJava(); }
}

