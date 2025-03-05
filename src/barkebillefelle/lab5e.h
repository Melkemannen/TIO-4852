#ifndef lab5eInit_h
#define lab5eInit_h
#include <MKRNB.h>
//#include <stdint.h>




unsigned int spanPort = 1234;

int dbg;
// the apn/adress init_lab5e() uses
//#define SPAN_APN "mda.lab5e"

/**
* @brief initialize lab5e.
*/
void init_lab5e();

/**
* @brief read A1 to A5 and put the result in an array.
*/
int get_all_photoresistors(uint16_t output[], int length);

/**
* @brief plot in a fomat the arduino plotter understands
*/
int plot_values(const char *strings[], uint16_t data[], int length);

// linearize. R_dark is the resistance of the photoresistor when its completly dark.
uint16_t linearize_photoresistor(float R1, float R_dark, uint16_t data , uint16_t max_value);



// send all photoresistors, buth cut down to u8 instead of u16.
int send_all_photoresistirs_u8(uint16_t output[], int length);

void print_dbg(int * dbg);


#endif