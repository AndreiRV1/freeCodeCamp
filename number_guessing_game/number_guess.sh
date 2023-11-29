#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=number_guess --no-align --tuples-only -c"

NUMBER=$(( $RANDOM % 1000 + 1 ))
echo $NUMBER
echo Enter your username:
read NAME
PLAYER_ID=$($PSQL "SELECT player_id FROM players WHERE username='$NAME'")

if [[ -z $PLAYER_ID ]]
then
  echo Welcome, $NAME! It looks like this is your first time here.
  INSERT_RES=$($PSQL "INSERT INTO players(username) VALUES('$NAME');")
  PLAYER_ID=$($PSQL "SELECT player_id FROM players WHERE username='$NAME'")
else
  GAMES_PLAYED=$($PSQL "SELECT COUNT(*) FROM games WHERE player_id = $PLAYER_ID")
  BEST_GAME=$($PSQL "SELECT MIN(guesses) FROM games WHERE player_id = $PLAYER_ID")
  echo "Welcome back, $NAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi
GUESSES=0
echo Guess the secret number between 1 and 1000:
while [[ $CURRENT -ne $NUMBER ]]
do
  read CURRENT
  if [[ $CURRENT =~ ^[0-9]+$ ]]
  then
    GUESSES=$(( GUESSES+1))
    if (( CURRENT < NUMBER ))
    then 
      echo "It's higher than that, guess again:"
    elif (( CURRENT > NUMBER ))
    then
      echo "It's lower than that, guess again:"
    fi
  else
    echo "That is not an integer, guess again:"
  fi

done
  INSERT=$($PSQL "INSERT INTO games(guesses,player_id) VALUES($GUESSES,$PLAYER_ID);")
  echo You guessed it in $GUESSES tries. The secret number was $NUMBER. Nice job!
