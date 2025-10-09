package routes

import (
	"github.com/Debugger3000/Vivo/controllers" // adjust to your module name in go.mod

	"github.com/gofiber/fiber/v2"
)

func SetupTesterRoutes(app *fiber.App) {
	// Example GET route
	app.Get("/", controllers.TesterGet)

	// Events Router
	app.Post(("/api/events"))

	// Example POST route
	app.Post("/tester", controllers.CreateTester)
}
