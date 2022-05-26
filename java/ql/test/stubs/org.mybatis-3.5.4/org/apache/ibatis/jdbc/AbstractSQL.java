package org.apache.ibatis.jdbc;

public abstract class AbstractSQL<T> {
    public abstract T getSelf();

    public T UPDATE(String table) {
        return getSelf();
    }

    public T SET(String sets) {
        return getSelf();
    }

    public T SET(String ... sets) {
        return getSelf();
    }

    public T INSERT_INTO(String tableName) {
        return getSelf();
    }

    public T VALUES(String columns, String values) {
        return getSelf();
    }

    public T INTO_COLUMNS(String ... columns) {
        return getSelf();
    }

    public T INTO_VALUES(String ... values) {
        return getSelf();
    }

    public T SELECT(String columns) {
        return getSelf();
    }

    public T SELECT(String ... columns) {
        return getSelf();
    }

    public T SELECT_DISTINCT(String columns) {
        return getSelf();
    }

    public T SELECT_DISTINCT(String ... columns) {
        return getSelf();
    }

    public T DELETE_FROM(String table) {
        return getSelf();
    }

    public T FROM(String table) {
        return getSelf();
    }

    public T FROM(String ... tables) {
        return getSelf();
    }

    public T JOIN(String join) {
        return getSelf();
    }

    public T JOIN(String ... joins) {
        return getSelf();
    }

    public T INNER_JOIN(String join) {
        return getSelf();
    }

    public T INNER_JOIN(String ... joins) {
        return getSelf();
    }

    public T LEFT_OUTER_JOIN(String join) {
        return getSelf();
    }

    public T LEFT_OUTER_JOIN(String ... joins) {
        return getSelf();
    }

    public T RIGHT_OUTER_JOIN(String join) {
        return getSelf();
    }

    public T RIGHT_OUTER_JOIN(String ... joins) {
        return getSelf();
    }

    public T OUTER_JOIN(String join) {
        return getSelf();
    }

    public T OUTER_JOIN(String ... joins) {
        return getSelf();
    }

    public T WHERE(String conditions) {
        return getSelf();
    }

    public T WHERE(String ... conditions) {
        return getSelf();
    }

    public T GROUP_BY(String columns) {
        return getSelf();
    }

    public T GROUP_BY(String ... columns) {
        return getSelf();
    }

    public T HAVING(String conditions) {
        return getSelf();
    }

    public T HAVING(String ... conditions) {
        return getSelf();
    }

    public T ORDER_BY(String columns) {
        return getSelf();
    }

    public T ORDER_BY(String ... columns) {
        return getSelf();
    }

    public T LIMIT(String variable) {
        return getSelf();
    }

    public T OFFSET(String variable) {
        return getSelf();
    }

    public T FETCH_FIRST_ROWS_ONLY(String variable) {
        return getSelf();
    }

    public T OFFSET_ROWS(String variable) {
        return getSelf();
    }

    @Override
    public String toString() {
    return "";
    }
}