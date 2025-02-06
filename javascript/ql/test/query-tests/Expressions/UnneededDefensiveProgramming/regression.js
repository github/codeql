function getDate() {
	var date;
	if (something()) {
		date = new Date();
	} else {
		return null;
	}
	console.log(date);
	return date && date.getTime(); // $ Alert
}

function isNotNullOrString(obj) {
  return obj != null && obj != undefined && // $ Alert
      typeof obj != 'string'; 
}
