package main

import (
	"context"
	"fmt"
	"net/http"
	"strconv"
	"time"

	"github.com/pwntester/go-twirp-rpc-example/rpc/notes"
	"github.com/twitchtv/twirp"
)

type notesService struct {
	Notes     []notes.Note
	CurrentId int32
}

func (s *notesService) CreateNote(ctx context.Context, params *notes.CreateNoteParams) (*notes.Note, error) { // test: routeHandler, request
	if len(params.Text) < 4 {
		return nil, twirp.InvalidArgument.Error("Text should be min 4 characters.")
	}

	note := notes.Note{
		Id:        s.CurrentId,
		Text:      params.Text,
		CreatedAt: time.Now().UnixMilli(),
	}

	notes.NewNotesServiceProtobufClient(params.Text, &http.Client{})                               // test: ssrfSink, ssrf
	notes.NewNotesServiceProtobufClient(strconv.FormatInt(int64(s.CurrentId), 10), &http.Client{}) // test: ssrfSink, !ssrf

	s.Notes = append(s.Notes, note)

	s.CurrentId++

	return &note, nil
}

func (s *notesService) GetAllNotes(ctx context.Context, params *notes.GetAllNotesParams) (*notes.GetAllNotesResult, error) { // test: routeHandler, request
	allNotes := make([]*notes.Note, 0)

	fmt.Println(params)
	for _, note := range s.Notes {
		n := note
		allNotes = append(allNotes, &n)
	}

	return &notes.GetAllNotesResult{
		Notes: allNotes,
	}, nil
}

func main() {
	notesServer := notes.NewNotesServiceServer(&notesService{})

	mux := http.NewServeMux()
	mux.Handle(notesServer.PathPrefix(), notesServer)

	err := http.ListenAndServe(":8000", notesServer) // test: !ssrfSink
	if err != nil {
		panic(err)
	}
}
