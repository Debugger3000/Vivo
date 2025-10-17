package controllers

import (
	"context"
	"fmt"

	"github.com/Debugger3000/Vivo/database"
	"github.com/gofiber/fiber/v2"
)


// json tags - only deals with how it appears in the response, NOTHING TO DO WITH DB MAPPING
// name - should map to exact COLUMN name
type CategoriesBody struct {
Name []string `json:"Name"`
}



// GET - Cateogories
func GetCategories(c *fiber.Ctx) error {
	
	// log the body
	fmt.Println("Grabbing categories controller...");

	// GET request - Database call line...
	rows, err := database.Conn.Query(context.Background(), "select name from categories")

	// if there is an error, err = nil
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": "failed to grab categories data",
		})
	}

	fmt.Println("after query grabbed");



	defer rows.Close()

	// Create a slice to hold all categories
	var categories []string

	// GOlang - uses this 
	for rows.Next() {
		var cat string
		if err := rows.Scan(&cat); err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
				"error": "failed to read category data",
			})
		}
		categories = append(categories, cat)
	}

	fmt.Println("Row data from GET categories returned: ", categories);

	// Handle any row iteration errors
	if rows.Err() != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": "error iterating over category rows",
		})
	}

	// Return the categories as JSON
	return c.Status(fiber.StatusOK).JSON(fiber.Map{
		"message":    "Categories grabbed successfully",
		"categories": categories,
	})
}