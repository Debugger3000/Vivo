package controllers

import (
	"context"
	"fmt"

	"github.com/Debugger3000/Vivo/database"
	"github.com/gofiber/fiber/v2"
	"github.com/jackc/pgx/v5/pgtype"
	// "github.com/jackc/pgx/v5/pgtype"
)

// ----------------------------------------------

func EventSearch(c *fiber.Ctx) error {
	// Get query parameters from the URL
	title := c.Query("title")
	category := c.Query("categories")

	// Base SQL
	query := "SELECT id, user_id, title, description, created_at, interested, latitude, longitude, start_time, end_time, tags, categories, address, event_image FROM events WHERE 1=1"
	var args []interface{}
	argCount := 1

	// 1. Add Title Filter (ILIKE for case-insensitive partial match)
	if title != "" {
		query += fmt.Sprintf(" AND title ILIKE $%d", argCount)
		args = append(args, "%"+title+"%")
		argCount++
	}

	// 2. Add Category Filter (Checks if string exists in the Postgres array)
	if category != "" {
		query += fmt.Sprintf(" AND $%d = ANY(categories)", argCount)
		args = append(args, category)
		argCount++
	}

	// Execute Query
	rows, err := database.Pool.Query(context.Background(), query, args...)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": "Query failed"})
	}
	defer rows.Close()

	var events []EventsBodyGet
	for rows.Next() {
		var ev EventsBodyGet
		var tags pgtype.Array[string]
		var categories pgtype.Array[string]

		err := rows.Scan(
			&ev.Id, &ev.UserId, &ev.Title, &ev.Description, &ev.CreatedAt,
			&ev.Interested, &ev.Latitude, &ev.Longitude, &ev.StartTime,
			&ev.EndTime, &tags, &categories, &ev.Address, &ev.EventImage,
		)
		if err != nil {
			continue
		}

		// Helper to convert pgtype to slices
		ev.Tags = flattenPgArray(tags)
		ev.Categories = flattenPgArray(categories)
		events = append(events, ev)
	}

	return c.JSON(events)
}

// Helper to clean up your scanner code
func flattenPgArray(arr pgtype.Array[string]) []string {
	res := make([]string, len(arr.Elements))
	for i, e := range arr.Elements {
		res[i] = e
	}
	return res
}
