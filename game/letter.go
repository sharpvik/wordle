package game

import (
	"fmt"
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
