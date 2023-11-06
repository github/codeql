import {
    BaseEntity, Brackets, DataSource, JoinColumn, NotBrackets
    , OneToOne, Entity, PrimaryGeneratedColumn, Column, SelectQueryBuilder, InsertQueryBuilder
} from "typeorm";

@Entity()
export class UserActiveRecord extends BaseEntity {
    @PrimaryGeneratedColumn()
    id: number
    @Column()
    firstName: string
    @Column()
    lastName: string
    @Column()
    age: number

    static findByName(firstName: string, lastName: string) {
        return this.createQueryBuilder("user")
            .where("user.firstName = " + firstName)
            .andWhere("user.lastName = " + lastName)
            .getMany()
    }
}

@Entity()
export class Profile {
    @PrimaryGeneratedColumn()
    id: number
    @Column()
    gender: string
    @Column()
    photo: string
}

@Entity()
export class User {
    @PrimaryGeneratedColumn()
    id: number
    @Column()
    name: string
    @OneToOne(() => Profile)
    @JoinColumn()
    profile: Profile
}

@Entity()
export class User2 {
    @PrimaryGeneratedColumn()
    id: number
    @Column()
    firstName: string
    @Column()
    lastName: string
    @Column()
    age: number

}

export const AppDataSource = new DataSource({
    type: "sqlite",
    database: "database.sqlite",
    synchronize: true,
    logging: false,
    entities: [User, User2, Profile, UserActiveRecord],
    migrations: [],
    subscribers: [],
})

function makePaginationQuery<T>(q: SelectQueryBuilder<T>): SelectQueryBuilder<T> {
    return q;
}

AppDataSource.initialize().then(async () => {
    // Active record
    await UserActiveRecord.findByName("FirstNameToFind", "LastNameToFind")

    // data mapper
    const selectQueryBuilder = makePaginationQuery<User>(AppDataSource
        .createQueryBuilder(User, "User").select());
    selectQueryBuilder.where('id > 5').getMany().then(result => {
        console.log(result)
    });

    const selectQueryBuilder2 = makePaginationQuery<User>(AppDataSource
        .createQueryBuilder(User, "User"));
    selectQueryBuilder2.where('id > 5').getMany().then(result => {
        console.log(result)
    });

    const insertQueryBuilder: InsertQueryBuilder<User2> = AppDataSource
        .createQueryBuilder(User2, "User2").insert();
    insertQueryBuilder.into(User2)
        .values({
            firstName: "Timber",
            lastName: () => "LastNameToFind",
            age: 33,
        }).execute().then(result => {
            console.log(result)


        })

    AppDataSource
        .createQueryBuilder(User2, "User")
        .insert()
        .into(User2)
        .values({
            firstName: "Timber",
            lastName: () => "LastNameToFind",
            age: 33,
        })
        .orUpdate(
            ["firstName", "lastName"],
            ["externalId"],
        )
        .getQueryAndParameters()

    await AppDataSource.getRepository(User2).createQueryBuilder("user2")
        .update(User2)
        .set({ firstName: () => "firstname", lastName: "Saw2", age: 12 })
        .where('id > 5')
        .execute()

    await AppDataSource.getRepository(User2).createQueryBuilder('user2')
        .delete()
        .from(User2)
        .where('id > 5')
        .execute()


    const queryRunner = AppDataSource.createQueryRunner()
    await queryRunner.query('SELECT name,id FROM table1 WHERE id > 5')

    await queryRunner.manager
        .createQueryBuilder(User2, "User")
        .select("name,id")
        .where("id > 5").execute()

    await AppDataSource
        .createQueryBuilder(User, "User")
        .innerJoin("User.profile", "profile", 'id > 5', {
            id: 2,
        }).getMany().then(res => console.log(res))

    await AppDataSource
        .createQueryBuilder(User, "User")
        .leftJoinAndMapOne("User.profile", "profile", "profile", 'id > 5', {
            id: 2,
        }).getMany().then(res => console.log(res))


    await AppDataSource
        .createQueryBuilder(User2, "User2")
        .where((qb) => {
            const subQuery = qb
                .subQuery()
                .select("name,id")
                .from(User2, "user2")
                .where('id > 5')
                .getQuery()
            return "User2.id IN " + subQuery
        })
        .setParameter("registered", true)
        .getMany()


    // Using repository
    let users = await AppDataSource.getRepository(User2).createQueryBuilder("User2").where("User2.id =:kind", { kind: 1 }).getMany()

    // Using DataSource
    users = await AppDataSource
        .createQueryBuilder()
        .select("User2")
        .from(User2, "User2")
        .where('id > 5', { id: 1 })
        .getMany()

    // Using entity manager
    await AppDataSource.manager
        .createQueryBuilder(User2, "User2").where("User2.id =:kind and id > 5", { kind: '1' }).getMany()
    await AppDataSource
        .createQueryBuilder(User2, "User2")
        .leftJoinAndSelect("user.photos", "photo", 'id > 5').getMany()
    await AppDataSource
        .createQueryBuilder(User2, "User2").groupBy("User2.id").having('id > 5').getMany()
    // orderBy
    // it is a little bit restrictive, e.g. sqlite don't support it at all
    await AppDataSource
        .createQueryBuilder(User2, "User2").where('id > 5', {
            firstName: "Timber",
        })
        .where(
            new Brackets((qb) => {
                qb.where('id > 5').orWhere('id > 5');
            })
        )
        .orderBy("name").orWhere('id > 5').getMany()

    // relation
    AppDataSource.createQueryBuilder().relation(User, "name")
        .of(User)
        .select().where('id > 5').getMany().then(results => {
            console.log(results)
        })

    // Brackets
    await AppDataSource.createQueryBuilder(User2, "User2")
        .where('id > 5')
        .andWhere(
            new Brackets((qb) => {
                qb.where('id > 5').orWhere('id > 5');
            })
        ).andWhere(
            new NotBrackets((qb) => {
                qb.where('id > 5').orWhere('id > 5')
            }),
        ).getMany()
}).catch(error => console.log(error))
