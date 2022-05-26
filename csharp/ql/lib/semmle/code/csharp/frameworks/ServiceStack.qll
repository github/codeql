/**
 * General modeling of ServiceStack framework including separate modules for:
 *  - flow sources
 *  - SQLi sinks
 *  - XSS sinks
 */

import csharp
private import semmle.code.csharp.dataflow.ExternalFlow

/** A class representing a Service */
private class ServiceClass extends Class {
  ServiceClass() {
    this.getBaseClass+().hasQualifiedName("ServiceStack", "Service") or
    this.getABaseType*().getABaseInterface().hasQualifiedName("ServiceStack", "IService")
  }

  /** Get a method that handles incoming requests */
  Method getARequestMethod() {
    exists(string name |
      result = this.getAMethod(name) and
      name.regexpMatch("(Get|Post|Put|Delete|Any|Option|Head|Patch)(Async|Json|Xml|Jsv|Csv|Html|Protobuf|Msgpack|Wire)?")
    )
  }
}

/** Flow sources for the ServiceStack framework */
module Sources {
  private import semmle.code.csharp.security.dataflow.flowsources.Remote

  /**
   *  Remote flow sources for ServiceStack. Parameters of well-known `request` methods.
   */
  private class ServiceStackSource extends RemoteFlowSource {
    ServiceStackSource() {
      exists(ServiceClass service |
        service.getARequestMethod().getAParameter() = this.asParameter()
      )
    }

    override string getSourceType() { result = "ServiceStack request parameter" }
  }
}

