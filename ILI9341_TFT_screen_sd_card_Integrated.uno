/*
*      File Name: ILI9341_TFT_screen_sd_card_Integrated.uno
*      Date: 21/01/2016
*
*      Author: Dhanunjaya Singh
*              Varun Tandon
*
*      Email Id: dhanunjay.201889@gmail.com
*
*      Description:
*
*       1. Multiple ILI9341 TFT LCD Screen Interfaced with Arduino
*       2. SD Card Integrated with Arduino to load images to the screen
*
*       The author's acknowldege the contribution of the library developers included in this software for this software development.
*
*       The Code below is granted free of charge, to any person obtaining a copy of this software
*       and associated documentation files (the "Software"), to deal in the Software without restriction,
*       including without limitation on the rights to use, copy, modify, merge, publish and distribute.
*
*/

/*Core graphics library*/
#include <Adafruit_GFX_AS.h>     

/*Hardware-specific library*/
#include <Adafruit_ILI9341_AS.h> 

/*lighweight and faster than SD card library*/
#include <SdFat.h>               
SdFat SD;                        

#include <SPI.h>                 
#include <Wire.h>

/*Digital read pin*/
int digitalreadpin=2;
static int previousreadpinstate=1;
static int readpinstate=0;

#define _sclk 13
#define _miso 12 // Needed for SD card, but does not need to be connected to TFT
#define _mosi 11 // Master Out Slave In to send commands/data to TFT and SD card

/*TFT chip select and data/command line*/
#define _cs1 10
#define _cs2 4
#define _cs3 5
#define _dc 9

static int i=-1; 

/*SD chip select*/
#define _sdcs 8

static int count=0;

/*select Alphabets*/
int levelselect=1;

static int screenincr=1;
static int previousscreenincr=0;

/*TFT reset line, can be connected to Arduino reset*/
#define _rst 7
#define _rst2 6
#define _rst3 3

int ledpin=13;

/* Invoke custom library*/
Adafruit_ILI9341_AS tft[] = {Adafruit_ILI9341_AS(_cs1, _dc, _rst),Adafruit_ILI9341_AS(_cs2, _dc, _rst2),Adafruit_ILI9341_AS(_cs3, _dc, _rst3)}; 

/*You can use MS Paint to pick colours off an image and see the RGB values*/
#define ILI9341_GREY 0xCE9A // Light grey

/*These are used when calling drawBMP() function*/
/*Temporarily flip the TFT coords for standard Bottom-Up bit maps*/
#define BU_BMP 1 

/*Draw inverted Top-Down bitmaps in standard coord frame*/
#define TD_BMP 0 

static int bootup=0;

/*Variable to save draw times for testing*/
uint32_t drawTime = 0; 

/*
* Function name:           setup
* Descriptions:            To set things up
*/

