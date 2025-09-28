package controllers

import (
	"context"
	"fmt"

	"github.com/Debugger3000/Vivo/database"
	"github.com/gofiber/fiber/v2"
)

// Payload for incoming request
type TesterPayload struct {
	FirstName string `json:"first_name"`
	LastName  string `json:"last_name"`
	Color     string `json:"color"`
}

// POST /tester
func CreateTester(c *fiber.Ctx) error {
	// grab request body into variable
	var body TesterPayload
	if err := c.BodyParser(&body); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "cannot parse JSON",
		})
	}

	// log the body
	fmt.Println("Post Test body: ", body)    

	// Insert into table
	_, err := database.Conn.Exec(
		context.Background(),
		"INSERT INTO tester (first_name, last_name, color) VALUES ($1, $2, $3)",
		body.FirstName, body.LastName, body.Color,
	)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": "failed to insert data",
		})
	}

	return c.JSON(fiber.Map{
		"message": "data inserted successfully",
	})
}


// GET handler
func TesterGet(c *fiber.Ctx) error {
	return c.JSON(fiber.Map{
		"message": "Hello from Tester GET!",
	})
}
