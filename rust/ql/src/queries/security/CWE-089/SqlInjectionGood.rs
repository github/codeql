// with SQLx

let prepared_query = "SELECT * FROM people WHERE firstname=?";

let _ = sqlx::query(prepared_query_1).bind(&remote_controlled_string).fetch_all(&mut conn).await?; // GOOD (prepared statement with bound parameter)
