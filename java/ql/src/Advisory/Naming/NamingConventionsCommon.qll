import java

class ConstantField extends Field {
  ConstantField() {
    this.isStatic() and
    this.isFinal()
  }
}
