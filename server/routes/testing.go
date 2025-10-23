package routes

import (
	"github.com/Debugger3000/Vivo/controllers" // adjust to your module name in go.mod

	"github.com/gofiber/fiber/v2"
)

func SetupTesterRoutes(app *fiber.App) {

	// Events
	app.Delete("/api/events/:id", controllers.DeleteEvent)

	// Example GET route
	app.Get("/", controllers.TesterGet)

	// Events Router
	app.Post("/api/events", controllers.CreateEvent)

	// Categories
	app.Get("/api/categories", controllers.GetCategories)

	// Example POST route
	app.Post("/tester", controllers.CreateTester)

	// Events
	app.Get("/api/events-preview", controllers.GetEvents)
}
