import csharp

/** Provides definitions related to the namespace `ServiceStack`. */
module ServiceStack {
    class ServiceClass extends Class {
        ServiceClass() { this.getBaseClass+().getName()="Service" }
    }
          
    class ServiceStackRequestClass extends Class {
        ServiceStackRequestClass() {
            // Classes directly used in as param to request method
            exists(Method m |
                serviceStackRequests(m) and
                this = m.getAParameter().getType()) or
            // Classes of a property or field on another request class
            exists(ServiceStackRequestClass outer |
                this = outer.getAProperty().getType() or
                this = outer.getAField().getType())
        }
    }
    
    predicate serviceStackRequests(Method m) {
        exists(ValueOrRefType type, ServiceClass ssc |
            type.fromSource() and
            m = type.getAMethod() and
            m = ssc.getAMember().getDeclaringType().getAMethod() and
    
            // verify other verb methods in service stack docs
            m.getName() = ["Post","Get", "Put", "Delete","Any", "Option", "Head"]
            // not reccommended match approach below
            //.toLowerCase().regexpMatch("(Post|Get|Put|Delete)")
    
        )
    }
}

/** Flow sources for the ServiceStack framework */
module Sources {
    private import ServiceStack::ServiceStack
    private import semmle.code.csharp.security.dataflow.flowsources.Remote

    class ServiceClassSources extends RemoteFlowSource {
        ServiceClassSources() { 
            exists(Method m | 
                serviceStackRequests(m) and
                // keep this for primitive typed request params (string/int)
                this.asParameter() = m.getAParameter()) or
            exists(ServiceStackRequestClass reqClass |
                // look for field reads on request classes
                reqClass.getAProperty().getAnAccess() = this.asExpr() or
                reqClass.getAField().getAnAccess() = this.asExpr())
        }
      
        override string getSourceType() {
            result = "ServiceStackSources"
        }
    }
}

/** SQL sinks for the ServiceStack framework */
module SQL {
    private import ServiceStack::ServiceStack
    private import semmle.code.csharp.security.dataflow.SqlInjection::SqlInjection
      
    class SqlSinks extends Sink {
        SqlSinks() { this.asExpr() instanceof SqlInjectionExpr }
    }
      
    class SqlStringMethod extends Method {
        SqlStringMethod() {
            this.getName() in [
                "Custom", "CustomSelect", "CustomInsert", "CustomUpdate",
                "SqlScalar", "SqlList", "SqlColumn", "ColumnDistinct",
                "PreCreateTable", "PostCreateTable", "PreDropTable", "PostDropTable",
                "ExecuteSql", "ExecuteSqlAsync",
                "UnsafeSelect", "UnsafeFrom", "UnsafeWhere", "UnsafeAnd", "UnsafeOr"
            ]  
        }
    }
      
    class SqlInjectionExpr extends Expr {
        SqlInjectionExpr() {
            exists(MethodCall mc |
                mc.getTarget() instanceof SqlStringMethod and mc.getArgument(1) = this
            )
        }
    }
}

/** XSS sinks for the ServiceStack framework */
module XSS {
    private import ServiceStack::ServiceStack
    private import semmle.code.csharp.security.dataflow.XSS::XSS

    class XssSinks extends Sink {
        XssSinks() { this.asExpr() instanceof XssExpr }
    }

    class XssExpr extends Expr {
        XssExpr() {
            exists(ReturnStmt r |
                this = r.getExpr() and
                (
                    (
                        r.getExpr().(ObjectCreation).getType().hasName("HttpResult")
                        //TODO write a content type check for this decorated version
                    ) 
                    or 
                    (
                        r.getExpr().getType() instanceof StringType
                    )
                )
            )
        }
    }
}
