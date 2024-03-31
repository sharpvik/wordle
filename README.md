# 5БУКВ

## Install

```bash
go install github.com/sharpvik/wordle
```

## Run

```bash
wordle  # displays some logs
```

Open [localhost:9090](http://localhost:9090) in your browser and play.

1. Input letters one by one (CTRL+A to select and replace as it won't allow you to type more than one letter)
2. Double-click to change letter state

   - Grey: absent
   - White: present but in a different spot
   - Yellow: correct letter in its exact place

3. Submit to get a list of words that match the parameters
4. Restart the game to drop history
