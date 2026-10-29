function sendRecord(record) {
	sendResponse({
		name: record.lastName + ', ' + record.firstName,
		DOB: record.dateOfBirth,
		address: record.streetAddress + '\n'
		       + record.postCode + ' ' + record.city + '\n'
		       + record.country,
		email: record.email,
		url: record.website
	});
}