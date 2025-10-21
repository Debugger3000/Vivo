package controllers

import (
	"context"
	"fmt"

	"github.com/Debugger3000/Vivo/database"
	"github.com/gofiber/fiber/v2"
	"github.com/jackc/pgx/v5/pgtype"
)

type EventsBody struct {
	UserId      string   `json:"userId"`
	Title       string   `json:"title"`
	Description string   `json:"description"`
	Tags        []string `json:"tags"`
	Categories  []string `json:"categories"`
	Date        string   `json:"date"`
	Address     string   `json:"address"`
	Lat         float64  `json:"lat"`
	Lng         float64  `json:"lng"`
}

type EventsBodyGet struct {
	Id          string             `json:"id"`
	UserId      string             `json:"userId"`
	Title       string             `json:"title"`
	Description string             `json:"description"`
	Tags        []string           `json:"tags"`
	Categories  []string           `json:"categories"`
	Date        pgtype.Timestamptz `json:"date"`
	Interested  int32              `json:"interested"`
	Latitude    float64            `json:"latitude"`
	Longitude   float64            `json:"longitude"`
}

// []string `json:"categories"`

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
		"INSERT INTO events (user_id, title, description, tags, categories, date, address, latitude, longitude) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)",
		body.UserId, body.Title, body.Description, body.Tags, body.Categories, body.Date, body.Address, body.Lat, body.Lng,
	)
	if err != nil {
		fmt.Println(err)
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": "failed to insert data",
		})
	}

	return c.JSON(fiber.Map{
		"message": "Events data inserted successfully",
	})
}

// -----------------------
// PATCH - Events
func EditEvent(c *fiber.Ctx) error {
	// grab request body into variable
	var body EventsBodyGet
	if err := c.BodyParser(&body); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "cannot parse JSON",
		})
	}

	// log the body
	fmt.Println("Edit Event body: ", body)

	// Make sure the body includes the event ID
	// if body.ID {
	//     return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
	//         "error": "missing event ID",
	//     })
	// }

	// Update the event record
	_, err := database.Conn.Exec(
		context.Background(),
		`UPDATE events 
         SET user_id = $1, title = $2, description = $3, tags = $4, categories = $5, date = $6,
         WHERE id = $8`,
		body.UserId, body.Title, body.Description, body.Tags, body.Categories, body.Date,
	)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": "failed to update event",
		})
	}

	return c.JSON(fiber.Map{
		"message": "Event updated successfully",
	})
}

// ----------------------
// GET - events
// POST /tester
func GetEvents(c *fiber.Ctx) error {
	
	rows, err := database.Conn.Query(
		context.Background(),
		"SELECT id, user_id, title, description, date, interested, latitude, longitude, tags, categories FROM events",
	)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": "failed to fetch events",
		})
	}
	defer rows.Close()

	var events []EventsBodyGet

	for rows.Next() {
		var ev EventsBodyGet
		var tags pgtype.Array[string]
		var categories pgtype.Array[string]
		if err := rows.Scan(
			&ev.Id,
			&ev.UserId,
			&ev.Title,
			&ev.Description,
			&ev.Date,
			&ev.Interested,
			&ev.Latitude,
			&ev.Longitude,
			&tags,
			&categories,
		); err != nil {
			println("Get Events preview failure:", err.Error())
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
				"error": "failed to scan row",
			})
		}

		// Convert to []string
		ev.Tags = make([]string, len(tags.Elements))
		for i, e := range tags.Elements {
			ev.Tags[i] = e
		}

		ev.Categories = make([]string, len(categories.Elements))
		for i, e := range categories.Elements {
			ev.Categories[i] = e
		}

		events = append(events, ev)
	}

	fmt.Printf("event data: %+v\n", events)

	return c.JSON(events)
}
