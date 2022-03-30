// adopted from https://stackoverflow.com/questions/9577611/http-get-request-in-node-js-express

var fs = require('fs');
var request = require('request');

function PostJSON(jsonData)
{
  request({jsonData}, function (error, response, body){ // BAD: passing data from file to the request body
    console.log(response);
  });
}

function PostXML(xmlData)
{

  request({
    url: "http://example.com/myxml",
    method: "POST",
    headers: {
        "content-type": "application/xml",
    },
    body: xmlData    // BAD: passing data from file to the request body
  }, function (error, response, body){
    console.log(response);
  });
}

fs.readFile('MyFile.json', 'utf-8', function (err, data) { // source
  if (err) {
    console.log("FATAL An error occurred trying to read in the file: " + err);
    process.exit(-2);
  }
  // Make sure there's data before we post it
  if(data) {
    PostJSON(data);
  }
  else {
    console.log("No data to post");
    process.exit(-1);
  }
});

fs.readFile('MyFile.xml', 'utf-8', function (err, data) {           // source
  if (err) {
    console.log("FATAL An error occurred trying to read in the file: " + err);
    process.exit(-2);
  }
  // Make sure there's data before we post it
  if(data) {
    PostXML(data);
  }
  else {
    console.log("No data to post");
    process.exit(-1);
  }
});
