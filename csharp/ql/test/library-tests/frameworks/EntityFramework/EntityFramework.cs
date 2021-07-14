using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity;
using System.Linq;

namespace EFTests
{
    class Person
    {
        public virtual int Id { get; set; }
        public virtual string Name { get; set; }

        [NotMapped]
        public string Title { get; set; }

        // Navigation property
        public ICollection<Address> Addresses { get; set; }
    }

    class Address
    {
        public int Id { get; set; }
        public string Street { get; set; }
    }

    class PersonAddressMap
    {
        public int Id { get; set; }
        public int PersonId { get; set; }
        public int AddressId { get; set; }

        // Navigation properties
        public Person Person { get; set; }
        public Address Address { get; set; }
    }

    class MyContext : DbContext
    {
        public virtual DbSet<Person> Persons { get; set; }
        public virtual DbSet<Address> Addresses { get; set; }
        public virtual DbSet<PersonAddressMap> PersonAddresses { get; set; }

        public static MyContext GetInstance() => null;
    }

    class Tests
    {
        void FlowSources()
        {
            var p = new Person();
            var id = p.Id;  // Remote flow source
            var name = p.Name;  // Remote flow source
            var title = p.Title;  // Not a remote flow source
        }

        void TestSaveChangesDirectDataFlow()
        {
            var p1 = new Person
            {
                // Flows to `ReadFirstPersonFromDB`
                Name = "tainted"
            };
            var p2 = new Person { Name = "untainted" };

            var ctx = MyContext.GetInstance();
            ctx.Persons.Add(p1);
            ctx.Persons.Add(p2);
            ctx.SaveChanges();

            var p3 = new Person
            {
                // No flow (no call to `SaveChanges`)
                Name = "tainted"
            };
            ctx.Persons.Add(p3);
        }

        async void TestSaveChangesAsyncDirectDataFlow()
        {
            var p1 = new Person
            {
                // Flows to `ReadFirstPersonFromDB`
                Name = "tainted"
            };
            var p2 = new Person { Name = "untainted" };

            var ctx = MyContext.GetInstance();
            ctx.Persons.Add(p1);
            ctx.Persons.Add(p2);
            await ctx.SaveChangesAsync();

            var p3 = new Person
            {
                // No flow (no call to `SaveChanges`)
                Name = "tainted"
            };
            ctx.Persons.Add(p3);
        }

        void TestSaveChangesIndirectDataFlow()
        {
            var p1 = new Person
            {
                // Flows to `ReadFirstPersonFromDB`
                Name = "tainted"
            };
            var p2 = new Person { Name = "untainted" };

            AddPersonToDB(p1);
            AddPersonToDB(p2);

            var p3 = new Person
            {
                // No flow (not added)
                Name = "tainted"
            };
        }

        void TestNotMappedDataFlow()
        {
            var p1 = new Person
            {
                // Flows only to `Sink` below as `Title` it is not mapped
                Title = "tainted"
            };
            var ctx = MyContext.GetInstance();
            ctx.Persons.Add(p1);
            ctx.SaveChanges();
            Sink(p1.Title);

            var p2 = new Person { Title = "untainted" };
            ctx.Persons.Add(p2);
            ctx.SaveChanges();
            Sink(p2.Title);
        }

        void TestNavigationPropertyReadFlow()
        {
            var ctx = MyContext.GetInstance();
            var p1 = new Person
            {
                Addresses = new[] {
                    new Address {
                        // Flows to `ReadFirstAddressFromDB` and `ReadFirstPersonAddress`
                        Street = "tainted"
                    }
                }
            };
            ctx.Persons.Add(p1);
            ctx.SaveChanges();

            var p2 = new Person { Addresses = new[] { new Address { Street = "untainted" } } };
            ctx.Persons.Add(p2);
            ctx.SaveChanges();

            var a1 = new Address
            {
                // Flows to `ReadFirstAddressFromDB` and `ReadFirstPersonAddress`
                Street = "tainted"
            };
            ctx.Addresses.Add(a1);
            ctx.SaveChanges();

            var a2 = new Address { Street = "untainted" };
            ctx.Addresses.Add(a2);
            ctx.SaveChanges();
        }

        void TestNavigationPropertyStoreFlow()
        {
            var ctx = MyContext.GetInstance();
            var p1 = new Person
            {
                // Flows to `ReadFirstPersonFromDB`
                Name = "tainted"
            };
            var a1 = new Address
            {
                // Flows to `ReadFirstAddressFromDB` and `ReadFirstPersonAddress`
                Street = "tainted"
            };
            var personAddressMap1 = new PersonAddressMap() { Person = p1, Address = a1 };
            ctx.PersonAddresses.Add(personAddressMap1);
            ctx.SaveChanges();

            var p2 = new Person { Name = "untainted" };
            var a2 = new Address { Street = "untainted" };
            var personAddressMap2 = new PersonAddressMap() { Person = p2, Address = a2 };
            ctx.PersonAddresses.Add(personAddressMap2);
            ctx.SaveChanges();
        }

        void AddPersonToDB(Person p)
        {
            var ctx = MyContext.GetInstance();
            ctx.Persons.Add(p);
            ctx.SaveChanges();
        }

        void ReadFirstPersonFromDB()
        {
            var ctx = MyContext.GetInstance();
            Sink(ctx.Persons.First().Id);
            Sink(ctx.Persons.First().Name);
            Sink(ctx.Persons.First().Title);
        }

        void ReadFirstAddressFromDB()
        {
            var ctx = MyContext.GetInstance();
            Sink(ctx.Addresses.First().Id);
            Sink(ctx.Addresses.First().Street);
        }

        void ReadFirstPersonAddress()
        {
            var ctx = MyContext.GetInstance();
            Sink(ctx.Persons.First().Addresses.First().Id);
            Sink(ctx.Persons.First().Addresses.First().Street);
        }

        void Sink(object @object)
        {
        }
    }
}
