package controllers

import (
	"context"
	"fmt"

	"github.com/Debugger3000/Vivo/database"
	"github.com/gofiber/fiber/v2"
	// "github.com/jackc/pgx/v5/pgtype"
)

// ----------------------------------------------

// General Events Grabbed on load... could be filtered via location distance, favourite categories, interested...
// Search Bar - grabs events based on search criteria : tags
// title - might be bad criteria as its not guaranteed to be fully descriptive

// ideally user would want to search things like a specific place like a restaurant, bar or anything like that
// username
// or a thing like darts
// tags

// -------
// Search Bar UI - if searches on client resemble categories, we can have dropdown of categories to click.
// grid - the fuck out of category icons for search bar dropdown... fck yeah

// big brain thought
// this app with 'promotions' can pop the fuck off.
// imagine various stores in barrie all having their current promotions for whatever products available all in one place.
// ---------
// Small stores - manual posting
// corporations - business account / promo link to company

// vibe of the app
// in the moment, whats live tonight, whats happening around me ?
	// Find places that have events happening or things going on (promotions: 2 for 1 pints, smash burger + fries for $5)
	// random live music, shows or whatever cool things the city has to offer. 
// largely for the man, small stores, individuals, or groups.
// ---
// Groups is key too. This needs to be fleshed out.
	// Get involved with your community, find people with common hobbies
	// communities on the app. That generally is supposed to be based upon person to person interaction


// events + groups

// ---------------------------------------------

type SearchBody struct {
	SearchBarData      string   `json:"searchBarData"`
}

// ---------------------------------------------------

// []string `json:"categories"`

// ideally, we could return event data.. via this same request
// Search Body Post --> Event Get

// POST /tester
func EventSearchBar(c *fiber.Ctx) error {
	// grab request body into variable
	var body EventsBody
	if err := c.BodyParser(&body); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "cannot parse JSON",
		})
	}

	// log the body
	fmt.Println("Search bar Post body: ", body)
	

	// Insert into table
	_, err := database.Pool.Query(
		context.Background(),
		"select * from events ",
	)
	if err != nil {
		fmt.Println(err)
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": "Failed to get event data on Search Bar.",
		})
	}




	fmt.Println("Event Get: ", )

	return c.JSON(fiber.Map{
		"message": "Events data inserted successfully",
	})
}


// POST /tester
func EventSearchBarCategorySelected(c *fiber.Ctx) error {
	// grab request body into variable
	var body EventsBody
	if err := c.BodyParser(&body); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "cannot parse JSON",
		})
	}

	// log the body
	fmt.Println("Search bar Post body: ", body)
	

	// Insert into table
	_, err := database.Pool.Query(
		context.Background(),
		"select * from events ",
	)
	if err != nil {
		fmt.Println(err)
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": "Failed to get event data on Search Bar.",
		})
	}




	fmt.Println("Event Get: ", )

	return c.JSON(fiber.Map{
		"message": "Events data inserted successfully",
	})
}
