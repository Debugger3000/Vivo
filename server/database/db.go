package database

import (
	"context"
	"log"
	"os"

	"github.com/jackc/pgx/v5"
)

var Conn *pgx.Conn

func ConnectDB() {
	conn, err := pgx.Connect(context.Background(), os.Getenv("DATABASE_URL"))
	if err != nil {
		log.Fatalf("Failed to connect to the database: %v", err)
	}

	Conn = conn
	log.Println("✅ Database connection established")

	// Optional test query
	var version string
	if err := Conn.QueryRow(context.Background(), "SELECT version()").Scan(&version); err != nil {
		log.Fatalf("Query failed: %v", err)
	}
	log.Println("Postgres version:", version)
}

// Close connection on shutdown
func CloseDB() {
	if Conn != nil {
		Conn.Close(context.Background())
	}
}