private class ServiceStackRemoteSinkModelCsv extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        // IRestClient
        "ServiceStack;IRestClient;true;Send<>;(System.String,System.String,System.Object);;Argument[2];remote",
        "ServiceStack;IRestClient;true;Patch<>;(System.String,System.Object);;Argument[1];remote",
        "ServiceStack;IRestClient;true;Post<>;(System.String,System.Object);;Argument[1];remote",
        "ServiceStack;IRestClient;true;Put<>;(System.String,System.Object);;Argument[1];remote",
        // IRestClientSync
        "ServiceStack;IRestClientSync;true;CustomMethod;(System.String,ServiceStack.IReturnVoid);;Argument[1];remote",
        "ServiceStack;IRestClientSync;true;CustomMethod<>;(System.String,System.Object);;Argument[1];remote",
        "ServiceStack;IRestClientSync;true;CustomMethod<>;(System.String,ServiceStack.IReturn<TResponse>);;Argument[1];remote",
        "ServiceStack;IRestClientSync;true;Delete;(ServiceStack.IReturnVoid);;Argument[0];remote",
        "ServiceStack;IRestClientSync;true;Delete<>;(System.Object);;Argument[0];remote",
        "ServiceStack;IRestClientSync;true;Delete<>;(ServiceStack.IReturn<TResponse>);;Argument[0];remote",
        "ServiceStack;IRestClientSync;true;Get;(ServiceStack.IReturnVoid);;Argument[0];remote",
        "ServiceStack;IRestClientSync;true;Get<>;(System.Object);;Argument[0];remote",
        "ServiceStack;IRestClientSync;true;Get<>;(ServiceStack.IReturn<TResponse>);;Argument[0];remote",
        "ServiceStack;IRestClientSync;true;Patch;(ServiceStack.IReturnVoid);;Argument[0];remote",
        "ServiceStack;IRestClientSync;true;Patch<>;(System.Object);;Argument[0];remote",
        "ServiceStack;IRestClientSync;true;Patch<>;(ServiceStack.IReturn<TResponse>);;Argument[0];remote",
        "ServiceStack;IRestClientSync;true;Post;(ServiceStack.IReturnVoid);;Argument[0];remote",
        "ServiceStack;IRestClientSync;true;Post<>;(System.Object);;Argument[0];remote",
        "ServiceStack;IRestClientSync;true;Post<>;(ServiceStack.IReturn<TResponse>);;Argument[0];remote",
        "ServiceStack;IRestClientSync;true;Put;(ServiceStack.IReturnVoid);;Argument[0];remote",
        "ServiceStack;IRestClientSync;true;Put<>;(System.Object);;Argument[0];remote",
        "ServiceStack;IRestClientSync;true;Put<>;(ServiceStack.IReturn<TResponse>);;Argument[0];remote",
        // IRestGateway
        "ServiceStack;IRestGateway;true;Delete<>;(ServiceStack.IReturn<T>);;Argument[0];remote",
        "ServiceStack;IRestGateway;true;Get<>;(ServiceStack.IReturn<T>);;Argument[0];remote",
        "ServiceStack;IRestGateway;true;Post<>;(ServiceStack.IReturn<T>);;Argument[0];remote",
        "ServiceStack;IRestGateway;true;Put<>;(ServiceStack.IReturn<T>);;Argument[0];remote",
        "ServiceStack;IRestGateway;true;Send<>;(ServiceStack.IReturn<T>);;Argument[0];remote",
        // IOneWayClient
        "ServiceStack;IOneWayClient;true;SendAllOneWay;(System.Collections.Generic.IEnumerable<System.Object>);;Argument[1].Element;remote",
        "ServiceStack;IOneWayClient;true;SendOneWay;(System.String,System.Object);;Argument[1];remote",
        "ServiceStack;IOneWayClient;true;SendOneWay;(System.Object);;Argument[0];remote",
        // IServiceGateway
        "ServiceStack;IServiceGateway;true;Publish;(System.Object);;Argument[0];remote",
        "ServiceStack;IServiceGateway;true;PublishAll;(System.Collections.Generic.IEnumerable<System.Object>);;Argument[0].Element;remote",
        "ServiceStack;IServiceGateway;true;Send<>;(System.Object);;Argument[0];remote",
        "ServiceStack;IServiceGateway;true;SendAll<>;(System.Collections.Generic.IEnumerable<System.Object>);;Argument[0].Element;remote",
        // IRestClientAsync
        "ServiceStack;IRestClientAsync;true;CustomMethodAsync;(System.String,ServiceStack.IReturnVoid,System.Threading.CancellationToken);;Argument[1];remote",
        "ServiceStack;IRestClientAsync;true;CustomMethodAsync<>;(System.String,System.Object,System.Threading.CancellationToken);;Argument[1];remote",
        "ServiceStack;IRestClientAsync;true;CustomMethodAsync<>;(System.String,ServiceStack.IReturn<TResponse>,System.Threading.CancellationToken);;Argument[1];remote",
        "ServiceStack;IRestClientAsync;true;DeleteAsync;(ServiceStack.IReturnVoid,System.Threading.CancellationToken);;Argument[0];remote",
        "ServiceStack;IRestClientAsync;true;DeleteAsync<>;(System.Object,System.Threading.CancellationToken);;Argument[0];remote",
        "ServiceStack;IRestClientAsync;true;DeleteAsync<>;(ServiceStack.IReturn<TResponse>,System.Threading.CancellationToken);;Argument[0];remote",
        "ServiceStack;IRestClientAsync;true;GetAsync;(ServiceStack.IReturnVoid,System.Threading.CancellationToken);;Argument[0];remote",
        "ServiceStack;IRestClientAsync;true;GetAsync<>;(System.Object,System.Threading.CancellationToken);;Argument[0];remote",
        "ServiceStack;IRestClientAsync;true;GetAsync<>;(ServiceStack.IReturn<TResponse>,System.Threading.CancellationToken);;Argument[0];remote",
        "ServiceStack;IRestClientAsync;true;PatchAsync;(ServiceStack.IReturnVoid,System.Threading.CancellationToken);;Argument[0];remote",
        "ServiceStack;IRestClientAsync;true;PatchAsync<>;(System.Object,System.Threading.CancellationToken);;Argument[0];remote",
        "ServiceStack;IRestClientAsync;true;PatchAsync<>;(ServiceStack.IReturn<TResponse>,System.Threading.CancellationToken);;Argument[0];remote",
        "ServiceStack;IRestClientAsync;true;PostAsync;(ServiceStack.IReturnVoid,System.Threading.CancellationToken);;Argument[0];remote",
        "ServiceStack;IRestClientAsync;true;PostAsync<>;(System.Object,System.Threading.CancellationToken);;Argument[0];remote",
        "ServiceStack;IRestClientAsync;true;PostAsync<>;(ServiceStack.IReturn<TResponse>,System.Threading.CancellationToken);;Argument[0];remote",
        "ServiceStack;IRestClientAsync;true;PutAsync;(ServiceStack.IReturnVoid,System.Threading.CancellationToken);;Argument[0];remote",
        "ServiceStack;IRestClientAsync;true;PutAsync<>;(System.Object,System.Threading.CancellationToken);;Argument[0];remote",
        "ServiceStack;IRestClientAsync;true;PutAsync<>;(ServiceStack.IReturn<TResponse>,System.Threading.CancellationToken);;Argument[0];remote",
        // IRestGatewayAsync
        "ServiceStack;IRestGatewayAsync;true;DeleteAsync<>;(ServiceStack.IReturn<T>,System.Threading.CancellationToken);;Argument[0];remote",
        "ServiceStack;IRestGatewayAsync;true;GetAsync<>;(ServiceStack.IReturn<T>,System.Threading.CancellationToken);;Argument[0];remote",
        "ServiceStack;IRestGatewayAsync;true;PostAsync<>;(ServiceStack.IReturn<T>,System.Threading.CancellationToken);;Argument[0];remote",
        "ServiceStack;IRestGatewayAsync;true;PutAsync<>;(ServiceStack.IReturn<T>,System.Threading.CancellationToken);;Argument[0];remote",
        "ServiceStack;IRestGatewayAsync;true;SendAsync<>;(ServiceStack.IReturn<T>,System.Threading.CancellationToken);;Argument[0];remote",
        // IServiceGatewayAsync
        "ServiceStack;IServiceGatewayAsync;true;PublishAsync;(System.Object,System.Threading.CancellationToken);;Argument[0];remote",
        "ServiceStack;IServiceGatewayAsync;true;PublishAllAsync;(System.Collections.Generic.IEnumerable<System.Object>,System.Threading.CancellationToken);;Argument[0].Element;remote",
        "ServiceStack;IServiceGatewayAsync;true;SendAsync<>;(System.Object,System.Threading.CancellationToken);;Argument[0];remote",
        "ServiceStack;IServiceGatewayAsync;true;SendAllAsync<>;(System.Collections.Generic.IEnumerable<System.Object>,System.Threading.CancellationToken);;Argument[0].Element;remote",
        // ServiceClientBase
        "ServiceStack;ServiceClientBase;true;Publish<>;(T);;Argument[0];remote",
        "ServiceStack;ServiceClientBase;true;Publish<>;(ServiceStack.Messaging.IMessage<T>);;Argument[0];remote",
        "ServiceStack;ServiceClientBase;true;Delete;(System.Object);;Argument[0];remote",
        "ServiceStack;ServiceClientBase;true;Get;(System.Object);;Argument[0];remote",
        "ServiceStack;ServiceClientBase;true;Patch;(System.Object);;Argument[0];remote",
        "ServiceStack;ServiceClientBase;true;Post;(System.Object);;Argument[0];remote",
        "ServiceStack;ServiceClientBase;true;Put;(System.Object);;Argument[0];remote",
        "ServiceStack;ServiceClientBase;true;Head;(System.Object);;Argument[0];remote",
        "ServiceStack;ServiceClientBase;true;Head;(ServiceStack.IReturn);;Argument[0];remote",
        "ServiceStack;ServiceClientBase;true;CustomMethod;(System.String,System.String,System.Object);;Argument[2];remote",
        "ServiceStack;ServiceClientBase;true;CustomMethod<>;(System.String,System.String,System.Object);;Argument[2];remote",
        "ServiceStack;ServiceClientBase;true;CustomMethodAsync<>;(System.String,System.String,System.Object,System.Threading.CancellationToken);;Argument[2];remote",
        "ServiceStack;ServiceClientBase;true;DownloadBytes;(System.String,System.String,System.Object);;Argument[2];remote",
        "ServiceStack;ServiceClientBase;true;DownloadBytesAsync;(System.String,System.String,System.Object);;Argument[2];remote"
      ]
  }
}

