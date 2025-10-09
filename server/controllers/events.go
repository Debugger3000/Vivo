package controllers

import (
	"context"
	"fmt"

	"github.com/Debugger3000/Vivo/database"
	"github.com/gofiber/fiber/v2"
)


type EventsBody struct {
    ID          int    `json:"id"`
    UserId      int    `json:"user_id"`
    Title       string `json:"title"`
    Description string `json:"description"`
    Tags        string `json:"tags"`
    Categories  string `json:"categories"`
    Date        string `json:"date"`
    Interested  string `json:"interested"`
}



// POST /tester
func CreateEvent(c *fiber.Ctx) error {
	// grab request body into variable
	var body EventsBody
	if err := c.BodyParser(&body); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "cannot parse JSON",
		})
	}

	// log the body
	fmt.Println("Post Events body: ", body)    

	// Insert into table
	_, err := database.Conn.Exec(
		context.Background(),
		"INSERT INTO events (user_id, title, description, tags, categories, date, interested) VALUES ($1, $2, $3, $4, $5, $6, $7)",
		body.UserId, body.Title, body.Description, body.Tags, body.Categories, body.Date, body.Interested,
	)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": "failed to insert data",
		})
	}

	return c.JSON(fiber.Map{
		"message": "Events data inserted successfully",
	})
}