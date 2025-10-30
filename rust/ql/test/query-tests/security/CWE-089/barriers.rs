use sqlx::Connection;
use sqlx::Executor;

/**
 * Test cases for SQL injection barriers/sanitizers.
 * These test that proper validation blocks taint flow.
 */

async fn test_barriers(enable_remote: bool) -> Result<(), sqlx::Error> {
    let pool: sqlx::Pool<sqlx::MySql> = sqlx::mysql::MySqlPool::connect("").await?;
    
    // Get remote data (untrusted source)
    let remote_string = reqwest::blocking::get("http://example.com/").unwrap().text().unwrap_or(String::from("Alice")); // $ Source=remote_barrier
    
    // --- Barrier 1: Numeric type sanitization ---
    // When untrusted data is parsed to a numeric type, it should be safe
    let remote_number = remote_string.parse::<i32>().unwrap_or(0);
    let safe_numeric_query = format!("SELECT * FROM people WHERE id={remote_number}");
    let _ = sqlx::query(safe_numeric_query.as_str()).execute(&pool).await?; // $ sql-sink SPURIOUS: Alert[rust/sql-injection]=remote_barrier
    
    // Also test with other numeric types
    let remote_u32 = remote_string.parse::<u32>().unwrap_or(0);
    let safe_u32_query = format!("SELECT * FROM people WHERE id={remote_u32}");
    let _ = sqlx::query(safe_u32_query.as_str()).execute(&pool).await?; // $ sql-sink SPURIOUS: Alert[rust/sql-injection]=remote_barrier
    
    let remote_i64 = remote_string.parse::<i64>().unwrap_or(0);
    let safe_i64_query = format!("SELECT * FROM people WHERE id={remote_i64}");
    let _ = sqlx::query(safe_i64_query.as_str()).execute(&pool).await?; // $ sql-sink SPURIOUS: Alert[rust/sql-injection]=remote_barrier
    
    let remote_f64 = remote_string.parse::<f64>().unwrap_or(0.0);
    let safe_f64_query = format!("SELECT * FROM people WHERE price={remote_f64}");
    let _ = sqlx::query(safe_f64_query.as_str()).execute(&pool).await?; // $ sql-sink SPURIOUS: Alert[rust/sql-injection]=remote_barrier
    
    // --- Barrier 2: Single constant comparison ---
    // When untrusted data is compared with a single constant value
    if enable_remote {
        let remote_string2 = reqwest::blocking::get("http://example.com/").unwrap().text().unwrap_or(String::from("Alice")); // $ Source=remote_barrier2
        
        // Safe: validated against single constant
        if remote_string2 == "admin" {
            let safe_single_const = format!("SELECT * FROM people WHERE role='{remote_string2}'");
            let _ = sqlx::query(safe_single_const.as_str()).execute(&pool).await?; // $ sql-sink SPURIOUS: Alert[rust/sql-injection]=remote_barrier2
        }
        
        // Safe: validated with != (false branch is safe)
        if remote_string2 != "admin" {
            // unsafe branch - still tainted
            let unsafe_ne_query = format!("SELECT * FROM people WHERE role='{remote_string2}'");
            let _ = sqlx::query(unsafe_ne_query.as_str()).execute(&pool).await?; // $ sql-sink Alert[rust/sql-injection]=remote_barrier2
        } else {
            // safe branch - validated to be "admin"
            let safe_ne_query = format!("SELECT * FROM people WHERE role='{remote_string2}'");
            let _ = sqlx::query(safe_ne_query.as_str()).execute(&pool).await?; // $ sql-sink SPURIOUS: Alert[rust/sql-injection]=remote_barrier2
        }
    }
    
    // --- Barrier 3: Multiple constant comparison (OR pattern) ---
    // When untrusted data is compared with multiple constant values
    if enable_remote {
        let remote_string3 = reqwest::blocking::get("http://example.com/").unwrap().text().unwrap_or(String::from("Alice")); // $ Source=remote_barrier3
        
        // Safe: validated against multiple constants with OR
        if remote_string3 == "person" || remote_string3 == "vehicle" {
            let safe_multi_const = format!("SELECT * FROM entities WHERE type='{remote_string3}'");
            let _ = sqlx::query(safe_multi_const.as_str()).execute(&pool).await?; // $ sql-sink SPURIOUS: Alert[rust/sql-injection]=remote_barrier3
        }
        
        // Safe: validated against multiple constants with OR (more than 2)
        if remote_string3 == "alice" || remote_string3 == "bob" || remote_string3 == "charlie" {
            let safe_multi_const_3 = format!("SELECT * FROM people WHERE name='{remote_string3}'");
            let _ = sqlx::query(safe_multi_const_3.as_str()).execute(&pool).await?; // $ sql-sink SPURIOUS: Alert[rust/sql-injection]=remote_barrier3
        }
    }
    
    // --- Barrier 4: Collection/array constant comparison ---
    // When untrusted data is checked against a collection of constant values
    if enable_remote {
        let remote_string4 = reqwest::blocking::get("http://example.com/").unwrap().text().unwrap_or(String::from("Alice")); // $ Source=remote_barrier4
        
        // Safe: validated against an array of constants
        let allowed_roles = vec!["admin", "user", "guest"];
        if allowed_roles.contains(&remote_string4.as_str()) {
            let safe_array_check = format!("SELECT * FROM people WHERE role='{remote_string4}'");
            let _ = sqlx::query(safe_array_check.as_str()).execute(&pool).await?; // $ sql-sink SPURIOUS: Alert[rust/sql-injection]=remote_barrier4
        }
        
        // Safe: validated with slice contains
        if ["manager", "employee", "contractor"].contains(&remote_string4.as_str()) {
            let safe_slice_check = format!("SELECT * FROM people WHERE role='{remote_string4}'");
            let _ = sqlx::query(safe_slice_check.as_str()).execute(&pool).await?; // $ sql-sink SPURIOUS: Alert[rust/sql-injection]=remote_barrier4
        }
        
        // Safe: validated with HashSet
        use std::collections::HashSet;
        let mut allowed_set = HashSet::new();
        allowed_set.insert("alice");
        allowed_set.insert("bob");
        allowed_set.insert("charlie");
        if allowed_set.contains(&remote_string4.as_str()) {
            let safe_set_check = format!("SELECT * FROM people WHERE name='{remote_string4}'");
            let _ = sqlx::query(safe_set_check.as_str()).execute(&pool).await?; // $ sql-sink SPURIOUS: Alert[rust/sql-injection]=remote_barrier4
        }
    }
    
    // --- Negative test cases: Incorrect sanitization ---
    
    if enable_remote {
        let remote_string5 = reqwest::blocking::get("http://example.com/").unwrap().text().unwrap_or(String::from("Alice")); // $ Source=remote_barrier5
        
        // Unsafe: comparison with non-constant value (another variable)
        let other_string = String::from("admin");
        if remote_string5 == other_string {
            let unsafe_non_const = format!("SELECT * FROM people WHERE role='{remote_string5}'");
            let _ = sqlx::query(unsafe_non_const.as_str()).execute(&pool).await?; // $ sql-sink Alert[rust/sql-injection]=remote_barrier5
        }
        
        // Unsafe: comparison with OR where one side is not validated
        if remote_string5 == "admin" || remote_string5.len() > 5 {
            let unsafe_mixed_or = format!("SELECT * FROM people WHERE role='{remote_string5}'");
            let _ = sqlx::query(unsafe_mixed_or.as_str()).execute(&pool).await?; // $ sql-sink Alert[rust/sql-injection]=remote_barrier5
        }
        
        // Unsafe: array contains with non-constant elements
        let dynamic_vec = vec![other_string.as_str(), "user"];
        if dynamic_vec.contains(&remote_string5.as_str()) {
            let unsafe_dynamic_array = format!("SELECT * FROM people WHERE role='{remote_string5}'");
            let _ = sqlx::query(unsafe_dynamic_array.as_str()).execute(&pool).await?; // $ sql-sink Alert[rust/sql-injection]=remote_barrier5
        }
        
        // Unsafe: checking length or other properties (not value equality)
        if remote_string5.len() == 5 {
            let unsafe_length_check = format!("SELECT * FROM people WHERE name='{remote_string5}'");
            let _ = sqlx::query(unsafe_length_check.as_str()).execute(&pool).await?; // $ sql-sink Alert[rust/sql-injection]=remote_barrier5
        }
    }
    
    Ok(())
}

fn main() {
    println!("--- CWE-089 barriers.rs test ---");
    let enable_remote = std::env::args().nth(1) == Some(String::from("ENABLE_REMOTE"));
    
    match futures::executor::block_on(test_barriers(enable_remote)) {
        Ok(_) => println!("  successful!"),
        Err(e) => println!("  error: {}", e),
    }
}
