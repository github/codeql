function getDate() {
	var date;
	if (something()) {
		date = new Date();
	} else {
		return null;
	}
	console.log(date);
	return date && date.getTime(); // $ Alert[js/unneeded-defensive-code]
}

function isNotNullOrString(obj) {
  return obj != null && obj != undefined && // $ Alert[js/unneeded-defensive-code]
      typeof obj != 'string';
}
