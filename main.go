package main

import (
	"embed"
	"log"
	"wordle/service"
)

//go:embed app/*
var app embed.FS

func main() {
	if err := service.New().Server(app).Start(":9090"); err != nil {
		log.Fatal(err)
	}
}
