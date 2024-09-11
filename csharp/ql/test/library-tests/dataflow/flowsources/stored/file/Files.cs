using System.IO;

namespace Test
{
    class Files
    {
        public static void ReadAllText(string path)
        {
            string text = File.ReadAllText(path);
            Sink(text); // $ hasTaintFlow=line:9
        }

        public static void ReadAllLines(string path)
        {
            string[] lines = File.ReadAllLines(path);
            Sink(lines); // $ hasTaintFlow=line:15
        }

        public static void ReadAllBytes(string path)
        {
            byte[] bytes = File.ReadAllBytes(path);
            Sink(bytes); // $ hasTaintFlow=line:21
        }

        public static void ReadLines(string path)
        {
            foreach (string line in File.ReadLines(path))
            {
                Sink(line); // $ hasTaintFlow=line:27
            }
        }

        public static void BufferedRead(string path)
        {
            using (FileStream fs = new FileStream(path, FileMode.Open))
            {
                using (BufferedStream bs = new BufferedStream(fs))
                {
                    using (StreamReader sr = new StreamReader(bs))
                    {
                        string line;
                        while ((line = sr.ReadLine()) != null)
                        {
                            Sink(line); // $ hasTaintFlow=line:35
                        }
                    }
                }
            }
        }

        public static void ReadBlocks(string path)
        {
            using (FileStream fs = File.OpenRead(path))
            {
                byte[] buffer = new byte[1024];
                int bytesRead;
                while ((bytesRead = fs.Read(buffer, 0, buffer.Length)) > 0)
                {
                    Sink(buffer[0]); // $ hasTaintFlow=line:53
                }
            }
        }

        public static async void ReadAllTextAsync(string path)
        {
            string text = await File.ReadAllTextAsync(path);
            Sink(text); // $ hasTaintFlow=line:66

            using (FileStream fs = File.Open(path, FileMode.Open))
            {
                using (StreamReader sr = new StreamReader(fs))
                {
                    string line;
                    while ((line = await sr.ReadLineAsync()) != null)
                    {
                        Sink(line); // $ hasTaintFlow=line:69
                    }
                }
            }
        }

        static void Sink(object o) { }
    }
}