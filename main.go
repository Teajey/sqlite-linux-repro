package main

import (
	"database/sql"
	"log"

	_ "github.com/mattn/go-sqlite3"
)

func main() {
	log.Println("Started!")
	database, err := sql.Open("sqlite3", "./test.db")
	if err != nil {
		log.Println("Failed to open db")
		log.Fatal(err)
		return
	}
	log.Println("Successfully opened db")
	_, err = database.Exec(`BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS "user" (
	"id"	INTEGER NOT NULL UNIQUE,
	"name"	TEXT NOT NULL UNIQUE,
	PRIMARY KEY("id" AUTOINCREMENT)
);
COMMIT;
`)
	if err != nil {
		log.Println("Failed to init db")
		log.Fatal(err)
	}
	log.Println("Successfully init db!")
}
