package game

import (
	_ "embed"

	"github.com/bigmate/set"
	"github.com/sharpvik/fungi"
)

type Game struct {
	words     []string
	positions [5]set.Set[rune]
	has       map[rune]int
}

func New(words []string) *Game {
	return &Game{
		words: words,
		positions: [5]set.Set[rune]{
			letterSet(),
			letterSet(),
			letterSet(),
			letterSet(),
			letterSet(),
		},
		has: make(map[rune]int),
	}
}

func (g *Game) Update(attempt [5]Letter) *Game {
	return g.update(attempt).filter()
}

func (g *Game) Words() []string {
	return g.words
}

func (g *Game) filter() *Game {
	stream := fungi.SliceStream(g.words)
	filters := fungi.Batch(g.filterAtPosition(), g.filterMustHave())
	g.words, _ = fungi.CollectSlice(filters(stream))
	return g
}

func (g *Game) update(attempt [5]Letter) *Game {
	has := make(map[rune]int)
	for i, letter := range attempt {
		switch l := letter.(type) {
		case ExactLetter:
			has[rune(l)]++
			g.atPosition(i, rune(l))
		case PresentLetter:
			has[rune(l)]++
			g.notAtPosition(i, rune(l))
		case AbsentLetter:
			r := rune(l)
			_, ok1 := has[r]
			_, ok2 := g.has[r]
			if ok1 || ok2 {
				g.notAtPosition(i, r)
			} else {
				g.notInWord(r)
			}
		}
	}
	layer(g.has, has)
	return g
}

func (g *Game) atPosition(i int, r rune) {
	g.positions[i] = set.FromSlice(r)
}

func (g *Game) notInWord(r rune) {
	for _, position := range g.positions {
		position.Del(r)
	}
}

func (g *Game) notAtPosition(i int, r rune) {
	g.positions[i].Del(r)
}

func (g *Game) filterMustHave() fungi.StreamIdentity[string] {
	var filters []fungi.StreamIdentity[string]
	for letter, count := range g.has {
		filters = append(filters, present(letter, count))
	}
	return fungi.Batch(filters...)
}

func (g *Game) filterAtPosition() fungi.StreamIdentity[string] {
	var filters []fungi.StreamIdentity[string]
	for i, s := range g.positions {
		filters = append(filters, atPosition(i, s))
	}
	return fungi.Batch(filters...)
}
