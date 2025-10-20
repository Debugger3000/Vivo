package main

import (
	"fmt"
	"log"
	"os"

	"github.com/Debugger3000/Vivo/routes"

	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/cors"
	"github.com/gofiber/fiber/v2/middleware/logger"
	"github.com/joho/godotenv"

	"github.com/Debugger3000/Vivo/database"
)

func main() {
	// Load .env if present
	// _ is used to assign return value when you DONT CARE about the return... Make compiler happy...
	_ = godotenv.Load()

	// Create new Fiber app
	app := fiber.New()

	// Connect to database
	database.ConnectDB()
	defer database.CloseDB()

	// Middleware
	app.Use(logger.New()) // log requests
	app.Use(cors.New())   // allow cross-origin requests

	// Mount routes
	routes.SetupTesterRoutes(app)

	// Port from env or fallback
	port := os.Getenv("PORT")
	if port == "" {
		port = "3001"
	}

	// Listen on all interfaces
	addr := fmt.Sprintf("0.0.0.0:%s", port) // <-- change here
	log.Printf("🚀 Server running at http://0.0.0.0:%s", port)

	// addr := fmt.Sprintf(":%s", port)
	// log.Printf("🚀 Server running at http://localhost%s", addr)

	// Start server
	log.Fatal(app.Listen(addr))
}
