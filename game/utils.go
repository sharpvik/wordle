package game

import (
	_ "embed"
	"strings"

	"github.com/bigmate/set"
	"github.com/bigmate/slice"
	"github.com/sharpvik/fungi"
)

const russianLetters = "йцукенгшщзхъфывапролджэячсмитьбю"

var (
	//go:embed russian.utf.txt
	rawWords string
	allWords = strings.Split(rawWords, "\n")
	Words, _ = fungi.CollectSlice(fungi.Batch(length5, onlyLetters)(fungi.SliceStream(allWords)))

	length5 = fungi.Filter(func(s string) bool {
		return len([]rune(s)) == 5
	})
	onlyLetters = fungi.Filter(func(s string) bool {
		return slice.AllBool(slice.Map([]rune(s), letterSet().Has)...)
	})
)

func letterSet() set.Set[rune] {
	return set.FromSlice([]rune(russianLetters)...)
}

func If[T any](b bool, x, y T) T {
	if b {
		return x
	} else {
		return y
	}
}
