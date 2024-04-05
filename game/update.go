package game

import "github.com/bigmate/set"

func (g *Game) updateLetterSetsWithAttempt(attempt [5]Letter) [5]set.Set[rune] {
	ss := g.positions
	for i, letter := range attempt {
		switch letter.(type) {
		case ExactLetter:
			ss[i] = updateLetterSetWith(letter, ss[i])
		default:
			ss = g.updateLetterSets(letter)
		}
	}
	return ss
}

func (g *Game) updateLetterSets(letter Letter) [5]set.Set[rune] {
	ss := g.positions
	for i, s := range ss {
		ss[i] = updateLetterSetWith(letter, s)
	}
	return ss
}

func updateLetterSetWith(letter Letter, s set.Set[rune]) set.Set[rune] {
	switch r := letter.(type) {
	case AbsentLetter:
		if s.Len() > 1 {
			s.Del(rune(r))
		}
		return s
	case ExactLetter:
		ss := set.New[rune](1)
		ss.Add(rune(r))
		return ss
	default:
		return s
	}
}
