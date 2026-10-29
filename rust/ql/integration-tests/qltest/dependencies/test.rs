use anyhow;
use log::info;

fn foo() -> anyhow::Result<()> {
    info!("logging works");
    Ok(())
}
