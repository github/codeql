mod sync_test {
    use mysql::prelude::*;
    use mysql::*;

    pub fn test_mysql(url: &str) -> Result<(), Box<dyn std::error::Error>> {
        // connect through a MySQL connection pool
        let mut pool = Pool::new("")?; // (this test is not runnable)
        let mut conn: PooledConn = pool.get_conn()?;
        let mut conn2: Conn = pool.get_conn()?.unwrap();

        // construct queries
        let mut remote_string = reqwest::blocking::get("http://example.com/") // $ Source=remote10
            .unwrap()
            .text()
            .unwrap_or(String::from(""));
        let safe_query = String::from("SELECT * FROM people WHERE firstname='Alice'");
        let unsafe_query =
            String::from("SELECT * FROM people WHERE firstname='") + &remote_string + "'";
        let prepared_query = String::from("SELECT * FROM people WHERE firstname=?"); // (prepared arguments are safe)

        // direct execution (safe)
        let _: Vec<i64> = conn.query(safe_query.as_str())?; // $ sql-sink

        // direct execution (unsafe)
        let _: Vec<i64> = conn.query(unsafe_query.as_str())?; // $ sql-sink Alert[rust/sql-injection]=remote10
        let _: Vec<Result<i64, FromRowError>> = conn.query_opt(unsafe_query.as_str())?; // $ sql-sink Alert[rust/sql-injection]=remote10
        conn.query_drop(unsafe_query.as_str()); // $ sql-sink Alert[rust/sql-injection]=remote10
        let _: i64 = conn.query_first(unsafe_query.as_str())?.unwrap(); // $ sql-sink Alert[rust/sql-injection]=remote10
        let _: Result<i64, FromRowError> = conn.query_first_opt(unsafe_query.as_str())?.unwrap(); // $ sql-sink Alert[rust/sql-injection]=remote10
        let _ = conn.query_fold(unsafe_query.as_str(), 0, |_: i64, _: i64| -> i64 { 0 })?; // $ sql-sink Alert[rust/sql-injection]=remote10
        let _ = conn.query_fold_opt( // $ sql-sink Alert[rust/sql-injection]=remote10
            unsafe_query.as_str(),
            0,
            |_: i64, _: Result<i64, FromRowError>| -> i64 { 0 },
        )?;
        let _ = conn.query_iter(unsafe_query.as_str())?; // $ sql-sink Alert[rust/sql-injection]=remote10
        let _ = conn.query_map(unsafe_query.as_str(), |_: i64| -> () {})?; // $ sql-sink Alert[rust/sql-injection]=remote10
        let _ = conn.query_map_opt( // $ sql-sink Alert[rust/sql-injection]=remote10
            unsafe_query.as_str(),
            |_: Result<i64, FromRowError>| -> () {},
        )?;
        let _: Vec<i64> = conn2.query(unsafe_query.as_str())?; // $ sql-sink Alert[rust/sql-injection]=remote10

        // prepared queries (safe)
        let stmt = conn.prep(prepared_query.as_str())?; // $ sql-sink
        let _: Vec<i64> = conn.exec(&stmt, (remote_string.as_str(),))?;
        let _: Vec<Result<i64, FromRowError>> = conn.exec_opt(&stmt, (remote_string.as_str(),))?;
        let _ = conn.exec_batch(&stmt, vec![(remote_string.as_str(),)])?;
        conn.exec_drop(&stmt, (&remote_string.as_str(),));
        let _: i64 = conn.exec_first(&stmt, (remote_string.as_str(),))?.unwrap();
        let _: Result<i64, FromRowError> = conn
            .exec_first_opt(&stmt, (remote_string.as_str(),))?
            .unwrap();
        let _ = conn.exec_fold(
            &stmt,
            (remote_string.as_str(),),
            0,
            |_: i64, _: i64| -> i64 { 0 },
        )?;
        let _ = conn.exec_fold_opt(
            &stmt,
            (remote_string.as_str(),),
            0,
            |_: i64, _: Result<i64, FromRowError>| -> i64 { 0 },
        )?;
        let _ = conn.exec_iter(&stmt, (remote_string.as_str(),))?;
        let _ = conn.exec_map(&stmt, (remote_string.as_str(),), |_: i64| -> () {})?;
        let _ = conn.exec_map_opt(
            &stmt,
            (remote_string.as_str(),),
            |_: Result<i64, FromRowError>| -> () {},
        )?;

        // prepared queries (unsafe use)
        let stmt2 = conn.prep(unsafe_query.as_str())?; // $ sql-sink Alert[rust/sql-injection]=remote10
        // ...

        // transactions
        let mut trans = conn.start_transaction(TxOpts::default())?;
        trans.query_drop(unsafe_query.as_str()); // $ sql-sink Alert[rust/sql-injection]=remote10
        trans.commit()?;

        Ok(())
    }
}

