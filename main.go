package main

import (
	"embed"
	"log"
	"os"
	"wordle/service"

	"github.com/pkg/browser"
	"github.com/urfave/cli/v2"
)

var (
	//go:embed app
	app embed.FS

	share = false
)

var CLI = cli.App{
	Name:  "wordle",
	Usage: "Russian wordle solver",
	Flags: []cli.Flag{
		&cli.BoolFlag{
			Name:        "share",
			Aliases:     []string{"s"},
			Usage:       "run this app publically",
			Destination: &share,
		},
	},
	Action: run,
}

func run(c *cli.Context) error {
	addr, url := web(share)
	browser.OpenURL(url)
	if err := service.New().Server(app).Start(addr); err != nil {
		return err
	}
	return nil
}

func web(share bool) (addr, url string) {
	if share {
		addr = "0.0.0.0:80"
	} else {
		addr = "127.0.0.1:9090"
	}
	url = "http://" + addr
	return
}

func main() {
	if err := CLI.Run(os.Args); err != nil {
		log.Fatal(err)
	}
}
