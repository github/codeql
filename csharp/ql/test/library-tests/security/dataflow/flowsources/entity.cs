
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;

public class Blog
{
    public int BlogId { get; set; }
    public string Name { get; set; }

    public virtual List<Post> Posts { get; set; }
}

public class Post
{
    public int PostId { get; set; }
    public string Title { get; set; }
    public string Content { get; set; }

    public int BlogId { get; set; }
    public virtual Blog Blog { get; set; }
}

public class BloggingContext : DbContext
{
    public DbSet<Blog> Blogs { get; set; }
    public DbSet<Post> Posts { get; set; }

    public void Execute()
    {
        DbRawSqlQuery<Blog> blogs = Database.SqlQuery<Blog>("SELECT * FROM Blogs");
        foreach (var blog in blogs)
        {
            // This will be a source because it is an access of an entity property
            Console.WriteLine(blog.Name);
        }

        DbRawSqlQuery<string> blogNames = Database.SqlQuery<string>("SELECT Name FROM Blogs");
        foreach (var blogName in blogNames)
        {
            // This will be a source because it is returned from an SqlQuery
            Console.WriteLine(blogName);
        }
    }
}
