package main

import (
	"fmt"
	"log"
	"net/http"
)

func badExample() {
	fmt.Println("Vulnapp server listening : 1337")

	http.Handle("/assets/", http.StripPrefix("/assets/", http.FileServer(http.Dir("assets/"))))

	http.HandleFunc("/adminusers/", ShowAdminPageCache)
	err := http.ListenAndServe(":1337", nil)
	if err != nil {
		log.Fatal("ListenAndServe: ", err)
	}
}
