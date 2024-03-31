package main

import (
	"embed"
	"log"
	"wordle/service"

	"github.com/pkg/browser"
)

const (
	addr = "localhost:9090"
	url  = "http://" + addr
)

//go:embed app
var app embed.FS

func main() {
	browser.OpenURL(url)
	if err := service.New().Server(app).Start(addr); err != nil {
		log.Fatal(err)
	}
}
