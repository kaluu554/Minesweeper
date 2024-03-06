
private final static int NUM_ROWS = 16;
private final static int NUM_COLS = 16;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton> (); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
  size(400, 400);
  textAlign(CENTER, CENTER);

  // make the manager
  Interactive.make( this );

  buttons = new MSButton[NUM_ROWS][NUM_COLS];
  for (int r = 0; r<NUM_ROWS; r++) {
    for (int c=0; c<NUM_COLS; c++) {
      buttons[r][c] = new MSButton(r, c);
    }
  }

  setMines();
}
public void setMines()
{
  while (mines.size() < 25) {
    int r = (int)(Math.random()*NUM_ROWS);
    int c = (int)(Math.random()*NUM_COLS);
    if (!(mines.contains(buttons[r][c]))) {
      mines.add(buttons[r][c]);
      System.out.println(r + ", " + c);
    }
  }
}

public void draw ()
{
  background( 0 );
  if (isWon() == true) {
    for (int r = 0; r<NUM_ROWS; r++) {
      for (int c=0; c<NUM_COLS; c++) {
        buttons[r][c].flagged = false;
        buttons[r][c].clicked = true;
      }
    }
    displayWinningMessage();
  }
}
public boolean isWon()
{
  int count = 0;
  for (int r = 0; r<NUM_ROWS; r++) {
    for (int c=0; c<NUM_COLS; c++) {
      if (buttons[r][c].clicked == true && buttons[r][c].isFlagged() == false) {
        count++;
      }
    }
  }
  if (count == (NUM_ROWS*NUM_COLS - mines.size()) && !mines.contains(this)) {
    return true;
  }
  return false;
}
public void displayLosingMessage()
{
  for (int r = 0; r<NUM_ROWS; r++) {
    for (int c=0; c<NUM_COLS; c++) {
      buttons[r][c].flagged = false;
      buttons[r][c].clicked = true;
    }
  }
  buttons[5][4].setLabel("Y");
  buttons[5][5].setLabel("O");
  buttons[5][6].setLabel("U");
  buttons[5][8].setLabel(" ");
  buttons[5][9].setLabel("L");
  buttons[5][10].setLabel("O");
  buttons[5][11].setLabel("S");
  buttons[5][12].setLabel("E");
}
public void displayWinningMessage()
{
  buttons[5][4].setLabel("Y");
  buttons[5][5].setLabel("O");
  buttons[5][6].setLabel("U");
  buttons[5][8].setLabel(" ");
  buttons[5][9].setLabel("W");
  buttons[5][10].setLabel("I");
  buttons[5][11].setLabel("N");

}
public boolean isValid(int r, int c)
{
  if (r<NUM_ROWS && r>=0 && c<NUM_COLS && c>=0) {
    return true;
  } else {
    return false;
  }
}
public int countMines(int row, int col)
{
  int numMines = 0;
  for (int r = row-1; r <= row+1; r++) {
    for (int c = col-1; c<= col+1; c++) {
      if (!(r==row && c==col)) {
        if (isValid(r, c) && mines.contains(buttons[r][c])) {
          numMines++;
        }
      }
    }
  }
  return numMines;
}
public class MSButton
{
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean clicked, flagged;
  private String myLabel;

  public MSButton ( int row, int col )
  {
    width = 400/NUM_COLS;
    height = 400/NUM_ROWS;
    myRow = row;
    myCol = col; 
    x = myCol*width;
    y = myRow*height;
    myLabel = "";
    flagged = clicked = false;
    Interactive.add( this ); // register it with the manager
  }

  // called by manager
  public void mousePressed () 
  {
    clicked = true;

    if (mouseButton == RIGHT) {
      if (flagged  == true) {
        flagged = clicked = false;
      } else {
        flagged = true;
      }
    } else if(mouseButton == LEFT && flagged == true){
      
    }else if (mines.contains(this) && flagged == false) {
      displayLosingMessage();
    } else if (countMines(myRow, myCol) > 0) {
      if(flagged == false)
      setLabel(countMines(myRow, myCol));
    } else {
      //up
      if (isValid(myRow-1, myCol) && buttons[myRow-1][myCol].clicked == false ) {
        buttons[myRow-1][myCol].mousePressed();
      }
      //right 
      if (isValid(myRow, myCol+1) && buttons[myRow][myCol+1].clicked == false) {
        buttons[myRow][myCol+1].mousePressed();
      }
      //left 
      if (isValid(myRow, myCol-1) && buttons[myRow][myCol-1].clicked == false) {
        buttons[myRow][myCol-1].mousePressed();
      }
      //down left
      if (isValid(myRow+1, myCol-1) && buttons[myRow+1][myCol-1].clicked == false) {
        buttons[myRow+1][myCol-1].mousePressed();
      }
      //up  left
      if (isValid(myRow-1, myCol-1) && buttons[myRow-1][myCol-1].clicked == false) {
        buttons[myRow-1][myCol-1].mousePressed();
      }
      //down
      if (isValid(myRow+1, myCol) && buttons[myRow+1][myCol].clicked == false) {
        buttons[myRow+1][myCol].mousePressed();
      }
      //down right
      if (isValid(myRow+1, myCol+1) && buttons[myRow+1][myCol+1].clicked == false) {
        buttons[myRow+1][myCol+1].mousePressed();
      }

      //up right
      if (isValid(myRow-1, myCol+1) && buttons[myRow-1][myCol+1].clicked == false) {
        buttons[myRow-1][myCol+1].mousePressed();
      }
    }
  }

  public void draw () 
  {    
    if (flagged)
      fill(#38CE1B);
    else if ( clicked && mines.contains(this) ) 
      fill(255, 0, 0);
    else if (clicked)
      fill( 200 );
    else 
    fill( 100 );

    rect(x, y, width, height);
    fill(0);
    text(myLabel, x+width/2, y+height/2);
  }
  public void setLabel(String newLabel)
  {
    myLabel = newLabel;
  }
  public void setLabel(int newLabel)
  {
    myLabel = ""+ newLabel;
  }
  public boolean isFlagged()
  {
    return flagged;
  }
}
