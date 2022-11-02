import java.util.Iterator;

final int OBJECTS_COUNT = 60;
final int RINGS_DISTANCE = 20;
final int RINGS_SPEED = 1;
final int CENTER_MOVEMENT_SPEED = 1;
final int MAX_DISTANCE_TO_CENTER = 30;
final boolean TENTACLES_MOVEMENT = true;
final boolean SHOW_RINGS = true;

//------------------------------
int distanceToCenter = 0;
boolean movingToCenter = false; 
int colorFactor = 0;
int globalCounter = 0;
ArrayList<TrailingObject> objects;
Iterator<TrailingObject> objIterator;  

class TrailingObject { 
  float difX;
  float difY;
  float circX;
  float circY;
  float diameter;
  float radio;
  float speed;
  int quadrant; //1-4
  
  TrailingObject(){
    speed = 5;
    quadrant = 1;
    diameter = 100;
    radio = diameter / 2;
    circX = mouseX - radio;
    circY = mouseY - radio;  
  }
  
  TrailingObject(float speed, int quadrant){
    super();
    this.speed = speed;
    this.quadrant = quadrant;
  }  
  
  private void adjustQuadrant(){
    switch(this.quadrant){
      case 1:
        difX -= radio + distanceToCenter;
        difY -= radio + distanceToCenter;
      break;
      case 2:
        difX += radio + distanceToCenter;
        difY -= radio + distanceToCenter;
      break;
      case 3:
        difX -= radio + distanceToCenter;
        difY += radio + distanceToCenter;
      break;
      case 4:
        difX += radio + distanceToCenter;
        difY += radio + distanceToCenter;
      break;
    }
  }
  
  void update() {           
    diameter = speed * 2;
    radio = diameter / 2;
    
    difX = mouseX - circX;
    difY = mouseY - circY;
    
    adjustQuadrant();
    
    circX += difX / speed;
    circY += difY / speed;    
  } 
} 

void updateColorFactor(){ 
  if (globalCounter % RINGS_SPEED == 0){
    if (colorFactor >= RINGS_DISTANCE) 
      colorFactor = 1;
    else
      colorFactor += 1;   
  }
}

void updateDistanceToCenter(){  
  if (globalCounter % CENTER_MOVEMENT_SPEED == 0){
      if (distanceToCenter > MAX_DISTANCE_TO_CENTER)
        movingToCenter = true;
        
      if (distanceToCenter <= 0)
        movingToCenter = false;    
      
      if (movingToCenter) 
        distanceToCenter -= 1;
      else
        distanceToCenter += 1;   
  }
}

void setup() { 
  size(800,600);
  
  objects = new ArrayList<TrailingObject>();   
  
  for (int i = OBJECTS_COUNT; i > 0 ; i--){
     objects.add(new TrailingObject(i, 1)); 
     objects.add(new TrailingObject(i, 2)); 
     objects.add(new TrailingObject(i, 3)); 
     objects.add(new TrailingObject(i, 4)); 
  }      

}

boolean isLight(int index){
  boolean result = false;
  
  int iterations = OBJECTS_COUNT / RINGS_DISTANCE * 4;
  
  for (int i = 0; i <= iterations; i++){
    result = result || (index >= colorFactor + (RINGS_DISTANCE * i) && index < colorFactor + (RINGS_DISTANCE * i) + 4);
  }
    
  return result;
}

void draw() { 
  background(0);   
    
  objIterator = objects.iterator();
  
  int i = 0;

  while(objIterator.hasNext()){
     i++;
    
     TrailingObject obj = objIterator.next();
     
     obj.update();

     noStroke();     
     
     float colorValue = (i * 255 / (OBJECTS_COUNT * 4));
     
     if (SHOW_RINGS && isLight(i)) 
       fill(0, colorValue + 20, 0);
     else
      fill(0, colorValue , 0);
     
     circle(obj.circX, obj.circY, obj.diameter);         
  }
 
  updateColorFactor();
  if (TENTACLES_MOVEMENT) updateDistanceToCenter();
  globalCounter++;

}
    
    
