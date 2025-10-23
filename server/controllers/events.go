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
	StartTime   string   `json:"startTime"`
	EndTime     string   `json:"endTime"`
	Address     string   `json:"address"`
	Lat         float64  `json:"lat"`
	Lng         float64  `json:"lng"` // access field | data type | FIELD to map from req body
}

type EventsBodyGet struct {
	Id          string             `json:"id"`
	UserId      string             `json:"userId"`
	Title       string             `json:"title"`
	Description string             `json:"description"`
	Tags        []string           `json:"tags"`
	Categories  []string           `json:"categories"`
	CreatedAt   pgtype.Timestamptz `json:"createdAt"`
	Interested  int32              `json:"interested"`
	Latitude    float64            `json:"latitude"`
	Longitude   float64            `json:"longitude"`
	Address     string             `json:"address"`
	StartTime   pgtype.Timestamptz `json:"startTime"`
	EndTime     pgtype.Timestamptz `json:"endTime"`
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
	fmt.Println("Post ev start: ", body.StartTime)

	// Insert into table
	_, err := database.Pool.Query(
		context.Background(),
		"INSERT INTO events (user_id, title, description, tags, categories, start_time, end_time, address, latitude, longitude) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)",
		body.UserId, body.Title, body.Description, body.Tags, body.Categories, body.StartTime, body.EndTime, body.Address, body.Lat, body.Lng,
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
	_, err := database.Pool.Query(
		context.Background(),
		`UPDATE events 
         SET title = $1, description = $2, tags = $3, categories = $4, latitude = $5, longitude = $6, address = $7, start_time = $8, end_time = $9
         WHERE id = $10`,
		body.Title, body.Description, body.Tags, body.Categories, body.Latitude, body.Longitude, body.Address, body.StartTime, body.EndTime, body.Id,
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
	fmt.Println("Get events preview...")

	rows, err := database.Pool.Query(
		context.Background(),
		"SELECT id, user_id, title, description, created_at, interested, latitude, longitude, start_time, end_time, tags, categories FROM events",
	)
	// check if there was error fetching data
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": "failed to fetch events",
		})
	} else {
		fmt.Println("Query no error...")
	}

	defer rows.Close()

	var events []EventsBodyGet

	fmt.Println("After Query, before scan")

	for rows.Next() {
		var ev EventsBodyGet
		var tags pgtype.Array[string]
		var categories pgtype.Array[string]
		if err := rows.Scan(
			&ev.Id,
			&ev.UserId,
			&ev.Title,
			&ev.Description,
			&ev.CreatedAt,
			&ev.Interested,
			&ev.Latitude,
			&ev.Longitude,
			&ev.StartTime,
			&ev.EndTime,
			&tags,
			&categories,
		); err != nil {
			// println("Get Events preview failure:", err.Error())
			// return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			// 	"error": "failed to scan row",
			// })
			fmt.Println("Skipping row:", err)
			continue
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
		fmt.Println("Event appended in Get")
		events = append(events, ev)
	}

	// check if rows are empty...
	// if len(events) == 0 {
	// 	return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
	// 		"error": "Event array is empty",
	// 	})
	// }

	fmt.Printf("event data: %+v\n", len(events))

	return c.JSON(events)
}
