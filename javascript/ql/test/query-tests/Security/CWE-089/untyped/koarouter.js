const Router = require('koa-router')
const {Sequelize} = require("sequelize");

new Router().get("/hello", (ctx) => {
    const { version } = ctx.query;

    if (version && validVersion(version) === false) {
        throw new Error(`invalid version ${version}`);
    }

    const conditions = ['1'];

    if (version) {
        conditions.push(`version = ${version}`)
    }

    new Sequelize().query(`SELECT * FROM t WHERE ${conditions.join(' and ')}`, null); // OK
});

function validVersion(version) {
    const pattern = /^[a-zA-Z0-9]+$/;
    return pattern.test(version);
}
