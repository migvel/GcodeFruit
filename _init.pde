
// define the parameters of our machine.
#define X_STEPS_PER_INCH 416.772354
#define X_STEPS_PER_MM   320
#define X_MOTOR_STEPS    400

#define Y_STEPS_PER_INCH 416.772354
#define Y_STEPS_PER_MM   320
#define Y_MOTOR_STEPS    400

#define Z_STEPS_PER_INCH 416.772354
#define Z_STEPS_PER_MM   320
#define Z_MOTOR_STEPS    400

#define SD_CARD_WRITE    2
#define SD_CARD_DETECT   3
#define SD_CARD_SELECT   4



//our maximum feedrates
#define FAST_XY_FEEDRATE 800
#define FAST_Z_FEEDRATE  50.0

// Units in curve section
#define CURVE_SECTION_INCHES 0.019685
#define CURVE_SECTION_MM 0.5

// Set to one if sensor outputs inverting (ie: 1 means open, 0 means closed)
// RepRap opto endstops are *not* inverting.
#define SENSORS_INVERTING 0

// How many temperature samples to take.  each sample takes about 100 usecs.
#define TEMPERATURE_SAMPLES 5

/****************************************************************************************
 * digital i/o pin assignment
 *
 * this uses the undocumented feature of Arduino - pins 14-19 correspond to analog 0-5
 ****************************************************************************************/

//cartesian bot pins


#define X_STEP_PIN 15
#define X_DIR_PIN 18
#define X_MIN_PIN 20
#define X_MAX_PIN 21
#define X_ENABLE_PIN 19


#define Y_STEP_PIN 23
#define Y_DIR_PIN 22
#define Y_MIN_PIN 25
#define Y_MAX_PIN 26
#define Y_ENABLE_PIN 24


#define Z_STEP_PIN 27
#define Z_DIR_PIN 28
#define Z_MIN_PIN 30
#define Z_MAX_PIN 31
#define Z_ENABLE_PIN 29


//extruder pins
#define EXTRUDER_MOTOR_SPEED_PIN   11
#define EXTRUDER_MOTOR_DIR_PIN     12
#define EXTRUDER_HEATER_PIN        6
#define EXTRUDER_FAN_PIN           5
#define EXTRUDER_THERMISTOR_PIN    0  //a -1 disables thermistor readings
#define EXTRUDER_THERMOCOUPLE_PIN  -1 //a -1 disables thermocouple readings

