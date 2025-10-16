package controllers

import (
	"context"
	"fmt"

	"github.com/Debugger3000/Vivo/database"
	"github.com/gofiber/fiber/v2"
)


type CategoriesBody struct {
Categories []string `json:"categories"`
}



// POST /tester
func GetCategories(c *fiber.Ctx) error {
	// grab request body into variable
	var body CategoriesBody
	if err := c.BodyParser(&body); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "cannot parse JSON",
		})
	}

	// log the body
	fmt.Println("Grabbing categories controller...");

	// Insert into table
	_, err := database.Conn.Exec(
		context.Background(),
		"select name from categories",
	)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": "failed to grab categories data",
		})
	}

	return c.JSON(fiber.Map{
		"message": "Categories grabbed successfully",
	})
}