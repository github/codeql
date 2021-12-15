import Sequelize from 'sequelize';

export class Foo {
    constructor(private seq: Sequelize) {}

    method() {
        this.seq.query('SELECT 123');
    }
}
