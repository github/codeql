/**
 * Provides classes for modeling the `graphql` gem.
 */

private import codeql.ruby.AST
private import codeql.ruby.Concepts
private import codeql.ruby.controlflow.CfgNodes
private import codeql.ruby.DataFlow
private import codeql.ruby.dataflow.RemoteFlowSources
private import codeql.ruby.ast.internal.Module
private import codeql.ruby.ApiGraphs

private API::Node graphQlSchema() { result = API::getTopLevelMember("GraphQL").getMember("Schema") }

/**
 * A `ClassDeclaration` for a class that extends `GraphQL::Schema::RelayClassicMutation`.
 * For example,
 *
 * ```rb
 * module Mutations
 *   class BaseMutation < GraphQL::Schema::RelayClassicMutation
 *     argument_class Types::BaseArgument
 *     field_class Types::BaseField
 *     input_object_class Types::BaseInputObject
 *     object_class Types::BaseObject
 *   end
 * end
 *
 * module Mutation
 *   class MyMutation < BaseMutation
 *     argument :something_id, ID, required: false
 *     field :success, Boolean, null: false
 *
 *     def resolve(something_id:)
 *       # call your application logic here...
 *     end
 *   end
 * end
 * ```
 */
private class GraphqlRelayClassicMutationClass extends ClassDeclaration {
  GraphqlRelayClassicMutationClass() {
    this.getSuperclassExpr() =
      graphQlSchema().getMember("RelayClassicMutation").getASubclass*().getAUse().asExpr().getExpr()
  }
}

/**
 * A `ClassDeclaration` for a class that extends `GraphQL::Schema::Resolver`.
 * For example,
 *
 * ```rb
 * module Resolvers
 *   class Base < GraphQL::Schema::Resolver
 *     argument_class Arguments::Base
 *   end
 * end
 *
 * module Resolvers
 *   class RecommendedItems < Resolvers::Base
 *     type [Types::Item], null: false
 *     argument :order_by, Types::ItemOrder, required: false
 *
 *     def resolve(order_by: )
 *       # call your application logic here...
 *     end
 *   end
 * end
 * ```
 */
private class GraphqlSchemaResolverClass extends ClassDeclaration {
  GraphqlSchemaResolverClass() {
    this.getSuperclassExpr() =
      graphQlSchema().getMember("Resolver").getASubclass().getAUse().asExpr().getExpr()
  }
}

/**
 * A `ClassDeclaration` for a class that extends `GraphQL::Schema::Object`.
 * For example,
 *
 * ```rb
 * class BaseObject < GraphQL::Schema::Object
 *   field_class BaseField
 * end
 *
 * class Musician < BaseObject
 *   field :favorite_key, Key
 * end
 * ```
 */
class GraphqlSchemaObjectClass extends ClassDeclaration {
  GraphqlSchemaObjectClass() {
    this.getSuperclassExpr() =
      graphQlSchema().getMember("Object").getASubclass().getAUse().asExpr().getExpr()
  }

  /** Gets a `GraphqlFieldDefinitionMethodCall` called in this class. */
  GraphqlFieldDefinitionMethodCall getAFieldDefinitionMethodCall() {
    result.getReceiverClass() = this
  }
}

/**
 * A `ClassDeclaration` for a class that extends either
 * `GraphQL::Schema::RelayClassicMutation` or
 * `GraphQL::Schema::Resolver`.
 *
 * Both of these classes have an overrideable `resolve` instance
 * method which can receive user input in order to resolve a query or mutation.
 */
private class GraphqlResolvableClass extends ClassDeclaration {
  GraphqlResolvableClass() {
    this instanceof GraphqlRelayClassicMutationClass or
    this instanceof GraphqlSchemaResolverClass
  }
}

