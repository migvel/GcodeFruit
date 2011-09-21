  #include <PString.h>

// Arduino G-code Interpreter
// v1.0 by Mike Ellery - initial software (mellery@gmail.com)
// v1.1 by Zach Hoeken - cleaned up and did lots of tweaks (hoeken@gmail.com)
// v1.2 by Chris Meighan - cleanup / G2&G3 support (cmeighan@gmail.com)
// v1.3 by Zach Hoeken - added thermocouple support and multi-sample temp readings. (hoeken@gmail.com)
// Adafruit motor board  version - Dirty and fast mod, need revision. (miguel.jgz@gmail.com)

#include <HardwareSerial.h>
#include <WProgram.h>
#include <SimplePacket.h>
#include <RepRapSDCard.h>
#include <WString.h>


//our command string
#define COMMAND_SIZE 25

RepRapSDCard card;
File f;

int startpos=0;
int actualpos=0;

//our buffer of bytes.
#define BUFFSIZE 100
char buffer[BUFFSIZE];
byte bufferIndex = 0;
byte error = 0;

byte serial_count;
int no_data = 0;
int enable_power=14;
char filename1[50]="test.TXT";


char command[COMMAND_SIZE];

char clean[COMMAND_SIZE];
char dirty[COMMAND_SIZE];

PString cleanstr(clean, sizeof(clean));
PString dirtystr(dirty, sizeof(dirty));

int startcom=0;
int cont=0;

void setup()
{
  pinMode(enable_power,OUTPUT);
  digitalWrite(enable_power,LOW);


  //Do startup stuff here
  Serial.begin(19200);
  Serial.println("start");

  //other initialization.
  init_process_string();
  init_steppers();
  //init_extruder();

  delay(500);
  init_sd_card();  

  open_gfile("test.txt");
  //read_gfile(); 

  cleanstr.begin();
  dirtystr.begin();



}



void loop()
{

  //read 8 bytes of sdcar into buffer.
  uint8_t result = card.read_file(f, (uint8_t *)buffer, 8);
  
  
  if(result==0){
    Serial.println("End of file");
    
    digitalWrite(enable_power,HIGH);  
    delay(10000);
    digitalWrite(enable_power,LOW);  
    
    
    
    //some tests to check the gcode commands.
    while(digitalRead(20) == LOW)
    {
      process_string("G0 X-30",80);
    }
    
    delay(500);
    process_string("G90",80);
    process_string("G92",80);
    process_string("G0 X5",80);
    digitalWrite(enable_power,HIGH);  

    while(1){}
    
  }
    
    
    
  else{
    //take a look in buffer.
    cont=0;
    while(cont<8)
    {
      if(buffer[cont]=='G') startcom=1;
      else if(buffer[cont]=='\n'){
        Serial.println(clean);
        process_string(clean, 80);
        cleanstr.begin();
        startcom=0;
      }
      
      if(startcom==1)
      {
        cleanstr.print(buffer[cont]);
      }
      
      cont++;
    }  
  }
  
  

 


  //countline_gfile();
  //process_string(command, 80);
  //loads the buffer in filebuf.
  //filebuf.append(buffer);
  //delay(500);
  //Serial.println("calling fun count...");
  //countline_gfile();  
  //delay(20000);
  //int size=0;
  //size_command();
  //Serial.println("something");
  //load_command("comandoG!!!!");
  //mystring.print("comandog");
  //Serial.println(buffer1);
  //delay(1000);
  //Serial.println("Starts the counter");
  //countline_gfile();
  //countline_gfile();  
  //
  //print_gfile();
  //delay(5000); 
  /*
  	char c;
   	
   	//keep it hot!
   	//extruder_manage_temperature();
   
   	//read in characters if we got them.
   	if (Serial.available() > 0)
   	{
   	c = Serial.read();
   		no_data = 0;
   	        Serial.println("inside serial avaliable");
   		//newlines are ends of commands.
   		if (c != '\n')
   		{
   			wordo[serial_count] = c;
   			serial_count++;
   		}
   	}
   	//mark no data.
   	else
   	{
   		no_data++;
   		delayMicroseconds(100);
   	}
   	//if theres a pause or we got a real command, do it
   	if (serial_count && (c == '\n' || no_data > 100))
   	{
   		//process our command!
   	        Serial.println(wordo);
   	process_string(wordo, serial_count);
   
   		//clear command.
   		init_process_string();
   	}
   
   	//no data?  turn off steppers
   	if (no_data > 1000)
   	  disable_steppers();
   */
}


