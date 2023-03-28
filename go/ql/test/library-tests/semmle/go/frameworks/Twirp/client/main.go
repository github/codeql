package main

import (
	"context"
	"log"
	"net/http"

	"github.com/pwntester/go-twirp-rpc-example/rpc/notes"
)

func main() {
	client := notes.NewNotesServiceProtobufClient("http://localhost:8000", &http.Client{}) // test: ssrfSink

	ctx := context.Background()

	_, err := client.CreateNote(ctx, &notes.CreateNoteParams{Text: "Hello World"})
	if err != nil {
		log.Fatal(err)
	}
	allNotes, err := client.GetAllNotes(ctx, &notes.GetAllNotesParams{})
	if err != nil {
		log.Fatal(err)
	}

	for _, note := range allNotes.Notes {
		log.Println(note)
	}
}
