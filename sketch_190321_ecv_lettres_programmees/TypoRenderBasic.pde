class TypoRenderBasic extends TypoRender
{
  // 0 : lines
  // 1 : circles
  // 2 : rectangles
  // 3 : custom
  int mode = 2;

  float size1      = 30;
  float size2      = 10;
  float angle      = 20;
  float angleStart = 0;
  float angleEnd   = 40;

  Slider sliderSize1, sliderSize2,sliderAngle;
  Toggle tgMotionSize1,tgMotionSize2,tgMotionAngle;
  DropdownList dlMode;
  
  boolean bMotionSize1 = false;
  boolean bMotionSize2 = false;
  boolean bMotionAngle = false;

  PVector pzero = new PVector();
  //  CallbackListener cbGrid

  // ----------------------------------------------------------
  TypoRenderBasic()
  {
    super();
    this.name = "typoRenderBasic";
  }

  // ----------------------------------------------------------
  void createControls(float x, float y)
  {
    super.createControls(x, y);

    sliderSize1 = cp5.addSlider("size1").setPosition(xc, yc).setSize(wControl, hControl).setRange(1, 200).setGroup(groupControls).setValue(size1).addCallback(this.cbControls);
    tgMotionSize1 = cp5.addToggle("tgSize1").setPosition(xc+sliderSize1.getWidth()+6*padding, yc).setLabel("").setSize(hControl, hControl).setValue(bMotionSize1).setGroup(groupControls).addCallback(this.cbControls);
    yc+=(hControl+padding);
    sliderSize2 = cp5.addSlider("size2").setPosition(xc, yc).setSize(wControl, hControl).setRange(1, 200).setGroup(groupControls).setValue(size2).addCallback(this.cbControls);
    tgMotionSize2 = cp5.addToggle("tgSize2").setPosition(xc+sliderSize2.getWidth()+6*padding, yc).setLabel("").setSize(hControl, hControl).setValue(bMotionSize2).setGroup(groupControls).addCallback(this.cbControls);
    yc+=(hControl+padding);
    sliderAngle = cp5.addSlider("angle").setPosition(xc, yc).setSize(wControl, hControl).setRange(0, 360).setGroup(groupControls).setValue(angle).addCallback(this.cbControls);
    tgMotionAngle = cp5.addToggle("tgAngle").setPosition(xc+sliderSize2.getWidth()+6*padding, yc).setLabel("").setSize(hControl, hControl).setValue(bMotionAngle).setGroup(groupControls).addCallback(this.cbControls);
    yc+=(hControl+padding);
  }

  // ----------------------------------------------------------
  void setMode( int mode_ )
  {
    this.mode = mode_;
    if (this.mode > 5 || mode < 0)
      this.mode = 0;
  }

  // ----------------------------------------------------------
  CallbackListener cbControls = new CallbackListener() 
  {
    public void controlEvent(CallbackEvent theEvent) 
    {
      String name = theEvent.getController().getName();
      float value = theEvent.getController().getValue();

      switch(theEvent.getAction()) 
      {
      case ControlP5.ACTION_BROADCAST:
        if (name.equals("size1")) 
          typoRenderBasic.size1 = value;
        if (name.equals("size2")) 
          typoRenderBasic.size2 = value;
        if (name.equals("angle")) 
          typoRenderBasic.angle = value;
        if (name.equals("tgSize1")) 
          typoRenderBasic.bMotionSize1 = value > 0;
        if (name.equals("tgSize2")) 
          typoRenderBasic.bMotionSize2 = value > 0;
        if (name.equals("tgAngle")) 
          typoRenderBasic.bMotionAngle = value > 0;
        break;

      case ControlP5.ACTION_RELEASED: 
      case ControlP5.ACTION_RELEASEDOUTSIDE: 
        break;
      }
    }
  };

  // ----------------------------------------------------------
  PVector getDisplacement(int iShape, int iPoint)
  {
    if (this.rndDisplacements != null && !isComputing)
      return this.rndDisplacements[iShape][iPoint];
    return pzero;
  }

  // ----------------------------------------------------------
  void drawMode()
  {
    int modeUser = mode+1;
    pushStyle();
    noStroke();
    fill(0);
    text(fontFilename+"\nmode "+modeUser+" / "+getModeString(), 5, 15);
    popStyle();
  }

  // ----------------------------------------------------------
  String getModeString()
  {
    if (mode == 0) return "lignes";
    else if (mode == 1) return "cercles";
    else if (mode == 2) return "rectangles";
    else if (mode == 3) return "motif SVG (fichier "+motifFilename+")";
    else if (mode == 4) return "custom (fonction drawCustom())";
    return "???";
  }

  // ----------------------------------------------------------
  float getValue(int indexPoint, int nbPoints, float value)
  {
    if (isMotion)
    {
      float t = float(indexPoint) / float(nbPoints-1);
      return getMotionValue(t,value);
    }
    
    return value;
  }

  // ----------------------------------------------------------
  void drawShapes(int nCalque)
  {
    if (tm == null) return;
    if (isComputing) return;
    PVector[][] ptPerShapes = tm.listePointsShape;
    PVector p, displacement;
    int i, j;
    pushStyle();
    rectMode(CENTER);
    noFill();
    stroke(colorLines);

    float angleRad = radians(angle);
    float size1_2 = 0;
    if (mode == 0)
    {
      for (i=0; i<ptPerShapes.length; i++)
      {
        for (j=0; j<ptPerShapes[i].length; j++)
        {
          p = ptPerShapes[i][j];
          displacement = getDisplacement(i, j);
          if (displacement != null)
          {
            size1_2 = ( bMotionSize1 ? getValue(j,ptPerShapes[i].length,size1) : size1)/2.0;
            pushMatrix();
            translate(p.x+displacement.x, p.y+displacement.y);
            rotate(bMotionAngle ? getValue(j,ptPerShapes[i].length,angleRad) : angleRad);
            line(-size1_2, 0, size1_2, 0);
            popMatrix();
          }
        }
      }
    } else if (mode == 1)
    {
      float size1_motion = 0;
      for (i=0; i<ptPerShapes.length; i++)
      {
        for (j=0; j<ptPerShapes[i].length; j++)
        {
          displacement = getDisplacement(i, j);
          if (displacement != null)
          {
            p = ptPerShapes[i][j];
            size1_motion = bMotionSize1 ? getValue(j,ptPerShapes[i].length,size1) : size1;
            ellipse(p.x+displacement.x, p.y+displacement.y, size1_motion, size1_motion);
          }
        }
      }
    } else if (mode == 2)
    {
      for (i=0; i<ptPerShapes.length; i++)
      {
        for (j=0; j<ptPerShapes[i].length; j++)
        {
          displacement = getDisplacement(i, j);
          if (displacement != null)
          {
            p = ptPerShapes[i][j];
            pushMatrix();
            translate(p.x+displacement.x, p.y+displacement.y);
            rotate(bMotionAngle ? getValue(j,ptPerShapes[i].length,angleRad) : angleRad);
            rect(0, 0, bMotionSize1 ? getValue(j,ptPerShapes[i].length,size1) : size1, bMotionSize2 ? getValue(j,ptPerShapes[i].length,size2) : size2);
            popMatrix();
          }
        }
      }
    } else if (mode == 3)
    {
      float size=1;
      if (motifSVG != null)
        for (i=0; i<ptPerShapes.length; i++)
        {
          for (j=0; j<ptPerShapes[i].length; j++)
          {
            p = ptPerShapes[i][j];
            displacement = getDisplacement(i, j);
            if (displacement != null)
            {
              pushMatrix();
              translate(p.x+displacement.x, p.y+displacement.y);
              rotate(bMotionAngle ? getValue(j,ptPerShapes[i].length,angleRad) : angleRad);
              shapeMode(CENTER);
              size = bMotionSize1 ? getValue(j,ptPerShapes[i].length,size1) : size1;
              shape(motifSVG, 0, 0, size, size);
              popMatrix();
            }
          }
        }
    } else if (mode == 4)
    {
      for (i=0; i<ptPerShapes.length; i++)
      {
        for (j=0; j<ptPerShapes[i].length; j++)
        {
          displacement = getDisplacement(i, j);
          if (displacement != null)
          {
            p = ptPerShapes[i][j];
            pushMatrix();
            translate(p.x+displacement.x, p.y+displacement.y);
              rotate(bMotionAngle ? getValue(j,ptPerShapes[i].length,angleRad) : angleRad);
            drawCustom(nCalque, j, ptPerShapes[i].length);
            popMatrix();
          }
        }
      }
    }
    popStyle();
  }
}
