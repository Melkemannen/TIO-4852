#include "ultrasonic_sensor.h"

unsigned long ultrasonic_get_measurement_in_ns(int trigger_pin, int echo_pin){
  unsigned long result = 0;
  digitalWrite(trigger_pin, LOW);  
	delayMicroseconds(2);  

	digitalWrite(trigger_pin, HIGH);  
	delayMicroseconds(10);  
	digitalWrite(trigger_pin, LOW);
  result = pulseIn(echo_pin, HIGH); 
  //Serial.println(result);
  return  result;

}

float ultrasonic_time_to_distance ( unsigned long duration){
  return ((float)duration * 0.0343 )/2.0;
}