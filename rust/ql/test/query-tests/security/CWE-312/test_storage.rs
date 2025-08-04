
use aes_gcm::aead::{Aead, AeadCore, OsRng};
use aes_gcm::aes::cipher::Unsigned;
use aes_gcm::{Aes256Gcm, KeyInit};
use base64::prelude::*;

use sqlx::Connection;
use sqlx::Executor;

// --- tests ---

fn get_harmless() -> String {
  return String::from("harmless");
}

fn get_social_security_number() -> String {
  return String::from("1234567890");
}

fn get_phone_number() -> String {
  return String::from("1234567890");
}

fn get_email() -> String {
  return String::from("a@b.com");
}

fn get_ccn() -> String {
  return String::from("1234567890");
}

fn encrypt(text: String, encryption_key: &aes_gcm::Key<Aes256Gcm>) -> String {
    // encrypt text -> ciphertext
    let cipher = Aes256Gcm::new(&encryption_key);
    let nonce = Aes256Gcm::generate_nonce(&mut OsRng);
    let ciphertext = cipher.encrypt(&nonce, text.as_ref()).unwrap();

    // append (nonce, ciphertext)
    let mut combined = nonce.to_vec();
    combined.extend(ciphertext);

    // encode to base64 string
    BASE64_STANDARD.encode(combined)
}

fn decrypt(data: String, encryption_key: &aes_gcm::Key<Aes256Gcm>) -> String {
    let cipher = Aes256Gcm::new(&encryption_key);

    // decode base64 string
    let decoded = BASE64_STANDARD.decode(data).unwrap();

    // split into (nonce, ciphertext)
    let nonce_size = <Aes256Gcm as AeadCore>::NonceSize::to_usize();
    let (nonce, ciphertext) = decoded.split_at(nonce_size);

    // decrypt ciphertext -> plaintext
    let plaintext = cipher.decrypt(nonce.into(), ciphertext).unwrap();
    String::from_utf8(plaintext).unwrap()
}

