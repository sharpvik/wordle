package game

import "github.com/sharpvik/fungi"

func notAtPosition(index int, letter rune) fungi.StreamIdentity[string] {
	return fungi.Filter(func(word string) bool {
		return []rune(word)[index] != letter
	})
}

func atPosition(index int, letter rune) fungi.StreamIdentity[string] {
	return fungi.Filter(func(word string) bool {
		return []rune(word)[index] == letter
	})
}
