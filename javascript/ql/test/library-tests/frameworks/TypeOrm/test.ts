import { BaseEntity, Brackets, DataSource, JoinColumn, NotBrackets, OneToOne } from "typeorm";
import { Entity, PrimaryGeneratedColumn, Column } from "typeorm"

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
            .where("user.firstName = :firstName", { firstName })
            .andWhere("user.lastName = :lastName", { lastName })
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
AppDataSource.initialize().then(async () => {
    // OK
    const userQb = AppDataSource
        .createQueryBuilder(User, "User")
        .select("user.name")
        .where("user.registered = :registered", { registered: true }).getParameters()

    let insertQuery = AppDataSource
        .createQueryBuilder(User2, "User")
        .insert()
        .into(User2)
        .values({
            firstName: "Timber",
            // NOT OK
            lastName: () => "Vulnerable \")--",
            age: 33,
        })
        .orUpdate(
            // NOT OK
            ["firstName inj3--\" ", "lastName inj1--\" "],
            ["externalId inj2\")-- "],
        )
        .getQueryAndParameters()
    console.log(insertQuery)

    let updateResult = await AppDataSource.getRepository(User2).createQueryBuilder("user2")
        .update(User2)
        .set({ firstName: () => "Vulnerable \")--", lastName: "Saw2", age: 12 })
        .where("user2.lastName = \"Saw2\" OR 1=1",)
        .execute()
    console.log(updateResult)

    let deleteResult = await AppDataSource.getRepository(User2).createQueryBuilder('user2')
        .delete()
        .from(User2)
        .where("id = 1 OR 1=1")
        .execute()
    console.log(deleteResult)


    const queryRunner = AppDataSource.createQueryRunner()
    let resultQueryRunner = await queryRunner.query("select * from USER2")
    console.log(resultQueryRunner)

    resultQueryRunner = await queryRunner.manager
        .createQueryBuilder(User2, "User")
        .select("*")
        .where("user.id >=3").execute()
    console.log(resultQueryRunner)

    // Active record
    const timber = await UserActiveRecord.findByName("Timber", "Saw")
    console.log(timber)
    await AppDataSource
        .createQueryBuilder(User, "User")
        .innerJoin("User.profile", "profile", "User.id = :id OR 1=1", {
            id: 2,
        }).getMany().then(res => console.log(res))

    await AppDataSource
        .createQueryBuilder(User, "User")
        .leftJoinAndMapOne("User.profile", "profile", "profile", "User.id = :id OR 1=1", {
            id: 2,
        }).getMany().then(res => console.log(res))


    await AppDataSource
        .createQueryBuilder(User2, "User2")
        .where((qb) => {
            const subQuery = qb
                .subQuery()
                .select("User2.firstName")
                .from(User2, "user2")
                .where("user2.id = :registered")
                .getQuery()
            return "User2.id IN " + subQuery
        })
        .setParameter("registered", true)
        .getMany()


    console.log("Loading users from the database...")
    // Using repository
    // OK: using parameters
    let users0 = await AppDataSource.getRepository(User2).createQueryBuilder("User2").where("User2.id =:kind", { kind: '1' }).getMany()
    // NOT OK
    let users = await AppDataSource.getRepository(User2).createQueryBuilder("User2").where("User2.id =:kind" + " OR 1=1", { kind: 1 }).getMany()
    console.log("Loaded users: ", users)

    // Using DataSource
    // NOT OK
    users = await AppDataSource
        .createQueryBuilder()
        .select("User2")
        .from(User2, "User2")
        .where("User2.id = :id", { id: 1 })
        .getMany()
    console.log("Loaded users: ", users)

    // Using entity manager
    users = await AppDataSource.manager
        .createQueryBuilder(User2, "User2").where("User2.id =:kind" + " OR 1=1", { kind: '1' }).getMany()
    console.log("Loaded users: ", users)

    let count = await AppDataSource
        .createQueryBuilder(User2, "User2").groupBy("User2.id").having("User2.firstName = :firstName", { firstName: "Timber" }).getMany()
    console.log("Loaded users: ", count)

    count = await AppDataSource
        .createQueryBuilder(User2, "User2")
        .leftJoinAndSelect("user.photos", "photo", "photo.isRemoved = :isRemoved", {
            isRemoved: false,
        }).getMany()


    count = await AppDataSource
        .createQueryBuilder(User2, "User2").groupBy("User2.id").having("User2.firstName = :firstName", { firstName: "Timber" }).getMany()
    console.log("Loaded users: ", count)

    // orderBy
    // it is a little bit restrictive, e.g. sqlite don't support it at all
    count = await AppDataSource
        .createQueryBuilder(User2, "User2").where("User2.firstName = :firstName", {
            firstName: "Timber",
        })
        .where(
            new Brackets((qb) => {
                qb.where("User2.firstName = :firstName", {
                    firstName: "Timber",
                }).orWhere("User2.lastName = :lastName) OR (1=1) OR (1=1", { lastName: "Saw" });
            })
        )
        .orderBy("User2.id").orWhere("id=1").getMany()
    console.log("Loaded users: ", count)

    // relation
    AppDataSource.createQueryBuilder().relation(User, "name")
        .of(User)
        .select().where("1=1").getMany().then(results => {
            console.log(results)
        })

    // Brackets
    let results2 = await AppDataSource.createQueryBuilder(User2, "User2")
        .where("User2.id =:kind", { kind: 1 })
        .andWhere(
            new Brackets((qb) => {
                qb.where("User2.firstName = :firstName", {
                    firstName: "Timber",
                }).orWhere("User2.lastName = :lastName) OR (1=1) OR (1=1", { lastName: "Saw" });
            })
        ).andWhere(
            new NotBrackets((qb) => {
                qb.where("User2.firstName = :firstName", {
                    firstName: "Timber",
                }).orWhere("User2.lastName = :lastName", { lastName: "Saw" })
            }),
        ).getMany()
    console.log("Brackets results:", results2)
}).catch(error => console.log(error))
