/** Provides models of commonly used functions and types in the gqlgen packages. */

import go

/** Provides models of commonly used functions and types in the gqlgen packages. */
module Gqlgen {
  class GqlgenGeneratedFile extends File {
    GqlgenGeneratedFile() {
      exists(DataFlow::CallNode call |
        call.getReceiver().getType().hasQualifiedName("github.com/99designs/gqlgen/graphql", _) and
        call.getFile() = this
      )
    }
  }

  class ResolverInterface extends Type {
    ResolverInterface() {
      this.getQualifiedName().matches("%Resolver") and
      this.getEntity().getDeclaration().getFile() instanceof GqlgenGeneratedFile
    }
  }

  class ResolverInterfaceMethod extends Method {
    ResolverInterfaceMethod() {
      this.getReceiver().getType() instanceof ResolverInterface
    }
  }

  class ResolverImplementationMethod extends Method {
    ResolverImplementationMethod() { this.implements(any(ResolverInterfaceMethod r)) }
     
    Parameter getAnUntrustedParameter() {
      result.getFunction() = this.getFuncDecl() and
      not result.getType().hasQualifiedName("context", "Context") and
      result.getIndex() > 0
    }
  }

  class ResolverParameter extends UntrustedFlowSource::Range instanceof DataFlow::ParameterNode {
    ResolverParameter() {
      this.asParameter() = any(ResolverImplementationMethod h).getAnUntrustedParameter()
    }
  }
}
