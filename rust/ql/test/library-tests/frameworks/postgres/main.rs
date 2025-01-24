

fn main() -> Result<(), Box<dyn std::error::Error>> {
    // Get input from CLI
    let args: Vec<String> = std::env::args().collect();
    let name = &args[1];
    let age = &args[2];

    let mut conn = postgres::Client::connect("host=localhost user=postgres", postgres::NoTls)?;

    conn.execute(       // $ sql-sink
        "CREATE TABLE person (
            id SERIAL PRIMARY KEY,
            name VARCHAR NOT NULL,
            age INT NOT NULL
        )",
        &[],
    )?;
    
    let query = format!("INSERT INTO person (name, age) VALUES ('{}', '{}')", name, age);

    conn.execute(query.as_str(), &[])?;     // $ sql-sink
    conn.batch_execute(query.as_str())?;    // $ sql-sink

    conn.prepare(query.as_str())?;          // $ sql-sink
    // conn.prepare_typed(query.as_str(), &[])?;

    conn.query(query.as_str(), &[])?;       // $ sql-sink
    conn.query_one(query.as_str(), &[])?;   // $ sql-sink
    conn.query_opt(query.as_str(), &[])?;   // $ sql-sink
    // conn.query_raw(query.as_str(), &[])?;
    // conn.query_typed(query.as_str(), &[])?;
    // conn.query_typed_raw(query.as_str(), &[])?;

    for row in &conn.query("SELECT id, name, age FROM person", &[])? {  // $ sql-sink
        let id: i32 = row.get("id");
        let name: &str = row.get("name");
        let age: i32 = row.get("age");
        println!("found person: {} {} {}", id, name, age);
    }

    Ok(())
}