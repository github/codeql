/** Provides classes for modeling the `github.com/rs/cors` package. */

import go

/** An abstract class for modeling the Go CORS handler model origin write. */
abstract class UniversalOriginWrite extends DataFlow::ExprNode {
  /** Gets the config variable holding header values. */
  abstract DataFlow::Node getBase();

  /** Gets the config variable holding header values. */
  abstract Variable getConfig();
}

/**
 * An abstract class for modeling the Go CORS handler model allow all origins
 * write.
 */
abstract class UniversalAllowAllOriginsWrite extends DataFlow::ExprNode {
  /** Gets the config variable holding header values. */
  abstract DataFlow::Node getBase();

  /** Gets the config variable holding header values. */
  abstract Variable getConfig();
}

/**
 * An abstract class for modeling the Go CORS handler model allow credentials
 * write.
 */
abstract class UniversalAllowCredentialsWrite extends DataFlow::ExprNode {
  /** Gets the config struct holding header values. */
  abstract DataFlow::Node getBase();

  /** Gets the config variable holding header values. */
  abstract Variable getConfig();
}

/** Provides classes for modeling the `github.com/rs/cors` package. */
module RsCors {
  /** Gets the package name `github.com/gin-gonic/gin`. */
  string packagePath() { result = package("github.com/rs/cors", "") }

  /** The `New` function that creates a new rs Handler. */
  class New extends Function {
    New() { exists(Function f | f.hasQualifiedName(packagePath(), "New") | this = f) }
  }

  /**
   * A write to the value of Access-Control-Allow-Credentials header.
   */
  class AllowCredentialsWrite extends UniversalAllowCredentialsWrite {
    DataFlow::Node base;

    AllowCredentialsWrite() {
      exists(Field f, Write w |
        f.hasQualifiedName(packagePath(), "Options", "AllowCredentials") and
        w.writesField(base, f, this) and
        this.getType() instanceof BoolType
      )
    }

    /** Gets the options struct holding header values. */
    override DataFlow::Node getBase() { result = base }

    /** Gets the options variable holding header values. */
    override RsOptions getConfig() {
      exists(RsOptions gc |
        (
          gc.getV().getBaseVariable().getDefinition().(SsaExplicitDefinition).getRhs() =
            base.asInstruction() or
          gc.getV().getAUse() = base
        ) and
        result = gc
      )
    }
  }

  /** A write to the value of Access-Control-Allow-Origins header. */
  class AllowOriginsWrite extends UniversalOriginWrite {
    DataFlow::Node base;

    AllowOriginsWrite() {
      exists(Field f, Write w |
        f.hasQualifiedName(packagePath(), "Options", "AllowedOrigins") and
        w.writesField(base, f, this) and
        this.asExpr() instanceof SliceLit
      )
    }

    /** Gets the options struct holding header values. */
    override DataFlow::Node getBase() { result = base }

    /** Gets the options variable holding header values. */
    override RsOptions getConfig() {
      exists(RsOptions gc |
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
   * A write to the value of Access-Control-Allow-Origins of value "*",
   * overriding `AllowOrigins`.
   */
  class AllowAllOriginsWrite extends UniversalAllowAllOriginsWrite {
    DataFlow::Node base;

    AllowAllOriginsWrite() {
      exists(Field f, Write w |
        f.hasQualifiedName(packagePath(), "Options", "AllowAllOrigins") and
        w.writesField(base, f, this) and
        this.getType() instanceof BoolType
      )
    }

    /** Gets the options struct holding header values. */
    override DataFlow::Node getBase() { result = base }

    /** Gets options variable holding header values. */
    override RsOptions getConfig() {
      exists(RsOptions gc |
        (
          gc.getV().getBaseVariable().getDefinition().(SsaExplicitDefinition).getRhs() =
            base.asInstruction() or
          gc.getV().getAUse() = base
        ) and
        result = gc
      )
    }
  }

  /** A variable of type Options that holds the headers to be set. */
  class RsOptions extends Variable {
    SsaWithFields v;

    RsOptions() {
      this = v.getBaseVariable().getSourceVariable() and
      v.getType().hasQualifiedName(packagePath(), "Options")
    }

    /** Gets the SSA variable declaration of Options. */
    SsaWithFields getV() { result = v }
  }
}
