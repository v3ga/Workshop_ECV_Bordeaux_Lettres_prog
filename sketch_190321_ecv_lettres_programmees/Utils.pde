// ----------------------------------------------------------
String timestamp() 
{
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}

// ------------------------------------------------------
void initMedias()
{
  font15 = loadFont("fontes-controls/OpenSans-Regular-15.vlw");
  font30 = loadFont("fontes-controls/OpenSans-Regular-30.vlw");
  backgroundSVG = loadShape(backgroundFilename);
  motifSVG = loadShape(motifFilename);
}

// ------------------------------------------------------
void initLibraries()
{
  RG.init(this);
}

// ------------------------------------------------------
class Timer
{
  float now = 0;
  float before = 0;
  float dt = 0;

  Timer()
  {
    now = before = millis()/1000.0f;
  }

  float dt()
  {
    now = millis()/1000.0f;
    dt = now - before;
    before = now;
    return dt;
  }

}
