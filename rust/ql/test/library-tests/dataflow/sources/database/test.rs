fn sink<T>(_: T) { }

// --- tests ---

mod test_mysql {
    use mysql::*;
    use mysql::prelude::*;
    use super::sink;

    pub fn test_mysql() -> Result<(), Box<dyn std::error::Error>> {
        // connect through a MySQL connection pool
        let mut pool = mysql::Pool::new("")?;
        let mut conn = pool.get_conn()?;

        let mut rows : Vec<mysql::Row> = conn.query("SELECT id, name, age FROM person")?; // $ Alert[rust/summary/taint-sources]
        let mut row = &mut rows[0];

        let v1 : i64 = row.get(0).unwrap(); // $ Alert[rust/summary/taint-sources]
        sink(v1); // $ hasTaintFlow=0

        let v2 : i64 = row.get_opt(0).unwrap().unwrap(); // $ Alert[rust/summary/taint-sources]
        sink(v2); // $ hasTaintFlow=0

        let v3 : i64 = row.take(0).unwrap(); // $ Alert[rust/summary/taint-sources]
        sink(v3); // $ hasTaintFlow=0

        let v4 : i64 = row.take_opt(0).unwrap().unwrap(); // $ Alert[rust/summary/taint-sources]
        sink(v4); // $ hasTaintFlow=0

        let value5 = row.as_ref(0).unwrap(); // $ Alert[rust/summary/taint-sources]
        if let mysql::Value::Int(v) = value5 {
            sink(v); // $ MISSING: hasTaintFlow=0
        } else if let mysql::Value::Bytes(v) = value5 {
            sink(v); // $ MISSING: hasTaintFlow=0
        }

        let v6: i64 = conn.query_first("SELECT id FROM person")?.unwrap(); // $ Alert[rust/summary/taint-sources]
        sink(v6); // $ hasTaintFlow

        let mut t1 = conn.exec_iter("SELECT id FROM person", (1, 2, 3))?; // $ Alert[rust/summary/taint-sources]
        sink(t1.nth(0).unwrap().unwrap().get::<i64, usize>(1).unwrap()); // $ Alert[rust/summary/taint-sources] hasTaintFlow=1
        for row in t1 {
            for v in row {
                sink(v); // $ hasTaintFlow
            }
        }

        let _ = conn.query_map( // $ Alert[rust/summary/taint-sources]
            "SELECT id FROM person",
            |values: i64| -> () {
                sink(values); // $ hasTaintFlow
            }
        )?;

        let _ = conn.query_map( // $ Alert[rust/summary/taint-sources]
            "SELECT id, name, age FROM person",
            |values: (i64, String, i32)| -> () {
                sink(values.0); // $ MISSING: hasTaintFlow
                sink(values.1); // $ MISSING: hasTaintFlow
                sink(values.2); // $ MISSING: hasTaintFlow
            }
        )?;

        let total = conn.query_fold("SELECT id FROM person", 0, |acc: i64, row: i64| { // $ Alert[rust/summary/taint-sources]
            sink(row); // $ hasTaintFlow
            acc + row
        })?;
        sink(total); // $ hasTaintFlow

        let _ = conn.query_fold("SELECT id, name, age FROM person", 0, |acc: i64, row: (i64, String, i32)| { // $ Alert[rust/summary/taint-sources]
            let id: i64 = row.0;
            let name: String = row.1;
            let age: i32 = row.2;
            sink(id); // $ MISSING: hasTaintFlow
            sink(name); // $ MISSING: hasTaintFlow
            sink(age); // $ MISSING: hasTaintFlow
            acc + 1
        })?;

        Ok(())
    }
}

mod test_mysql_async {
    use mysql_async::*;
    use mysql_async::prelude::*;
    use async_std::stream::StreamExt;
    use super::sink;

    #[derive(Debug, PartialEq, Eq, Clone)]
    struct Person {
        id: i64,
        name: String,
        age: i32,
    }

