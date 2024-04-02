package game

import "fmt"

type Letter interface{}

type (
	AbsentLetter  rune
	PresentLetter rune
)

func (l AbsentLetter) String() string {
	return fmt.Sprintf("(X %c)", rune(l))
}

func (l PresentLetter) String() string {
	return fmt.Sprintf("(? %c)", rune(l))
}
