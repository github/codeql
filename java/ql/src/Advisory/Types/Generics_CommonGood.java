public <T> List<T> constructParameterizedList(T o) {
    List<T> list;  // Parameterized variable declaration
    list = new ArrayList<T>();  // Parameterized constructor call
    list.add(o);
    return list;  // Parameterized method return type (see signature above)
}