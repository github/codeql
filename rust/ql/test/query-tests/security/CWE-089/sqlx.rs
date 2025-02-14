use sqlx::Connection;
use sqlx::Executor;

/**
 * This test is designed to be "run" in two ways:
 *  - you can extract and analyze the code here using the CodeQL test runner in the usual way,
 *    verifying the that various vulnerabilities are detected.
 *  - you can compile and run the code using `cargo`, verifying that it really is a complete
 *    program that compiles, runs and executes SQL commands (the sqlite ones, at least).
 *
 * To do the latter:
 *
 * Install `sqlx`:
 * ```
 * cargo install sqlx-cli
 * ```
 *
 * Create the database:
 * ```
 * export DATABASE_URL="sqlite:sqlite_database.db"
 * sqlx db create
 * sqlx migrate run
 * ```
 *
 * Build and run with the provided `cargo.toml.manual`:
 * ```
 * cp cargo.toml.manual cargo.toml
 * cargo run
 * ```
 *
 * You can also rebuild the sqlx 'query cache' in the `.sqlx` subdirectory
 * with:
 * ```
 * cargo sqlx prepare
 * ```
 * This allows the code (in particular the `prepare!` macro) to be built
 * in the test without setting `DATABASE_URL` first.
 */

async fn test_sqlx_mysql(url: &str, enable_remote: bool) -> Result<(), sqlx::Error> {
    // connect through a MySQL connection pool
    let pool = sqlx::mysql::MySqlPool::connect(url).await?;
    let mut conn = pool.acquire().await?;

    // construct queries (with extra variants)
    let const_string = String::from("Alice");
    let arg_string = std::env::args().nth(1).unwrap_or(String::from("Alice")); // $ MISSING: Source=args1
    let remote_string = reqwest::blocking::get("http://example.com/").unwrap().text().unwrap_or(String::from("Alice")); // $ Source=remote1
    let remote_number = remote_string.parse::<i32>().unwrap_or(0);
    let safe_query_1 = String::from("SELECT * FROM people WHERE firstname='Alice'");
    let safe_query_2 = String::from("SELECT * FROM people WHERE firstname='") + &const_string + "'";
    let safe_query_3 = format!("SELECT * FROM people WHERE firstname='{remote_number}'");
    let unsafe_query_1 = &arg_string;
    let unsafe_query_2 = &remote_string;
    let unsafe_query_3 = String::from("SELECT * FROM people WHERE firstname='") + &remote_string + "'";
    let unsafe_query_4 = format!("SELECT * FROM people WHERE firstname='{remote_string}'");
    let prepared_query_1 = String::from("SELECT * FROM people WHERE firstname=?"); // (prepared arguments are safe)

    // direct execution
    let _ = conn.execute(safe_query_1.as_str()).await?; // $ sql-sink
    let _ = conn.execute(safe_query_2.as_str()).await?; // $ sql-sink
    let _ = conn.execute(safe_query_3.as_str()).await?; // $ sql-sink
    let _ = conn.execute(unsafe_query_1.as_str()).await?; // $ sql-sink MISSING: Alert[rust/sql-injection]=args1
    if enable_remote {
        let _ = conn.execute(unsafe_query_2.as_str()).await?; // $ sql-sink MISSING: Alert[rust/sql-injection]=remote1
        let _ = conn.execute(unsafe_query_3.as_str()).await?; // $ sql-sink MISSING: Alert[rust/sql-injection]=remote1
        let _ = conn.execute(unsafe_query_4.as_str()).await?; // $ sql-sink Alert[rust/sql-injection]=remote1
    }

    // prepared queries
    let _ = sqlx::query(safe_query_1.as_str()).execute(&pool).await?; // $ sql-sink
    let _ = sqlx::query(safe_query_2.as_str()).execute(&pool).await?; // $ sql-sink
    let _ = sqlx::query(safe_query_3.as_str()).execute(&pool).await?; // $ sql-sink
    let _ = sqlx::query(unsafe_query_1.as_str()).execute(&pool).await?; // $ sql-sink MISSING: Alert[rust/sql-injection][rust/sql-injection]=args1
    if enable_remote {
        let _ = sqlx::query(unsafe_query_2.as_str()).execute(&pool).await?; // $ sql-sink MISSING: Alert[rust/sql-injection]=remote1
        let _ = sqlx::query(unsafe_query_3.as_str()).execute(&pool).await?; // $ sql-sink MISSING: Alert[rust/sql-injection]=remote1
        let _ = sqlx::query(unsafe_query_4.as_str()).execute(&pool).await?; // $ sql-sink Alert[rust/sql-injection]=remote1
    }
    let _ = sqlx::query(prepared_query_1.as_str()).bind(const_string).execute(&pool).await?; // $ sql-sink
    let _ = sqlx::query(prepared_query_1.as_str()).bind(arg_string).execute(&pool).await?; // $ sql-sink
    if enable_remote {
        let _ = sqlx::query(prepared_query_1.as_str()).bind(remote_string).execute(&pool).await?; // $ sql-sink
        let _ = sqlx::query(prepared_query_1.as_str()).bind(remote_number).execute(&pool).await?; // $ sql-sink
    }

    Ok(())
}

