// with SQLx

let unsafe_query = format!("SELECT * FROM people WHERE firstname='{remote_controlled_string}'");

let _ = conn.execute(unsafe_query.as_str()).await?; // BAD (arbitrary SQL injection is possible)

let _ = sqlx::query(unsafe_query.as_str()).fetch_all(&mut conn).await?; // BAD (arbitrary SQL injection is possible)
