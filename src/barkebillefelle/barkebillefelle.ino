void get_all_sensors(uint16_t output[]);


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
#define ANALOG_BITWIDTH 11
#define ANALOG_MAX      1024
uint16_t analog_read_buffer[5];
// This is the potentiometer reading and button state (pressed or not, HIGH when not pressed, LOW when pressed)
int potmeterValue = 0;
int lastButtonState = HIGH;
int buttonState = HIGH;

 const char *strings[] = {"A1:", "A2:", "A3:", "A4:", "A5:"};

int get_all_sensors(uint16_t output[],int length){
 if (length!=5)return 1;
output[0]=analogRead(A1);
output[1]=analogRead(A2);
output[2]=analogRead(A3);
output[3]=analogRead(A4);
output[4]=analogRead(A5);
return 0;
}
int plot_values(const char *strings[],uint16_t data[], int length){
for (int i=0; i< length  ;i++){
  Serial.print(strings[i]);
  
  Serial.print(data[i]);
  if (i < length-1){
  Serial.print(" , ");
  }
}
Serial.println();
}

void loop() {

    //potmeterValue = analogRead(A1);
    get_all_sensors(analog_read_buffer,sizeof(analog_read_buffer)/sizeof(analog_read_buffer[0]));
    plot_values(strings,analog_read_buffer,sizeof(analog_read_buffer)/sizeof(analog_read_buffer[0]));
    //Serial.print("Sending packet with value ");
    //Serial.println(potmeterValue);

    memset(packetBuffer, 0, PACKET_SIZE);
    //sprintf((char*)packetBuffer, "Value is %d", potmeterValue);

    // Send the packet. This is sent as plain text but a proper firmware implementation should
    // use some kind of encoding to save power (and time).
    
  delay(100);  
}