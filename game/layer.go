package game

func layer(m1, m2 map[rune]int) map[rune]int {
	for k2, v2 := range m2 {
		v1, exists := m1[k2]
		if !exists {
			m1[k2] = v2
		} else if v2 > v1 {
			m1[k2] = v2
		}
	}
	return m1
}
