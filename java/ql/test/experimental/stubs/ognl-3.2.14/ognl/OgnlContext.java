package ognl;

import java.util.*;

public class OgnlContext extends Object implements Map {
  @Override
  public int size() {
      return 0;
  }

  @Override
  public boolean isEmpty() {
      return false;
  }

  @Override
  public boolean containsKey(Object key) {
      return true;
  }

  @Override
  public boolean containsValue(Object value) {
      return true;
  }

  @Override
  public Object get(Object key) {
    return new Object();
  }

  @Override
  public Object put(Object key, Object value) {
    return new Object();
  }

  @Override
  public Object remove(Object key) {
    return new Object();
  }

  @Override
  public void putAll(Map t) { }

  @Override
  public void clear() {}

  @Override
  public Set keySet() {
    return new HashSet();
  }

  @Override
  public Collection values() {
    return new HashSet();
  }

  @Override
  public Set entrySet() {
    return new HashSet();
  }

  @Override
  public boolean equals(Object o) {
    return true;
  }

  @Override
  public int hashCode() {
    return 0;
  }
}