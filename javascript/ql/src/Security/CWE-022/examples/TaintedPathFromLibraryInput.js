var fs = require('fs'),
    http = require('http'),
    url = require('url');

/** Example 1. Get the user information for the given user. */
export function getUserInfo1(userName) {
  // BAD: This could read any file on the file system
  return fs.readFileSync(userName, 'utf8');
}

/** Example 2. Get the user information for the given user. */
export function getUserInfo2(userName) {
  const userInfoPath = path.join('/home/user/user-data', userName);

  // BAD: This could read any file on the file system
  return fs.readFileSync(userInfoPath, 'utf8');
}
