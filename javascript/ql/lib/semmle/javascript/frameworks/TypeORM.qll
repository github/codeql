import javascript

module Sqlite {
  // Gets an expression that constructs or returns a Sqlite database instance.
  API::Node dataSource() {
    result = API::moduleImport("typeorm").getMember("DataSource").getInstance()
  }

  // Gets return value of a `createQueryBuilder`
  API::Node queryBuilderInstance() {
    result =
      [
        // Using DataSource
        dataSource(),
        // Using repository
        dataSource().getMember("getRepository").getReturn(),
        // Using entity manager
        dataSource().getMember("manager")
      ].getMember("createQueryBuilder").getReturn()
  }

  //API::moduleImport("typeorm").getMember("exports").getMember("DataSource").getInstance().getMember("createQueryBuilder").getReturn().getMember("where")
  // Gets The Brackets that are SQL Subqueries equivalent
  API::Node brackets() {
    result =
      API::moduleImport("typeorm")
          .getMember(["Brackets", "NotBrackets"])
          .getParameter(0)
          .getParameter(0)
  }

  // Gets any Successor node of Brackets, NotBrackets
  API::Node getASuccessorOfBrackets() {
    result = brackets() or
    result = getASuccessorOfBrackets().getAMember() or
    result = getASuccessorOfBrackets().getAParameter() or
    result = getASuccessorOfBrackets().getUnknownMember() or
    result = getASuccessorOfBrackets().getReturn() or
    result = getASuccessorOfBrackets().getInstance()
  }

  // Gets any Successor node of createQueryBuilder
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
   *  `orderBy` is not injectable in sqlite, if we want to write a filter we should specify a DataSource parameter string value,
   *  which mostly is taken from config files and we will loose many sinks,
   *  Also many application support multiple DBMSs besides sqlite,
   *  Also Consider it that `Order By` clause is one of the most popular injectable sinks
   */
  string selectExpression() {
    result =
      [
        "select", "addSelect", "from", "where", "andWhere", "orWhere", "having", "orHaving",
        "andHaving", "orderBy", "addOrderBy", "distinctOn", "groupBy", "addCommonTableExpression",
        "leftJoinAndSelect", "innerJoinAndSelect", "leftJoin", "innerJoin", "leftJoinAndMapOne",
        "innerJoinAndMapOne", "leftJoinAndMapMany", "innerJoinAndMapMany"
      ]
  }

  // Gets functions that return results
  string queryBuilderResult() {
    result = ["getOne", "getOneOrFail", "getMany", "getRawOne", "getRawMany", "stream"]
  }

  /**
   *  A call to a TypeORM Query Builder method and its successor nodes.
   */
  private class QueryCall extends DatabaseAccess, API::CallNode {
    API::Node typeOrmNode;

    QueryCall() {
      (
        typeOrmNode = getASuccessorOfBuilderInstance() and
        this = typeOrmNode.asSource()
        or
        // I'm doing following because this = typeOrmNode.asSource()s
        // won't let me to get a member in getAQueryArgument
        typeOrmNode = getASuccessorOfBrackets() and
        typeOrmNode.getMember(selectExpression()).getACall() = this
      ) and
      this.getFile().getLocation().toString().matches("%.ts%")
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
            "select", "addSelect", "from", "where", "andWhere", "orWhere", "having", "orHaving",
            "andHaving", "orderBy", "addOrderBy", "distinctOn", "groupBy",
            "addCommonTableExpression"
          ] and
        result = typeOrmNode.getMember(memberName).getParameter(0).asSink()
      )
    }
  }

  /** An expression that is passed to the `query` method and hence interpreted as SQL. */
  class QueryString extends SQL::SqlString {
    QueryString() { this = any(QueryCall qc).getAQueryArgument() }
  }
}

predicate test(API::Node n) { n = API::moduleImport("typeorm").getASuccessor*().getMember("where") }

predicate test2(API::Node n) {
  n =
    API::moduleImport("typeorm")
        .getMember("DataSource")
        .getInstance()
        .getMember("getRepository")
        .getReturn()
        .getMember("createQueryBuilder")
        .getReturn()
        .getMember("where")
        .getParameter(0)
}