async fn test_storage_sqlx_sql_command(url: &str) -> Result<(), sqlx::Error> {
    // connect through a MySQL connection pool
    let pool1 = sqlx::mysql::MySqlPool::connect(url).await?;
    let mut conn1 = pool1.acquire().await?;

    // construct queries
    let id = "123";
    let select_query1 = String::from("SELECT * FROM CONTACTS WHERE ID = ") + id;
    let select_query2 = String::from("SELECT * FROM CONTACTS WHERE SSN = '") + &get_social_security_number() + "'";
    let insert_query1 = String::from("INSERT INTO CONTACTS(ID, HARMLESS) VALUES(") + id + ", '" + &get_harmless() + "')";
    let insert_query2 = String::from("INSERT INTO CONTACTS(ID, PHONE) VALUES(") + id + ", '" + &get_phone_number() + "')"; // $ Source[rust/cleartext-storage-database]
    let update_query1 = String::from("UPDATE CONTACTS SET HARMLESS='") + &get_harmless() + "' WHERE ID=" + id;
    let update_query2 = String::from("UPDATE CONTACTS SET EMAIL='") + &get_email() + "' WHERE ID=" + id;
    let s1 = &get_social_security_number();
    let update_query3 = String::from("UPDATE CONTACTS SET SSN='") + s1 + "' WHERE ID=" + id;
    let update_query4 = String::from("UPDATE CONTACTS SET SSN='") + &s1 + "' WHERE ID=" + id;
    let s2 = s1.as_str();
    let update_query5 = String::from("UPDATE CONTACTS SET SSN='") + s2 + "' WHERE ID=" + id;
    let update_query6 = String::from("UPDATE CONTACTS SET SSN='") + &s2 + "' WHERE ID=" + id;
    let delete_query1 = String::from("DELETE FROM CONTACTS WHERE ID=") + id;
    let delete_query2 = String::from("DELETE FROM CONTACTS WHERE SSN='") + &get_social_security_number() + "'";
    let prepared_query = String::from("UPDATE CONTACTS SET SSN=? WHERE ID=?");

    // execute queries - MySQL, direct
    let _ = conn1.execute(select_query1.as_str()).await?;
    let _ = conn1.execute(select_query2.as_str()).await?; // $ MISSING: Alert[rust/cleartext-storage-database]
    let _ = conn1.execute(insert_query1.as_str()).await?;
    let _ = conn1.execute(insert_query2.as_str()).await?; // $ MISSING: Alert[rust/cleartext-storage-database]
    let _ = conn1.execute(update_query1.as_str()).await?;
    let _ = conn1.execute(update_query2.as_str()).await?; // $ MISSING: Alert[rust/cleartext-storage-database]
    let _ = conn1.execute(update_query3.as_str()).await?; // $ MISSING: Alert[rust/cleartext-storage-database]
    let _ = conn1.execute(update_query4.as_str()).await?; // $ MISSING: Alert[rust/cleartext-storage-database]
    let _ = conn1.execute(update_query5.as_str()).await?; // $ MISSING: Alert[rust/cleartext-storage-database]
    let _ = conn1.execute(update_query6.as_str()).await?; // $ MISSING: Alert[rust/cleartext-storage-database]
    let _ = conn1.execute(delete_query1.as_str()).await?;
    let _ = conn1.execute(delete_query2.as_str()).await?; // $ MISSING: Alert[rust/cleartext-storage-database]

    // execute queries - MySQL, prepared query
    let _ = sqlx::query(insert_query1.as_str()).execute(&pool1).await?;
    let _ = sqlx::query(insert_query2.as_str()).execute(&pool1).await?; // $ Alert[rust/cleartext-storage-database]
    let _ = sqlx::query(prepared_query.as_str()).bind(get_harmless()).execute(&pool1).await?;
    let _ = sqlx::query(prepared_query.as_str()).bind(get_social_security_number()).execute(&pool1).await?; // $ MISSING: Alert[rust/cleartext-storage-database]
    let _ = sqlx::query(prepared_query.as_str()).bind(&s1).execute(&pool1).await?; // $ MISSING: Alert[rust/cleartext-storage-database]
    let _ = sqlx::query(prepared_query.as_str()).bind(&s2).execute(&pool1).await?; // $ MISSING: Alert[rust/cleartext-storage-database]

    // connect through SQLite, no connection pool
    let mut conn2 = sqlx::sqlite::SqliteConnection::connect(url).await?;

    // execute queries - SQLite, direct
    let _ = conn2.execute(insert_query1.as_str()).await?;
    let _ = conn2.execute(insert_query2.as_str()).await?; // $ MISSING: Alert[rust/cleartext-storage-database]

    // execute queries - SQLite, direct variant
    let _ = sqlx::raw_sql(insert_query1.as_str()).execute(&mut conn2).await?;
    let _ = sqlx::raw_sql(insert_query2.as_str()).execute(&mut conn2).await?; // $ Alert[rust/cleartext-storage-database]

    // execute queries - SQLite, prepared query
    let _ = sqlx::query(insert_query1.as_str()).execute(&mut conn2).await?;
    let _ = sqlx::query(insert_query2.as_str()).execute(&mut conn2).await?; // $ Alert[rust/cleartext-storage-database]
    let _ = sqlx::query(prepared_query.as_str()).bind(get_harmless()).bind(id).execute(&mut conn2).await?;
    let _ = sqlx::query(prepared_query.as_str()).bind(get_social_security_number()).bind(id).execute(&mut conn2).await?; // $ MISSING: Alert[rust/cleartext-storage-database]

    // execute queries - SQLite, prepared query variant
    let _ = sqlx::query(insert_query1.as_str()).fetch(&mut conn2);
    let _ = sqlx::query(insert_query2.as_str()).fetch(&mut conn2); // $ Alert[rust/cleartext-storage-database]
    let _ = sqlx::query(prepared_query.as_str()).bind(get_harmless()).bind(id).fetch(&mut conn2);
    let _ = sqlx::query(prepared_query.as_str()).bind(get_social_security_number()).bind(id).fetch(&mut conn2); // $ MISSING: Alert[rust/cleartext-storage-database]

    // connect through a PostgreSQL connection pool
    let pool3 = sqlx::postgres::PgPool::connect(url).await?;
    let mut conn3 = pool3.acquire().await?;

    // execute queries - PostgreSQL, direct
    let _ = conn3.execute(insert_query1.as_str()).await?;
    let _ = conn3.execute(insert_query2.as_str()).await?; // $ MISSING: Alert[rust/cleartext-storage-database]

    // execute queries - PostgreSQL, prepared query
    let _ = sqlx::query(insert_query1.as_str()).execute(&pool3).await?;
    let _ = sqlx::query(insert_query2.as_str()).execute(&pool3).await?; // $ Alert[rust/cleartext-storage-database]
    let _ = sqlx::query(prepared_query.as_str()).bind(get_harmless()).bind(id).execute(&pool3).await?;
    let _ = sqlx::query(prepared_query.as_str()).bind(get_social_security_number()).bind(id).execute(&pool3).await?; // $ MISSING: Alert[rust/cleartext-storage-database]

    // "bad" example
    {
        let pool = &pool1;
        let credit_card_number = get_ccn();

        let query = "INSERT INTO PAYMENTDETAILS(ID, CARDNUM) VALUES(?, ?)";
        let result = sqlx::query(query)
            .bind(id)
            .bind(credit_card_number) // $ MISSING: Alert[rust/cleartext-storage-database]
            .execute(pool)
            .await?;
    }

    // "good" example
    {
        let pool = &pool1;
        let credit_card_number = get_ccn();

        let encryption_key = Aes256Gcm::generate_key(OsRng);

        // ...

        let query = "INSERT INTO PAYMENTDETAILS(ID, CARDNUM) VALUES(?, ?)";
        let result = sqlx::query(query)
            .bind(id)
            .bind(encrypt(credit_card_number, &encryption_key))
            .execute(pool)
            .await?;
    }

    Ok(())
}

