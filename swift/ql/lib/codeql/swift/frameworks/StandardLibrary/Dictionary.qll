import swift

class CanonicalDictionaryType extends BoundGenericType {
    CanonicalDictionaryType() {
        this.getName().matches("Dictionary<%")
    }
}
