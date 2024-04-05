package game

import (
	"fmt"

	"github.com/bigmate/slice"
)

type Letter interface{}

type (
	AbsentLetter  rune
	PresentLetter rune
	ExactLetter   rune
)

func (l AbsentLetter) String() string {
	return fmt.Sprintf("(X %c)", rune(l))
}

func (l PresentLetter) String() string {
	return fmt.Sprintf("(? %c)", rune(l))
}

func (l ExactLetter) String() string {
	return fmt.Sprintf("(! %c)", rune(l))
}

func presents(ls []Letter) []PresentLetter {
	return slice.Map(
		slice.Filter(ls, isPresentLetter),
		func(l Letter) PresentLetter { return l.(PresentLetter) },
	)
}

func isPresentLetter(l Letter) bool {
	switch l.(type) {
	case PresentLetter:
		return true
	default:
		return false
	}
}
