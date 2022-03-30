using System;
using System.IO;
using System.Threading.Tasks;

namespace Semmle
{
    public class Asynchronous
    {
        private static string[] filenames = { "async.cs", "Await.ql" };

        private static void Main(string[] args)
        {
            Task[] results = new Task[filenames.Length];

            for (int i = 0; i < results.Length; i++)
                results[i] = PrintContentLengthAsync(filenames[i]);

            for (int i = 0; i < results.Length; i++)
                results[i].Wait();
        }

        private static async Task PrintContentLengthAsync(string filename)
        {
            int length = await ContentLengthAsync(filename);
            Console.WriteLine("Fetched " + length + " characters");
        }

        private static async Task<int> ContentLengthAsync(string filename)
        {
            using (StreamReader reader = File.OpenText(filename))
            {
                string content = await reader.ReadToEndAsync();
                return content.Length;
            }
        }

        // regression test for 'AddResumePoint' error
        private static async void AsyncIterator(string filename)
        {
            using (StreamReader other = File.OpenText(filename))
            {
                using (StreamReader reader = await OpenAsync(filename))
                {
                    string content = await reader.ReadToEndAsync();
                    Console.WriteLine(content.Length);
                }
            }
        }

        private static async Task<StreamReader> OpenAsync(string filename)
        {
            await PrintContentLengthAsync(filename);
            return File.OpenText(filename);
        }
    }
}
