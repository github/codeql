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
            .where("user.firstName = " + firstName)  // test: SQLInjectionPoint
            .andWhere("user.lastName = " + lastName)  // test: SQLInjectionPoint
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
    const BadInput = "A user controllable Remote Source like `' 1=1 --` "

    // Active record
    await UserActiveRecord.findByName(BadInput, "Saw")

    // data mapper
    const selectQueryBuilder = makePaginationQuery<User>(AppDataSource
        .createQueryBuilder(User, "User").select());
    selectQueryBuilder.where(BadInput).getMany().then(result => {    // test: SQLInjectionPoint
        console.log(result)
    });

    const selectQueryBuilder2 = makePaginationQuery<User>(AppDataSource
        .createQueryBuilder(User, "User"));
    selectQueryBuilder2.where(BadInput).getMany().then(result => {   // test: SQLInjectionPoint
        console.log(result)
    });

    const insertQueryBuilder: InsertQueryBuilder<User2> = AppDataSource
        .createQueryBuilder(User2, "User2").insert();
    insertQueryBuilder.into(User2)
        .values({
            firstName: "Timber",
            lastName: () => BadInput,   // test: SQLInjectionPoint
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
            lastName: () => BadInput,   // test: SQLInjectionPoint
            age: 33,
        })
        .orUpdate(
            [BadInput, BadInput],   // test: SQLInjectionPoint
            [BadInput],   // test: SQLInjectionPoint
        )
        .getQueryAndParameters()

    await AppDataSource.getRepository(User2).createQueryBuilder("user2")
        .update(User2)
        .set({ firstName: () => BadInput, lastName: "Saw2", age: 12 })   // test: SQLInjectionPoint
        .where(BadInput,)   // test: SQLInjectionPoint
        .execute()

    await AppDataSource.getRepository(User2).createQueryBuilder('user2')
        .delete()
        .from(User2)
        .where(BadInput)   // test: SQLInjectionPoint
        .execute()


    const queryRunner = AppDataSource.createQueryRunner()
    await queryRunner.query(BadInput)   // test: SQLInjectionPoint

    await queryRunner.manager
        .createQueryBuilder(User2, "User")
        .select(BadInput)   // test: SQLInjectionPoint
        .where(BadInput).execute()   // test: SQLInjectionPoint

    await AppDataSource
        .createQueryBuilder(User, "User")
        .innerJoin("User.profile", "profile", BadInput, {   // test: SQLInjectionPoint
            id: 2,
        }).getMany().then(res => console.log(res))

    await AppDataSource
        .createQueryBuilder(User, "User")
        .leftJoinAndMapOne("User.profile", "profile", "profile", BadInput, {   // test: SQLInjectionPoint
            id: 2,
        }).getMany().then(res => console.log(res))


    await AppDataSource
        .createQueryBuilder(User2, "User2")
        .where((qb) => {
            const subQuery = qb
                .subQuery()
                .select(BadInput)   // test: SQLInjectionPoint
                .from(User2, "user2")
                .where(BadInput)   // test: SQLInjectionPoint
                .getQuery()
            return "User2.id IN " + subQuery
        })
        .setParameter("registered", true)
        .getMany()


    // Using repository
    await AppDataSource.getRepository(User2).createQueryBuilder("User2").where("User2.id =:kind" + BadInput, { kind: 1 }).getMany()

    // Using DataSource
    await AppDataSource
        .createQueryBuilder()
        .select(BadInput)   // test: SQLInjectionPoint
        .from(User2, "User2")
        .where(BadInput, { id: 1 })   // test: SQLInjectionPoint
        .getMany()

    // Using entity manager
    await AppDataSource.manager
        .createQueryBuilder(User2, "User2").where("User2.id =:kind" + BadInput, { kind: '1' }).getMany()   // test: SQLInjectionPoint
    await AppDataSource
        .createQueryBuilder(User2, "User2")
        .leftJoinAndSelect("user.photos", "photo", BadInput).getMany()   // test: SQLInjectionPoint
    await AppDataSource
        .createQueryBuilder(User2, "User2").groupBy("User2.id").having(BadInput).getMany()   // test: SQLInjectionPoint
    // orderBy
    // it is a little bit restrictive, e.g. sqlite don't support it at all
    await AppDataSource
        .createQueryBuilder(User2, "User2").where(BadInput, {   // test: SQLInjectionPoint
            firstName: "Timber",
        })
        .where(
            new Brackets((qb) => {
                qb.where(BadInput).orWhere(BadInput);   // test: SQLInjectionPoint
            })
        )
        .orderBy(BadInput).orWhere(BadInput).getMany()   // test: SQLInjectionPoint

    // relation
    AppDataSource.createQueryBuilder().relation(User, "name")
        .of(User)
        .select().where(BadInput).getMany().then(results => {   // test: SQLInjectionPoint
            console.log(results)
        })

    // Brackets
    await AppDataSource.createQueryBuilder(User2, "User2")
        .where(BadInput)   // test: SQLInjectionPoint
        .andWhere(
            new Brackets((qb) => {
                qb.where(BadInput).orWhere(BadInput);  // test: SQLInjectionPoint
            })
        ).andWhere(
            new NotBrackets((qb) => {
                qb.where(BadInput).orWhere(BadInput)   // test: SQLInjectionPoint
            }),
        ).getMany()
}).catch(error => console.log(error))