async fn test_sqlx_sqlite(url: &str, enable_remote: bool) -> Result<(), sqlx::Error> {
    // connect through SQLite, no connection pool
    let mut conn = sqlx::sqlite::SqliteConnection::connect(url).await?;

    // construct queries
    let const_string = String::from("Alice");
    let remote_string = reqwest::blocking::get("http://example.com/").unwrap().text().unwrap_or(String::from("Alice")); // $ MISSING: Source=remote2
    let safe_query_1 = String::from("SELECT * FROM people WHERE firstname='") + &const_string + "'";
    let unsafe_query_1 = String::from("SELECT * FROM people WHERE firstname='") + &remote_string + "'";
    let prepared_query_1 = String::from("SELECT * FROM people WHERE firstname=?"); // (prepared arguments are safe)

    // direct execution (with extra variants)
    let _ = conn.execute(safe_query_1.as_str()).await?; // $ sql-sink
    if enable_remote {
        let _ = conn.execute(unsafe_query_1.as_str()).await?; // $ sql-sink MISSING: Alert[rust/sql-injection]=remote2
    }
    // ...
    let _ = sqlx::raw_sql(safe_query_1.as_str()).execute(&mut conn).await?; // $ sql-sink
    if enable_remote {
        let _ = sqlx::raw_sql(unsafe_query_1.as_str()).execute(&mut conn).await?; // $ sql-sink MISSING: Alert[rust/sql-injection]=remote2
    }

    // prepared queries (with extra variants)
    let _ = sqlx::query(safe_query_1.as_str()).execute(&mut conn).await?; // $ sql-sink
    let _ = sqlx::query(prepared_query_1.as_str()).bind(&const_string).execute(&mut conn).await?; // $ sql-sink
    if enable_remote {
        let _ = sqlx::query(unsafe_query_1.as_str()).execute(&mut conn).await?; // $ sql-sink MISSING: Alert[rust/sql-injection]=remote2
        let _ = sqlx::query(prepared_query_1.as_str()).bind(&remote_string).execute(&mut conn).await?; // $ sql-sink
    }
    // ...
    let _ = sqlx::query(safe_query_1.as_str()).fetch(&mut conn); // $ sql-sink
    let _ = sqlx::query(prepared_query_1.as_str()).bind(&const_string).fetch(&mut conn); // $ sql-sink
    if enable_remote {
        let _ = sqlx::query(unsafe_query_1.as_str()).fetch(&mut conn); // $ sql-sink MISSING: Alert[rust/sql-injection]=remote2
        let _ = sqlx::query(prepared_query_1.as_str()).bind(&remote_string).fetch(&mut conn); // $ sql-sink
    }
    // ...
    let row1: (i64, String, String) = sqlx::query_as(safe_query_1.as_str()).fetch_one(&mut conn).await?; // $ sql-sink
    println!("  row1 = {:?}", row1);
    let row2: (i64, String, String) = sqlx::query_as(prepared_query_1.as_str()).bind(&const_string).fetch_one(&mut conn).await?; // $ sql-sink
    println!("  row2 = {:?}", row2);
    if enable_remote {
        let _: (i64, String, String) = sqlx::query_as(unsafe_query_1.as_str()).fetch_one(&mut conn).await?; // $ sql-sink MISSING: Alert[rust/sql-injection]=remote2
        let _: (i64, String, String) = sqlx::query_as(prepared_query_1.as_str()).bind(&remote_string).fetch_one(&mut conn).await?; // $ sql-sink
    }
    // ...
    let row3: (i64, String, String) = sqlx::query_as(safe_query_1.as_str()).fetch_optional(&mut conn).await?.expect("no data"); // $ sql-sink
    println!("  row3 = {:?}", row3);
    let row4: (i64, String, String) = sqlx::query_as(prepared_query_1.as_str()).bind(&const_string).fetch_optional(&mut conn).await?.expect("no data"); // $ sql-sink
    println!("  row4 = {:?}", row4);
    if enable_remote {
        let _: (i64, String, String) = sqlx::query_as(unsafe_query_1.as_str()).fetch_optional(&mut conn).await?.expect("no data"); // $ sql-sink $ MISSING: Alert[rust/sql-injection]=remote2
        let _: (i64, String, String) = sqlx::query_as(prepared_query_1.as_str()).bind(&remote_string).fetch_optional(&mut conn).await?.expect("no data"); // $ sql-sink
    }
    // ...
    let _ = sqlx::query(safe_query_1.as_str()).fetch_all(&mut conn).await?; // $ sql-sink
    let _ = sqlx::query(prepared_query_1.as_str()).bind(&const_string).fetch_all(&mut conn).await?; // $ sql-sink
    let _ = sqlx::query("SELECT * FROM people WHERE firstname=?").bind(&const_string).fetch_all(&mut conn).await?; // $ sql-sink
    if enable_remote {
        let _ = sqlx::query(unsafe_query_1.as_str()).fetch_all(&mut conn).await?; // $ sql-sink MISSING: Alert[rust/sql-injection]=remote2
        let _ = sqlx::query(prepared_query_1.as_str()).bind(&remote_string).fetch_all(&mut conn).await?; // $ sql-sink
        let _ = sqlx::query("SELECT * FROM people WHERE firstname=?").bind(&remote_string).fetch_all(&mut conn).await?; // $ sql-sink
    }
    // ...
    let _ = sqlx::query!("SELECT * FROM people WHERE firstname=$1", const_string).fetch_all(&mut conn).await?; // $ MISSING: sql-sink (only takes string literals, so can't be vulnerable)
    if enable_remote {
        let _ = sqlx::query!("SELECT * FROM people WHERE firstname=$1", remote_string).fetch_all(&mut conn).await?; // $ MISSING: sql-sink
    }

    Ok(())
}

