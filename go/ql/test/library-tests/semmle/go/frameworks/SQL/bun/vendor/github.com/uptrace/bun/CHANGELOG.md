## [1.1.14](https://github.com/uptrace/bun/compare/v1.1.13...v1.1.14) (2023-05-24)


### Bug Fixes

* enable CompositeIn for MySQL ([9f377b5](https://github.com/uptrace/bun/commit/9f377b5e744cb38ef4aadd61213855c009e47354))



## [1.1.13](https://github.com/uptrace/bun/compare/v1.1.12...v1.1.13) (2023-05-06)


### Bug Fixes

* bunbig.Int.Scan typo ([7ddabb8](https://github.com/uptrace/bun/commit/7ddabb8c667f50032bc0bb2523a287efbe0851e7))
* compare full MySQL version ([096fabe](https://github.com/uptrace/bun/commit/096fabefa114202d3601ad8e456f5e491a4e3787))
* enable delete table alias for MySQL >= 8.0.16 ([77a600b](https://github.com/uptrace/bun/commit/77a600bc060154fb91aa68e68ba6a8875e5b10fb))
* incorrect table relationship panic message [#791](https://github.com/uptrace/bun/issues/791) ([ad41888](https://github.com/uptrace/bun/commit/ad4188862eeaab30fc7c48d3224b5a786557aec5))
* should rollback if migrate using transaction and got an err (thanks [@bayshark](https://github.com/bayshark)) ([e7a119b](https://github.com/uptrace/bun/commit/e7a119b1b8911d8bf059bb271c90ad4a5f5f02be))


### Features

* add option to customize Go migration template ([f31bf73](https://github.com/uptrace/bun/commit/f31bf739b9c7a0383411b9e67cba96c858795c68))
* expose Exec(…) method for RawQuery ([11192c8](https://github.com/uptrace/bun/commit/11192c83f932eb7421ef09e06859a7f171de7803))
* prefix migration files with 1 upto 14 digits ([b74b671](https://github.com/uptrace/bun/commit/b74b6714bb6a83e470e21801c97cc40e20acfb50))
* rename option ([9353a3f](https://github.com/uptrace/bun/commit/9353a3f921c038fdf4a90665f1b0a9d0d03dc182))



## [1.1.12](https://github.com/uptrace/bun/compare/v1.1.11...v1.1.12) (2023-02-20)



## [1.1.11](https://github.com/uptrace/bun/compare/v1.1.10...v1.1.11) (2023-02-01)


### Bug Fixes

* add support for inserting values with unicode encoding for mssql dialect ([e98c6c0](https://github.com/uptrace/bun/commit/e98c6c0f033b553bea3bbc783aa56c2eaa17718f))
* fix relation tag ([a3eedff](https://github.com/uptrace/bun/commit/a3eedff49700490d4998dcdcdc04f554d8f17166))



## [1.1.10](https://github.com/uptrace/bun/compare/v1.1.9...v1.1.10) (2023-01-16)


### Bug Fixes

* allow QueryEvent to better detect operations in raw queries ([8e44735](https://github.com/uptrace/bun/commit/8e4473538364bae6562055d35e94c3e9c0b77691))
* append default VARCHAR length instead of hardcoding it in the type definition ([e5079c7](https://github.com/uptrace/bun/commit/e5079c70343ba8c8b410aed23ac1d1ae5a2c9ff6))
* prevent panic when use pg array with custom database type ([67e4412](https://github.com/uptrace/bun/commit/67e4412a972a9ed5f3a1d07c66957beedbc8a8a3))
* properly return sql.ErrNoRows when scanning []byte ([996fead](https://github.com/uptrace/bun/commit/996fead2595fbcaff4878b77befe6709a54b3a4d))


### Features

*  mssql output support for update or delete query ([#718](https://github.com/uptrace/bun/issues/718)) ([08876b4](https://github.com/uptrace/bun/commit/08876b4d420e761cbfa658aa6bb89b3f7c62c240))
* add Err method to query builder ([c722c90](https://github.com/uptrace/bun/commit/c722c90f3dce2642ca4f4c2ab3f9a35cd496b557))
* add support for time.Time array in Postgres ([3dd6f3b](https://github.com/uptrace/bun/commit/3dd6f3b2ac1bfbcda08240dc1676647b61715a9c))
* mssql and pg merge query ([#723](https://github.com/uptrace/bun/issues/723)) ([deea764](https://github.com/uptrace/bun/commit/deea764d9380b16aad34228aa32717d10f2a4bab))
* setError on attempt to set non-positive .Varchar() ([3335e0b](https://github.com/uptrace/bun/commit/3335e0b9d6d3f424145e1f715223a0fffe773d9a))


### Reverts

* go 1.18 ([67a4488](https://github.com/uptrace/bun/commit/67a448897eaaf1ebc54d629dfd3b2509b35da352))



## [1.1.9](https://github.com/uptrace/bun/compare/v1.1.8...v1.1.9) (2022-11-23)


### Bug Fixes

* addng dialect override for append-bool ([#695](https://github.com/uptrace/bun/issues/695)) ([338f2f0](https://github.com/uptrace/bun/commit/338f2f04105ad89e64530db86aeb387e2ad4789e))
* don't call hooks twice for whereExists ([9057857](https://github.com/uptrace/bun/commit/90578578e717f248e4b6eb114c5b495fd8d4ed41))
* don't lock migrations when running Migrate and Rollback ([69a7354](https://github.com/uptrace/bun/commit/69a7354d987ff2ed5338c9ef5f4ce320724299ab))
* **query:** make WhereDeleted compatible with ForceDelete ([299c3fd](https://github.com/uptrace/bun/commit/299c3fd57866aaecd127a8f219c95332898475db)), closes [#673](https://github.com/uptrace/bun/issues/673)
* relation join soft delete SQL generate ([a98f4e9](https://github.com/uptrace/bun/commit/a98f4e9f2bbdbc2b81cd13aa228a1a91eb905ba2))


### Features

* add migrate.Exec ([d368bbe](https://github.com/uptrace/bun/commit/d368bbe52bb1ee3dabf0aada190bf967eec10255))
* **update:** "skipupdate" while bulk ([1a32b2f](https://github.com/uptrace/bun/commit/1a32b2ffbd5bc9a8d8b5978dd0f16c9fb79242ee))
* **zerolog:** added zerolog hook ([9d2267d](https://github.com/uptrace/bun/commit/9d2267d414b47164ab6ceada55bf311ad548a6b0))



## [1.1.8](https://github.com/uptrace/bun/compare/v1.1.7...v1.1.8) (2022-08-29)


### Bug Fixes

* **bunotel:** handle option attributes ([#656](https://github.com/uptrace/bun/issues/656)) ([9f1e0bd](https://github.com/uptrace/bun/commit/9f1e0bd19fc0300f12996b3e6595f093024e06b6))
* driver.Valuer returns itself causes stackoverflow ([c9f51d3](https://github.com/uptrace/bun/commit/c9f51d3e2dabed0c29c26a4221abbc426a7206f3)), closes [#657](https://github.com/uptrace/bun/issues/657)
* **pgdriver:** return FATAL and PANIC errors immediately ([4595e38](https://github.com/uptrace/bun/commit/4595e385d3706116e47bf9dc295186ec7a2ab0f9))
* quote m2m table name fixes [#649](https://github.com/uptrace/bun/issues/649) ([61a634e](https://github.com/uptrace/bun/commit/61a634e4cd5c18df4b75f756d4b0f06ea94bc3c8))
* support multi-level embed column ([177ec4c](https://github.com/uptrace/bun/commit/177ec4c6e04f92957614ad4724bc82c422649a4b)), closes [#643](https://github.com/uptrace/bun/issues/643)


### Features

* conditions not supporting composite in ([e5d78d4](https://github.com/uptrace/bun/commit/e5d78d464b94b78438cf275b4c35f713d129961d))
* **idb:** support raw query ([be4e688](https://github.com/uptrace/bun/commit/be4e6886ad94b4b6ca42f24f73d79a15b1ac3188))
* **migrate:** add MissingMigrations ([42567d0](https://github.com/uptrace/bun/commit/42567d052280f2c412d4796df7178915e537e6d9))
* **pgdriver:** implement database/sql/driver.SessionResetter ([bda298a](https://github.com/uptrace/bun/commit/bda298ac66305e5b00ba67d72d3973625930c6b9))
* **pgdriver:** provide access to the underlying net.Conn ([d07ea0e](https://github.com/uptrace/bun/commit/d07ea0ed1541225b5f08e59a4c87383811f7f051))



## [1.1.7](https://github.com/uptrace/bun/compare/v1.1.6...v1.1.7) (2022-07-29)


### Bug Fixes

* change ScanAndCount without a limit to select all rows ([de5c570](https://github.com/uptrace/bun/commit/de5c5704166563aea41a82f7863f2db88ff108e2))



## [1.1.6](https://github.com/uptrace/bun/compare/v1.1.5...v1.1.6) (2022-07-10)


### Bug Fixes

* bunotel add set attributes to query metrics ([dae82cc](https://github.com/uptrace/bun/commit/dae82cc0e3af49be1e474027b55c34364676985d))
* **db.ScanRows:** ensure rows.Close is called ([9ffbc6a](https://github.com/uptrace/bun/commit/9ffbc6a46e24b908742b6973f33ef8e5b17cc12b))
* merge apply ([3081849](https://github.com/uptrace/bun/commit/30818499eacddd3b1a3e749091ba6a1468125641))
* **migrate:** close conn/tx on error ([7b168ea](https://github.com/uptrace/bun/commit/7b168eabfe0f844bcbf8dc89629d04c385b9f58c))
* **migrate:** type Migration should be used as a value rather than a pointer ([fb43935](https://github.com/uptrace/bun/commit/fb4393582b49fe528800a66aac5fb1c9a6033048))
* **migrate:** type MigrationGroup should be used as a value rather than a pointer ([649da1b](https://github.com/uptrace/bun/commit/649da1b3c158060add9b61b32c289260daafa65a))
* mssql cursor pagination ([#589](https://github.com/uptrace/bun/issues/589)) ([b34ec97](https://github.com/uptrace/bun/commit/b34ec97ddda95629f73762721d60fd3e00e7e99f))


### Features

* "skipupdate" model field tag ([#565](https://github.com/uptrace/bun/issues/565)) ([9288294](https://github.com/uptrace/bun/commit/928829482c718a0c215aa4f4adfa6f3fb3ed4302))
* add pgdriver write error to log ([5ddda3d](https://github.com/uptrace/bun/commit/5ddda3de31cd08ceee4bdea64ceae8d15eace07b))
* add query string representation ([520da7e](https://github.com/uptrace/bun/commit/520da7e1d6dbf7b06846f6b39a7f99e8753c1466))
* add relation condition with tag ([fe5bbf6](https://github.com/uptrace/bun/commit/fe5bbf64f33d25b310e5510ece7d705b9eb3bfea))
* add support for ON UPDATE and ON DELETE rules on belongs-to relationships from struct tags ([#533](https://github.com/uptrace/bun/issues/533)) ([a327b2a](https://github.com/uptrace/bun/commit/a327b2ae216abb55a705626296c0cdbf8d648697))
* add tx methods to IDB ([#587](https://github.com/uptrace/bun/issues/587)) ([feab313](https://github.com/uptrace/bun/commit/feab313c0358200b6e270ac70f4551b011ab5276))
* added raw query calls ([#596](https://github.com/uptrace/bun/issues/596)) ([127644d](https://github.com/uptrace/bun/commit/127644d2eea443736fbd6bed3417595d439e4639))
* **bunotel:** add option to enable formatting of queries ([#547](https://github.com/uptrace/bun/issues/547)) ([b9c768c](https://github.com/uptrace/bun/commit/b9c768cec3b5dea36c3c9c344d1e76e0ffad1369))
* **config.go:** add sslrootcert support to DSN parameters ([3bd5d69](https://github.com/uptrace/bun/commit/3bd5d692d7df4f30d07b835d6a46fc7af382489a))
* create an extra module for newrelic ([#599](https://github.com/uptrace/bun/issues/599)) ([6c676ce](https://github.com/uptrace/bun/commit/6c676ce13f05fe763471fbec2d5a2db48bc88650))
* **migrate:** add WithMarkAppliedOnSuccess ([31b2cc4](https://github.com/uptrace/bun/commit/31b2cc4f5ccd794a436d081073d4974835d3780d))
* **pgdialect:** add hstore support ([66b44f7](https://github.com/uptrace/bun/commit/66b44f7c0edc205927fb8be96aaf263b31828fa1))
* **pgdialect:** add identity support ([646251e](https://github.com/uptrace/bun/commit/646251ec02a1e2ec717e907e6f128d8b51f17c6d))
* **pgdriver:** expose pgdriver.ParseTime ([405a7d7](https://github.com/uptrace/bun/commit/405a7d78d8f60cf27e8f175deaf95db5877d84be))



## [1.1.5](https://github.com/uptrace/bun/compare/v1.1.4...v1.1.5) (2022-05-12)


### Bug Fixes

* **driver/sqliteshim:** make it work with recent version of modernc sqlite ([2360584](https://github.com/uptrace/bun/commit/23605846c20684e39bf1eaac50a2147a1b68a729))



## [1.1.4](https://github.com/uptrace/bun/compare/v1.1.3...v1.1.4) (2022-04-20)


### Bug Fixes

* automatically set nullzero when there is default:value option ([72c44ae](https://github.com/uptrace/bun/commit/72c44aebbeec3a83ed97ea25a3262174d744df65))
* fix ForceDelete on live/undeleted rows ([1a33250](https://github.com/uptrace/bun/commit/1a33250f27f00e752a735ce10311ac95dcb0c968))
* fix OmitZero and value overriding ([087ea07](https://github.com/uptrace/bun/commit/087ea0730551f1e841bacb6ad2fa3afd512a1df8))
* rename Query to QueryBuilder ([98d111b](https://github.com/uptrace/bun/commit/98d111b7cc00fa61b6b2cec147f43285f4baadb4))


### Features

* add ApplyQueryBuilder ([582eca0](https://github.com/uptrace/bun/commit/582eca09cf2b59e67c2e4a2ad24f1a74cb53addd))
* **config.go:** add connect_timeout to DSN parsable params ([998b04d](https://github.com/uptrace/bun/commit/998b04d51a9a4f182ac3458f90db8dbf9185c4ba)), closes [#505](https://github.com/uptrace/bun/issues/505)



# [1.1.3](https://github.com/uptrace/bun/compare/v1.1.2...v) (2022-03-29)

### Bug Fixes

- fix panic message when has-many encounter an error
  ([cfd2747](https://github.com/uptrace/bun/commit/cfd27475fac89a1c8cf798bfa64898bd77bbba79))
- **migrate:** change rollback to match migrate behavior
  ([df5af9c](https://github.com/uptrace/bun/commit/df5af9c9cbdf54ce243e037bbb2c7b154f8422b3))

### Features

- added QueryBuilder interface for SelectQuery, UpdateQuery, DeleteQuery
  ([#499](https://github.com/uptrace/bun/issues/499))
  ([59fef48](https://github.com/uptrace/bun/commit/59fef48f6b3ec7f32bdda779b6693c333ff1dfdb))

# [1.1.2](https://github.com/uptrace/bun/compare/v1.1.2...v) (2022-03-22)

### Bug Fixes

- correctly handle bun.In([][]byte{...})
  ([800616e](https://github.com/uptrace/bun/commit/800616ed28ca600ad676319a10adb970b2b4daf6))

### Features

- accept extend option to allow extending existing models
  ([48b80e4](https://github.com/uptrace/bun/commit/48b80e4f7e3ed8a28fd305f7853ebe7ab984a497))

# [1.1.0](https://github.com/uptrace/bun/compare/v1.1.0-beta.1...v1.1.0) (2022-02-28)

### Features

- Added [MSSQL](https://bun.uptrace.dev/guide/drivers.html#mssql) support as a 4th fully supported
  DBMS.
- Added `SetColumn("col_name", "upper(?)", "hello")` in addition to
  `Set("col_name = upper(?)", "hello")` which works for all 4 supported DBMS.

* improve nil ptr values handling
  ([b398e6b](https://github.com/uptrace/bun/commit/b398e6bea840ea2fd3e001b7879c0b00b6dcd6f7))

### Breaking changes

- Bun no longer automatically marks some fields like `ID int64` as `pk` and `autoincrement`. You
  need to manually add those options:

```diff
type Model struct {
-	 ID int64
+	 ID int64 `bun:",pk,autoincrement"`
}
```

Bun [v1.0.25](#1024-2022-02-22) prints warnings for models with missing options so you are
recommended to upgrade to v1.0.24 before upgrading to v1.1.x.

- Also, Bun no longer adds `nullzero` option to `soft_delete` fields.

- Removed `nopk` and `allowzero` options.

### Bug Fixes

- append slice values
  ([4a65129](https://github.com/uptrace/bun/commit/4a651294fb0f1e73079553024810c3ead9777311))
- check for nils when appeding driver.Value
  ([7bb1640](https://github.com/uptrace/bun/commit/7bb1640a00fceca1e1075fe6544b9a4842ab2b26))
- cleanup soft deletes for mssql
  ([e72e2c5](https://github.com/uptrace/bun/commit/e72e2c5d0a85f3d26c3fa22c7284c2de1dcfda8e))
- **dbfixture:** apply cascade option. Fixes [#447](https://github.com/uptrace/bun/issues/447)
  ([d32d988](https://github.com/uptrace/bun/commit/d32d98840bc23e74c836f8192cb4bc9529aa9233))
- create table WithForeignKey() and has-many relation
  ([3cf5649](https://github.com/uptrace/bun/commit/3cf56491706b5652c383dbe007ff2389ad64922e))
- do not emit m2m relations in WithForeignKeys()
  ([56c8c5e](https://github.com/uptrace/bun/commit/56c8c5ed44c0d6d734c3d3161c642ce8437e2248))
- accept dest in select queries
  ([33b5b6f](https://github.com/uptrace/bun/commit/33b5b6ff660b77238a737a543ca12675c7f0c284))

## [1.0.25](https://github.com/uptrace/bun/compare/v1.0.23...v1.0.25) (2022-02-22)

### Bug Fixes

### Deprecated

In the comming v1.1.x release, Bun will stop automatically adding `,pk,autoincrement` options on
`ID int64/int32` fields. This version (v1.0.23) only prints a warning when it encounters such
fields, but the code will continue working as before.

To fix warnings, add missing options:

```diff
type Model struct {
-	 ID int64
+	 ID int64 `bun:",pk,autoincrement"`
}
```

To silence warnings:

```go
bun.SetWarnLogger(log.New(ioutil.Discard, "", log.LstdFlags))
```

Bun will also print a warning on [soft delete](https://bun.uptrace.dev/guide/soft-deletes.html)
fields without a `,nullzero` option. You can fix the warning by adding missing `,nullzero` or
`,allowzero` options.

In v1.1.x, such options as `,nopk` and `,allowzero` will not be necessary and will be removed.

### Bug Fixes

- fix missing autoincrement warning
  ([3bc9c72](https://github.com/uptrace/bun/commit/3bc9c721e1c1c5104c256a0c01c4525df6ecefc2))

* append slice values
  ([4a65129](https://github.com/uptrace/bun/commit/4a651294fb0f1e73079553024810c3ead9777311))
* don't automatically set pk, nullzero, and autoincrement options
  ([519a0df](https://github.com/uptrace/bun/commit/519a0df9707de01a418aba0d6b7482cfe4c9a532))

### Features

- add CreateTableQuery.DetectForeignKeys
  ([a958fcb](https://github.com/uptrace/bun/commit/a958fcbab680b0c5ad7980f369c7b73f7673db87))

## [1.0.22](https://github.com/uptrace/bun/compare/v1.0.21...v1.0.22) (2022-01-28)

### Bug Fixes

- improve scan error message
  ([54048b2](https://github.com/uptrace/bun/commit/54048b296b9648fd62107ce6fa6fd7e6e2a648c7))
- properly discover json.Marshaler on ptr field
  ([3b321b0](https://github.com/uptrace/bun/commit/3b321b08601c4b8dc6bcaa24adea20875883ac14))

### Breaking (MySQL, MariaDB)

- **insert:** get last insert id only with pk support auto increment
  ([79e7c79](https://github.com/uptrace/bun/commit/79e7c797beea54bfc9dc1cb0141a7520ff941b4d)). Make
  sure your MySQL models have `bun:",pk,autoincrement"` options if you are using autoincrements.

### Features

- refuse to start when version check does not pass
  ([ff8d767](https://github.com/uptrace/bun/commit/ff8d76794894eeaebede840e5199720f3f5cf531))
- support Column in ValuesQuery
  ([0707679](https://github.com/uptrace/bun/commit/0707679b075cac57efa8e6fe9019b57b2da4bcc7))

## [1.0.21](https://github.com/uptrace/bun/compare/v1.0.20...v1.0.21) (2022-01-06)

### Bug Fixes

- append where to index create
  ([1de6cea](https://github.com/uptrace/bun/commit/1de6ceaa8bba59b69fbe0cc6916d1b27da5586d8))
- check if slice is nil when calling BeforeAppendModel
  ([938d9da](https://github.com/uptrace/bun/commit/938d9dadb72ceeeb906064d9575278929d20cbbe))
- **dbfixture:** directly set matching types via reflect
  ([780504c](https://github.com/uptrace/bun/commit/780504cf1da687fc51a22d002ea66e2ccc41e1a3))
- properly handle driver.Valuer and type:json
  ([a17454a](https://github.com/uptrace/bun/commit/a17454ac6b95b2a2e927d0c4e4aee96494108389))
- support scanning string into uint64
  ([73cc117](https://github.com/uptrace/bun/commit/73cc117a9f7a623ced1fdaedb4546e8e7470e4d3))
- unique module name for opentelemetry example
  ([f2054fe](https://github.com/uptrace/bun/commit/f2054fe1d11cea3b21d69dab6f6d6d7d97ba06bb))

### Features

- add anonymous fields with type name
  ([508375b](https://github.com/uptrace/bun/commit/508375b8f2396cb088fd4399a9259584353eb7e5))
- add baseQuery.GetConn()
  ([81a9bee](https://github.com/uptrace/bun/commit/81a9beecb74fed7ec3574a1d42acdf10a74e0b00))
- create new queries from baseQuery
  ([ae1dd61](https://github.com/uptrace/bun/commit/ae1dd611a91c2b7c79bc2bc12e9a53e857791e71))
- support INSERT ... RETURNING for MariaDB >= 10.5.0
  ([b6531c0](https://github.com/uptrace/bun/commit/b6531c00ecbd4c7ec56b4131fab213f9313edc1b))

## [1.0.20](https://github.com/uptrace/bun/compare/v1.0.19...v1.0.20) (2021-12-19)

### Bug Fixes

- add Event.QueryTemplate and change Event.Query to be always formatted
  ([52b1ccd](https://github.com/uptrace/bun/commit/52b1ccdf3578418aa427adef9dcf942d90ae4fdd))
- change GetTableName to return formatted table name in case ModelTableExpr
  ([95144dd](https://github.com/uptrace/bun/commit/95144dde937b4ac88b36b0bd8b01372421069b44))
- change ScanAndCount to work with transactions
  ([5b3f2c0](https://github.com/uptrace/bun/commit/5b3f2c021c424da366caffd33589e8adde821403))
- **dbfixture:** directly call funcs bypassing template eval
  ([a61974b](https://github.com/uptrace/bun/commit/a61974ba2d24361c5357fb9bda1f3eceec5a45cd))
- don't append CASCADE by default in drop table/column queries
  ([26457ea](https://github.com/uptrace/bun/commit/26457ea5cb20862d232e6e5fa4dbdeac5d444bf1))
- **migrate:** mark migrations as applied on error so the migration can be rolled back
  ([8ce33fb](https://github.com/uptrace/bun/commit/8ce33fbbac8e33077c20daf19a14c5ff2291bcae))
- respect nullzero when appending struct fields. Fixes
  [#339](https://github.com/uptrace/bun/issues/339)
  ([ffd02f3](https://github.com/uptrace/bun/commit/ffd02f3170b3cccdd670a48d563cfb41094c05d6))
- reuse tx for relation join ([#366](https://github.com/uptrace/bun/issues/366))
  ([60bdb1a](https://github.com/uptrace/bun/commit/60bdb1ac84c0a699429eead3b7fdfbf14fe69ac6))

### Features

- add `Dialect()` to Transaction and IDB interface
  ([693f1e1](https://github.com/uptrace/bun/commit/693f1e135999fc31cf83b99a2530a695b20f4e1b))
- add model embedding via embed:prefix\_
  ([9a2cedc](https://github.com/uptrace/bun/commit/9a2cedc8b08fa8585d4bfced338bd0a40d736b1d))
- change the default logoutput to stderr
  ([4bf5773](https://github.com/uptrace/bun/commit/4bf577382f19c64457cbf0d64490401450954654)),
  closes [#349](https://github.com/uptrace/bun/issues/349)

## [1.0.19](https://github.com/uptrace/bun/compare/v1.0.18...v1.0.19) (2021-11-30)

### Features

- add support for column:name to specify column name
  ([e37b460](https://github.com/uptrace/bun/commit/e37b4602823babc8221970e086cfed90c6ad4cf4))

## [1.0.18](https://github.com/uptrace/bun/compare/v1.0.17...v1.0.18) (2021-11-24)

### Bug Fixes

- use correct operation for UpdateQuery
  ([687a004](https://github.com/uptrace/bun/commit/687a004ef7ec6fe1ef06c394965dd2c2d822fc82))

### Features

- add pgdriver.Notify
  ([7ee443d](https://github.com/uptrace/bun/commit/7ee443d1b869d8ddc4746850f7425d0a9ccd012b))
- CreateTableQuery.PartitionBy and CreateTableQuery.TableSpace
  ([cd3ab4d](https://github.com/uptrace/bun/commit/cd3ab4d8f3682f5a30b87c2ebc2d7e551d739078))
- **pgdriver:** add CopyFrom and CopyTo
  ([0b97703](https://github.com/uptrace/bun/commit/0b977030b5c05f509e11d13550b5f99dfd62358d))
- support InsertQuery.Ignore on PostgreSQL
  ([1aa9d14](https://github.com/uptrace/bun/commit/1aa9d149da8e46e63ff79192e394fde4d18d9b60))

## [1.0.17](https://github.com/uptrace/bun/compare/v1.0.16...v1.0.17) (2021-11-11)

### Bug Fixes

- don't call rollback when tx is already done
  ([8246c2a](https://github.com/uptrace/bun/commit/8246c2a63e2e6eba314201c6ba87f094edf098b9))
- **mysql:** escape backslash char in strings
  ([fb32029](https://github.com/uptrace/bun/commit/fb32029ea7604d066800b16df21f239b71bf121d))

## [1.0.16](https://github.com/uptrace/bun/compare/v1.0.15...v1.0.16) (2021-11-07)

### Bug Fixes

- call query hook when tx is started, committed, or rolled back
  ([30e85b5](https://github.com/uptrace/bun/commit/30e85b5366b2e51951ef17a0cf362b58f708dab1))
- **pgdialect:** auto-enable array support if the sql type is an array
  ([62c1012](https://github.com/uptrace/bun/commit/62c1012b2482e83969e5c6f5faf89e655ce78138))

### Features

- support multiple tag options join:left_col1=right_col1,join:left_col2=right_col2
  ([78cd5aa](https://github.com/uptrace/bun/commit/78cd5aa60a5c7d1323bb89081db2b2b811113052))
- **tag:** log with bad tag name
  ([4e82d75](https://github.com/uptrace/bun/commit/4e82d75be2dabdba1a510df4e1fbb86092f92f4c))

## [1.0.15](https://github.com/uptrace/bun/compare/v1.0.14...v1.0.15) (2021-10-29)

### Bug Fixes

- fixed bug creating table when model has no columns
  ([042c50b](https://github.com/uptrace/bun/commit/042c50bfe41caaa6e279e02c887c3a84a3acd84f))
- init table with dialect once
  ([9a1ce1e](https://github.com/uptrace/bun/commit/9a1ce1e492602742bb2f587e9ed24e50d7d07cad))

### Features

- accept columns in WherePK
  ([b3e7035](https://github.com/uptrace/bun/commit/b3e70356db1aa4891115a10902316090fccbc8bf))
- support ADD COLUMN IF NOT EXISTS
  ([ca7357c](https://github.com/uptrace/bun/commit/ca7357cdfe283e2f0b94eb638372e18401c486e9))

## [1.0.14](https://github.com/uptrace/bun/compare/v1.0.13...v1.0.14) (2021-10-24)

### Bug Fixes

- correct binary serialization for mysql ([#259](https://github.com/uptrace/bun/issues/259))
  ([e899f50](https://github.com/uptrace/bun/commit/e899f50b22ef6759ef8c029a6cd3f25f2bde17ef))
- correctly escape single quotes in pg arrays
  ([3010847](https://github.com/uptrace/bun/commit/3010847f5c2c50bce1969689a0b77fd8a6fb7e55))
- use BLOB sql type to encode []byte in MySQL and SQLite
  ([725ec88](https://github.com/uptrace/bun/commit/725ec8843824a7fc8f4058ead75ab0e62a78192a))

### Features

- warn when there are args but no placeholders
  ([06dde21](https://github.com/uptrace/bun/commit/06dde215c8d0bde2b2364597190729a160e536a1))

## [1.0.13](https://github.com/uptrace/bun/compare/v1.0.12...v1.0.13) (2021-10-17)

### Breaking Change

- **pgdriver:** enable TLS by default with InsecureSkipVerify=true
  ([15ec635](https://github.com/uptrace/bun/commit/15ec6356a04d5cf62d2efbeb189610532dc5eb31))

### Features

- add BeforeAppendModelHook
  ([0b55de7](https://github.com/uptrace/bun/commit/0b55de77aaffc1ed0894ef16f45df77bca7d93c1))
- **pgdriver:** add support for unix socket DSN
  ([f398cec](https://github.com/uptrace/bun/commit/f398cec1c3873efdf61ac0b94ebe06c657f0cf91))

## [1.0.12](https://github.com/uptrace/bun/compare/v1.0.11...v1.0.12) (2021-10-14)

### Bug Fixes

- add InsertQuery.ColumnExpr to specify columns
  ([60ffe29](https://github.com/uptrace/bun/commit/60ffe293b37912d95f28e69734ff51edf4b27da7))
- **bundebug:** change WithVerbose to accept a bool flag
  ([b2f8b91](https://github.com/uptrace/bun/commit/b2f8b912de1dc29f40c79066de1e9d6379db666c))
- **pgdialect:** fix bytea[] handling
  ([a5ca013](https://github.com/uptrace/bun/commit/a5ca013742c5a2e947b43d13f9c2fc0cf6a65d9c))
- **pgdriver:** rename DriverOption to Option
  ([51c1702](https://github.com/uptrace/bun/commit/51c1702431787d7369904b2624e346bf3e59c330))
- support allowzero on the soft delete field
  ([d0abec7](https://github.com/uptrace/bun/commit/d0abec71a9a546472a83bd70ed4e6a7357659a9b))

### Features

- **bundebug:** allow to configure the hook using env var, for example, BUNDEBUG={0,1,2}
  ([ce92852](https://github.com/uptrace/bun/commit/ce928524cab9a83395f3772ae9dd5d7732af281d))
- **bunotel:** report DBStats metrics
  ([b9b1575](https://github.com/uptrace/bun/commit/b9b15750f405cdbd345b776f5a56c6f742bc7361))
- **pgdriver:** add Error.StatementTimeout
  ([8a7934d](https://github.com/uptrace/bun/commit/8a7934dd788057828bb2b0983732b4394b74e960))
- **pgdriver:** allow setting Network in config
  ([b24b5d8](https://github.com/uptrace/bun/commit/b24b5d8014195a56ad7a4c634c10681038e6044d))

## [1.0.11](https://github.com/uptrace/bun/compare/v1.0.10...v1.0.11) (2021-10-05)

### Bug Fixes

- **mysqldialect:** remove duplicate AppendTime
  ([8d42090](https://github.com/uptrace/bun/commit/8d42090af34a1760004482c7fc0923b114d79937))

## [1.0.10](https://github.com/uptrace/bun/compare/v1.0.9...v1.0.10) (2021-10-05)

### Bug Fixes

- add UpdateQuery.OmitZero
  ([2294db6](https://github.com/uptrace/bun/commit/2294db61d228711435fff1075409a30086b37555))
- make ExcludeColumn work with many-to-many queries
  ([300e12b](https://github.com/uptrace/bun/commit/300e12b993554ff839ec4fa6bbea97e16aca1b55))
- **mysqldialect:** append time in local timezone
  ([e763cc8](https://github.com/uptrace/bun/commit/e763cc81eac4b11fff4e074ad3ff6cd970a71697))
- **tagparser:** improve parsing options with brackets
  ([0daa61e](https://github.com/uptrace/bun/commit/0daa61edc3c4d927ed260332b99ee09f4bb6b42f))

### Features

- add timetz parsing
  ([6e415c4](https://github.com/uptrace/bun/commit/6e415c4c5fa2c8caf4bb4aed4e5897fe5676f5a5))

## [1.0.9](https://github.com/uptrace/bun/compare/v1.0.8...v1.0.9) (2021-09-27)

### Bug Fixes

- change DBStats to use uint32 instead of uint64 to make it work on i386
  ([caca2a7](https://github.com/uptrace/bun/commit/caca2a7130288dec49fa26b49c8550140ee52f4c))

### Features

- add IQuery and QueryEvent.IQuery
  ([b762942](https://github.com/uptrace/bun/commit/b762942fa3b1d8686d0a559f93f2a6847b83d9c1))
- add QueryEvent.Model
  ([7688201](https://github.com/uptrace/bun/commit/7688201b485d14d3e393956f09a3200ea4d4e31d))
- **bunotel:** add experimental bun.query.timing metric
  ([2cdb384](https://github.com/uptrace/bun/commit/2cdb384678631ccadac0fb75f524bd5e91e96ee2))
- **pgdriver:** add Config.ConnParams to session config params
  ([408caf0](https://github.com/uptrace/bun/commit/408caf0bb579e23e26fc6149efd6851814c22517))
- **pgdriver:** allow specifying timeout in DSN
  ([7dbc71b](https://github.com/uptrace/bun/commit/7dbc71b3494caddc2e97d113f00067071b9e19da))

## [1.0.8](https://github.com/uptrace/bun/compare/v1.0.7...v1.0.8) (2021-09-18)

### Bug Fixes

- don't append soft delete where for insert queries with on conflict clause
  ([27c477c](https://github.com/uptrace/bun/commit/27c477ce071d4c49c99a2531d638ed9f20e33461))
- improve bun.NullTime to accept string
  ([73ad6f5](https://github.com/uptrace/bun/commit/73ad6f5640a0a9b09f8df2bc4ab9cb510021c50c))
- make allowzero work with auto-detected primary keys
  ([82ca87c](https://github.com/uptrace/bun/commit/82ca87c7c49797d507b31fdaacf8343716d4feff))
- support soft deletes on nil model
  ([0556e3c](https://github.com/uptrace/bun/commit/0556e3c63692a7f4e48659d52b55ffd9cca0202a))

## [1.0.7](https://github.com/uptrace/bun/compare/v1.0.6...v1.0.7) (2021-09-15)

### Bug Fixes

- don't append zero time as NULL without nullzero tag
  ([3b8d9cb](https://github.com/uptrace/bun/commit/3b8d9cb4e39eb17f79a618396bbbe0adbc66b07b))
- **pgdriver:** return PostgreSQL DATE as a string
  ([40be0e8](https://github.com/uptrace/bun/commit/40be0e8ea85f8932b7a410a6fc2dd3acd2d18ebc))
- specify table alias for soft delete where
  ([5fff1dc](https://github.com/uptrace/bun/commit/5fff1dc1dd74fa48623a24fa79e358a544dfac0b))

### Features

- add SelectQuery.Exists helper
  ([c3e59c1](https://github.com/uptrace/bun/commit/c3e59c1bc58b43c4b8e33e7d170ad33a08fbc3c7))

## [1.0.6](https://github.com/uptrace/bun/compare/v1.0.5...v1.0.6) (2021-09-11)

### Bug Fixes

- change unique tag to create a separate unique constraint
  ([8401615](https://github.com/uptrace/bun/commit/84016155a77ca77613cc054277fefadae3098757))
- improve zero checker for ptr values
  ([2b3623d](https://github.com/uptrace/bun/commit/2b3623dd665d873911fd20ca707016929921e862))

## v1.0.5 - Sep 09 2021

- chore: tweak bundebug colors
- fix: check if table is present when appending columns
- fix: copy []byte when scanning

## v1.0.4 - Sep 08 2021

- Added support for MariaDB.
- Restored default `SET` for `ON CONFLICT DO UPDATE` queries.

## v1.0.3 - Sep 06 2021

- Fixed bulk soft deletes.
- pgdialect: fixed scanning into an array pointer.

## v1.0.2 - Sep 04 2021

- Changed to completely ignore fields marked with `bun:"-"`. If you want to be able to scan into
  such columns, use `bun:",scanonly"`.
- pgdriver: fixed SASL authentication handling.

## v1.0.1 - Sep 02 2021

- pgdriver: added erroneous zero writes retry.
- Improved column handling in Relation callback.

## v1.0.0 - Sep 01 2021

- First stable release.

## v0.4.1 - Aug 18 2021

- Fixed migrate package to properly rollback migrations.
- Added `allowzero` tag option that undoes `nullzero` option.

## v0.4.0 - Aug 11 2021

- Changed `WhereGroup` function to accept `*SelectQuery`.
- Fixed query hooks for count queries.

## v0.3.4 - Jul 19 2021

- Renamed `migrate.CreateGo` to `CreateGoMigration`.
- Added `migrate.WithPackageName` to customize the Go package name in generated migrations.
- Renamed `migrate.CreateSQL` to `CreateSQLMigrations` and changed `CreateSQLMigrations` to create
  both up and down migration files.

## v0.3.1 - Jul 12 2021

- Renamed `alias` field struct tag to `alt` so it is not confused with column alias.
- Reworked migrate package API. See
  [migrate](https://github.com/uptrace/bun/tree/master/example/migrate) example for details.

## v0.3.0 - Jul 09 2021

- Changed migrate package to return structured data instead of logging the progress. See
  [migrate](https://github.com/uptrace/bun/tree/master/example/migrate) example for details.

## v0.2.14 - Jul 01 2021

- Added [sqliteshim](https://pkg.go.dev/github.com/uptrace/bun/driver/sqliteshim) by
  [Ivan Trubach](https://github.com/tie).
- Added support for MySQL 5.7 in addition to MySQL 8.

## v0.2.12 - Jun 29 2021

- Fixed scanners for net.IP and net.IPNet.

## v0.2.10 - Jun 29 2021

- Fixed pgdriver to format passed query args.

## v0.2.9 - Jun 27 2021

- Added support for prepared statements in pgdriver.

## v0.2.7 - Jun 26 2021

- Added `UpdateQuery.Bulk` helper to generate bulk-update queries.

  Before:

  ```go
  models := []Model{
  	{42, "hello"},
  	{43, "world"},
  }
  return db.NewUpdate().
  	With("_data", db.NewValues(&models)).
  	Model(&models).
  	Table("_data").
  	Set("model.str = _data.str").
  	Where("model.id = _data.id")
  ```

  Now:

  ```go
  db.NewUpdate().
  	Model(&models).
  	Bulk()
  ```

## v0.2.5 - Jun 25 2021

- Changed time.Time to always append zero time as `NULL`.
- Added `db.RunInTx` helper.

## v0.2.4 - Jun 21 2021

- Added SSL support to pgdriver.

## v0.2.3 - Jun 20 2021

- Replaced `ForceDelete(ctx)` with `ForceDelete().Exec(ctx)` for soft deletes.

## v0.2.1 - Jun 17 2021

- Renamed `DBI` to `IConn`. `IConn` is a common interface for `*sql.DB`, `*sql.Conn`, and `*sql.Tx`.
- Added `IDB`. `IDB` is a common interface for `*bun.DB`, `bun.Conn`, and `bun.Tx`.

## v0.2.0 - Jun 16 2021

- Changed [model hooks](https://bun.uptrace.dev/guide/hooks.html#model-hooks). See
  [model-hooks](example/model-hooks) example.
- Renamed `has-one` to `belongs-to`. Renamed `belongs-to` to `has-one`. Previously Bun used
  incorrect names for these relations.
