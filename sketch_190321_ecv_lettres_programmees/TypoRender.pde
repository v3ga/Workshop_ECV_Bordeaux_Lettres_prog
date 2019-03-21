class TypoRender
{
  TypoManager tm;
  String name = "";
  String fontName = "";
  String text = "";
  float segmentLength = 10;

  boolean bDrawPoints = false;
  boolean bDrawShape = false;

  float randomDisplacement = 10.0;
  PVector[][] rndDisplacements;

  int nbCalques = 1;
  float angleCalques = 0;
  float xOffsetCalques = 0;
  float yOffsetCalques = 0;
  float scaleCalques = 1;

  ControlP5 cp5;
  Group groupControls;
  Slider sliderSegmentsLength;
  Slider sliderNbCalques, sliderAngleCalques, sliderScaleCalques;
  Slider sliderXOffsetCalques, sliderYOffsetCalques;
  Slider sliderDisplacement;

  Slider sliderMotionSine_angleSpeed;
  Slider sliderMotionSine_factor;
  Slider sliderMotionSine_freq;

  int xc = 0;
  int yc = 10;
  int wControl = 300;
  int hControl = 20;
  int padding = 10;

  boolean isComputing = false;
  boolean isMotion = true;

  // Motion
  float motionSine_angle = 0.0;
  float motionSine_angleSpeed = 180.0;
  float motionSine_factor = 0.2;
  float motionSine_freq = 8.0;

  TypoRender()
  {
  }

  void createControls(float x, float y)
  {
    cp5 = cf.cp5;
    groupControls = cp5.addGroup("group"+this.name).setBackgroundHeight(300).setWidth(wControl).setHeight(hControl).setPosition(x, y);
    sliderSegmentsLength = cp5.addSlider(this.name+"_segmentLength").setLabel("dist. points").setPosition(xc, yc).setSize(wControl, hControl).setRange(5, 100).setGroup(groupControls).addCallback(this.cb);
    yc+=(hControl+padding);

    //    cp5.addTextlabel("lblCalques").setText("CALQUES").setPosition(xc, yc);
    //    yc += (hControl+padding);
    // >>>> CALQUES
    sliderNbCalques = cp5.addSlider(this.name+"_nbCalques").setLabel("nb calques").setPosition(xc, yc).setSize(wControl, hControl).setRange(1, 10).setNumberOfTickMarks(10).setGroup(groupControls).addCallback(this.cb);
    yc+=(hControl+padding);
    sliderAngleCalques = cp5.addSlider(this.name+"_angleCalques").setLabel("angle calques").setPosition(xc, yc).setSize(wControl, hControl).setRange(0, 360).setGroup(groupControls).addCallback(this.cb);
    yc+=(hControl+padding);
    sliderScaleCalques = cp5.addSlider(this.name+"_scaleCalques").setLabel("échelle calques").setPosition(xc, yc).setSize(wControl, hControl).setRange(0.1, 1).setValue(scaleCalques).setGroup(groupControls).addCallback(this.cb);
    yc+=(hControl+padding);
    sliderXOffsetCalques = cp5.addSlider(this.name+"_xoffsetCalques").setLabel("x calques").setPosition(xc, yc).setSize(wControl, hControl).setRange(-100, 100).setValue(xOffsetCalques).setGroup(groupControls).addCallback(this.cb);
    yc+=(hControl+padding);
    sliderYOffsetCalques = cp5.addSlider(this.name+"_yoffsetCalques").setLabel("y calques").setPosition(xc, yc).setSize(wControl, hControl).setRange(-100, 100).setValue(yOffsetCalques).setGroup(groupControls).addCallback(this.cb);
    yc+=(hControl+padding);

    // >>>> DISPLACEMENTS
    sliderDisplacement = cp5.addSlider(this.name+"_rndDisplacement").setLabel("random offset").setPosition(xc, yc).setSize(wControl, hControl).setRange(0, 50).setValue(randomDisplacement).setGroup(groupControls).addCallback(this.cb);
    yc+=(hControl+padding);

    // >>>> MOTION
    sliderMotionSine_angleSpeed = cp5.addSlider(this.name+"_motionSineAngleSpeed").setLabel("angle vitesse").setPosition(xc, yc).setSize(wControl, hControl).setRange(0, 360).setValue(motionSine_angleSpeed).setGroup(groupControls).addCallback(this.cb);
    yc+=(hControl+padding);
    sliderMotionSine_factor = cp5.addSlider(this.name+"_motionSineFactor").setLabel("factor").setPosition(xc, yc).setSize(wControl, hControl).setRange(0, 1).setValue(motionSine_factor).setGroup(groupControls).addCallback(this.cb);
    yc+=(hControl+padding);
    sliderMotionSine_freq = cp5.addSlider(this.name+"_motionSineAngleFreq").setLabel("angle frequence").setPosition(xc, yc).setSize(wControl, hControl).setRange(1, 20).setNumberOfTickMarks(20).setValue(motionSine_freq).setGroup(groupControls).addCallback(this.cb);
    yc+=(hControl+padding);


    hideControls();
  }

  // ----------------------------------------------------------
  void showControls()
  {
    groupControls.show();
  }

  // ----------------------------------------------------------
  void hideControls()
  {
    groupControls.hide();
  }

  // ----------------------------------------------------------
  CallbackListener cb = new CallbackListener() 
  {
    public void controlEvent(CallbackEvent theEvent) 
    {
      String name = theEvent.getController().getName();
      float value = theEvent.getController().getValue();

      String[] list;

      switch(theEvent.getAction()) 
      {
      case ControlP5.ACTION_BROADCAST:
        list = split(name, '_');
        if (list.length == 2)
        {
          TypoRender tr = getTypoRender( list[0] );
          if (tr != null)
          {
            if (list[1].equals("nbCalques")) tr.nbCalques = (int)value;
            else if (list[1].equals("angleCalques")) tr.angleCalques = value;
            else if (list[1].equals("scaleCalques")) tr.scaleCalques = value;
            else if (list[1].equals("xoffsetCalques")) tr.xOffsetCalques = value;
            else if (list[1].equals("motionSineAngleSpeed")) tr.motionSine_angleSpeed = value;
            else if (list[1].equals("motionSineFactor")) tr.motionSine_factor = value;
            else if (list[1].equals("motionSineAngleFreq")) tr.motionSine_freq = value;
          }
        }
        break;

      case ControlP5.ACTION_RELEASED: 
      case ControlP5.ACTION_RELEASEDOUTSIDE: 
        list = split(name, '_');
        if (list.length == 2)
        {
          TypoRender tr = getTypoRender( list[0] );
          if (tr != null)
          {
            if (list[1].equals("segmentLength")) tr.setSegmentLength(value);
            else if (list[1].equals("rndDisplacement"))
            { 
              tr.randomDisplacement = value;
              tr.computeRandomDisplacements();
            }
          }
        }
        break;
      }
    }
  };


  void reset()
  {
  }

  void set(String fontName, String t, float sl)
  {
    this.text = t;
    this.fontName = fontName;
    this.segmentLength = sl;
    this.compute();
  }

  void setText(String t)
  {
    this.text = t;
    this.compute();
  }

  void setSegmentLength(float sl)
  {
    this.segmentLength = sl;
    this.compute();
  }


  void setFontName(String fontName)
  {
    this.fontName = fontName;
    this.compute();
  }

  void computeRandomDisplacements()
  {
    float rndAngle = 0;
    int nbShapes = tm.shapesNb();
    println("computeRandomDisplacements(), nbShapes="+nbShapes);
    this.rndDisplacements = new PVector[nbShapes][];
    for (int i=0; i<nbShapes; i++)
    {
      int nbPoints = tm.listePointsShape[i].length;
      this.rndDisplacements[i] = new PVector[nbPoints];
      float x, y;
      for (int j=0; j<nbPoints; j++)
      {
        rndAngle = random(0, TWO_PI);
        this.rndDisplacements[i][j] = new PVector( randomDisplacement*cos(rndAngle), randomDisplacement*sin(rndAngle)  );
      }
    }
  }

  void compute()
  {
    isComputing = true;
    this.tm = new TypoManager(fontName, text, segmentLength);
    this.computeRandomDisplacements();
    isComputing = false;
  }

  void update(float dt)
  {
    motionSine_angle += motionSine_angleSpeed*dt;
    if (motionSine_angle >= 360.0) motionSine_angle -= 360.0;
  }

  float getMotionValue(float t, float value)
  {
    // Sine
    return map(sin( t*motionSine_freq*TWO_PI + radians(motionSine_angle )), -1, 1, motionSine_factor*value, value);
  }

  void draw()
  {
    pushMatrix();
    translate(width/2, height/2);
    if (tm != null)
    {
      pushStyle();
      for (int i=0; i<nbCalques; i++)
      {
        pushMatrix();
        float angle = map(i, 0, nbCalques, 0, radians(angleCalques));
        float scale = map(i, 0, nbCalques, 1, scaleCalques);
        float x = map(i, 0, nbCalques, 0, xOffsetCalques); 
        float y = map(i, 0, nbCalques, 0, yOffsetCalques); 
        translate(x, y);
        rotate(angle);
        scale(scale);
        drawShapes(i);

        if (bDrawShape && !bExportSVG)
        {
          pushStyle();
          noFill();
          stroke(0, 120);
          tm.drawShapes();
          popStyle();
        }

        if (bDrawPoints && !bExportSVG)
        {
          pushStyle();
          noFill();
          stroke(0, 120);
          tm.drawPoints();
          popStyle();
        }


        popMatrix();
      }
      popStyle();
    }
    popMatrix();
  }

  void drawShapes(int nCalque)
  {
  }
  void drawMode()
  {
  }
}
