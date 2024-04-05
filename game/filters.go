package game

import (
	"github.com/bigmate/set"
	"github.com/bigmate/slice"
	"github.com/sharpvik/fungi"
)

func present(letter rune, count int) fungi.StreamIdentity[string] {
	return fungi.Filter(func(word string) bool {
		return countLetter(letter, word) == count
	})
}

func countLetter(letter rune, word string) int {
	return len(slice.Filter([]rune(word), func(r rune) bool { return r == letter }))
}

func atPosition(index int, s set.Set[rune]) fungi.StreamIdentity[string] {
	return fungi.Filter(func(word string) bool {
		return s.Has([]rune(word)[index])
	})
}