/**
 * A `resolve` instance method on a sub-class of either
 * `GraphQL::Schema::RelayClassicMutation` or
 * `GraphQL::Schema::Resolver`.
 *
 * This `resolve` method is essentially an HTTP request handler.
 * The user input data comes in through a GraphQL query, is parsed by the GraphQL
 * library, and this method handles the request. Then the result is serialized
 * into a GraphQL response on the way out.
 *
 * For example:
 *
 * ```rb
 * module Mutation
 *   class NameAnInstrument < BaseMutationn
 *     argument :instrument_uuid, Types::Uuid,
 *              required: true,
 *              loads: ::Instrument,
 *              as: :instrument,
 *     argument :name, String, required: true
 *
 *     def load_instrument(uuid)
 *       ::Instrument.find_by(uuid: uuid)
 *     end
 *
 *     # GraphqlResolveMethod
 *     def resolve(instrument:, name:)
 *       instrument.set_name(name)
 *     end
 *   end
 * end
 * ```
 */
class GraphqlResolveMethod extends Method, HTTP::Server::RequestHandler::Range {
  private GraphqlResolvableClass resolvableClass;

  GraphqlResolveMethod() { this = resolvableClass.getMethod("resolve") }

  override Parameter getARoutedParameter() { result = this.getAParameter() }

  override string getFramework() { result = "GraphQL" }

  /** Gets the mutation class containing this method. */
  GraphqlResolvableClass getMutationClass() { result = resolvableClass }
}

/**
 * A `load_*` method on a sub-class of either
 * `GraphQL::Schema::RelayClassicMutation` or
 * `GraphQL::Schema::Resolver`.
 *
 * This method takes user input (some kind of ID or specifier) and is intended
 * to resolve the domain object using that ID.
 *
 * For example:
 *
 * ```rb
 * module Mutation
 *   class NameAnInstrument < BaseMutationn
 *     argument :instrument_uuid, Types::Uuid,
 *              required: true,
 *              loads: ::Instrument,
 *              as: :instrument,
 *     argument :name, String, required: true
 *
 *     # GraphqlLoadMethod
 *     def load_instrument(uuid)
 *       ::Instrument.find_by(uuid: uuid)
 *     end
 *
 *     def resolve(instrument:, name:)
 *       instrument.set_name(name)
 *     end
 *   end
 * end
 * ```
 */
class GraphqlLoadMethod extends Method, HTTP::Server::RequestHandler::Range {
  private GraphqlResolvableClass resolvableClass;

  GraphqlLoadMethod() {
    this.getEnclosingModule() = resolvableClass and
    this.getName().regexpMatch("^load_.*")
  }

  override Parameter getARoutedParameter() { result = this.getAParameter() }

  override string getFramework() { result = "GraphQL" }

  /** Gets the mutation class containing this method. */
  GraphqlResolvableClass getMutationClass() { result = resolvableClass }
}

/**
 * A `MethodCall` that represents calling a class method on a
 * a sub-class of `GraphQL::Schema::Object`
 */
private class GraphqlSchemaObjectClassMethodCall extends MethodCall {
  private GraphqlSchemaObjectClass recvCls;

  GraphqlSchemaObjectClassMethodCall() {
    // e.g. Foo.some_method(...)
    recvCls.getModule() = resolveConstantReadAccess(this.getReceiver())
    or
    // e.g. self.some_method(...) within a graphql Object or Interface
    this.getReceiver() instanceof SelfVariableAccess and
    this.getEnclosingModule() = recvCls
  }

  /** Gets the `GraphqlSchemaObjectClass` representing the receiver of this method. */
  GraphqlSchemaObjectClass getReceiverClass() { result = recvCls }
}

/**
 * A `MethodCall` that represents calling the class method `field` on a GraphQL
 * object.
 *
 * For example:
 *
 * ```rb
 * class Types::User < GraphQL::Schema::Object
 *   # GraphqlFieldDefinitionMethodCall
 *   field :email, String
 * end
 * ```
 *
 * See also: https://graphql-ruby.org/fields/introduction.html
 */
class GraphqlFieldDefinitionMethodCall extends GraphqlSchemaObjectClassMethodCall {
  GraphqlFieldDefinitionMethodCall() { this.getMethodName() = "field" }

  /** Gets the name of this GraphQL field. */
  string getFieldName() { result = this.getArgument(0).getConstantValue().getStringlikeValue() }
}

/**
 * A `MethodCall` that represents calling the class method `argument` inside the
 * block for a `field` definition on a GraphQL object.
 *
 * For example:
 *
 * ```rb
 * class Types::User < GraphQL::Schema::Object
 *   field :email, String
 *   field :friends, [Types::User] do
 *     # GraphqlFieldArgumentDefinitionMethodCall
 *     argument :starts_with, String, "Show only friends matching the given prefix"
 *   end
 * end
 * ```
 *
 * See Also: https://graphql-ruby.org/fields/arguments
 */
