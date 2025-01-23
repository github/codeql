
use rusqlite::Connection;

#[derive(Debug)]
struct Person {
    id: i32,
    name: String,
    age: i32,
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    // Get input from CLI
    let args: Vec<String> = std::env::args().collect();
    let name = &args[1];
    let age = &args[2];

    let connection = Connection::open_in_memory()?;

    connection.execute(       // $ sql-sink
        "CREATE TABLE person (
            id SERIAL PRIMARY KEY,
            name VARCHAR NOT NULL,
            age INT NOT NULL
        )",
        (),
    )?;
    
    let query = format!("INSERT INTO person (name, age) VALUES ('{}', '{}')", name, age);

    connection.execute(&query, ())?;    // $ sql-sink

    let person = connection.query_row(&query, (), |row| {    // $ sql-sink
        Ok(Person {
            id: row.get(0)?,
            name: row.get(1)?,
            age: row.get(2)?,
        })
    })?;

    let mut stmt = connection.prepare("SELECT id, name, age FROM person")?;      // $ sql-sink
    let people = stmt.query_map([], |row| {
        Ok(Person {
            id: row.get(0)?,
            name: row.get(1)?,
            age: row.get(2)?,
        })
    })?;

    Ok(())
}