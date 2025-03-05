#ifndef ULTRASONIC_SENSOR_H
#define ULTRASONIC_SENSOR_H
#include <Arduino.h>

/**
* @brief start a measurment and return the travel time
*/
unsigned long ultrasonic_get_measurement_in_ns(int trigger_pin, int echo_pin);


/**
* @brief estimate distance based on time.
* @param duration time in ns
* @return distance in centimeter
*/
float ultrasonic_time_to_distance ( unsigned long duration);




#endif