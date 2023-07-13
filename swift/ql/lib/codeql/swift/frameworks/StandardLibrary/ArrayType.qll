import swift

class ArrayType extends BoundGenericType {
    ArrayType() {
        this.getName().matches("Array<%")
    }
}
