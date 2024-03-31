package service

import (
	"io/fs"
	"log"
	"net/http"
	"wordle/game"

	"github.com/bigmate/slice"
	"github.com/labstack/echo/v4"
)

type Service struct {
	*game.Game
}

func New() *Service {
	return &Service{
		Game: game.New(),
	}
}

func (s *Service) Server(app fs.FS) *echo.Echo {
	e := echo.New()
	e.StaticFS("/", echo.MustSubFS(app, "app"))
	e.PATCH("/", s.update)
	e.DELETE("/", s.restart)
	return e
}

func (s *Service) restart(c echo.Context) error {
	s.Game = game.New()
	log.Println("GAME RESET")
	c.String(http.StatusOK, "GAME RESET")
	return nil
}

func (s *Service) update(c echo.Context) error {
	var payload Request

	if err := c.Bind(&payload); err != nil {
		log.Println(err)
		return c.String(http.StatusBadRequest, "FAILURE")
	}

	letters := slice.MapPtr(payload.Letters[:], makeLetter)
	log.Println("LETTERS THIS ROUND:", letters)
	if len(letters) != 5 {
		return c.String(http.StatusBadRequest, "NOT ENOUGH LETTERS")
	}

	words := s.Update([5]game.Letter(letters)).PossibleWords()
	return c.JSONPretty(http.StatusOK, words, "  ")
}

type Request struct {
	Letters [5]RequestLetter `json:"letters"`
}

type RequestLetter struct {
	Type string `json:"type"`
	Rune string `json:"rune"`
}

func makeLetter(letter *RequestLetter) game.Letter {
	switch r := []rune(letter.Rune)[0]; letter.Type {
	case "placed":
		return game.PlacedLetter(r)
	case "present":
		return game.PresentLetter(r)
	default:
		return game.AbsentLetter(r)
	}
}
