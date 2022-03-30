// Adapted from https://github.com/bkimminich/juice-shop, which is
// licensed under the MIT license; see file juice-shop-LICENSE.
const Sequelize = require('sequelize');
const sequelize = new Sequelize('database', 'username', 'password', {
  dialect: 'sqlite',
  storage: 'data/juiceshop.sqlite'
});
sequelize.query('SELECT * FROM Products WHERE (name LIKE \'%' + criteria + '%\') AND deletedAt IS NULL) ORDER BY name');


exports.sequelize = sequelize;
