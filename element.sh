PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ATOMIC_NUMBER=$($PSQL "select atomic_number from elements where atomic_number=$1")
  else
    ATOMIC_NUMBER=$($PSQL "select atomic_number from elements where symbol='$1' or name='$1'")
  fi
  if [[ -z $ATOMIC_NUMBER ]]
  then 
    echo "I could not find that element in the database."
  else
    ELEMENT_ROW=$($PSQL "select * from elements where atomic_number=$ATOMIC_NUMBER")
    PROPERTY_ROW=$($PSQL "select type, atomic_mass, melting_point_celsius, boiling_point_celsius from properties inner join types using (type_id) where atomic_number=$ATOMIC_NUMBER")
    echo "$ELEMENT_ROW" | while IFS="|" read ATOMIC_NUMBER SYMBOL NAME
    do
      echo "$PROPERTY_ROW" | while IFS="|" read TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT
      do
        echo "The element with atomic number $ATOMIC_NUMBER is "$NAME" ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
      done
    done
  fi  
fi