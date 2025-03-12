#include "lab5e.h"
#include "ultrasonic_sensor.h"

GPRS gprs;
NB nbAccess(true);
NBUDP Udp;



// the ip address to use
IPAddress spanAddress(172, 16, 15, 14);

#define DISABLE_NBIOT
#define TRIGGER_PIN 0
#define ECHO_PIN 1

unsigned int localPort = 4200;

void setup() {
  // Open serial communications and wait for port to open:
  Serial.begin(9600);
  pinMode(TRIGGER_PIN, OUTPUT);
  digitalWrite(TRIGGER_PIN, LOW);
  pinMode(ECHO_PIN, INPUT);
  delay(1000);
#ifndef DISABLE_NBIOT
  Serial.println("Connecting....");
  boolean connected = false;
  while (!connected) {
    if ((nbAccess.begin(NULL, "mda.lab5e") == NB_READY) && (gprs.attachGPRS() == GPRS_READY)) {
      connected = true;
    } else {
      Serial.println("Not connected, retrying...");
      delay(1000);
    }
  }

  Udp.begin(localPort);
  Serial.println("connected");
#else
  Serial.println("GPRS disabled. running localy");
#endif  //DISABLE_NBIOT
}


// This is the buffer we're going to send
#define PACKET_SIZE 128
byte packetBuffer[PACKET_SIZE];
#define ANALOG_BITWIDTH 11
#define ANALOG_MAX 1024
#define POLL_TIME 100
#define NUMBER_OF_SENSORS 5
// which of the sensors are refference
#define REFFERENCE_MEASURMENT 0
uint16_t analog_read_buffer[NUMBER_OF_SENSORS];
uint16_t photoresistor_unfiltered[NUMBER_OF_SENSORS];



int height_photoresistor, prev_height_photoresistor;
const char *strings[] = { "A1:", "A2:", "A3:", "A4:", "A5:" };
unsigned long delay_timer = 0;
// value of the constant resistor
float R1[NUMBER_OF_SENSORS] = {
  1000.0,
  1000.0,
  1000.0,
  1000.0,
  1000.0,
};
// value of the photoresistor when it completly dark
float R_dark[NUMBER_OF_SENSORS] = {
  967.0,
  994.0,
  981.0,
  1047.0,
  1047.0,
};

#define MOVING_AVERAGE_LENGTH 10
#define M_A_val 10
uint16_t FIR_scalars_divider[30] = {
  M_A_val, M_A_val, M_A_val, M_A_val, M_A_val,
  M_A_val, M_A_val, M_A_val, M_A_val, M_A_val,
  M_A_val, M_A_val, M_A_val, M_A_val, M_A_val,
  M_A_val, M_A_val, M_A_val, M_A_val, M_A_val,
  M_A_val, M_A_val, M_A_val, M_A_val, M_A_val,
  M_A_val, M_A_val, M_A_val, M_A_val, M_A_val
};

int photoresistor_ringbuffer_ptr = 0;
uint32_t photoresistor_FIR_buffer[NUMBER_OF_SENSORS][30];
bool sensor_state_low[NUMBER_OF_SENSORS];

uint32_t ultrasonic_FIR_buffer[30];
int ultrasonic_ringbuffer_ptr = 0;
float height_ultrasonic;
float prev_height_ultrasonic;
float hysteresis_ultrasonic= 1.0;


// the position of each photoresistor. used to convert from covered sensors to height_photoresistor.
// since there are 4 sensors and 1 reference only element 0 to 4 is used.
const uint8_t photosensor_position_centimeter[] = { 0, 1, 7, 11, 15, 19 };

