// Use this value for the APN and comment out the line above if you are using
// a COM4 SIM card
//#define SPAN_APN "mda.lab5e"
#include "lab5e.h"

void print_dbg(int *dbg) {
  Serial.println(*dbg);
  dbg++;
}




void init_lab5e() {
  // Configure the pin for the microswitch
  pinMode(10, INPUT_PULLUP);

  // Connect to the mobile network. Initialise the modem, then GPRS
  Serial.println("Connecting....");
  boolean connected = false;
  Serial.println("line 1");
  while (!connected) {
    
    if ((nbAccess.begin(NULL, "mda.lab5e") == NB_READY)){
      Serial.println("line 2");

      if (gprs.attachGPRS() == GPRS_READY){
          connected = true;
        }
  
    } else {
      Serial.println("Not connected, retrying...");
      delay(1000);
    }
  }

  // Initialise the UDP sender class
  Udp.begin(localPort);
  Serial.println("Setup complete");
}

// This is the address and port of the Span service (172.16.15.14:1234)
//IPAddress spanAddress(172, 16, 15, 14);
//unsigned int spanPort = 1234;



int get_all_photoresistors(uint16_t output[], int length) {
  if (length != 5) return 1;
  output[0] = analogRead(A1);
  output[1] = analogRead(A2);
  output[2] = analogRead(A3);
  output[3] = analogRead(A4);
  output[4] = analogRead(A5);
  return 0;
}

int plot_values(const char *strings[], uint16_t data[], int length) {
  for (int i = 0; i < length; i++) {
    Serial.print(strings[i]);

    Serial.print(data[i]);
    if (i < length - 1) {
      Serial.print(" , ");
    }
  }
}

int send_all_photoresistirs_u8(uint16_t output[], int length) {
  uint8_t truncated[length];
  for (int i = 0; i < length; i++) {
    truncated[i] = output[i] >> 8;
    Serial.println(truncated[i]);
  }
  Serial.println();
  //Udp.beginPacket(spanAddress, spanPort);
  //Udp.write(truncated, sizeof(truncated)/sizeof(truncated[i])));
  //Udp.endPacket();
}



uint16_t linearize_photoresistor(float R1, float R_dark, uint16_t data, uint16_t max_value) {
  // output= (data/max_value - 1)*R1 + R_dark
  float output = 0;
  output = 1 - ((float)data / (float)max_value);
  output = output * R1 - R_dark;
  return -output;
}
