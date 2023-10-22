import javascript

/**
 * Provides SQL injection Sinks for [TypeORM](https://www.npmjs.com/package/typeorm) package
 */
module TypeOrm {
  /**
   * Gets a `DataSource` instance
   */
  API::Node dataSource() {
    result = API::moduleImport("typeorm").getMember("DataSource").getInstance()
  }

  /**
   * Gets a `QueryRunner` nodes
   */
  API::Node queryRunner() { result = dataSource().getMember("createQueryRunner").getReturn() }

  /**
   *  Gets a `*QueryBuilder` node of an Active record based Entity
   */
  API::Node activeRecordQueryBuilder() {
    result =
      API::moduleImport("typeorm")
          .getMember("Entity")
          .getReturn()
          .getADecoratedClass()
          .getMember("createQueryBuilder")
  }

  /**
   *   Gets a `*QueryBuilder` node of a Data Mapper based Entity
   */
  API::Node dataMapperQueryBuilder() {
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
    // in case of custom query builders
    result =
      API::moduleImport("typeorm")
          .getMember([
              "SelectQueryBuilder", "InsertQueryBuilder", "RelationQueryBuilder",
              "UpdateQueryBuilder"
            ])
          .getInstance()
  }

  /**
   * Gets a `*QueryBuilder` node
   */
  API::Node queryBuilderInstance() {
    result = dataMapperQueryBuilder() or
    result = activeRecordQueryBuilder()
  }

  /**
   * Gets The Brackets that are SQL Subqueries equivalent
   */
  API::Node brackets() {
    result =
      API::moduleImport("typeorm")
          .getMember(["Brackets", "NotBrackets"])
          .getParameter(0)
          .getParameter(0)
  }

  /**
   * Gets any Successor node of Brackets, NotBrackets
   */
  API::Node getASuccessorOfBrackets() {
    result = brackets() or
    result = getASuccessorOfBrackets().getAMember() or
    result = getASuccessorOfBrackets().getAParameter() or
    result = getASuccessorOfBrackets().getUnknownMember() or
    result = getASuccessorOfBrackets().getReturn() or
    result = getASuccessorOfBrackets().getInstance()
  }

  /**
   * Gets any Successor node of createQueryBuilder
   */
  API::Node getASuccessorOfBuilderInstance() {
    result = queryBuilderInstance() or
    result = getASuccessorOfBuilderInstance().getAMember() or
    result = getASuccessorOfBuilderInstance().getAParameter() or
    result = getASuccessorOfBuilderInstance().getUnknownMember() or
    result = getASuccessorOfBuilderInstance().getReturn() or
    result = getASuccessorOfBuilderInstance().getInstance()
  }

  /**
   *  Gets functions responsible for select expressions
   *  `orderBy` is not injectable in TypeORM, if we want to write a filter we should specify a DataSource parameter string value,
   *  which mostly is taken from config files and we will loose many sinks,
   *  Also many application support multiple DBMSs besides TypeORM,
   *  Also Consider it that `Order By` clause is one of the most popular injectable sinks
   */
  string selectExpression() {
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
   * Gets functions that return results
   */
  string queryBuilderResult() {
    result = ["getOne", "getOneOrFail", "getMany", "getRawOne", "getRawMany", "stream"]
  }

  /**
   *  A call to some successor functions of TypeORM `createQueryBuilder` function which are dangerous
   */
  private class QueryBuilderCall extends DatabaseAccess, API::CallNode {
    API::Node typeOrmNode;

    QueryBuilderCall() {
      typeOrmNode = getASuccessorOfBuilderInstance() and
      this = typeOrmNode.asSource()
      or
      // I'm doing following because `this = TypeORMNode.asSource()`
      // don't let me to get a member in getAQueryArgument
      typeOrmNode = getASuccessorOfBrackets() and
      typeOrmNode.getMember(selectExpression()).getACall() = this
    }

    override DataFlow::Node getAResult() {
      result = typeOrmNode.getMember(queryBuilderResult()).getReturn().asSource()
    }

    override DataFlow::Node getAQueryArgument() {
      exists(string memberName | memberName = selectExpression() |
        memberName = ["leftJoinAndSelect", "innerJoinAndSelect", "leftJoin", "innerJoin"] and
        result = typeOrmNode.getMember(memberName).getParameter(2).asSink()
        or
        memberName =
          ["leftJoinAndMapOne", "innerJoinAndMapOne", "leftJoinAndMapMany", "innerJoinAndMapMany"] and
        result = typeOrmNode.getMember(memberName).getParameter(3).asSink()
        or
        memberName =
          [
            "select", "addSelect", "where", "andWhere", "orWhere", "having", "orHaving",
            "andHaving", "orderBy", "addOrderBy", "distinctOn", "groupBy",
            "addCommonTableExpression"
          ] and
        result = typeOrmNode.getMember(memberName).getParameter(0).asSink()
        or
        memberName = ["orIgnore", "orUpdate"] and
        result = typeOrmNode.getMember(memberName).getParameter([0, 1]).asSink()
        or
        // following functions if use a function as their input fields,called function parameters which are vulnerable
        memberName = ["values", "set"] and
        result = typeOrmNode.getMember(memberName).getParameter(0).getAMember().getReturn().asSink()
      )
    }
  }

  /**
   *  A call to a TypeORM `query` function of QueryRunner
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
