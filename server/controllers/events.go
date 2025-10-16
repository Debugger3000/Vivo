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
    Tags        []string `json:"tags"`
    Categories  []string `json:"categories"`
    Date        string `json:"date"`
    Interested  string `json:"interested"`
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


// -----------------------
// PATCH - Events
// 
func EditEvent(c *fiber.Ctx) error {
    // grab request body into variable
    var body EventsBody
    if err := c.BodyParser(&body); err != nil {
        return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
            "error": "cannot parse JSON",
        })
    }

    // log the body
    fmt.Println("Edit Event body: ", body)

    // Make sure the body includes the event ID
    if body.ID == 0 {
        return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
            "error": "missing event ID",
        })
    }

    // Update the event record
    _, err := database.Conn.Exec(
        context.Background(),
        `UPDATE events 
         SET user_id = $1, title = $2, description = $3, tags = $4, categories = $5, date = $6, interested = $7
         WHERE id = $8`,
        body.UserId, body.Title, body.Description, body.Tags, body.Categories, body.Date, body.Interested, body.ID,
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
        "SELECT id, user_id, title, description, tags, categories, date, interested FROM events",
    )
    if err != nil {
        return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
            "error": "failed to fetch events",
        })
    }
    defer rows.Close()

    var events []EventsBody

    for rows.Next() {
        var ev EventsBody
        if err := rows.Scan(
            &ev.ID,
            &ev.UserId,
            &ev.Title,
            &ev.Description,
            &ev.Tags,
            &ev.Categories,
            &ev.Date,
            &ev.Interested,
        ); err != nil {
            return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
                "error": "failed to scan row",
            })
        }
        events = append(events, ev)
    }

	println("event data: ", events);

    return c.JSON(events)
}
