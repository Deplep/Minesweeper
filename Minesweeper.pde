import de.bezier.guido.*;
private static int NUM_ROWS = 20;
private static int NUM_COLS = 20;
private static int NUM_MINES = 40;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines; //ArrayList of just the minesweeper buttons that are mined
boolean isGameOver = false;

void setup ()
{
    size(400, 450);
    textAlign(CENTER,CENTER);
    // make the manager
    Interactive.make( this );
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int r = 0; r < NUM_ROWS; r++){
      for(int c = 0; c < NUM_COLS; c++){
        buttons[r][c] = new MSButton(r, c);
      }
    }
    setMines();
}
public void setMines()
{
  mines = new ArrayList(10);
  while(mines.size() < NUM_MINES){  
    int randomRow = (int)(Math.random()*20);
    int randomCol = (int)(Math.random()*20);
    if(mines.contains(buttons[randomRow][randomCol]) == false){
      mines.add(buttons[randomRow][randomCol]);
      //System.out.println(randomRow + ", " + randomCol);
    }
  }
}

public void draw ()
{
  background(200);
    if(isWon() == true){
        displayWinningMessage();
    } if (isGameOver == true){
      displayLosingMessage();
    }
}
public boolean isWon()
{
  for (int r = 0; r < NUM_ROWS; r++) {
    for (int c = 0; c < NUM_COLS; c++) {
      if (!mines.contains(buttons[r][c]) && !buttons[r][c].isClicked()) {
        return false;
      }
    }
  }
    return true;
}
public void displayLosingMessage()
{
    fill(255, 0, 0);
    textSize(20);
    text("You Lost :(", width / 2, height - 25);
    textSize(12);
    isGameOver = true;
    for (int r = 0; r < NUM_ROWS; r++) {
    for (int c = 0; c < NUM_COLS; c++) {
      if (mines.contains(buttons[r][c])) {
        buttons[r][c].setClicked(true);
      }
    }
  }
}
public void displayWinningMessage()
{
    fill(0, 225, 0);
    textSize(20);
    text("You Win!", width / 2, height - 25);
    textSize(12);
}
public boolean isValid(int r, int c)
{
    if (r>=0 && r<20 && c>=0 && c<20)
      return true;
    else
      return false;
}
public int countMines(int row, int col)
{
  int numMines = 0;
  if(isValid(row-1, col-1) && mines.contains(buttons[row - 1][col - 1])){
    numMines += 1;
  }
  if(isValid(row-1, col+1) && mines.contains(buttons[row - 1][col + 1])){
    numMines += 1;
  }
  if(isValid(row, col-1)&& mines.contains(buttons[row][col - 1])){
    numMines += 1;
  }
  if(isValid(row, col+1) && mines.contains(buttons[row][col + 1])){
    numMines += 1;
  }
  if(isValid(row+1, col-1) && mines.contains(buttons[row + 1][col - 1])){
    numMines += 1;
  }
  if(isValid(row+1, col) && mines.contains(buttons[row + 1][col])){
    numMines += 1;
  }
  if(isValid(row + 1, col+1) && mines.contains(buttons[row + 1][col + 1])){
    numMines += 1;
  }
  if(isValid(row-1, col) && mines.contains(buttons[row - 1][col])){
    numMines += 1;
  }
  return numMines;
}

public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
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
    public boolean isClicked(){
      return clicked;
    }
    public void setClicked(boolean clicked) {
        this.clicked = clicked;
    }
    // called by manager
    public void mousePressed (){
    clicked = true;
    if (mouseButton == RIGHT) {
        flagged = !flagged;
        if (!flagged) {
            clicked = false;
        }
        return;
    }
    if (mines.contains(this)) {
        displayLosingMessage();
        return;
    }
        if(countMines(myRow, myCol) > 0){
          setLabel(countMines(myRow, myCol));
        } else {
          //top left
            if(isValid(myRow-1, myCol-1) && buttons[myRow - 1][myCol - 1].isClicked() == false){
              buttons[myRow - 1][myCol - 1].mousePressed();
            }
            //top right
            if(isValid(myRow-1, myCol+1) && buttons[myRow - 1][myCol + 1].isClicked() == false){
              buttons[myRow - 1][myCol + 1].mousePressed();
            }
            //top middle
            if(isValid(myRow-1, myCol) && buttons[myRow - 1][myCol].isClicked() == false){
              buttons[myRow - 1][myCol].mousePressed();
            }
            //middle left
            if(isValid(myRow, myCol-1)&& buttons[myRow][myCol - 1].isClicked() == false){
              buttons[myRow][myCol - 1].mousePressed();
            }
            //middle right
            if(isValid(myRow, myCol+1) && buttons[myRow][myCol + 1].isClicked() == false){
              buttons[myRow][myCol + 1].mousePressed();
            }
            //middle bottom
            if(isValid(myRow+1, myCol) && buttons[myRow + 1][myCol].isClicked() == false){
              buttons[myRow + 1][myCol].mousePressed();
            }
            //bottom left
            if(isValid(myRow+1, myCol-1) && buttons[myRow + 1][myCol - 1].isClicked() == false){
              buttons[myRow + 1][myCol - 1].mousePressed();
            }
            //bottom right
            if(isValid(myRow + 1, myCol+1) && buttons[myRow + 1][myCol + 1].isClicked() == false){
              buttons[myRow + 1][myCol + 1].mousePressed();
            }

      }
    }
    public void draw ()
    {    
        if (flagged)
            fill(0);
        else if( clicked && mines.contains(this) )
             fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
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
