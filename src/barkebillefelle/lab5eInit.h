#ifndef lab5eInit_h
#define lab5eInit_h
#include <MKRNB.h>

GPRS gprs;
NB nbAccess;
NBUDP Udp;

// This is the local port
unsigned int localPort = 4200;

#define SPAN_APN "mda.lab5e"

// Use this value for the APN and comment out the line above if you are using 
// a COM4 SIM card
//#define SPAN_APN "lab5e.com4.net"

void init_lab5e(){
   Serial.println("Connecting...."); 
  boolean connected = false;
  while (!connected) {
    if ((nbAccess.begin(NULL, SPAN_APN) == NB_READY) &&
        (gprs.attachGPRS() == GPRS_READY)) {
      connected = true;
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
IPAddress spanAddress(172, 16, 15, 14); 
unsigned int spanPort = 1234;
}

#endif