package extlib;

import java.util.*;

class BoundKotlin {}

class InheritsGenericKotlin<T, S extends BoundKotlin> { }

public class GenericTypeKotlin<T, S extends BoundKotlin> extends InheritsGenericKotlin<T, S> { 
  public static GenericTypeKotlin getRaw() { return new GenericTypeKotlin(); }
}

