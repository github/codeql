/**
 * Provides classes for working with SQL connectors.
 */

import javascript

module ExperimentalSql {
  /**
   * Provides SQL injection Sinks for the [TypeORM](https://www.npmjs.com/package/typeorm) package
   */
  private module TypeOrm {
    /**
     * Gets a `DataSource` instance
     *
     * `DataSource` is a pre-defined connection configuration to a specific database.
     */
    API::Node dataSource() {
      result = API::moduleImport("typeorm").getMember("DataSource").getInstance()
    }

    /**
     * Gets a `QueryRunner` instance
     */
    API::Node queryRunner() { result = dataSource().getMember("createQueryRunner").getReturn() }

    /**
     * Gets a `*QueryBuilder` instance
     */
    API::Node queryBuilderInstance() {
      // a `*QueryBuilder` instance of a Data Mapper based Entity
      result =
        [
          // Using DataSource
          dataSource(),
          // Using repository
          dataSource().getMember("getRepository").getReturn(),
          // Using entity manager
          dataSource().getMember("manager"), queryRunner().getMember("manager")
        ].getMember("createQueryBuilder").getReturn()
      or
      // A `*QueryBuilder` instance of an Active record based Entity
      result =
        API::moduleImport("typeorm")
            .getMember("Entity")
            .getReturn()
            .getADecoratedClass()
            .getMember("createQueryBuilder")
            .getReturn()
      or
      // A WhereExpressionBuilder can be used in complex WHERE expression
      result =
        API::moduleImport("typeorm")
            .getMember(["Brackets", "NotBrackets"])
            .getParameter(0)
            .getParameter(0)
      or
      // In case of custom query builders
      result =
        API::moduleImport("typeorm")
            .getMember([
                "SelectQueryBuilder", "InsertQueryBuilder", "RelationQueryBuilder",
                "UpdateQueryBuilder", "WhereExpressionBuilder"
              ])
            .getInstance()
    }

    /**
     *  Gets function names which create any type of `QueryBuilder` like `WhereExpressionBuilder` or `InsertQueryBuilder`
     */
    string queryBuilderMethods() {
      result =
        [
          "select", "addSelect", "where", "andWhere", "orWhere", "having", "orHaving", "andHaving",
          "orderBy", "addOrderBy", "distinctOn", "groupBy", "addCommonTableExpression",
          "leftJoinAndSelect", "innerJoinAndSelect", "leftJoin", "innerJoin", "leftJoinAndMapOne",
          "innerJoinAndMapOne", "leftJoinAndMapMany", "innerJoinAndMapMany", "orUpdate", "orIgnore",
          "values", "set"
        ]
    }

    /**
     * Gets function names that the return values of these functions can be the results of a database query run
     */
    string queryBuilderResult() {
      result = ["getOne", "getOneOrFail", "getMany", "getRawOne", "getRawMany", "stream"]
    }

    /**
     * Gets a QueryBuilder instance that has a query builder function
     */
    API::Node getASuccessorOfBuilderInstance(string queryBuilderMethod) {
      result.getMember(queryBuilderMethod) = queryBuilderInstance().getASuccessor*()
    }

    /**
     *  A call to some successor functions of TypeORM `createQueryBuilder` function which are dangerous
     */
    private class QueryBuilderCall extends DatabaseAccess, DataFlow::Node {
      API::Node queryBuilder;

      QueryBuilderCall() {
        queryBuilder = getASuccessorOfBuilderInstance(queryBuilderMethods()) and
        this = queryBuilder.asSource()
      }

      override DataFlow::Node getAResult() {
        result = queryBuilder.getMember(queryBuilderResult()).getReturn().asSource()
      }

      override DataFlow::Node getAQueryArgument() {
        exists(string memberName | memberName = queryBuilderMethods() |
          memberName = ["leftJoinAndSelect", "innerJoinAndSelect", "leftJoin", "innerJoin"] and
          result = queryBuilder.getMember(memberName).getParameter(2).asSink()
          or
          memberName =
            ["leftJoinAndMapOne", "innerJoinAndMapOne", "leftJoinAndMapMany", "innerJoinAndMapMany"] and
          result = queryBuilder.getMember(memberName).getParameter(3).asSink()
          or
          memberName =
            [
              "select", "addSelect", "where", "andWhere", "orWhere", "having", "orHaving",
              "andHaving", "orderBy", "addOrderBy", "distinctOn", "groupBy",
              "addCommonTableExpression"
            ] and
          result = queryBuilder.getMember(memberName).getParameter(0).asSink()
          or
          memberName = ["orIgnore", "orUpdate"] and
          result = queryBuilder.getMember(memberName).getParameter([0, 1]).asSink()
          or
          // following functions if use a function as their input fields,called function parameters which are vulnerable
          memberName = ["values", "set"] and
          result =
            queryBuilder.getMember(memberName).getParameter(0).getAMember().getReturn().asSink()
        )
      }
    }

    /**
     *  A call to the TypeORM `query` function of a `QueryRunner`
     */
    private class QueryRunner extends DatabaseAccess, API::CallNode {
      QueryRunner() { queryRunner().getMember("query").getACall() = this }

      override DataFlow::Node getAResult() { result = this }

      override DataFlow::Node getAQueryArgument() { result = this.getArgument(0) }
    }

    /** An expression that is passed to the `query` function and hence interpreted as SQL. */
    class QueryString extends SQL::SqlString {
      QueryString() {
        this = any(QueryRunner qr).getAQueryArgument() or
        this = any(QueryBuilderCall qb).getAQueryArgument()
      }
    }
  }
}
