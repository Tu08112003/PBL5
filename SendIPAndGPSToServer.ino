#include <WiFi.h>
#include <TinyGPS++.h>
#include <HardwareSerial.h> // Thêm thư viện này để sử dụng cổng UART của ESP32-CAM
#include "esp_camera.h"
TinyGPSPlus gps;
HardwareSerial mygps(2); // Sử dụng cổng UART 2 của ESP32-CAM
#define GPS_RX_PIN 13 // Kết nối chân TX của GPS module với chân IO13 của ESP32-CAM
#define GPS_TX_PIN 14 // Kết nối chân RX của GPS module với chân IO14 của ESP32-CAM
#define CAMERA_MODEL_AI_THINKER // Has PSRAM
#include "camera_pins.h"
String esp32CAM_IP = "";
const char* ssid = "TUHOC_KHU_A";
const char* password = "";
const char* serverAddress = "10.10.3.11";
const int serverPort = 3000;

void startCameraServer();
void setupLedFlash(int pin);

void setup() {
  Serial.begin(115200);
  Serial.setDebugOutput(true);
  mygps.begin(9600, SERIAL_8N1, GPS_RX_PIN, GPS_TX_PIN); // Bắt đầu cổng UART với tốc độ 9600 và chân RX, TX đã được định nghĩa
  // Cấu hình cho camera
  camera_config_t config;
  config.ledc_channel = LEDC_CHANNEL_0;
  config.ledc_timer = LEDC_TIMER_0;
  config.pin_d0 = Y2_GPIO_NUM;
  config.pin_d1 = Y3_GPIO_NUM;
  config.pin_d2 = Y4_GPIO_NUM;
  config.pin_d3 = Y5_GPIO_NUM;
  config.pin_d4 = Y6_GPIO_NUM;
  config.pin_d5 = Y7_GPIO_NUM;
  config.pin_d6 = Y8_GPIO_NUM;
  config.pin_d7 = Y9_GPIO_NUM;
  config.pin_xclk = XCLK_GPIO_NUM;
  config.pin_pclk = PCLK_GPIO_NUM;
  config.pin_vsync = VSYNC_GPIO_NUM;
  config.pin_href = HREF_GPIO_NUM;
  config.pin_sccb_sda = SIOD_GPIO_NUM;
  config.pin_sccb_scl = SIOC_GPIO_NUM;
  config.pin_pwdn = PWDN_GPIO_NUM;
  config.pin_reset = RESET_GPIO_NUM;
  config.xclk_freq_hz = 20000000;
  config.frame_size = FRAMESIZE_UXGA;
  config.pixel_format = PIXFORMAT_JPEG; // for streaming
  //config.pixel_format = PIXFORMAT_RGB565; // for face detection/recognition
  config.grab_mode = CAMERA_GRAB_WHEN_EMPTY;
  config.fb_location = CAMERA_FB_IN_PSRAM;
  config.jpeg_quality = 12;
  config.fb_count = 1;
  
  // if PSRAM IC present, init with UXGA resolution and higher JPEG quality
  //                      for larger pre-allocated frame buffer.
  if(config.pixel_format == PIXFORMAT_JPEG){
    if(psramFound()){
      config.jpeg_quality = 10;
      config.fb_count = 2;
      config.grab_mode = CAMERA_GRAB_LATEST;
    } else {
      // Limit the frame size when PSRAM is not available
      config.frame_size = FRAMESIZE_SVGA;
      config.fb_location = CAMERA_FB_IN_DRAM;
    }
  } else {
    // Best option for face detection/recognition
    config.frame_size = FRAMESIZE_240X240;
#if CONFIG_IDF_TARGET_ESP32S3
    config.fb_count = 2;
#endif
  }

#if defined(CAMERA_MODEL_ESP_EYE)
  pinMode(13, INPUT_PULLUP);
  pinMode(14, INPUT_PULLUP);
#endif

  // camera init
  esp_err_t err = esp_camera_init(&config);
  if (err != ESP_OK) {
    Serial.printf("Camera init failed with error 0x%x", err);
    return;
  }

  sensor_t * s = esp_camera_sensor_get();
  // initial sensors are flipped vertically and colors are a bit saturated
  if (s->id.PID == OV3660_PID) {
    s->set_vflip(s, 1); // flip it back
    s->set_brightness(s, 1); // up the brightness just a bit
    s->set_saturation(s, -2); // lower the saturation
  }
  // drop down frame size for higher initial frame rate
  if(config.pixel_format == PIXFORMAT_JPEG){
    s->set_framesize(s, FRAMESIZE_QVGA);
  }

#if defined(CAMERA_MODEL_M5STACK_WIDE) || defined(CAMERA_MODEL_M5STACK_ESP32CAM)
  s->set_vflip(s, 1);
  s->set_hmirror(s, 1);
#endif

#if defined(CAMERA_MODEL_ESP32S3_EYE)
  s->set_vflip(s, 1);
#endif

// Setup LED FLash if LED pin is defined in camera_pins.h
#if defined(LED_GPIO_NUM)
  setupLedFlash(LED_GPIO_NUM);
#endif

  connectToWiFi();
}

void loop() {
  while (mygps.available() > 0) {
    gps.encode(mygps.read());
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
      // delay(5000);
    }
  }
}

void connectToWiFi() {
  Serial.print("Connecting to WiFi...");
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.print(".");
  }
  Serial.println("Connected!");
  startCameraServer();
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
