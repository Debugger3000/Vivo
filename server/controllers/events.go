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
	EventImage  string   `json:"eventImage"`
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
	EventImage  string             `json:"eventImage"`
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
		"INSERT INTO events (user_id, title, description, tags, categories, start_time, end_time, address, latitude, longitude, event_image) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)",
		body.UserId, body.Title, body.Description, body.Tags, body.Categories, body.StartTime, body.EndTime, body.Address, body.Lat, body.Lng, body.EventImage,
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
		"SELECT id, user_id, title, description, created_at, interested, latitude, longitude, start_time, end_time, tags, categories, address, event_image FROM events",
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
			&ev.Address,
			&ev.EventImage,
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

	fmt.Printf("events length: %+v\n", len(events))
	fmt.Printf("event data: %+v\n", events)

	return c.JSON(events)
}

// DELETE /api/events/:id
func DeleteEvent(c *fiber.Ctx) error {
	// Grab the event ID from the route parameter
	eventID := c.Params("id")
	if eventID == "" {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "missing event ID",
		})
	}

	// Execute the delete query
	commandTag, err := database.Pool.Exec(
		context.Background(),
		"DELETE FROM events WHERE id = $1",
		eventID,
	)
	if err != nil {
		fmt.Println("Delete error:", err)
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": "failed to delete event",
		})
	}

	if commandTag.RowsAffected() == 0 {
		return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
			"error": "event not found",
		})
	}

	return c.JSON(fiber.Map{
		"message": "Event deleted successfully",
		"id":      eventID,
	})
}

// interested in events
// POST /api/events-interested
func ToggleInterest(c *fiber.Ctx) error {
	//  Parse the body (matches your Flutter request)
	type InterestRequest struct {
		EventId string `json:"eventId"`
		UserId  string `json:"userId"`
	}

	var req InterestRequest
	if err := c.BodyParser(&req); err != nil {
		return c.Status(400).JSON(fiber.Map{"error": "Invalid request body"})
	}

	//  Start a transaction
	ctx := context.Background()
	tx, err := database.Pool.Begin(ctx)
	if err != nil {
		return c.Status(500).JSON(fiber.Map{"error": "Transaction failed"})
	}
	// Rollback if we don't commit
	defer tx.Rollback(ctx)

	// First DB Call
	// Increment the interested count in 'events' table
	_, err = tx.Exec(ctx,
		"UPDATE events SET interested = interested + 1 WHERE id = $1",
		req.EventId,
	)
	if err != nil {
		return c.Status(500).JSON(fiber.Map{"error": "Failed to update event count"})
	}

	// Second DB call
	// Add to profile's interested_events list using helper
	if err := AddEventToProfileInterest(ctx, tx, req.UserId, req.EventId); err != nil {
		fmt.Println("Profile update error:", err)
		return c.Status(500).JSON(fiber.Map{"error": "Failed to update profile"})
	}

	//  Commit the transaction
	if err := tx.Commit(ctx); err != nil {
		return c.Status(500).JSON(fiber.Map{"error": "Failed to save changes"})
	}

	return c.JSON(fiber.Map{
		"success": true,
		"message": "Interest registered successfully",
	})
}

// POST /api/events-uninterested
func UntoggleInterest(c *fiber.Ctx) error {
	type InterestRequest struct {
		EventId string `json:"eventId"`
		UserId  string `json:"userId"`
	}

	var req InterestRequest
	if err := c.BodyParser(&req); err != nil {
		return c.Status(400).JSON(fiber.Map{"error": "Invalid request body"})
	}

	ctx := context.Background()
	tx, err := database.Pool.Begin(ctx)
	if err != nil {
		return c.Status(500).JSON(fiber.Map{"error": "Transaction failed"})
	}
	defer tx.Rollback(ctx)

	// Decrement the interested count (ensure it doesn't go below 0 if you want)
	_, err = tx.Exec(ctx,
		"UPDATE events SET interested = GREATEST(0, interested - 1) WHERE id = $1",
		req.EventId,
	)
	if err != nil {
		return c.Status(500).JSON(fiber.Map{"error": "Failed to update event count"})
	}

	// 2. Remove from profile's interested_events list using the new helper
	if err := RemoveEventFromProfileInterest(ctx, tx, req.UserId, req.EventId); err != nil {
		return c.Status(500).JSON(fiber.Map{"error": "Failed to update profile"})
	}

	if err := tx.Commit(ctx); err != nil {
		return c.Status(500).JSON(fiber.Map{"error": "Failed to save changes"})
	}

	return c.JSON(fiber.Map{
		"success": true,
		"message": "Interest removed successfully",
	})
}

// -----------

// Get events user has flagged as interested
func GetUserInterestedEvents(c *fiber.Ctx) error {
	userId := c.Query("userId")
	if userId == "" {
		return c.Status(400).JSON(fiber.Map{"error": "userId is required"})
	}

	// This SQL query selects events where the event ID is found
	// inside the interested_events array of the specific user
	query := `
        SELECT id, user_id, title, description, created_at, interested, 
               latitude, longitude, start_time, end_time, tags, 
               categories, address, event_image 
        FROM events 
        WHERE id = ANY(
            SELECT unnest(interested_events) 
            FROM profiles 
            WHERE id = $1
        )`

	rows, err := database.Pool.Query(context.Background(), query, userId)
	if err != nil {
		return c.Status(500).JSON(fiber.Map{"error": "failed to fetch events"})
	}
	defer rows.Close()

	var events []EventsBodyGet
	for rows.Next() {
		var ev EventsBodyGet
		var tags, categories pgtype.Array[string]

		err := rows.Scan(
			&ev.Id, &ev.UserId, &ev.Title, &ev.Description, &ev.CreatedAt,
			&ev.Interested, &ev.Latitude, &ev.Longitude, &ev.StartTime,
			&ev.EndTime, &tags, &categories, &ev.Address, &ev.EventImage,
		)
		if err != nil {
			continue
		}

		// Use the logic from your previous GetEvents to convert pgtype arrays
		ev.Tags = tags.Elements
		ev.Categories = categories.Elements
		events = append(events, ev)
	}

	return c.JSON(events)
}
