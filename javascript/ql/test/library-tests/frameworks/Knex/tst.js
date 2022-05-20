// Based on example code from https://knexjs.org

const knex = require('knex')();

knex({ a: 'table', b: 'table' })
  .select({
    aTitle: 'a.title',
    bTitle: 'b.title'
  })
  .whereRaw('?? = ??', ['a.column_1', 'b.column_2']);

knex.withUserParams({customUserParam: 'table1'}).table('t').select('x');

knex.select().from('books').timeout(1000);
knex.select('title', 'author', 'year').from('books');

knex.avg('sum_column1').from(function() {
    this.sum('column1 as sum_column1').from('t1').groupBy('column1').as('t1')
  }).as('ignored_alias');

knex.column('title', 'author', 'year').select().from('books');

knex.select('*').from('users');

knex.with('with_alias', knex.raw('select * from "books" where "author" = ?', 'Test')).select('*').from('with_alias');

knex.withRecursive('ancestors', (qb) => {
    qb.select('*').from('people').where('people.id', 1).union((qb) => {
      qb.select('*').from('people').join('ancestors', 'ancestors.parentId', 'people.id')
    })
  }).select('*').from('ancestors');

knex.withSchema('public').select('*').from('users');

knex('users').where({
    first_name: 'Test',
    last_name:  'User'
  }).select('id');

knex('users').where('id', 1);

knex('users')
  .where((builder) =>
    builder.whereIn('id', [1, 11, 15]).whereNotIn('id', [17, 19])
  )
  .andWhere(function() {
    this.where('id', '>', 10)
  });

knex('users').where(function() {
  this.where('id', 1).orWhere('id', '>', 10)
}).orWhere({name: 'Tester'});

knex('users').where('columnName', 'like', '%rowlikeme%');

knex('users').where('votes', '>', 100);

const subquery = knex('users').where('votes', '>', 100).andWhere('status', 'active').orWhere('name', 'John').select('id');
knex('accounts').where('id', 'in', subquery);

knex('users').where('id', 1).orWhere({votes: 100, user: 'knex'});

knex('users').whereNot({
  first_name: 'Test',
  last_name:  'User'
}).select('id');

knex('users').whereNot('id', 1);

knex('users').whereNot(function() {
  this.where('id', 1).orWhereNot('id', '>', 10)
}).orWhereNot({name: 'Tester'});

const subquery2 = knex('users')
  .whereNot('votes', '>', 100)
  .andWhere('status', 'active')
  .orWhere('name', 'John')
  .select('id');

knex('accounts').where('id', 'not in', subquery2);

knex.select('name').from('users')
  .whereIn('id', [1, 2, 3])
  .orWhereIn('id', [4, 5, 6]);

knex.select('name').from('users')
  .whereIn('account_id', function() {
    this.select('id').from('accounts');
  });

knex('users').whereNotIn('id', [1, 2, 3]);

knex('users').where('name', 'like', '%Test%').orWhereNotIn('id', [1, 2, 3]);

knex('users').whereNull('updated_at');

knex('users').whereNotNull('created_at');

knex('users').whereExists(function() {
  this.select('*').from('accounts').whereRaw('users.account_id = accounts.id');
});

knex('users').whereExists(knex.select('*').from('accounts').whereRaw('users.account_id = accounts.id'));

knex('users').whereNotExists(function() {
  this.select('*').from('accounts').whereRaw('users.account_id = accounts.id');
});

knex('users').whereBetween('votes', [1, 100]);

knex('users').whereNotBetween('votes', [1, 100]);

knex('users').whereRaw('id = ?', [1]);

knex('users')
  .join('contacts', 'users.id', '=', 'contacts.user_id')
  .select('users.id', 'contacts.phone');

knex('users')
  .join('contacts', 'users.id', 'contacts.user_id')
  .select('users.id', 'contacts.phone');

knex.select('*').from('users').join('accounts', function() {
  this.on('accounts.id', '=', 'users.account_id').orOn('accounts.owner_id', '=', 'users.id')
});

knex.select('*').from('users').join('accounts', function() {
  this.on(function() {
    this.on('accounts.id', '=', 'users.account_id')
    this.orOn('accounts.owner_id', '=', 'users.id')
  })
});

knex.select('*').from('users').join('accounts', 'accounts.type', knex.raw('?', ['admin']));

knex.from('users').innerJoin('accounts', 'users.id', 'accounts.user_id');

knex.select('*').from('users').leftJoin('accounts', 'users.id', 'accounts.user_id');

knex.select('*').from('users').leftOuterJoin('accounts', 'users.id', 'accounts.user_id');

knex.select('*').from('users').rightJoin('accounts', 'users.id', 'accounts.user_id');

knex.select('*').from('users').rightOuterJoin('accounts', 'users.id', 'accounts.user_id');

knex.select('*').from('users').fullOuterJoin('accounts', 'users.id', 'accounts.user_id');

knex.select('*').from('users').crossJoin('accounts');

knex.select('*').from('accounts').joinRaw('natural full join table1').where('id', 1);

knex.select('*').from('users').join('contacts', function() {
  this.on('users.id', '=', 'contacts.id').onNotNull('contacts.email')
});

knex.select('email', 'name').from('users').where('id', '<', 10).clear('select').clear('where');

knex('customers').distinct('first_name', 'last_name');

knex('users').distinctOn('age');

knex.select('year', knex.raw('SUM(profit)')).from('sales').groupByRaw('year WITH ROLLUP');

knex('users').orderBy('email');

knex.select('*').from('table').orderByRaw('col DESC NULLS LAST');

knex('users')
  .groupBy('count')
  .orderBy('name', 'desc')
  .having('count', '>', 100);

knex.select('*').from('users').havingIn('id', [5, 3, 10, 17]);

knex('users')
  .groupBy('count')
  .orderBy('name', 'desc')
  .havingRaw('count > ?', [100]);

knex.select('x').toString();
knex.select('x').valueOf();
knex.select('x').toSQL();
knex.select('x').then();
knex.select('x').catch();
knex.select('x').finally();
knex.select('x').asCallback();
knex.select('x').stream();
knex.select('x').stream(stream => { });