async fn test_sqlx_postgres(url: &str, enable_remote: bool) -> Result<(), sqlx::Error> {
    // connect through a PostgreSQL connection pool
    let pool = sqlx::postgres::PgPool::connect(url).await?;
    let mut conn = pool.acquire().await?;

    // construct queries
    let const_string = String::from("Alice");
    let remote_string = reqwest::blocking::get("http://example.com/").unwrap().text().unwrap_or(String::from("Alice")); // $ MISSING: Source=remote3
    let safe_query_1 = String::from("SELECT * FROM people WHERE firstname='") + &const_string + "'";
    let unsafe_query_1 = String::from("SELECT * FROM people WHERE firstname='") + &remote_string + "'";
    let prepared_query_1 = String::from("SELECT * FROM people WHERE firstname=$1"); // (prepared arguments are safe)

    // direct execution
    let _ = conn.execute(safe_query_1.as_str()).await?; // $ sql-sink
    if enable_remote {
        let _ = conn.execute(unsafe_query_1.as_str()).await?; // $ sql-sink MISSING: Alert[rust/sql-injection]=remote3
    }

    // prepared queries
    let _ = sqlx::query(safe_query_1.as_str()).execute(&pool).await?; // $ sql-sink
    let _ = sqlx::query(prepared_query_1.as_str()).bind(&const_string).execute(&pool).await?; // $ sql-sink
    if enable_remote {
        let _ = sqlx::query(unsafe_query_1.as_str()).execute(&pool).await?; // $ sql-sink MISSING: Alert[rust/sql-injection]=remote3
        let _ = sqlx::query(prepared_query_1.as_str()).bind(&remote_string).execute(&pool).await?; // $ sql-sink
    }

    Ok(())
}

fn main() {
    println!("--- CWE-089 sqlx.rs test ---");

    // we don't *actually* use data from a remote source unless we're explicitly told to at the
    // command line; that's because this test is designed to be runnable, and we don't really
    // want to expose the test database to potential SQL injection from http://example.com/ -
    // no matter how unlikely, local and compartmentalized that may seem.
    let enable_remote = std::env::args().nth(1) == Some(String::from("ENABLE_REMOTE"));
    println!("enable_remote = {enable_remote}");

    println!("test_sqlx_mysql...");
    match futures::executor::block_on(test_sqlx_mysql("", enable_remote)) {
        Ok(_) => println!("  successful!"),
        Err(e) => println!("  error: {}", e),
    }

    println!("test_sqlx_sqlite...");
    match futures::executor::block_on(test_sqlx_sqlite("sqlite:sqlite_database.db", enable_remote)) {
        Ok(_) => println!("  successful!"),
        Err(e) => println!("  error: {}", e),
    }

    println!("test_sqlx_postgres...");
    match futures::executor::block_on(test_sqlx_postgres("", enable_remote)) {
        Ok(_) => println!("  successful!"),
        Err(e) => println!("  error: {}", e),
    }
}