#[derive(Debug)]
struct Contact {
    id: i32,
    phone: String,
}

async fn test_storage_rusqlite_sql_command(url: &str) -> Result<(), Box<dyn std::error::Error>> {
    // connect with rusqlite
    let connection = rusqlite::Connection::open_in_memory()?;

    // construct queries
    let id = "123";
    let insert_query_good = String::from("INSERT INTO CONTACTS(ID, HARMLESS) VALUES(") + id + ", '" + &get_harmless() + "')";
    let insert_query_bad = String::from("INSERT INTO CONTACTS(ID, PHONE) VALUES(") + id + ", '" + &get_phone_number() + "')"; // $ Source[rust/cleartext-storage-database]
    let select_query_bad = String::from("SELECT * FROM CONTACTS WHERE PHONE = '") + &get_phone_number() + "'"; // $ Source[rust/cleartext-storage-database]

    // execute queries - rusqlite
    connection.execute(&insert_query_good, ())?;
    connection.execute(&insert_query_bad, ())?; // $ Alert[rust/cleartext-storage-database]

    let _ = connection.query_row(&select_query_bad, (), |row| { // $ Alert[rust/cleartext-storage-database]
        let row: &rusqlite::Row<'_> = row;
        Ok(Contact {
            id: row.get(0)?,
            phone: row.get(1)?,
        })
    })?;

    let mut stmt = connection.prepare(&select_query_bad)?; // $ Alert[rust/cleartext-storage-database]
    let people = stmt.query_map([], |row| {
        let row: &rusqlite::Row<'_> = row;
        Ok(Contact {
            id: row.get_unwrap(0),
            phone: row.get_unwrap(1),
        })
    })?;

    Ok(())
}

fn main() {
    println!("test_storage_sqlx_sql_command...");
    match futures::executor::block_on(test_storage_sqlx_sql_command("")) {
        Ok(_) => println!("  successful!"),
        Err(e) => println!("  error: {}", e),
    }

    println!("test_storage_rusqlite_sql_command...");
    match futures::executor::block_on(test_storage_rusqlite_sql_command("")) {
        Ok(_) => println!("  successful!"),
        Err(e) => println!("  error: {}", e),
    }
}
