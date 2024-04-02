package game

import (
	_ "embed"

	"github.com/sharpvik/fungi"
)

type Game struct {
	words []string
}

func New(words []string) *Game {
	return &Game{
		words: words,
	}
}

func (g *Game) Update(attempt [5]Letter) *Game {
	g.words = update(attempt, g.words)
	return g
}

func (g *Game) Words() []string {
	return g.words
}

func update(attempt [5]Letter, words []string) []string {
	stream := fungi.SliceStream(words)
	filtered, _ := fungi.CollectSlice(matching(attempt)(stream))
	return filtered
}

func matching(attempt [5]Letter) fungi.StreamIdentity[string] {
	var filters []fungi.StreamIdentity[string]
	for index, letter := range attempt {
		switch r := letter.(type) {
		case PresentLetter:
			filters = append(filters, atPosition(index, rune(r)))
		case AbsentLetter:
			filters = append(filters, notAtPosition(index, rune(r)))
		}
	}
	return fungi.Batch(filters...)
}
