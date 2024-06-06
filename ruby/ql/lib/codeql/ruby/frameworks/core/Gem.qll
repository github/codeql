/**
 * Provides modeling for the `Gem` module and `.gemspec` files.
 */

private import ruby
private import Ast
private import codeql.ruby.ApiGraphs

/** Provides modeling for the `Gem` module and `.gemspec` files. */
module Gem {
  /**
   * A .gemspec file that lists properties of a Ruby gem.
   * The contents of a .gemspec file generally look like:
   * ```Ruby
   * Gem::Specification.new do |s|
   *   s.name = 'library-name'
   *   s.require_path = "lib"
   *   # more properties
   * end
   * ```
   */
  class GemSpec instanceof File {
    API::Node specCall;

    GemSpec() {
      this.getExtension() = "gemspec" and
      specCall = API::getTopLevelMember("Gem").getMember("Specification").getMethod("new") and
      specCall.getLocation().getFile() = this
    }

    /** Gets the name of this .gemspec file. */
    string toString() { result = File.super.getBaseName() }

    /**
     * Gets a value of the `name` property of this .gemspec file.
     * These properties are set using the `Gem::Specification.new` method.
     */
    private Expr getSpecProperty(string name) {
      exists(Expr rhs |
        rhs =
          specCall
              .getBlock()
              .getParameter(0)
              .getMethod(name + "=")
              .getArgument(0)
              .asSink()
              .asExpr()
              .getExpr()
              .(Ast::AssignExpr)
              .getRightOperand()
      |
        result = rhs
        or
        // some properties are arrays, we just unfold them
        result = rhs.(ArrayLiteral).getAnElement()
      )
    }

    /** Gets the name of the gem */
    string getName() {
      result = this.getSpecProperty("name").getConstantValue().getString() or
      result = specCall.getArgument(0).getAValueReachingSink().getConstantValue().getString()
    }

    /** Gets a path that is loaded when the gem is required */
    private string getARequirePath() {
      result =
        this.getSpecProperty(["require_paths", "require_path"]).getConstantValue().getString()
      or
      not exists(
        this.getSpecProperty(["require_paths", "require_path"]).getConstantValue().getString()
      ) and
      result = "lib" // the default is "lib"
    }

    /** Gets a file that could be loaded when the gem is required. */
    private File getAPossiblyRequiredFile() {
      result =
        File.super.getParentContainer().getFolder(this.getARequirePath()).getAChildContainer*()
    }

    /** Gets a class/module that is exported by this gem. */
    private ModuleBase getAPublicModule() {
      result.(Toplevel).getLocation().getFile() = this.getAPossiblyRequiredFile()
      or
      result = this.getAPublicModule().getAModule()
      or
      result = this.getAPublicModule().getAClass()
      or
      result = this.getAPublicModule().getStmt(_).(SingletonClass)
    }

    /** Gets a parameter from an exported method, which is an input to this gem. */
    DataFlow::ParameterNode getAnInputParameter() {
      exists(MethodBase method |
        method = this.getAPublicModule().getAMethod() and
        result.getParameter() = method.getAParameter()
      |
        method.isPublic()
        or
        method.isProtected()
      )
    }
  }

  /** Gets a parameter that is an input to a named gem. */
  DataFlow::ParameterNode getALibraryInput() {
    exists(GemSpec spec |
      exists(spec.getName()) and // we only consider `.gemspec` files that have a name
      result = spec.getAnInputParameter()
    )
  }
}
