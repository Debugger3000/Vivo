package controllers

import (
	"context"
	"fmt"

	"github.com/Debugger3000/Vivo/database"
	"github.com/gofiber/fiber/v2"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgtype"
)

type Profile struct {
	Id               string             `json:"id"`
	Username         string             `json:"username"`
	Biography        string             `json:"biography"`
	Categories       []string           `json:"categories"`
	Email            string             `json:"email"`
	InterestedEvents []string           `json:"interestedEvents"`
	CreatedAt        pgtype.Timestamptz `json:"createdAt"` // Included for standard record keeping
}

// POST /api/events-interested-check
func CheckInterest(c *fiber.Ctx) error {
	type CheckRequest struct {
		EventId string `json:"eventId"`
		UserId  string `json:"userId"`
	}
	var req CheckRequest
	if err := c.BodyParser(&req); err != nil {
		// Return a message string to avoid Null pointer errors in Flutter
		return c.Status(400).JSON(fiber.Map{
			"message":      "Invalid request",
			"isInterested": false,
		})
	}

	var exists bool
	query := "SELECT EXISTS(SELECT 1 FROM profiles WHERE id = $1 AND $2 = ANY(interested_events))"

	err := database.Pool.QueryRow(context.Background(), query, req.UserId, req.EventId).Scan(&exists)

	fmt.Println("interest chek bool: ", exists)
	if err != nil {
		return c.Status(500).JSON(fiber.Map{
			"message":      "Database error",
			"isInterested": false,
		})
	}

	// Include "message" so the Flutter ResponseMessage.fromJson doesn't fail
	return c.JSON(fiber.Map{
		"message":      "Status fetched",
		"isInterested": exists, // This will now live inside the 'data' Map in Flutter
	})
}

func GetProfiles(c *fiber.Ctx) error {
	fmt.Println("Fetching profiles...")

	// get table rows from db
	rows, err := database.Pool.Query(
		context.Background(),
		"SELECT id, username, biography, categories, email, interested_events FROM profiles",
	)

	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": "failed to fetch profiles",
		})
	}
	defer rows.Close()

	var profiles []Profile

	for rows.Next() {
		var p Profile
		// Temporary pgtype holders for PostgreSQL arrays
		var categories pgtype.Array[string]
		var interestedEvents pgtype.Array[string]

		// scan into new var
		if err := rows.Scan(
			&p.Id,
			&p.Username,
			&p.Biography,
			&categories,
			&p.Email,
			&interestedEvents,
		); err != nil {
			fmt.Println("Skipping profile row error:", err)
			continue
		}

		// convert pgtype to string array
		p.Categories = make([]string, len(categories.Elements))
		for i, val := range categories.Elements {
			p.Categories[i] = val
		}

		// Convert interested_events pgtype.Array to []string
		p.InterestedEvents = make([]string, len(interestedEvents.Elements))
		for i, val := range interestedEvents.Elements {
			p.InterestedEvents[i] = val
		}

		profiles = append(profiles, p)
	}

	fmt.Printf("Profiles found: %d\n", len(profiles))
	return c.JSON(profiles)
}

func AddEventToProfileInterest(ctx context.Context, tx pgx.Tx, userId string, eventId string) error {
	// We use array_append to push the new eventId into the existing array
	// 'id = $2' ensures we only update the specific user
	_, err := tx.Exec(ctx,
		"UPDATE profiles SET interested_events = array_append(interested_events, $1) WHERE id = $2",
		eventId, userId,
	)
	return err
}

func RemoveEventFromProfileInterest(ctx context.Context, tx pgx.Tx, userId string, eventId string) error {
	// array_remove(column, element) removes all occurrences of that element
	_, err := tx.Exec(ctx,
		"UPDATE profiles SET interested_events = array_remove(interested_events, $1) WHERE id = $2",
		eventId, userId,
	)
	return err
}