private class ServiceStackSqlSinkModelCsv extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        // SqlExpression<T>
        "ServiceStack.OrmLite;SqlExpression<>;true;UnsafeAnd;(System.String,System.Object[]);;Argument[0];sql",
        "ServiceStack.OrmLite;SqlExpression<>;true;UnsafeFrom;(System.String);;Argument[0];sql",
        "ServiceStack.OrmLite;SqlExpression<>;true;UnsafeGroupBy;(System.String);;Argument[0];sql",
        "ServiceStack.OrmLite;SqlExpression<>;true;UnsafeHaving;(System.String,System.Object[]);;Argument[0];sql",
        "ServiceStack.OrmLite;SqlExpression<>;true;UnsafeOr;(System.String,System.Object[]);;Argument[0];sql",
        "ServiceStack.OrmLite;SqlExpression<>;true;UnsafeOrderBy;(System.String);;Argument[0];sql",
        "ServiceStack.OrmLite;SqlExpression<>;true;UnsafeSelect;(System.String,System.Boolean);;Argument[0];sql",
        "ServiceStack.OrmLite;SqlExpression<>;true;UnsafeSelect;(System.String);;Argument[0];sql",
        "ServiceStack.OrmLite;SqlExpression<>;true;UnsafeWhere;(System.String,System.Object[]);;Argument[0];sql",
        // IUntypedSqlExpression
        "ServiceStack.OrmLite;IUntypedSqlExpression;true;UnsafeAnd;(System.String,System.Object[]);;Argument[0];sql",
        "ServiceStack.OrmLite;IUntypedSqlExpression;true;UnsafeFrom;(System.String);;Argument[0];sql",
        "ServiceStack.OrmLite;IUntypedSqlExpression;true;UnsafeOr;(System.String,System.Object[]);;Argument[0];sql",
        "ServiceStack.OrmLite;IUntypedSqlExpression;true;UnsafeSelect;(System.String);;Argument[0];sql",
        "ServiceStack.OrmLite;IUntypedSqlExpression;true;UnsafeWhere;(System.String,System.Object[]);;Argument[0];sql",
        // OrmLiteReadApi
        "ServiceStack.OrmLite;OrmLiteReadApi;false;ExecuteNonQuery;(System.Data.IDbConnection,System.String);;Argument[1];sql",
        "ServiceStack.OrmLite;OrmLiteReadApi;false;ExecuteNonQuery;(System.Data.IDbConnection,System.String,System.Object);;Argument[1];sql",
        "ServiceStack.OrmLite;OrmLiteReadApi;false;ExecuteNonQuery;(System.Data.IDbConnection,System.String,System.Action<System.Data.IDbCommand>);;Argument[1];sql",
        "ServiceStack.OrmLite;OrmLiteReadApi;false;ExecuteNonQuery;(System.Data.IDbConnection,System.String,System.Collections.Generic.Dictionary<System.String,System.Object>);;Argument[1];sql",
        "ServiceStack.OrmLite;OrmLiteReadApi;false;Exists<>;(System.Data.IDbConnection,System.String,System.Object);;Argument[1];sql",
        "ServiceStack.OrmLite;OrmLiteReadApi;false;Dictionary<,>;(System.Data.IDbConnection,System.String,System.Object);;Argument[1];sql",
        "ServiceStack.OrmLite;OrmLiteReadApi;false;Lookup<,>;(System.Data.IDbConnection,System.String,System.Object);;Argument[1];sql",
        "ServiceStack.OrmLite;OrmLiteReadApi;false;Lookup<,>;(System.Data.IDbConnection,System.String,System.Collections.Generic.IEnumerable<System.Data.IDbDataParameter>);;Argument[1];sql",
        "ServiceStack.OrmLite;OrmLiteReadApi;false;KeyValuePairs;(System.Data.IDbConnection,System.String,System.System.Object);;Argument[1];sql",
        "ServiceStack.OrmLite;OrmLiteReadApi;false;Scalar<>;(System.Data.IDbConnection,System.String,System.Object);;Argument[1];sql",
        "ServiceStack.OrmLite;OrmLiteReadApi;false;Scalar<>;(System.Data.IDbConnection,System.String,System.Collections.Generic.IEnumerable<System.Data.IDbDataParameter>);;Argument[1];sql",
        "ServiceStack.OrmLite;OrmLiteReadApi;false;Select<>;(System.Data.IDbConnection,System.Type,System.String,System.Object);;Argument[2];sql",
        "ServiceStack.OrmLite;OrmLiteReadApi;false;Select<>;(System.Data.IDbConnection,System.String);;Argument[1];sql",
        "ServiceStack.OrmLite;OrmLiteReadApi;false;Select<>;(System.Data.IDbConnection,System.String,System.Collections.Generic.Dictionary<System.String,System.Object>);;Argument[1];sql",
        "ServiceStack.OrmLite;OrmLiteReadApi;false;Select<>;(System.Data.IDbConnection,System.String,System.Collections.Generic.IEnumerable<System.Data.IDbDataParameter>);;Argument[1];sql",
        "ServiceStack.OrmLite;OrmLiteReadApi;false;Select<>;(System.Data.IDbConnection,System.String,System.Object);;Argument[1];sql",
        "ServiceStack.OrmLite;OrmLiteReadApi;false;SelectLazy<>;(System.Data.IDbConnection,System.String,System.Object);;Argument[1];sql",
        "ServiceStack.OrmLite;OrmLiteReadApi;false;SelectNonDefaults<>;(System.Data.IDbConnection,System.String,T);;Argument[1];sql",
        "ServiceStack.OrmLite;OrmLiteReadApi;false;Single<>;(System.Data.IDbConnection,System.String,System.Object);;Argument[1];sql",
        "ServiceStack.OrmLite;OrmLiteReadApi;false;Single<>;(System.Data.IDbConnection,System.String,System.Collections.Generic.IEnumerable<System.Data.IDbDataParameter>);;Argument[1];sql",
        "ServiceStack.OrmLite;OrmLiteReadApi;false;SqlColumn<>;(System.Data.IDbConnection,System.String,System.Collections.Generic.Dictionary<System.String,System.Object>);;Argument[1];sql",
        "ServiceStack.OrmLite;OrmLiteReadApi;false;SqlColumn<>;(System.Data.IDbConnection,System.String,System.Collections.Generic.IEnumerable<System.Data.IDbDataParameter>);;Argument[1];sql",
        "ServiceStack.OrmLite;OrmLiteReadApi;false;SqlColumn<>;(System.Data.IDbConnection,System.String,System.Object);;Argument[1];sql",
        "ServiceStack.OrmLite;OrmLiteReadApi;false;SqlList<>;(System.Data.IDbConnection,System.String,System.Collections.Generic.Dictionary<System.String,System.Object>);;Argument[1];sql",
        "ServiceStack.OrmLite;OrmLiteReadApi;false;SqlList<>;(System.Data.IDbConnection,System.String,System.Collections.Generic.IEnumerable<System.Data.IDbDataParameter>);;Argument[1];sql",
        "ServiceStack.OrmLite;OrmLiteReadApi;false;SqlList<>;(System.Data.IDbConnection,System.String,System.Object);;Argument[1];sql",
        "ServiceStack.OrmLite;OrmLiteReadApi;false;SqlList<>;(System.Data.IDbConnection,System.String,System.Action<System.Data.IDbCommand>);;Argument[1];sql",
        "ServiceStack.OrmLite;OrmLiteReadApi;false;SqlScalar<>;(System.Data.IDbConnection,System.String,System.Collections.Generic.Dictionary<System.String,System.Object>);;Argument[1];sql",
        "ServiceStack.OrmLite;OrmLiteReadApi;false;SqlScalar<>;(System.Data.IDbConnection,System.String,System.Collections.Generic.IEnumerable<System.Data.IDbDataParameter>);;Argument[1];sql",
        "ServiceStack.OrmLite;OrmLiteReadApi;false;SqlScalar<>;(System.Data.IDbConnection,System.String,System.Object);;Argument[1];sql",
        "ServiceStack.OrmLite;OrmLiteReadApi;false;Column<>;(System.Data.IDbConnection,System.String,System.Object);;Argument[1];sql",
        "ServiceStack.OrmLite;OrmLiteReadApi;false;Column<>;(System.Data.IDbConnection,System.String,System.Collections.Generic.IEnumerable<System.Data.IDbDataParameter>);;Argument[1];sql",
        "ServiceStack.OrmLite;OrmLiteReadApi;false;ColumnDistinct<>;(System.Data.IDbConnection,System.String,System.Object);;Argument[1];sql",
        "ServiceStack.OrmLite;OrmLiteReadApi;false;ColumnDistinct<>;(System.Data.IDbConnection,System.String,System.Collections.Generic.IEnumerable<System.Data.IDbDataParameter>);;Argument[1];sql",
        "ServiceStack.OrmLite;OrmLiteReadApi;false;ColumnLazy<>;(System.Data.IDbConnection,System.String,System.Object);;Argument[1];sql",
        "ServiceStack.OrmLite;OrmLiteReadApi;false;ColumnLazy<>;(System.Data.IDbConnection,System.String,System.Collections.Generic.IEnumerable<System.Data.IDbDataParameter>);;Argument[1];sql",
        // OrmLiteReadExpressionsApi
        "ServiceStack.OrmLite;OrmLiteReadExpressionsApi;false;RowCount;(System.Data.IDbConnection,System.String,System.Object);;Argument[1];sql",
        "ServiceStack.OrmLite;OrmLiteReadExpressionsApi;false;RowCount;(System.Data.IDbConnection,System.String,System.Collections.Generic.IEnumerable<System.Data.IDbDataParameter>);;Argument[1];sql",
        // OrmLiteReadExpressionsApiAsync
        "ServiceStack.OrmLite;OrmLiteReadExpressionsApiAsync;false;RowCountAsync;(System.Data.IDbConnection,System.String,System.Object,System.Threading.CancellationToken);;Argument[1];sql",
        // OrmLiteReadApiAsync
        "ServiceStack.OrmLite;OrmLiteReadApiAsync;false;ColumnAsync<>;(System.Data.IDbConnection,System.String,System.Object,System.Threading.CancellationToken);;Argument[1];sql",
        "ServiceStack.OrmLite;OrmLiteReadApiAsync;false;ColumnAsync<>;(System.Data.IDbConnection,System.String,System.Collections.Generic.IEnumerable<System.Data.IDbDataParameter>,System.Threading.CancellationToken);;Argument[1];sql",
        "ServiceStack.OrmLite;OrmLiteReadApiAsync;false;ColumnDistinctAsync<>;(System.Data.IDbConnection,System.String,System.Object,System.Threading.CancellationToken);;Argument[1];sql",
        "ServiceStack.OrmLite;OrmLiteReadApiAsync;false;ColumnDistinctAsync<>;(System.Data.IDbConnection,System.String,System.Collections.Generic.IEnumerable<System.Data.IDbDataParameter>,System.Threading.CancellationToken);;Argument[1];sql",
        "ServiceStack.OrmLite;OrmLiteReadApiAsync;false;DictionaryAsync<,>;(System.Data.IDbConnection,System.String,System.Object,System.Threading.CancellationToken);;Argument[1];sql",
        "ServiceStack.OrmLite;OrmLiteReadApiAsync;false;ExecuteNonQueryAsync;(System.Data.IDbConnection,System.String,System.Threading.CancellationToken);;Argument[1];sql",
        "ServiceStack.OrmLite;OrmLiteReadApiAsync;false;ExecuteNonQueryAsync;(System.Data.IDbConnection,System.String,System.Object,System.Threading.CancellationToken);;Argument[1];sql",
        "ServiceStack.OrmLite;OrmLiteReadApiAsync;false;ExecuteNonQueryAsync;(System.Data.IDbConnection,System.String,System.Collections.Generic.Dictionary<System.String,System.Object>,System.Threading.CancellationToken);;Argument[1];sql",
        "ServiceStack.OrmLite;OrmLiteReadApiAsync;false;ExistsAsync<>;(System.Data.IDbConnection,System.String,System.Object,System.Threading.CancellationToken);;Argument[1];sql",
        "ServiceStack.OrmLite;OrmLiteReadApiAsync;false;KeyValuePairsAsync<,>;(System.Data.IDbConnection,System.String,System.Object,System.Threading.CancellationToken);;Argument[1];sql",
        "ServiceStack.OrmLite;OrmLiteReadApiAsync;false;KeyValuePairsAsync<,>;(System.Data.IDbConnection,System.String,System.Collections.Generic.IEnumerable<System.Data.IDbDataParameter>,System.Threading.CancellationToken);;Argument[1];sql",
        "ServiceStack.OrmLite;OrmLiteReadApiAsync;false;LookupAsync<,>;(System.Data.IDbConnection,System.String,System.Object,System.Threading.CancellationToken);;Argument[1];sql",
        "ServiceStack.OrmLite;OrmLiteReadApiAsync;false;LookupAsync<,>;(System.Data.IDbCommand,System.String,System.Collections.Generic.IEnumerable<System.Data.IDbDataParameter>,System.Threading.CancellationToken);;Argument[1];sql",
        "ServiceStack.OrmLite;OrmLiteReadApiAsync;false;LookupAsync<,>;(System.Data.IDbConnection,System.String,System.Collections.Generic.IEnumerable<System.Data.IDbDataParameter>,System.Threading.CancellationToken);;Argument[1];sql",
        "ServiceStack.OrmLite;OrmLiteReadApiAsync;false;ScalarAsync<>;(System.Data.IDbConnection,System.String,System.Object,System.Threading.CancellationToken);;Argument[1];sql",
        "ServiceStack.OrmLite;OrmLiteReadApiAsync;false;ScalarAsync<>;(System.Data.IDbConnection,System.String,System.Collections.Generic.IEnumerable<System.Data.IDbDataParameter>,System.Threading.CancellationToken);;Argument[1];sql",
        "ServiceStack.OrmLite;OrmLiteReadApiAsync;false;SelectAsync<>;(System.Data.IDbConnection,System.Type,System.String,System.Object,System.Threading.CancellationToken);;Argument[2];sql",
        "ServiceStack.OrmLite;OrmLiteReadApiAsync;false;SelectAsync<>;(System.Data.IDbConnection,System.String,System.Threading.CancellationToken);;Argument[1];sql",
        "ServiceStack.OrmLite;OrmLiteReadApiAsync;false;SelectAsync<>;(System.Data.IDbConnection,System.String,System.Collections.Generic.Dictionary<System.String,System.Object>,System.Threading.CancellationToken);;Argument[1];sql",
        "ServiceStack.OrmLite;OrmLiteReadApiAsync;false;SelectAsync<>;(System.Data.IDbConnection,System.String,System.Collections.Generic.IEnumerable<System.Data.IDbDataParameter>,System.Threading.CancellationToken);;Argument[1];sql",
        "ServiceStack.OrmLite;OrmLiteReadApiAsync;false;SelectAsync<>;(System.Data.IDbConnection,System.String,System.Object,System.Threading.CancellationToken);;Argument[1];sql",
        "ServiceStack.OrmLite;OrmLiteReadApiAsync;false;SelectNonDefaultsAsync<>;(System.Data.IDbConnection,System.String,T,System.Threading.CancellationToken);;Argument[1];sql",
        "ServiceStack.OrmLite;OrmLiteReadApiAsync;false;SingleAsync<>;(System.Data.IDbConnection,System.String,System.Object,System.Threading.CancellationToken);;Argument[1];sql",
        "ServiceStack.OrmLite;OrmLiteReadApiAsync;false;SingleAsync<>;(System.Data.IDbConnection,System.String,System.Collections.Generic.IEnumerable<System.Data.IDbDataParameter>,System.Threading.CancellationToken);;Argument[1];sql",
        "ServiceStack.OrmLite;OrmLiteReadApiAsync;false;SqlColumnAsync<>;(System.Data.IDbConnection,System.String,System.Collections.Generic.Dictionary<System.String,System.Object>,System.Threading.CancellationToken);;Argument[1];sql",
        "ServiceStack.OrmLite;OrmLiteReadApiAsync;false;SqlColumnAsync<>;(System.Data.IDbConnection,System.String,System.Collections.Generic.IEnumerable<System.Data.IDbDataParameter>,System.Threading.CancellationToken);;Argument[1];sql",
        "ServiceStack.OrmLite;OrmLiteReadApiAsync;false;SqlColumnAsync<>;(System.Data.IDbConnection,System.String,System.Object,System.Threading.CancellationToken);;Argument[1];sql",
        "ServiceStack.OrmLite;OrmLiteReadApiAsync;false;SqlListAsync<>;(System.Data.IDbConnection,System.String,System.Collections.Generic.Dictionary<System.String,System.Object>,System.Threading.CancellationToken);;Argument[1];sql",
        "ServiceStack.OrmLite;OrmLiteReadApiAsync;false;SqlListAsync<>;(System.Data.IDbConnection,System.String,System.Collections.Generic.IEnumerable<System.Data.IDbDataParameter>,System.Threading.CancellationToken);;Argument[1];sql",
        "ServiceStack.OrmLite;OrmLiteReadApiAsync;false;SqlListAsync<>;(System.Data.IDbConnection,System.String,System.Object,System.Threading.CancellationToken);;Argument[1];sql",
        "ServiceStack.OrmLite;OrmLiteReadApiAsync;false;SqlListAsync<>;(System.Data.IDbConnection,System.String,System.Action<System.Data.IDbCommand>,System.Threading.CancellationToken);;Argument[1];sql",
        "ServiceStack.OrmLite;OrmLiteReadApiAsync;false;SqlScalarAsync<>;(System.Data.IDbConnection,System.String,System.Collections.Generic.Dictionary<System.String,System.Object>,System.Threading.CancellationToken);;Argument[1];sql",
        "ServiceStack.OrmLite;OrmLiteReadApiAsync;false;SqlScalarAsync<>;(System.Data.IDbConnection,System.String,System.Collections.Generic.IEnumerable<System.Data.IDbDataParameter>,System.Threading.CancellationToken);;Argument[1];sql",
        "ServiceStack.OrmLite;OrmLiteReadApiAsync;false;SqlScalarAsync<>;(System.Data.IDbConnection,System.String,System.Object,System.Threading.CancellationToken);;Argument[1];sql",
        // Write API
        "ServiceStack.OrmLite;OrmLiteWriteApi;false;ExecuteSql;(System.Data.IDbConnection,System.String);;Argument[1];sql",
        "ServiceStack.OrmLite;OrmLiteWriteApi;false;ExecuteSql;(System.Data.IDbConnection,System.String,System.Object);;Argument[1];sql",
        "ServiceStack.OrmLite;OrmLiteWriteApi;false;ExecuteSql;(System.Data.IDbConnection,System.String,System.Collections.Generic.Dictionary<System.String,System.Object>);;Argument[1];sql",
        "ServiceStack.OrmLite;OrmLiteWriteApiAsync;false;ExecuteSqlAsync;(System.Data.IDbConnection,System.String,System.Threading.CancellationToken);;Argument[1];sql",
        "ServiceStack.OrmLite;OrmLiteWriteApiAsync;false;ExecuteSqlAsync;(System.Data.IDbConnection,System.String,System.Object,System.Threading.CancellationToken);;Argument[1];sql"
      ]
  }
}

