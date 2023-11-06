/**
 * Provides classes for modeling the `github.com/rs/cors` package.
 */

 import go

 /**
  * Provides classes for modeling the `github.com/rs/cors` package.
  */
 module RsCors {
   /** Gets the package name `github.com/gin-gonic/gin`. */
   string packagePath() { result = package("github.com/rs/cors", "") }
 
   /**
    * A new function create a new Handler that passed to handler chain as middleware
    */
   class New extends Function {
     New() { exists(Function f | f.hasQualifiedName(packagePath(), "New") | this = f) }
   }
 
   /**
    * A write to the value of Access-Control-Allow-Credentials header
    */
   class AllowCredentialsWrite extends DataFlow::ExprNode {
    RsOptions rs;
 
     AllowCredentialsWrite() {
       exists(Field f, Write w, DataFlow::Node base |
         f.hasQualifiedName(packagePath(), "Options", "AllowCredentials") and
         w.writesField(base, f, this) and
         this.getType() instanceof BoolType and
         (
           rs.getV().getBaseVariable().getDefinition().(SsaExplicitDefinition).getRhs() =
             base.asInstruction() or
           rs.getV().getAUse() = base
         )
       )
     }
 
     /**
      * Get config variable holding header values
      */
     RsOptions getConfig() { result = rs }
   }
 
   /**
    * A write to the value of Access-Control-Allow-Origins header
    */
   class AllowOriginsWrite extends DataFlow::ExprNode {
    RsOptions rs;
 
     AllowOriginsWrite() {
       exists(Field f, Write w, DataFlow::Node base |
         f.hasQualifiedName(packagePath(), "Options", "AllowedOrigins") and
         w.writesField(base, f, this) and
         this.asExpr() instanceof SliceLit and
         (
           rs.getV().getBaseVariable().getDefinition().(SsaExplicitDefinition).getRhs() =
             base.asInstruction() or
           rs.getV().getAUse() = base
         )
       )
     }
 
     /**
      * Get config variable holding header values
      */
     RsOptions getConfig() { result = rs }
   }
 
   /**
    * A write to the value of Access-Control-Allow-Origins of value "*", overriding AllowOrigins
    */
   class AllowAllOriginsWrite extends DataFlow::ExprNode {
    RsOptions rs;
 
     AllowAllOriginsWrite() {
       exists(Field f, Write w, DataFlow::Node base |
         f.hasQualifiedName(packagePath(), "Options", "AllowAllOrigins") and
         w.writesField(base, f, this) and
         this.getType() instanceof BoolType and
         (
           rs.getV().getBaseVariable().getDefinition().(SsaExplicitDefinition).getRhs() =
             base.asInstruction() or
           rs.getV().getAUse() = base
         )
       )
     }
 
     /**
      * Get config variable holding header values
      */
     RsOptions getConfig() { result = rs }
   }
 
   /**
    * A variable of type Config that holds the headers to be set.
    */
   class RsOptions extends Variable {
     SsaWithFields v;
 
     RsOptions() {
       this = v.getBaseVariable().getSourceVariable() and
       exists(Type t | t.hasQualifiedName(packagePath(), "Options") | v.getType() = t)
     }
 
     /**
      * Get variable declaration of RsOptions
      */
     SsaWithFields getV() { result = v }
   }
 }