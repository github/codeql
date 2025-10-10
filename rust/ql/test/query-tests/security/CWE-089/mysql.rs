use mysql::*;
use mysql::prelude::*;

async fn test_mysql(url: &str) -> Result<(), Box<dyn std::error::Error>> {
    // connect through a MySQL connection pool
    let mut pool = Pool::new("")?; // (this test is not runnable)
    let mut conn: PooledConn = pool.get_conn()?;
    let mut conn2: Conn = pool.get_conn()?.unwrap();

    // construct queries
    let mut remote_string = reqwest::blocking::get("http://example.com/").unwrap().text().unwrap_or(String::from("")); // $ MISSING: Source=remote10
    let safe_query = String::from("SELECT * FROM people WHERE firstname='Alice'");
    let unsafe_query = String::from("SELECT * FROM people WHERE firstname='") + &remote_string + "'";
    let prepared_query = String::from("SELECT * FROM people WHERE firstname=?"); // (prepared arguments are safe)

    // direct execution (safe)
    let _ : Vec<i64> = conn.query(safe_query.as_str())?;

    // direct execution (unsafe)
    let _ : Vec<i64> = conn.query(unsafe_query.as_str())?; // $ MISSING: sql-sink Alert[rust/sql-injection]=remote10
    let _ : Vec<Result<i64, FromRowError>> = conn.query_opt(unsafe_query.as_str())?; // $ MISSING: sql-sink Alert[rust/sql-injection]=remote10
    conn.query_drop(unsafe_query.as_str()); // $ MISSING: sql-sink Alert[rust/sql-injection]=remote10
    let _ : i64 = conn.query_first(unsafe_query.as_str())?.unwrap(); // $ MISSING: sql-sink Alert[rust/sql-injection]=remote10
    let _ : Result<i64, FromRowError>= conn.query_first_opt(unsafe_query.as_str())?.unwrap(); // $ MISSING: sql-sink Alert[rust/sql-injection]=remote10
    let _ = conn.query_fold(unsafe_query.as_str(), 0, |_: i64, _: i64| -> i64 { 0 })?; // $ MISSING: sql-sink Alert[rust/sql-injection]=remote10
    let _ = conn.query_fold_opt(unsafe_query.as_str(), 0, |_: i64, _: Result<i64, FromRowError>| -> i64 { 0 })?; // $ MISSING: sql-sink Alert[rust/sql-injection]=remote10
    let _ = conn.query_iter(unsafe_query.as_str())?; // $ MISSING: sql-sink Alert[rust/sql-injection]=remote10
    let _ = conn.query_map(unsafe_query.as_str(), |_: i64| -> () {})?; // $ MISSING: sql-sink Alert[rust/sql-injection]=remote10
    let _ = conn.query_map_opt(unsafe_query.as_str(), |_: Result<i64, FromRowError>| -> () {})?; // $ MISSING: sql-sink Alert[rust/sql-injection]=remote10
    let _ : Vec<i64> = conn2.query(unsafe_query.as_str())?; // $ MISSING: sql-sink Alert[rust/sql-injection]=remote10

    // prepared queries (safe)
    let stmt = conn.prep(prepared_query.as_str())?;
    let _ : Vec<i64> = conn.exec(&stmt, (remote_string.as_str(),))?;
    let _ : Vec<Result<i64, FromRowError>> = conn.exec_opt(&stmt, (remote_string.as_str(),))?;
    let _ = conn.exec_batch(&stmt, vec![(remote_string.as_str(),)])?;
    conn.exec_drop(&stmt, (&remote_string.as_str(),));
    let _ : i64 = conn.exec_first(&stmt, (remote_string.as_str(),))?.unwrap();
    let _ : Result<i64, FromRowError> = conn.exec_first_opt(&stmt, (remote_string.as_str(),))?.unwrap();
    let _ = conn.exec_fold(&stmt, (remote_string.as_str(),), 0, |_: i64, _: i64| -> i64 { 0 })?;
    let _ = conn.exec_fold_opt(&stmt, (remote_string.as_str(),), 0, |_: i64, _: Result<i64, FromRowError>| -> i64 { 0 })?;
    let _ = conn.exec_iter(&stmt, (remote_string.as_str(),))?;
    let _ = conn.exec_map(&stmt, (remote_string.as_str(),), |_: i64| -> () {})?;
    let _ = conn.exec_map_opt(&stmt, (remote_string.as_str(),), |_: Result<i64, FromRowError>| -> () {})?;

    Ok(())
}

fn main() {
    println!("test_mysql...");
    match futures::executor::block_on(test_mysql("")) {
        Ok(_) => println!("  successful!"),
        Err(e) => println!("  error: {}", e),
    }
}
