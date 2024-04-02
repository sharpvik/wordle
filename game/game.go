package game

import (
	_ "embed"

	"github.com/bigmate/set"
	"github.com/bigmate/slice"
	"github.com/sharpvik/fungi"
)

const allRussianLetters = "йцукенгшщзхъфывапролджэячсмитьбю"

type Game struct {
	alphabet set.Set[rune]
	present  []rune
	placed   map[int]rune
}

func New() *Game {
	return &Game{
		alphabet: runeSet(allRussianLetters),
		placed:   make(map[int]rune),
	}
}

func (g *Game) Update(attempt [5]Letter) *Game {
	for index, letter := range attempt {
		switch r := letter.(type) {
		case PresentLetter:
			g.addPresent(rune(r))
		case AbsentLetter:
			g.removeAbsent(rune(r))
		case PlacedLetter:
			g.addPlaced(index, rune(r))
		}
	}
	return g
}

func (g *Game) PossibleWords() []string {
	ws, _ := fungi.CollectSlice(g.possibleWords())
	if ws == nil {
		return []string{}
	}
	return ws
}

func (g *Game) addPresent(r rune) {
	g.present = append(g.present, r)
}

func (g *Game) removeAbsent(r rune) {
	g.alphabet.Del(r)
}

func (g *Game) addPlaced(index int, letter rune) {
	g.placed[index] = letter
}

func (g *Game) possibleWords() fungi.Stream[string] {
	stream := fungi.SliceStream(lines)
	matching := g.matching()
	return matching(length5(stream))
}

func (g *Game) matching() fungi.StreamIdentity[string] {
	return fungi.Batch(g.byAlpha(), g.byPlaced(), g.byPresent())
}

func (g *Game) byAlpha() fungi.StreamIdentity[string] {
	return fungi.Filter(func(s string) bool {
		return slice.AllBool(slice.Map([]rune(s), g.alphabet.Has)...)
	})
}

func (g *Game) byPresent() fungi.StreamIdentity[string] {
	return fungi.Filter(func(s string) bool {
		rs := runeSet(s)
		return slice.AllBool(slice.Map(g.present, func(r rune) bool {
			return rs.Has(r)
		})...)
	})
}

func (g *Game) byPlaced() fungi.StreamIdentity[string] {
	return fungi.Filter(func(s string) bool {
		rs := []rune(s)
		for index, expect := range g.placed {
			if rs[index] != expect {
				return false
			}
		}
		return true
	})
}