void init_sd_card()
{
  if (!card.init_card())
  {
    if (!card.isAvailable())
    {
      Serial.println("No card present"); 
      error = 1;
    }
    else
    {
      Serial.println("Card init failed"); 
      error = 2;
    }
  }
  else if (!card.open_partition())
  {
    Serial.println("No partition"); 
    error = 3;
  }
  else if (!card.open_filesys())
  {
    Serial.println("Can't open filesys"); 
    error = 4;
  }
  else if (!card.open_dir("/"))
  {
    Serial.println("Can't open /");
    error = 5;
  }
  else if (card.isLocked())
  {
    Serial.println("Card is locked");
    error = 6;
  }
}



/*
void countline_gfile()
{

  actualpos=0;
  startpos=0;

  Serial.println("Starts the count");

  while(actualpos<= 40)
  {
    commandstr.print(buffer[actualpos]);

    //End of line means end of command.
    if(buffer[actualpos]==10) 
    { 
      startpos=actualpos;       //update.
      Serial.println(command);  //execute the command.
      commandstr.begin();       //reset the buffer command.
    }
    ++actualpos; 
  }
}
*/


void open_gfile(char filename[50])
{

  strcpy(buffer, filename);
  f = card.open_file(buffer);
  if (!f)
  {
    Serial.print("error opening: ");
    error = 8;
  }

}  



void read_gfile()
{

  Serial.print("reading from: ");
  Serial.println(buffer);
  uint8_t result = card.read_file(f, (uint8_t *)buffer, 8000);

}



void close_gfile()
{
  card.close_file(f);  
}



void print_gfile()
{
  Serial.println(buffer);
}


void open_file()
{
  open_new_file();

  if (error == 0)
  {
    bufferIndex = 0;
    for (char c = 'a'; c<= 'z'; c++)
    {
      buffer[bufferIndex] = c;
      bufferIndex++;
    }

    card.write_file(f, (uint8_t *) buffer, bufferIndex);
    card.close_file(f);
  }

  read_first_file();        
}


void open_new_file()
{
  strcpy(buffer, filename1);
  for (buffer[5] = '0'; buffer[5] <= '9'; buffer[5]++)
  {
    for (buffer[6] = '0'; buffer[6] <= '9'; buffer[6]++)
    {
      f = card.open_file(buffer);
      if (!f)
        break;        // found a file!      
      card.close_file(f);
    }
    if (!f) 
      break;
  }

  if(!card.create_file(buffer))
  {
    Serial.print("couldnt create: ");
    Serial.println(buffer);
    error = 7;
  }
  else
  {
    f = card.open_file(buffer);
    if (!f)
    {
      Serial.print("error opening: ");
      Serial.println(buffer);
      error = 8;
    }
    else
    {
      Serial.print("writing to: ");
      Serial.println(buffer);
    }
  }
}



void read_first_file()
{
  strcpy(buffer, "test.txt");
  f = card.open_file(buffer);

  if (!f)
  {
    Serial.print("error opening: ");
    Serial.println(buffer);
    error = 8;
  }
  else
  {
    Serial.print("reading from: ");
    Serial.println(buffer);

    uint8_t result = card.read_file(f, (uint8_t *)buffer, 8);

    if (result >0)
      Serial.print(buffer);
    else if (result == 0)
      Serial.println("end of file.");
    else
    {
      Serial.print("read error: ");
      Serial.println(result, DEC);
    }
  }
}






