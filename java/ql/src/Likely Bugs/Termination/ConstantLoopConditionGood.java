Object getField(Object obj, String name) throws NoSuchFieldError {
  Class clazz = obj.getClass();
  if (clazz != null) {
    for (Field f : clazz.getDeclaredFields()) {
      if (f.getName().equals(name)) {
        f.setAccessible(true);
        return f.get(obj);
      }
    }
  }
  throw new NoSuchFieldError(name);
}
