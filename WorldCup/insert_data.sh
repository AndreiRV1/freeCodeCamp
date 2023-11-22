#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi
# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE games,teams")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS 
do
  if [[ YEAR -ne 'year' ]]
  then
    #search for team
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    if [[ -z $WINNER_ID ]]
    then
      #inset team if not found
      TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $TEAM_RESULT == "INSERT 0 1" ]]
      then
        echo INSERTED TEAM,$WINNER
        WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
      else
        echo WINNER NOT INSERTED
      fi
    fi
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    if [[ -z $OPPONENT_ID ]]
    then
      #inset team if not found
      TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $TEAM_RESULT == "INSERT 0 1" ]]
      then
        echo INSERTED TEAM,$OPPONENT
        OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
      else
        echo OPPONENT NOT INSERTED
      fi
    fi
    #insert data
    YEAR_ROUND_GOALS_RESULT=$($PSQL "INSERT INTO games(year,round,winner_goals,opponent_goals,winner_id,opponent_id) VALUES($YEAR,'$ROUND',$WINNER_GOALS,$OPPONENT_GOALS,$WINNER_ID,$OPPONENT_ID)")
    if [[ $YEAR_ROUND_GOALS_RESULT ]]
    then
      echo INSERTED GAME $YEAR $ROUND
    else
      echo ERROR GAME $YEAR $ROUND
    fi
  fi
done


