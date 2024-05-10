#include <WiFi.h>
#include <TinyGPS++.h>
#include <HardwareSerial.h> // Thêm thư viện này để sử dụng cổng UART của ESP32-CAM

TinyGPSPlus gps;
HardwareSerial mygps(2); // Sử dụng cổng UART 2 của ESP32-CAM
#define GPS_RX_PIN 13 // Kết nối chân TX của GPS module với chân IO13 của ESP32-CAM
#define GPS_TX_PIN 14 // Kết nối chân RX của GPS module với chân IO14 của ESP32-CAM
String esp32CAM_IP = "";
const char* ssid = "Shinichi";
const char* password = "100420033";
const char* serverAddress = "172.20.10.2";
const int serverPort = 3000;

void setup() {
  Serial.begin(115200);
  mygps.begin(9600, SERIAL_8N1, GPS_RX_PIN, GPS_TX_PIN); // Bắt đầu cổng UART với tốc độ 9600 và chân RX, TX đã được định nghĩa
  connectToWiFi();
}

void loop() {
  // while (mygps.available() > 0) {
  //   gps.encode(mygps.read());
    if (gps.location.isUpdated()) {
      float latitude = gps.location.lat();
      float longitude = gps.location.lng();
      char latitudeStr[12]; 
      char longitudeStr[12]; 
      dtostrf(latitude, 0, 6, latitudeStr); 
      dtostrf(longitude, 0, 6, longitudeStr); 
      String latitudeString = String(latitudeStr);
      String longitudeString = String(longitudeStr);
      sendDataToServer(latitudeString, longitudeString);
      delay(5000);
    }
  }
// }

void connectToWiFi() {
  Serial.print("Connecting to WiFi...");
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.print(".");
  }
  Serial.println("Connected!");
  esp32CAM_IP = WiFi.localIP().toString();
  Serial.print("ESP32-CAM IP: ");
  Serial.println(esp32CAM_IP); 
  sendESPToServer(esp32CAM_IP);
}

void sendDataToServer(String latitude, String longitude) {
  WiFiClient client;
  if (client.connect(serverAddress, serverPort)) {
    Serial.println("Sending data to server...");
    String data = "latitude=" + latitude + "&longitude=" + longitude;
    client.print("POST /send_location HTTP/1.1\r\n");
    client.print("Host: ");
    client.print(serverAddress);
    client.print("\r\n");
    client.print("Content-Type: application/x-www-form-urlencoded\r\n");
    client.print("Content-Length: ");
    client.print(data.length());
    client.print("\r\n\r\n");
    client.print(data);
    // Serial.println("Data sent successfully!");

    // Đợi và đọc phản hồi từ server
    while (client.connected()) {
      String line = client.readStringUntil('\n');
      Serial.println(line);
    }
    
    // Đóng kết nối
    client.stop();
    Serial.println("Connection closed.");
  } else {
    Serial.println("Failed to connect to server!");
  }
}

void sendESPToServer(String ipESP) {
//   Serial.print("Data send:");
//   Serial.println(ipESP);
  WiFiClient client;
  if (client.connect(serverAddress, serverPort)) {
    // Serial.println("Sending data to server...");
    String data = "ip=" + ipESP;
    // Serial.println(data);
    client.print("POST /send_ip_esp HTTP/1.1\r\n");
    client.print("Host: ");
    client.print(serverAddress);
    client.print("\r\n");
    client.print("Content-Type: application/x-www-form-urlencoded\r\n");
    client.print("Content-Length: ");
    client.print(data.length());
    client.print("\r\n\r\n");
    client.print(data);
    Serial.println("Data sent successfully!");

    // Đợi và đọc phản hồi từ server
    while (client.connected()) {
      String line = client.readStringUntil('\n');
      Serial.println(line);
    }
    
    // Đóng kết nối
    client.stop();
    Serial.println("Connection closed.");
  } else {
    Serial.println("Failed to connect to server!");
  }
}
