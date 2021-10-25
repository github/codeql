const { sequelize } = require("./sequelize");

sequelize.query('SELECT * FROM Products WHERE (name LIKE \'%' + criteria + '%\') AND deletedAt IS NULL) ORDER BY name');