private class ServiceStackCodeInjectionSinkModelCsv extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        // Redis API
        "ServiceStack.Redis;IRedisClient;true;Custom;(System.Object[]);;Argument[0];code",
        "ServiceStack.Redis;IRedisClient;true;ExecCachedLua;(System.String,System.Func<System.String,T>);;Argument[0];code",
        "ServiceStack.Redis;IRedisClient;true;ExecLua;(System.String,System.String[],System.String[]);;Argument[0];code",
        "ServiceStack.Redis;IRedisClient;true;ExecLua;(System.String,System.String[]);;Argument[0];code",
        "ServiceStack.Redis;IRedisClient;true;ExecLuaAsInt;(System.String,System.String[],System.String[]);;Argument[0];code",
        "ServiceStack.Redis;IRedisClient;true;ExecLuaAsInt;(System.String,System.String[]);;Argument[0];code",
        "ServiceStack.Redis;IRedisClient;true;ExecLuaAsList;(System.String,System.String[],System.String[]);;Argument[0];code",
        "ServiceStack.Redis;IRedisClient;true;ExecLuaAsList;(System.String,System.String[]);;Argument[0];code",
        "ServiceStack.Redis;IRedisClient;true;ExecLuaAsString;(System.String,System.String[],System.String[]);;Argument[0];code",
        "ServiceStack.Redis;IRedisClient;true;ExecLuaAsString;(System.String,System.String[]);;Argument[0];code",
        "ServiceStack.Redis;IRedisClient;true;LoadLuaScript;(System.String);;Argument[0];code",
        // IRedisClientAsync
        "ServiceStack.Redis;IRedisClientAsync;true;CustomAsync;(System.Object[]);;Argument[0];code",
        "ServiceStack.Redis;IRedisClientAsync;true;CustomAsync;(System.Object[],System.Threading.CancellationToken);;Argument[0].Element;code",
        "ServiceStack.Redis;IRedisClientAsync;true;ExecCachedLuaAsync;(System.String,System.Func<System.String,System.Threading.Tasks.ValueTask<T>>,System.Threading.CancellationToken);;Argument[0];code",
        "ServiceStack.Redis;IRedisClientAsync;true;ExecLuaAsync;(System.String,System.String[],System.String[],System.Threading.CancellationToken);;Argument[0];code",
        "ServiceStack.Redis;IRedisClientAsync;true;ExecLuaAsync;(System.String,System.String[],System.Threading.CancellationToken);;Argument[0];code",
        "ServiceStack.Redis;IRedisClientAsync;true;ExecLuaAsync;(System.String,System.String[]);;Argument[0];code",
        "ServiceStack.Redis;IRedisClientAsync;true;ExecLuaAsIntAsync;(System.String,System.String[],System.String[],System.Threading.CancellationToken);;Argument[0];code",
        "ServiceStack.Redis;IRedisClientAsync;true;ExecLuaAsIntAsync;(System.String,System.String[],System.Threading.CancellationToken);;Argument[0];code",
        "ServiceStack.Redis;IRedisClientAsync;true;ExecLuaAsIntAsync;(System.String,System.String[]);;Argument[0];code",
        "ServiceStack.Redis;IRedisClientAsync;true;ExecLuaAsStringAsync;(System.String,System.String[],System.String[],System.Threading.CancellationToken);;Argument[0];code",
        "ServiceStack.Redis;IRedisClientAsync;true;ExecLuaAsStringAsync;(System.String,System.String[],System.Threading.CancellationToken);;Argument[0];code",
        "ServiceStack.Redis;IRedisClientAsync;true;ExecLuaAsStringAsync;(System.String,System.String[]);;Argument[0];code",
        "ServiceStack.Redis;IRedisClientAsync;true;ExecLuaAsListAsync;(System.String,System.String[],System.String[],System.Threading.CancellationToken);;Argument[0];code",
        "ServiceStack.Redis;IRedisClientAsync;true;ExecLuaAsListAsync;(System.String,System.String[],System.Threading.CancellationToken);;Argument[0];code",
        "ServiceStack.Redis;IRedisClientAsync;true;ExecLuaAsListAsync;(System.String,System.String[]);;Argument[0];code",
        "ServiceStack.Redis;IRedisClientAsync;true;LoadLuaScriptAsync;(System.String,System.Threading.CancellationToken);;Argument[0];code"
      ]
  }
}

private class ServiceStackXssSummaryModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "ServiceStack;HttpResult;false;HttpResult;(System.String,System.String);;Argument[0];ReturnValue;taint",
        "ServiceStack;HttpResult;false;HttpResult;(System.Object,System.String,System.Net.HttpStatusCode);;Argument[0];ReturnValue;taint",
        "ServiceStack;HttpResult;false;HttpResult;(System.Object,System.String);;Argument[0];ReturnValue;taint",
        "ServiceStack;HttpResult;false;HttpResult;(System.Object,System.Net.HttpStatusCode);;Argument[0];ReturnValue;taint",
        "ServiceStack;HttpResult;false;HttpResult;(System.Object);;Argument[0];ReturnValue;taint",
        "ServiceStack;HttpResult;false;HttpResult;(System.IO.Stream,System.String);;Argument[0];ReturnValue;taint",
        "ServiceStack;HttpResult;false;HttpResult;(System.Byte[],System.String);;Argument[0];ReturnValue;taint"
      ]
  }
}

/** XSS support for ServiceStack framework */
module XSS {
  private import semmle.code.csharp.security.dataflow.XSSSinks

  /** XSS sinks for ServiceStack */
  class XssSink extends Sink {
    XssSink() {
      exists(ServiceClass service, Method m, Expr e |
        service.getARequestMethod() = m and
        this.asExpr() = e and
        m.canReturn(e) and
        (
          e.getType() instanceof StringType or
          e.getType().hasQualifiedName("ServiceStack", "HttpResult")
        )
      )
    }
  }
}
