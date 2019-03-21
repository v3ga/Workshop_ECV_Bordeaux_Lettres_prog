// ----------------------------------------------------------
void createControls()
{
  cf = new ControlFrame(this, 500, 500, "Controls");
}

// ----------------------------------------------------------
void customizeDropdown(DropdownList dl)
{
  dl.setItemHeight(20);
  dl.setBarHeight(20);
}

// ----------------------------------------------------------
class ControlFrame extends PApplet 
{
  PApplet parent;
  int w, h;
  ControlP5 cp5;
  Group groupMain;
  DropdownList dlRenderers;

  // ----------------------------------------------------------
  public ControlFrame(PApplet _parent, int _w, int _h, String _name) 
  {
    super();   
    parent = _parent;
    w=_w;
    h=_h;

    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }

  // ----------------------------------------------------------
  public void settings() 
  {
    size(w, 500);
  }

  // ----------------------------------------------------------
  public void setup() 
  {
    surface.setLocation(0, 10);
    //    cp5 = new ControlP5(this, new ControlFont(font15, 13));
    cp5 = new ControlP5(this);

    int wControl = 300;
    int hControl = 20;
    int padding = 10;
    int x = 5;
    int y = 10;

    //    groupMain = cp5.addGroup("Globals").setBackgroundHeight(400).setWidth(330).setBackgroundColor(color(0, 190)).setPosition(5, 15);


    dlRenderers = cp5.addDropdownList("dlRenderers").setPosition(x/2+padding, y).setWidth(wControl/2-padding).setLabel("types de rendu");
    customizeDropdown(dlRenderers);
    dlRenderers.addItem("formes basiques", 0);
//    dlRenderers.addItem("physique", 1);
    dlRenderers.close();

    cp5.addButton("btnExport")
      .setLabel("Exporter en SVG")
      .setPosition(dlRenderers.getPosition()[0] + dlRenderers.getWidth() + padding, y)
      .setSize(150, hControl);

    y += (2*hControl+padding);

    for (TypoRender tr : typoRenderers) 
      tr.createControls(x/2+padding,y);

    dlRenderers.bringToFront();
    showControlsFor(typoRenderCurrent);
  }

  // ----------------------------------------------------------
  public void draw() 
  {
    background(0);
  }

  // ----------------------------------------------------------
  void showControlsFor(TypoRender tr)
  {
    for (TypoRender tr_ : typoRenderers) 
      tr_.hideControls();
    tr.showControls();
  }
  
  // ----------------------------------------------------------
  void controlEvent(ControlEvent event)
  {
    String name = event.getController().getName();
    float value = event.getController().getValue();
    if (event.isController())
    {
      if (name.equals("dlRenderers"))
      {
        int whichRenderer = int(event.getValue());
        typoRenderCurrent = typoRenderers.get(whichRenderer);
        showControlsFor(typoRenderCurrent);
    
      }
    }
  }

  // ----------------------------------------------------------
  void btnExport()
  {
    bExportSVG = true;
  }
}
