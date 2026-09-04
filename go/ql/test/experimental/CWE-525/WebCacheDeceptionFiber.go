package main

import (
	"fmt"
	"log"

	"github.com/gofiber/fiber/v2"
)

func badRouting() {
	app := fiber.New()
	log.Println("We are logging in Golang!")

	// GET /api/register
	app.Get("/api/*", func(c *fiber.Ctx) error { // $ Alert
		msg := fmt.Sprintf("✋")
		return c.SendString(msg) // => ✋ register
	})

	app.Post("/api/*", func(c *fiber.Ctx) error { // $ Alert
		msg := fmt.Sprintf("✋")
		return c.SendString(msg) // => ✋ register
	})

	// GET /flights/LAX-SFO
	app.Get("/flights/:from-:to", func(c *fiber.Ctx) error {
		msg := fmt.Sprintf("💸 From: %s, To: %s", c.Params("from"), c.Params("to"))
		return c.SendString(msg) // => 💸 From: LAX, To: SFO
	})

	// GET /dictionary.txt
	app.Get("/:file.:ext", func(c *fiber.Ctx) error {
		msg := fmt.Sprintf("📃 %s.%s", c.Params("file"), c.Params("ext"))
		return c.SendString(msg) // => 📃 dictionary.txt
	})

	log.Fatal(app.Listen(":3000"))
}
