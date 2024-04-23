import cpp

class StringVariable extends Variable {
  StringVariable() {
    this.getType().(PointerType).stripType().getName() = "char"
  }
}

class StringField extends StringVariable, Field
{
}

class StringParameter extends StringVariable, Parameter
{
}

from StringVariable f
where f.getFile().getRelativePath().matches("c/extractor/src/%")
and not f.getASpecifier().getName() = "extern"
select f, f.getFile().getRelativePath()
