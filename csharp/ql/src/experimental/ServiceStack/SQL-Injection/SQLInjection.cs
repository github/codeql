using ServiceStack;
using ServiceStack.OrmLite;
using SqlServer.ServiceModel;
using SqlServer.ServiceModel.Types;

namespace SqlServer.ServiceInterface
{
    public class CustomerService : Service
    {
        public GetCustomersResponse Get(GetCustomers request)
        {
            return new GetCustomersResponse { Results = Db.Select<Customer>() };
        }

        public GetCustomerResponse Get(GetCustomer request)
        {
            //var customer = Db.SingleById<Customer>(request.Id);
            var customer = Db.SqlScalar<int>("SELECT Id FROM Customer WHERE Id = " + request.Id + ";");
            if (customer == null)
                throw HttpError.NotFound("Customer not found");

            return new GetCustomerResponse
            {
                Result = Db.SingleById<Customer>(request.Id)
            };
        }

        public CreateCustomerResponse Post(CreateCustomer request)
        {
            var customer = new Customer { Name = request.Name };
            //Db.Save(customer);
            Db.ExecuteSql("INSERT INTO Customer (Name) VALUES ('" + customer.Name + "')");
            return new CreateCustomerResponse
            {
                Result = customer
            };
        }

        public UpdateCustomerResponse Put(UpdateCustomer request)
        {
            var customer = Db.SingleById<Customer>(request.Id);
            if (customer == null)
                throw HttpError.NotFound("Customer '{0}' does not exist".Fmt(request.Id));

            customer.Name = request.Name;
            //Db.Update(customer);
            Db.ExecuteSqlAsync("UPDATE Customer SET Name = '" + customer.Name + "' WHERE Id = " + request.Id);
            return new UpdateCustomerResponse
            {
                Result = customer
            };
        }

        public void Delete(DeleteCustomer request)
        {
            //Db.DeleteById<Customer>(request.Id);
            string q = @"DELETE FROM Customer WHERE Id = " + request.Id;
            Db.ExecuteSql(q);
        }
    }
}
