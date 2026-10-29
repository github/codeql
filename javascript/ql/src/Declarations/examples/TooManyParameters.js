function sendRecord(firstName, lastName, dateOfBirth, streetAddress, postCode, city, country, email, website) {
	sendResponse({
		name: lastName + ', ' + firstName,
		DOB: dateOfBirth,
		address: streetAddress + '\n' + postCode + ' ' + city + '\n' + country,
		email: email,
		url: website
	});
}