    pub async fn test_mysql_async() -> Result<()> {
        // connect through a MySQL connection pool
        let mut pool = mysql_async::Pool::new("");
        let mut conn = pool.get_conn().await?;

        let mut rows : Vec<mysql_async::Row> = conn.query("SELECT id, name, age FROM person").await?; // $ Alert[rust/summary/taint-sources]
        let mut row = &mut rows[0];

        let v1 : i64 = row.get(0).unwrap(); // $ Alert[rust/summary/taint-sources]
        sink(v1); // $ hasTaintFlow=0

        let v2 : i64 = row.get_opt(0).unwrap().unwrap(); // $ Alert[rust/summary/taint-sources]
        sink(v2); // $ hasTaintFlow=0

        let v3 : i64 = row.take(0).unwrap(); // $ Alert[rust/summary/taint-sources]
        sink(v3); // $ hasTaintFlow=0

        let v4 : i64 = row.take_opt(0).unwrap().unwrap(); // $ Alert[rust/summary/taint-sources]
        sink(v4); // $ hasTaintFlow=0

        let value5 = row.as_ref(0).unwrap(); // $ Alert[rust/summary/taint-sources]
        if let mysql_async::Value::Int(v) = value5 {
            sink(v); // $ MISSING: hasTaintFlow=0
        } else if let mysql_async::Value::Bytes(v) = value5 {
            sink(v); // $ MISSING: hasTaintFlow=0
        }

        let v6: i64 = conn.query_first("SELECT id FROM person").await?.unwrap(); // $ Alert[rust/summary/taint-sources]
        sink(v6); // $ MISSING: hasTaintFlow

        let mut t1 = conn.exec_iter("SELECT id FROM person", (1, 2, 3)).await?; // $ Alert[rust/summary/taint-sources]
        for mut row in t1.stream::<(i64, String, i32)>().await? {
            while let v = row.next().await {
                let v = v.unwrap();
                sink(v); // $ MISSING: hasTaintFlow
            }
        }

        let _ = conn.query_map( // $ Alert[rust/summary/taint-sources]
            "SELECT id FROM person",
            |values: i64| -> () {
                sink(values); // $ hasTaintFlow
            }
        ).await?;

        let _ = conn.query_map( // $ Alert[rust/summary/taint-sources]
            "SELECT id, name, age FROM person",
            |values: (i64, String, i32)| -> () {
                sink(values.0); // $ MISSING: hasTaintFlow
                sink(values.1); // $ MISSING: hasTaintFlow
                sink(values.2); // $ MISSING: hasTaintFlow
            }
        ).await?;

        let total = conn.query_fold("SELECT id FROM person", 0, |acc: i64, row: i64| { // $ Alert[rust/summary/taint-sources]
            sink(row); // $ hasTaintFlow
            acc + row
        }).await?;
        sink(total); // $ hasTaintFlow

        let _ = conn.query_fold("SELECT id, name, age FROM person", 0, |acc: i64, row: (i64, String, i32)| { // $ Alert[rust/summary/taint-sources]
            let id: i64 = row.0;
            let name: String = row.1;
            let age: i32 = row.2;
            sink(id); // $ MISSING: hasTaintFlow
            sink(name); // $ MISSING: hasTaintFlow
            sink(age); // $ MISSING: hasTaintFlow
            acc + 1
        }).await?;

        let ids = "SELECT id FROM person".with(()).map(&mut conn,
            |person: i64| -> i64 {
                sink(person); // $ MISSING: hasTaintFlow
                person
            }
        ).await?;
        sink(ids[0]); // $ MISSING: hasTaintFlow

        let ages = "SELECT id, name, age FROM person".with(()).map(&mut conn, // $ MISSING: Alert[rust/summary/taint-sources]
            |person: (i64, String, i32)| -> i32 {
                sink(person.0); // $ MISSING: hasTaintFlow
                sink(person.1); // $ MISSING: hasTaintFlow
                sink(person.2); // $ MISSING: hasTaintFlow
                person.2
            }
        ).await?;
        sink(ages[0]); // $ MISSING: hasTaintFlow

        {
            let mut stream = "SELECT id FROM person".stream::<i64, _>(&mut conn).await?; // $ MISSING: Alert[rust/summary/taint-sources]
            while let Some(row) = stream.next().await {
                let id = row?;
                sink(id); // $ MISSING: hasTaintFlow
            }
        }

        {
            let mut stream = "SELECT id, name, age FROM person".stream::<(i64, String, i32), _>(&mut conn).await?; // $ MISSING: Alert[rust/summary/taint-sources]
            while let Some(row) = stream.next().await {
                let (id, name, age) = row?;
                sink(id); // $ MISSING: hasTaintFlow
                sink(name); // $ MISSING: hasTaintFlow
                sink(age); // $ MISSING: hasTaintFlow
            }
        }

        Ok(())
    }
}

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    println!("test_mysql...");
    match test_mysql::test_mysql() {
        Ok(_) => println!("complete"),
        Err(e) => println!("error: {}", e),
    }

    println!("test_mysql_async...");
    match futures::executor::block_on(test_mysql_async::test_mysql_async()) {
        Ok(_) => println!("complete"),
        Err(e) => println!("error: {}", e),
    }

    Ok(())
}
