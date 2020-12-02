import cpp

select count(BlockExpr be), count(ReturnStmt rs | rs.getExpr().getValue() = "0")
