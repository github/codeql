/**
 * Provides classes for working with untrusted flow sources from the `github.com/gin-gonic/gin` package.
 */

 import go

  module GinCors {
   /** Gets the package name `github.com/gin-gonic/gin`. */
   string packagePath() { result = package("github.com/gin-contrib/cors", "") }
 
   /**
    * Data from a `Context` struct, considered as a source of untrusted flow.
    */
     class New extends Function{
        New() {
            exists(Function f | f.hasQualifiedName(packagePath(), "New") | this = f)
        }

   }
   class Config extends Variable {
    Config() { this.hasQualifiedName(packagePath(), "Config") }

    // Field getAllowCredentials() {
    //     result = this.getField("AllowCredentials")
    // }
  }
   class AllowCredentialsWrite extends DataFlow::ExprNode {
    DataFlow::Node base;
    GinConfig gc;
    AllowCredentialsWrite() {
      exists(Field f, Write w |
        f.hasQualifiedName(packagePath(), "Config", "AllowCredentials") and
        w.writesField(base, f, this) and
        this.getType() instanceof BoolType and
        (gc.getV().getBaseVariable().getDefinition().(SsaExplicitDefinition).getRhs() = base.asInstruction() or
        gc.getV().getAUse() = base)
      )
    }
    GinConfig getConfig() { result =  gc}
  }
   class AllowOriginsWrite extends DataFlow::ExprNode {
    DataFlow::Node base;
    GinConfig gc;
    AllowOriginsWrite() {
      exists(Field f, Write w |
        f.hasQualifiedName(packagePath(), "Config", "AllowOrigins") and
        w.writesField(base, f, this) and
        this.asExpr() instanceof SliceLit and
        (gc.getV().getBaseVariable().getDefinition().(SsaExplicitDefinition).getRhs() = base.asInstruction() or
        gc.getV().getAUse() = base)
      )
    }
    GinConfig getConfig() { result = gc}
  }
  class AllowAllOriginsWrite extends DataFlow::ExprNode {
    DataFlow::Node base;

    AllowAllOriginsWrite() {
      exists(Field f, Write w |
        f.hasQualifiedName(packagePath(), "Config", "AllowAllOrigins") and
        w.writesField(base, f, this) and
        this.getType() instanceof BoolType 
        //and this.asExpr().(SliceLit).getAnElement().toString().matches("%null%")
      )
    }
    DataFlow::Node getBase() { result = base}
  }

   class GinConfig extends Variable {
    SsaWithFields v;

    GinConfig() {
      this = v.getBaseVariable().getSourceVariable() and
      exists(Type t | t.hasQualifiedName(packagePath(), "Config") | v.getType() = t)
    }
    SsaWithFields getV() { result = v}
  }
 
 }
 