void setup()
{
        /*Initialize serial Interface for debug messages*/
	Serial.begin(4800); 

        /*Set Mode for the Digital Pins*/
	pinMode(digitalreadpin,INPUT);
	digitalWrite(ledpin,OUTPUT);

	Serial.println(F("Initialising SD card..."));
	if (!SD.begin(_sdcs, SPI_FULL_SPEED)) {  // sdFat library allows speed setting, e.g. SPI_HALF_SPEED
		if (!SD.begin(_sdcs)) {              // Only needed when standard SD library is used
			Serial.println(F("failed!"));
			return;
		}
	}
	serial.println("!!! All Modules Initialized Successfully !!!);
}

/*
 * Function name:           loop
 * Descriptions:            Infinite loop
*/

void loop()
{
	delay(100);
	readpinstate = digitalRead(digitalreadpin);

	delay(100);
	Serial.println("readpinStatus");
	Serial.println(readpinstate);

	if(previousreadpinstate!=readpinstate)
	{
		if((screenincr%2)!=0)
		{
			if(readpinstate==1)
			{
				screenincr++;

			}
		}
		else
		{
			if(readpinstate==0)
			{
				screenincr++;
			}

		}
	}
	Serial.println("previousreadpinstate");
	Serial.println(previousreadpinstate);
	Serial.println(readpinstate);

	previousreadpinstate = readpinstate;

	Serial.println("Screenincr");
	Serial.println(screenincr);

	switch(levelselect)
	{
		case 1:Serial.println("alphabets");
		       // alphabets++;
		       display_alphabets();
		       break;

		case 2:Serial.println("numbers");
		       // numbers++;
		       // play_audionumbers();
		       break;

		case  3:Serial.println("Months");
			// months++;
			//play_audiomonths();
			break;

		case 4:Serial.println("Days");
		       //days++;
		       //play_audiomonths();
		       break;

		case 5:Serial.println("Multiples");
		       //multiple++;
		       //play_audiomultiples();
		       break;
	}
}
void display_alphabets()
{

	count++;

	Serial.println(F("Here we go..."));

	if(previousscreenincr-screenincr!=0)

	{
		Serial.println("value of i");
		Serial.print(i);
		i++;
		i=i%3;

		/*Initialise the display (various parameters configured)*/
		tft[i].init(); 
		tft[i].setTextColor(ILI9341_BLACK, ILI9341_WHITE);

		/*set Landscape mode*/
		tft[i].setRotation(1);

		delay(200);

		switch(screenincr)
		{
			case 1:
				if(i==0)
				{
					drawRAW("e.raw", 47, 7, 225, 225);
					Serial.println("A//////////////");
				}
				if(i==1)
				{
					drawRAW("d.raw", 47, 7, 225, 225);
					Serial.println("B//////////////");
				}
				if(i==2)
				{
					drawRAW("c.raw", 47, 7, 225, 225);
					Serial.println("C//////////////");
				}
				break;

			case 2:
				if(i==0)
				{

					drawRAW("j.raw", 47, 7, 225, 225);

					Serial.println("F//////////////");
				}
				if(i==1)
				{
					drawRAW("i.raw", 47, 7, 225, 225);

					Serial.println("G//////////////");
				}
				if(i==2)
				{

					drawRAW("h.raw", 47, 7, 225, 225);

					Serial.println("H//////////////");
				} 
				break;

			case 3:

				if(i==0)
				{
					drawRAW("o.raw", 47, 7, 225, 225);
				}
				if(i==1)
				{
					drawRAW("n.raw", 47, 7, 225, 225);
				}
				if(i==2)
				{
					drawRAW("m.raw", 47, 7, 225, 225);
				}
				break;

			case 4:

				if(i==0)
				{
					drawRAW("t.raw", 47, 7, 225, 225);
				}
				if(i==1)
				{
					drawRAW("s.raw", 47, 7, 225, 225);
				}
				if(i==2)
				{
					drawRAW("r.raw", 47, 7, 225, 225);
				}
				break;

			case 5:
				if(i==0)
				{
					drawRAW("y.raw", 47, 7, 225, 225);
				}
				if(i==1)
				{
					drawRAW("x.raw", 47, 7, 225, 225);
				}
				if(i==2)
				{
					drawRAW("w.raw", 47, 7, 225, 225);
				}
				break;

			case 6:

				drawRAW("z.raw", 47, 7, 225, 225);
				break;
		}
	}
	if (count%3==0)
	{
		previousscreenincr=screenincr;
	}
}

#define BUFF_SIZE 80


uint16_t read16(File& f) {
	uint16_t result;
	((uint8_t *)&result)[0] = f.read(); // LSB
	((uint8_t *)&result)[1] = f.read(); // MSB
	return result;
}

uint32_t read32(File& f) {
	uint32_t result;
	((uint8_t *)&result)[0] = f.read(); // LSB
	((uint8_t *)&result)[1] = f.read();
	((uint8_t *)&result)[2] = f.read();
	((uint8_t *)&result)[3] = f.read(); // MSB
	return result;
}

/*
* Function name:           drawRAW
* Descriptions:            Draws Image on the tft Screen
*/

void drawRAW(char *filename, int16_t x, int16_t y, int16_t rawWidth, int16_t rawHeight) 
{
	File     rawFile;
	uint8_t  sdbuffer[2 * BUFF_SIZE];   // SD read pixel buffer (16 bits per pixel)

	/*Check file exists and open it*/
	if ((rawFile = SD.open(filename)) == NULL) {
		Serial.println(F("File not found"));
		return;
	}

	drawTime = millis(); // Save current time for performance evaluation

	tft[i].setAddrWindow(x, y, x + rawWidth - 1, y + rawHeight - 1);

	/*Work out how many whole buffers to send*/
	uint16_t nr = ((long)rawHeight * rawWidth)/BUFF_SIZE;
	while(nr--) {
		rawFile.read(sdbuffer, sizeof(sdbuffer));
		tft[i].pushColors(sdbuffer, BUFF_SIZE);
	}

	/*Send any partial buffer*/
	nr = ((long)rawHeight * rawWidth)%BUFF_SIZE;
	if (nr) {
		rawFile.read(sdbuffer, nr<<1); // load  2 x BUFF_SIZE bytes
		tft[i].pushColors(sdbuffer, nr);      // send BUF_SIZE pixels
	}

	drawTime = millis() - drawTime;
	rawFile.close();
}

