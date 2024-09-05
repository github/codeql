fun user(hp: HasProps) {

  fun useGetters() = hp.accessorsPublic + hp.setterPrivate

  fun useSetter(x: Int) {
    hp.accessorsPublic = x
  }

}
