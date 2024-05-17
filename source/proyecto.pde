import g4p_controls.*;

int ITER;
String AXIOM;
String[] RULES;
float ANGLE;
float Initial_Angle = 0;

float step_F = 30;

class Turtle{
  float xpos, ypos;
  float facing_angle = 0;

  Turtle(){};
  Turtle(float x, float y, float theta){
    xpos = x; ypos = y; facing_angle = theta;
  }
  Turtle(Turtle t){
   xpos = t.xpos;
   ypos = t.ypos;
   facing_angle = t.facing_angle;
  }
}


void Forward(Turtle T){
  //Calculamos la nueva pos
  float new_X = T.xpos + cos(T.facing_angle)*step_F;
  float new_Y = T.ypos + sin(T.facing_angle)*step_F;
  line(T.xpos, T.ypos, new_X, new_Y);
  T.xpos = new_X;
  T.ypos = new_Y;
};

void jump(Turtle T){
  //Como trazar pero sin trazar xd
  float new_X = T.xpos + cos(T.facing_angle)*step_F;
  float new_Y = T.ypos + sin(T.facing_angle)*step_F;
  T.xpos = new_X;
  T.ypos = new_Y;

}

void rotateLeft(Turtle T){
  T.facing_angle =  (T.facing_angle + ANGLE)%(2*PI);
}
void rotateRight(Turtle T){
  T.facing_angle =  (T.facing_angle - ANGLE)%(2*PI);
}



public class Vec2{
  float x;
  float y;
  
  Vec2(){
    this.x = 0;
    this.y = 0;
  }
  
  Vec2(float x,  float y){
    this.x = x;
    this.y = y;
  }
  float Len(){
    return sqrt(x*x + y*y);
  }
  Vec2 multiply(float s){
      return new Vec2(this.x * s, this.y * s);
  }
  Vec2 add(Vec2 v){
    return new Vec2(this.x + v.x, this.y + v.y);
  }
  
  void normalize(){
    float m = Len();
    if(m != 0){
       x = x/m;
       y = y/m;
    }
  }
  
  void print() {
    println("(" + x + ", " + y + ")");
  }
}

class Edge{
  int p1;
  int p2;
  Edge(){
    p1 = 0; p2 = 0;
  }
  Edge(int P1, int P2){
    this.p1 = P1;
    this.p2 = P2;
  }
}


void constructFigure(){
     HashMap<Character, String> rules = new HashMap<Character, String>();
     //Asumes no repetitions
     for(String rule : RULES){
       String[] rule_parts = split(rule, '=');
       rules.put(rule_parts[0].charAt(0), rule_parts[1]);
     }
   
    Result_System = AXIOM;
    String substitution;
    String temporary_System = "";
    for(int iter = 0; iter < ITER; iter++){
      temporary_System = "";
      for(int i = 0; i < Result_System.length(); i++){
        substitution = rules.get(Result_System.charAt(i));
        if(substitution != null){
          temporary_System += substitution;
        }else{
          temporary_System += Result_System.charAt(i);
        }
      }
      Result_System = temporary_System;
    }
    
    //println(temporary_System);
    drawSystem();
}

String Result_System;

int total_Turtles = 1;
Turtle[] turtles;
int current_T = 0;

//For draing
ArrayList<Vec2> Points;
ArrayList<Edge> Edges;


void drawSystem(){
   
  total_Turtles = 1;
  for(int i = 0; i < Result_System.length(); i++){
    if(Result_System.charAt(i) == '['){
      total_Turtles++;
    }
  }
  
  
  turtles = new Turtle[total_Turtles];
  turtles[0] = new Turtle(0, 0, Initial_Angle);
  
  drawFigure = false;
  /*For drawing*/
  Points = new ArrayList<Vec2>(); Points.add(new Vec2(0,0));
  Edges = new ArrayList<Edge>();
  ArrayList<Integer> point_sequence = new ArrayList<Integer>();
  int current_point = 0;
  int last_point_added = 0;
  
  float maxX = 0, maxY = 0;
  float minX = 0, minY = 0;
  
  for(int pos = 0; pos < Result_System.length(); pos++){
    switch(Result_System.charAt(pos)){
      case 'F':
        //Forward(turtles[current_T]);
        jump(turtles[current_T]);
        
        if(turtles[current_T].xpos > maxX) maxX = turtles[current_T].xpos;
        if(turtles[current_T].xpos < minX) minX = turtles[current_T].xpos;
        if(turtles[current_T].ypos > maxY) maxY = turtles[current_T].ypos;
        if(turtles[current_T].ypos < minY) minY = turtles[current_T].ypos;
        
        Points.add(new Vec2(turtles[current_T].xpos, turtles[current_T].ypos));
        last_point_added++;
        Edges.add(new Edge(current_point, last_point_added));
        current_point = last_point_added;
        break;
      case 'f':
        jump(turtles[current_T]);
        Points.add(new Vec2(turtles[current_T].xpos, turtles[current_T].ypos));
        last_point_added++;
        current_point = last_point_added;
        break;
      case '+':
        rotateRight(turtles[current_T]);
        break;
      case '-':
        rotateLeft(turtles[current_T]);
        break;
      case '[':
        //Creamos la nueva tortuga
        Turtle temp = turtles[current_T];
        current_T ++;
        turtles[current_T] = new Turtle(temp);
        
        point_sequence.add(current_point);
        break;
      case ']':
        current_T --;
        
        current_point = point_sequence.get(point_sequence.size()-1);
        point_sequence.remove(point_sequence.size()-1);
        break;
    }
  }
  
  /*We fit it in the area*/
  
  float posX = (minX + maxX)/2.0;
  float posY = (minY + maxY)/2.0;
  
  float scaleX =  (width - 500)/(maxX - minX), scaleY = (height -100)/(maxY - minY);
  if(scaleX > 1) scaleX = 1;
  if(scaleY > 1) scaleY = 1;
  
  float scaleFactor = min(scaleX, scaleY);
  
  for(int i = 0; i < Points.size(); i++){
    Vec2 temp = Points.get(i);
    temp = temp.add(new Vec2(-posX, -posY));
    temp = temp.multiply(scaleFactor);
    temp = temp.add(new Vec2((450 + 1150)/2.0, 650/2.0));
    Points.set(i, temp);
  }
  
  
  drawFigure = true;
 
}







void setup(){
  size(1200,650, JAVA2D);
  stroke(255);
  createGUI();
  
}

boolean drawFigure = false;

void draw(){
     background(0);
     if(drawFigure){
       Vec2 P1, P2;
       for(Edge e : Edges){
         P1 = Points.get(e.p1);
         P2 = Points.get(e.p2);
         line(P1.x, P1.y, P2.x, P2.y);
       }
     }
}
