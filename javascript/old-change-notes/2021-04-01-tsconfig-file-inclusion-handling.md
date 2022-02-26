lgtm,codescanning
* Fixed a bug which caused some imports to be resolved incorrectly
  for projects containing multiple `tsconfig.json` files.
* Fixed a bug which could cause some files in the `node_modules` folder
  to be extracted even though they should be excluded.
