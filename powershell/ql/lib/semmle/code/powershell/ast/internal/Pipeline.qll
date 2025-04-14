private import AstImport

class Pipeline extends Expr, TPipeline {
  override string toString() {
    if this.getNumberOfComponents() = 1
    then result = this.getComponent(0).toString()
    else result = "...|..."
  }

  Expr getComponent(int i) {
    exists(ChildIndex index, Raw::Ast r | index = pipelineComp(i) and r = getRawAst(this) |
      synthChild(r, index, result)
      or
      not synthChild(r, index, _) and
      result = getResultAst(r.(Raw::Pipeline).getComponent(i))
    )
  }

  final override Ast getChild(ChildIndex i) {
    result = super.getChild(i)
    or
    exists(int index |
      i = pipelineComp(index) and
      result = this.getComponent(index)
    )
  }

  Expr getAComponent() { result = this.getComponent(_) }

  int getNumberOfComponents() { result = getRawAst(this).(Raw::Pipeline).getNumberOfComponents() }

  Expr getLastComponent() {
    exists(int i |
      result = this.getComponent(i) and
      not exists(this.getComponent(i + 1))
    )
  }
}
