
void setup()
{
  Serial.begin(9600);
  while (!Serial) {
    ; // wait for serial port to connect. Needed for native USB port only
  }

  // Configure the pin for the microswitch

  // Connect to the mobile network. Initialise the modem, then GPRS
 
}
// This is the buffer we're going to send
#define PACKET_SIZE 128
byte packetBuffer[PACKET_SIZE];

// This is the potentiometer reading and button state (pressed or not, HIGH when not pressed, LOW when pressed)
int potmeterValue = 0;
int lastButtonState = HIGH;
int buttonState = HIGH;

void loop() {
 
    potmeterValue = analogRead(A1);
    
    Serial.print("Sending packet with value ");
    Serial.println(potmeterValue);

    memset(packetBuffer, 0, PACKET_SIZE);
    //sprintf((char*)packetBuffer, "Value is %d", potmeterValue);

    // Send the packet. This is sent as plain text but a proper firmware implementation should
    // use some kind of encoding to save power (and time).
    
  delay(100);  
}