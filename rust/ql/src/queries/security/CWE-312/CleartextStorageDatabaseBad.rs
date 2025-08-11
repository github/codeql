let query = "INSERT INTO PAYMENTDETAILS(ID, CARDNUM) VALUES(?, ?)";
let result = sqlx::query(query)
	.bind(id)
	.bind(credit_card_number) // BAD: Cleartext storage of sensitive data in the database
	.execute(pool)
	.await?;
