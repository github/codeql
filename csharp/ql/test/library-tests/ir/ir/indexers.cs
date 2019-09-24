class Indexers
{
    public class Contact
    {
        private string[] address = new string[3];
        public string this[int index]
        {
            get
            {
                return address[index];
            }
            set
            {
                address[index] = value;
            }
        }
    }

    public static void Main()
    {
        Contact contact = new Contact();
        contact[0] = "Begumpet";
        contact[1] = "Hyderabad";
        contact[2] = "Telengana";
    }
}
