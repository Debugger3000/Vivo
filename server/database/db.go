package database

import (
	"context"
	"log"
	"os"

	//"time"

	"github.com/jackc/pgx/v5"
)

var Conn *pgx.Conn

// ConnectDB establishes the initial DB connection
func ConnectDB() {
	connect()
	//go startHealthCheck() // start background health check
}

func connect() {
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
	//log.Println("Postgres version:", version)
}

// health check
// // startHealthCheck pings the DB every 15 seconds
// func startHealthCheck() {
// 	ticker := time.NewTicker(60 * time.Second)
// 	defer ticker.Stop()

// 	for range ticker.C {
// 		if Conn == nil {
// 			log.Println("DB connection nil, reconnecting...")
// 			connect()
// 			continue
// 		}

// 		ctx, cancel := context.WithTimeout(context.Background(), 3*time.Second)
// 		defer cancel()

// 		var one int
// 		err := Conn.QueryRow(ctx, "SELECT 1").Scan(&one)
// 		if err != nil {
// 			log.Println("DB health check failed:", err)
// 			log.Println("Attempting to reconnect...")
// 			connect()
// 		} else {
// 			log.Println("DB is healthy ✅")
// 		}
// 	}
// }

// Close connection on shutdown
func CloseDB() {
	if Conn != nil {
		Conn.Close(context.Background())
	}
}
