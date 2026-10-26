using System.Collections.Generic;
using System.Linq;
using ServiceStack;
using System.Threading.Tasks;
using System;
using Microsoft.AspNetCore.Components.Forms;
using ServiceStack.OrmLite;

namespace ServiceStackTest
{
    public class Table
    {
        public int Column { get; set; }
    }

    public class Sql
    {
        public static async Task M()
        {
            ServiceStack.OrmLite.SqlExpression<int> expr = null;

            expr = expr.Select<Table>(t => t.Column); // ok

            expr = expr
                .UnsafeAnd("SQL")
                .UnsafeFrom("SQL")
                .UnsafeGroupBy("SQL")
                .UnsafeHaving("SQL")
                .UnsafeOr("SQL")
                .UnsafeOrderBy("SQL")
                .UnsafeSelect("SQL")
                .UnsafeWhere("SQL");

            var untyped = expr.GetUntypedSqlExpression();

            untyped
                .UnsafeAnd("SQL")
                .UnsafeFrom("SQL")
                .UnsafeOr("SQL")
                .UnsafeSelect("SQL")
                .UnsafeWhere("SQL")
                .Where("SQL");       // safe

            System.Data.IDbConnection conn = null;

            var row = conn.SingleById<Table>(1); // ok

            var rows = conn.Select<Table>(typeof(Table), "SQL", null);
            rows = await conn.SelectAsync<Table>(typeof(Table), "SQL", null);

            var count = conn.RowCount("SQL");
            count = await conn.RowCountAsync("SQL");

            conn.ExecuteSql("SQL", null);
            await conn.ExecuteSqlAsync("SQL", null);
        }

        public static async Task Redis()
        {
            ServiceStack.Redis.IRedisClient client = null;

            client.SetValue("key", "value"); // ok

            var s = client.LoadLuaScript("script");
            client.ExecLua("script", new[] { "" }, new[] { "" });
            client.ExecLuaSha("SHA", new[] { "" }, new[] { "" }); // ok
            client.Custom("command", "arg");        // false negative, params sinks doesn't work

            ServiceStack.Redis.IRedisClientAsync asyncClient = null;
            s = await asyncClient.LoadLuaScriptAsync("script");
            asyncClient.ExecLuaAsync("script", new[] { "" }, new[] { "" });
        }
    }
}