void loop() {

  if (delay_timer + POLL_TIME <= millis()) {
    height_photoresistor = 0;

    // measure all photoresistors. hard coded
    get_all_photoresistors(analog_read_buffer, 5);



    //Serial.println("fasdfdadsfa");
    for (int i = 0; i < NUMBER_OF_SENSORS; i++) {
      // FIR-filter. used as moving average.
      /*analog_read_buffer[i] = firFilter(photoresistor_FIR_buffer[i], MOVING_AVERAGE_LENGTH,
                                        FIR_scalars_divider, photoresistor_ringbuffer_ptr, analog_read_buffer[i]);
      //linearize. from "voltage" to light intensity
      analog_read_buffer[i] = linearize_photoresistor(R1[i], R_dark[i], analog_read_buffer[i], ANALOG_MAX);
      */
    }
    photoresistor_ringbuffer_ptr = (photoresistor_ringbuffer_ptr + 1) % MOVING_AVERAGE_LENGTH;
    for (int i = 0; i < NUMBER_OF_SENSORS; i++) {
      if (i != REFFERENCE_MEASURMENT) {
        //intefrate hysterisys into the measurment to reduce flickering.
        if ((analog_read_buffer[i] <= (analog_read_buffer[REFFERENCE_MEASURMENT] - 100)) && !sensor_state_low[i]) {
          sensor_state_low[i] = true;

        } else if ((analog_read_buffer[i] >= (analog_read_buffer[REFFERENCE_MEASURMENT] - 60)) && sensor_state_low[i]) {
          sensor_state_low[i] = false;
        }

        if (sensor_state_low[i] == true) {
          height_photoresistor = height_photoresistor + 1;
        }
      }
    }
    // measure ment from ultrasonic sensor -> moving average filter -> h(t) -> hysterisys
    unsigned long time_duration = ultrasonic_get_measurement_in_ns(TRIGGER_PIN, ECHO_PIN);
    /*time_duration = firFilter(ultrasonic_FIR_buffer, MOVING_AVERAGE_LENGTH,
                              FIR_scalars_divider, ultrasonic_ringbuffer_ptr, time_duration);
    ultrasonic_ringbuffer_ptr = (ultrasonic_ringbuffer_ptr + 1) % MOVING_AVERAGE_LENGTH;
    */

    //Serial.println(time_duration);
    // only send on change
    height_photoresistor = photosensor_position_centimeter[height_photoresistor];
    height_ultrasonic = 21.0 - ultrasonic_time_to_distance(time_duration);
#ifndef DISABLE_NBIOT
    if (height_photoresistor != prev_height_photoresistor) {
      Serial.print("sent photoresistor value: ");
      Serial.println(height_photoresistor);
      /*Udp.beginPacket(spanAddress, spanPort);
      udp.write(0x01);
      Udp.write(height_photoresistor);
      Udp.endPacket();*/
    }
          
    if (height_ultrasonic <= 0.0) {
        height_ultrasonic = 0;
    } 
    // only send if value changed by 10mm or more
    if ((height_ultrasonic > prev_height_ultrasonic + hysteresis_ultrasonic) || (height_ultrasonic < prev_height_ultrasonic - hysteresis_ultrasonic)) {

      uint8_t height_ultrasonic_u8= height_ultrasonic;
      /*Udp.beginPacket(spanAddress, spanPort);
      udp.write(0x02);  //identifyer
      Udp.write(height_ultrasonic_u8);
      Udp.endPacket();*/
      Serial.print("sent ultrasonic value: ");
      Serial.print(height_ultrasonic_u8);
      Serial.print("  ");
      Serial.println(height_ultrasonic);
      prev_height_ultrasonic = height_ultrasonic;
    }
#else
    //plot values
    plot_values(strings, analog_read_buffer, sizeof(analog_read_buffer) / sizeof(analog_read_buffer[0]));
    Serial.print(" , ");
    Serial.print("height_photoresistor:");
    Serial.print(height_photoresistor);
    Serial.print(", ultrasonic:");
    Serial.print(height_ultrasonic);
    Serial.println();
#endif  //DISABLE_NBIOT
    prev_height_photoresistor = height_photoresistor;
    //plot values
    /*plot_values(strings, analog_read_buffer, sizeof(analog_read_buffer) / sizeof(analog_read_buffer[0]));
    Serial.print(", height_photoresistor:");
    Serial.print(height_photoresistor);
    Serial.println();*/
    delay_timer = millis();

    //send_all_photoresistirs_u8(analog_read_buffer, sizeof(analog_read_buffer)/sizeof(analog_read_buffer[0]));
  }
  delay(10);
  //Serial.println(digitalRead(ECHO_PIN));
  //ultrasonic_get_measurement_in_ns(TRIGGER_PIN,ECHO_PIN);
}