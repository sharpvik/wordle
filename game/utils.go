package game

import (
	_ "embed"
	"strings"

	"github.com/bigmate/set"
	"github.com/sharpvik/fungi"
)

var (
	//go:embed russian.utf.txt
	allWords string
	lines    = strings.Split(allWords, "\n")

	length5 = fungi.Filter(func(s string) bool { return len([]rune(s)) == 5 })
)

func runeSet(s string) (alpha set.Set[rune]) {
	letters := []rune(s)
	alpha = set.New[rune](len(letters))
	for _, letter := range letters {
		alpha.Add(letter)
	}
	return
}