private class GraphqlFieldArgumentDefinitionMethodCall extends GraphqlSchemaObjectClassMethodCall {
  private GraphqlFieldDefinitionMethodCall fieldDefinition;

  GraphqlFieldArgumentDefinitionMethodCall() {
    this.getMethodName() = "argument" and
    fieldDefinition.getBlock() = this.getEnclosingCallable()
  }

  /** Gets the method call that defines the GraphQL field this argument is for */
  GraphqlFieldDefinitionMethodCall getFieldDefinition() { result = fieldDefinition }

  /** Gets the name of the field which this is an argument for */
  string getFieldName() { result = this.getFieldDefinition().getFieldName() }

  /** Gets the name of the argument (i.e. the first argument to this `argument` method call) */
  string getArgumentName() { result = this.getArgument(0).getConstantValue().getStringlikeValue() }
}

/**
 * A `Method` which represents an instance method which is the resolver method for a
 * GraphQL `field`.
 *
 * For example:
 *
 * ```rb
 * class Types::User < GraphQL::Schema::Object
 *   field :email, String
 *   field :friends, [Types::User] do
 *     argument :starts_with, String, "Show only friends matching the given prefix"
 *   end
 *
 *   # GraphqlFieldResolutionMethod
 *   def friends(starts_with:)
 *     object.friends.where("name like #{starts_with}")
 *   end
 * end
 * ```
 *
 * or:
 *
 * ```rb
 * class Types::User < GraphQL::Schema::Object
 *   field :email, String
 *   field :friends, [Types::User] do
 *     argument :starts_with, String, "Show only friends matching the given prefix",
 *       resolver_method: :my_custom_method, extras: [:graphql_name]
 *   end
 *
 *   # GraphqlFieldResolutionMethod
 *   def my_custom_method(**args)
 *     puts args[:graphql_name] # for debugging
 *     object.friends.where("name like #{args[:starts_with]}")
 *   end
 * end
 * ```
 */
class GraphqlFieldResolutionMethod extends Method, HTTP::Server::RequestHandler::Range {
  private GraphqlSchemaObjectClass schemaObjectClass;

  GraphqlFieldResolutionMethod() {
    this.getEnclosingModule() = schemaObjectClass and
    exists(GraphqlFieldDefinitionMethodCall defn |
      // field :foo, resolver_method: :custom_method
      // def custom_method(...)
      defn.getKeywordArgument("resolver_method")
          .getConstantValue()
          .isStringlikeValue(this.getName())
      or
      // field :foo
      // def foo(...)
      not exists(defn.getKeywordArgument("resolver_method").(SymbolLiteral)) and
      defn.getFieldName() = this.getName()
    )
  }

  /** Gets the method call which is the definition of the field corresponding to this resolver method. */
  GraphqlFieldDefinitionMethodCall getDefinition() {
    result
        .getKeywordArgument("resolver_method")
        .getConstantValue()
        .isStringlikeValue(this.getName())
    or
    not exists(result.getKeywordArgument("resolver_method").(SymbolLiteral)) and
    result.getFieldName() = this.getName()
  }

  // check for a named argument the same name as a defined argument for this field
  override Parameter getARoutedParameter() {
    result = this.getAParameter() and
    exists(GraphqlFieldArgumentDefinitionMethodCall argDefn |
      argDefn.getEnclosingCallable() = this.getDefinition().getBlock() and
      (
        result.(KeywordParameter).hasName(argDefn.getArgumentName())
        or
        // TODO this will cause false positives because now *anything* in the **args
        // param will be flagged as as RoutedParameter/RemoteFlowSource, but really
        // only the hash keys corresponding to the defined arguments are user input
        // others could be things defined in the `:extras` keyword argument to the `argument`
        result instanceof HashSplatParameter // often you see `def field(**args)`
      )
    )
  }

  override string getFramework() { result = "GraphQL" }

  /** Gets the class containing this method. */
  GraphqlSchemaObjectClass getGraphqlClass() { result = schemaObjectClass }
}
