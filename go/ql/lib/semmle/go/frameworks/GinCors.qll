/**
 * Provides classes for modeling the `github.com/gin-contrib/cors` package.
 */

import go

/**
 * Provides classes for modeling the `github.com/gin-contrib/cors` package.
 */
module GinCors {
  /** Gets the package name `github.com/gin-gonic/gin`. */
  string packagePath() { result = package("github.com/gin-contrib/cors", "") }

  /**
   * A new function create a new gin Handler that passed to gin as middleware
   */
  class New extends Function {
    New() { exists(Function f | f.hasQualifiedName(packagePath(), "New") | this = f) }
  }

  /**
   * A write to the value of Access-Control-Allow-Credentials header
   */
  class AllowCredentialsWrite extends UniversalAllowCredentialsWrite {
    DataFlow::Node base;

    AllowCredentialsWrite() {
      exists(Field f, Write w |
        f.hasQualifiedName(packagePath(), "Config", "AllowCredentials") and
        w.writesField(base, f, this) and
        this.getType() instanceof BoolType
      )
    }

    /**
     * Get config struct holding header values
     */
    override DataFlow::Node getBase() { result = base }

    /**
     * Get config variable holding header values
     */
    override GinConfig getConfig() {
      exists(GinConfig gc |
        (
          gc.getV().getBaseVariable().getDefinition().(SsaExplicitDefinition).getRhs() =
            base.asInstruction() or
          gc.getV().getAUse() = base
        ) and
        result = gc
      )
    }
  }

  /**
   * A write to the value of Access-Control-Allow-Origins header
   */
  class AllowOriginsWrite extends UniversalOriginWrite {
    DataFlow::Node base;

    AllowOriginsWrite() {
      exists(Field f, Write w |
        f.hasQualifiedName(packagePath(), "Config", "AllowOrigins") and
        w.writesField(base, f, this) and
        this.asExpr() instanceof SliceLit
      )
    }

    /**
     * Get config struct holding header values
     */
    override DataFlow::Node getBase() { result = base }

    /**
     * Get config variable holding header values
     */
    override GinConfig getConfig() {
      exists(GinConfig gc |
        (
          gc.getV().getBaseVariable().getDefinition().(SsaExplicitDefinition).getRhs() =
            base.asInstruction() or
          gc.getV().getAUse() = base
        ) and
        result = gc
      )
    }
  }

  /**
   * A write to the value of Access-Control-Allow-Origins of value "*", overriding AllowOrigins
   */
  class AllowAllOriginsWrite extends UniversalAllowAllOriginsWrite {
    DataFlow::Node base;

    AllowAllOriginsWrite() {
      exists(Field f, Write w |
        f.hasQualifiedName(packagePath(), "Config", "AllowAllOrigins") and
        w.writesField(base, f, this) and
        this.getType() instanceof BoolType
      )
    }

    /**
     * Get config struct holding header values
     */
    override DataFlow::Node getBase() { result = base }

    /**
     * Get config variable holding header values
     */
    override GinConfig getConfig() {
      exists(GinConfig gc |
        (
          gc.getV().getBaseVariable().getDefinition().(SsaExplicitDefinition).getRhs() =
            base.asInstruction() or
          gc.getV().getAUse() = base
        ) and
        result = gc
      )
    }
  }

  /**
   * A variable of type Config that holds the headers to be set.
   */
  class GinConfig extends Variable {
    SsaWithFields v;

    GinConfig() {
      this = v.getBaseVariable().getSourceVariable() and
      v.getType().hasQualifiedName(packagePath(), "Config")
    }

    /**
     * Get variable declaration of GinConfig
     */
    SsaWithFields getV() { result = v }
  }
}
