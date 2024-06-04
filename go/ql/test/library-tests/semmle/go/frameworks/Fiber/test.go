package fiber

//go:generate depstubber -vendor  github.com/gofiber/fiber/v2 Ctx New
import "github.com/gofiber/fiber/v2"

func FileSystemAccess() {
	app := fiber.New()
	app.Get("/b", func(c *fiber.Ctx) error {
		filepath := c.Params("filepath")
		header, _ := c.FormFile("f")
		_ = c.SaveFile(header, filepath) // $ FileSystemAccess=filepath
		return c.SendFile(filepath)      // $ FileSystemAccess=filepath
	})
	_ = app.Listen(":3000")
}