mod async_test {
    use mysql_async::prelude::*;
    use mysql_async::*;

    pub async fn test_mysql_async(url: &str) -> Result<()> {
        // connect through a MySQL connection pool
        let mut pool = Pool::new(""); // (this test is not runnable)
        let mut conn = pool.get_conn().await?;

        // construct queries
        let mut remote_string = reqwest::blocking::get("http://example.com/") // $ Source=remote11
            .unwrap()
            .text()
            .unwrap_or(String::from(""));
        let safe_query = String::from("SELECT * FROM people WHERE firstname='Alice'");
        let unsafe_query =
            String::from("SELECT * FROM people WHERE firstname='") + &remote_string + "'";
        let prepared_query = String::from("SELECT * FROM people WHERE firstname=?"); // (prepared arguments are safe)

        // direct execution (safe)
        let _: Vec<i64> = conn.query(safe_query.as_str()).await?; // $ sql-sink

        // direct execution (unsafe)
        let _: Vec<i64> = conn.query(unsafe_query.as_str()).await?; // $ sql-sink Alert[rust/sql-injection]=remote11
        conn.query_drop(unsafe_query.as_str()); // $ sql-sink Alert[rust/sql-injection]=remote11
        let _: Option<i64> = conn.query_first(unsafe_query.as_str()).await?; // $ sql-sink Alert[rust/sql-injection]=remote11
        let _ = conn
            .query_fold(unsafe_query.as_str(), 0, |_: i64, _: i64| -> i64 { 0 }) // $ sql-sink Alert[rust/sql-injection]=remote11
            .await?;
        let _ = conn.query_iter(unsafe_query.as_str()).await?; // $ sql-sink Alert[rust/sql-injection]=remote11
        let _ = conn
            .query_stream::<i64, &str>(unsafe_query.as_str()) // $ sql-sink Alert[rust/sql-injection]=remote11
            .await?;
        let _ = conn
            .query_map(unsafe_query.as_str(), |_: i64| -> () {}) // $ sql-sink Alert[rust/sql-injection]=remote11
            .await?;

        // prepared queries (safe)
        let stmt = conn.prep(prepared_query.as_str()).await?; // $ sql-sink
        let _: Vec<i64> = conn.exec(&stmt, (remote_string.as_str(),)).await?;
        let _ = conn
            .exec_batch(&stmt, vec![(remote_string.as_str(),)])
            .await?;
        conn.exec_drop(&stmt, (&remote_string.as_str(),));
        let _: Option<i64> = conn.exec_first(&stmt, (remote_string.as_str(),)).await?;
        let _ = conn
            .exec_fold(
                &stmt,
                (remote_string.as_str(),),
                0,
                |_: i64, _: i64| -> i64 { 0 },
            )
            .await?;
        let _ = conn.exec_iter(&stmt, (remote_string.as_str(),)).await?;
        let _ = conn
            .exec_stream::<i64, &Statement, (&str,)>(&stmt, (remote_string.as_str(),))
            .await?;
        let _ = conn
            .exec_map(&stmt, (remote_string.as_str(),), |_: i64| -> () {})
            .await?;

        // prepared queries (unsafe use)
        let stmt2 = conn.prep(unsafe_query.as_str()).await?; // $ sql-sink Alert[rust/sql-injection]=remote11
        // ...

        // transactions
        let mut trans = conn.start_transaction(TxOpts::default()).await?;
        trans.query_drop(unsafe_query.as_str()); // $ sql-sink Alert[rust/sql-injection]=remote11
        trans.commit().await?;

        Ok(())
    }
}

fn main() {
    println!("test_mysql...");
    match sync_test::test_mysql("") {
        Ok(_) => println!("  successful!"),
        Err(e) => println!("  error: {}", e),
    }

    println!("test_mysql_async...");
    match futures::executor::block_on(async_test::test_mysql_async("")) {
        Ok(_) => println!("  successful!"),
        Err(e) => println!("  error: {}", e),
    }
}
