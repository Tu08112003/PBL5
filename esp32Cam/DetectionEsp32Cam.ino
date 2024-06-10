#include <WebServer.h>
#include <WiFi.h>
#include <esp32cam.h>
#include <DFRobotDFPlayerMini.h>

#define RX_PIN 3 // Tx cua mp3 noi voi RX(Gipo3) cua Esp32-cam
#define TX_PIN 1 // Rx cua mp3 noi voi TX(Gipo3) cua Esp32-cam

HardwareSerial mySerial(2); // su dung cong serial 2 tren esp32 
DFRobotDFPlayerMini myDFPlayer; //khoi tao doi tuong dfplay
//Map ten bai hat theo chi muc trong the SD
const int NUM_SONGS = 10;
const char* songNames[NUM_SONGS] = {"table","sharps","person","stair","carriage","door","chair","wall"};


// const char* WIFI_SSID = "DHBK 412 N4 2.4G";
// const char* WIFI_PASS = "hoilamgi";
 
const char* WIFI_SSID = "?";
const char* WIFI_PASS = "12346789";
 


WebServer server(80);
 
static auto loRes = esp32cam::Resolution::find(770, 440);
static auto midRes = esp32cam::Resolution::find(660, 420);
static auto hiRes = esp32cam::Resolution::find(900, 700);
static auto customRes = esp32cam::Resolution::find(750, 500);  // Độ phân giải tùy chỉnh

void serveJpg()

{
  auto frame = esp32cam::capture();
  if (frame == nullptr) {
    Serial.println("CAPTURE FAIL");
    server.send(503, "", "");
    return;
  }
  Serial.printf("CAPTURE OK %dx%d %db\n", frame->getWidth(), frame->getHeight(),
                static_cast<int>(frame->size()));
 
  server.setContentLength(frame->size());
  server.send(200, "image/jpeg");
  WiFiClient client = server.client();
  frame->writeTo(client);
}
 
void handleJpgLo()
{
  if (!esp32cam::Camera.changeResolution(loRes)) {
    Serial.println("SET-LO-RES FAIL");
  }
  serveJpg();
}
 
void handleJpgHi()
{
  if (!esp32cam::Camera.changeResolution(hiRes)) {
    Serial.println("SET-HI-RES FAIL");
  }
  serveJpg();
}
 
void handleJpgMid()
{
  if (!esp32cam::Camera.changeResolution(midRes)) {
    Serial.println("SET-MID-RES FAIL");
  }
  serveJpg();
}

void handleJpgCustom()
{
  if (!esp32cam::Camera.changeResolution(customRes)) {
    Serial.println("SET-CUSTOM-RES FAIL");
  }
  serveJpg();
}

void playSongByName(const char* songName)
{
  for(int i = 0;i< NUM_SONGS;i++)
  {
    if(strcmp(songNames[i],songName) == 0)
    {
       myDFPlayer.play(i+1);
       return;
    }
  }
  
}
unsigned long timer = 0;
String result;
void handleDetection() 
{
  if (server.method() == HTTP_GET) {
     if (server.hasArg("result")) {
      result = server.arg("result");
      Serial.println("result: " + result);
      server.send(200, "text/plain", "OK");
     }
     else
     {
      server.send(404, "text/plain", " Not Objection");
     }
  } else {
    server.send(405, "text/plain", "Method Not Allowed");
  }
}

void setup(){
  Serial.begin(115200);

  Serial.println();
  {
    using namespace esp32cam;
    Config cfg;
    cfg.setPins(pins::AiThinker);
    cfg.setResolution(hiRes); // Sử dụng độ phân giải cao làm mặc định
    cfg.setBufferCount(2);
    cfg.setJpeg(80);
 
    bool ok = Camera.begin(cfg);
    Serial.println(ok ? "CAMERA OK" : "CAMERA FAIL");
  }
  WiFi.persistent(false);
  WiFi.mode(WIFI_STA);
  WiFi.begin(WIFI_SSID, WIFI_PASS);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
  }
  Serial.print("http://");
  Serial.println(WiFi.localIP());
  Serial.println("  /cam-lo.jpg");
  Serial.println("  /cam-hi.jpg");
  Serial.println("  /cam-mid.jpg");
  Serial.println("  /cam-custom.jpg");  // Thêm đường dẫn cho khung hình tùy chỉnh
 
  server.on("/cam-lo.jpg", handleJpgLo);
  server.on("/cam-hi.jpg", handleJpgHi);
  server.on("/cam-mid.jpg", handleJpgMid);
  server.on("/cam-custom.jpg", handleJpgCustom);  // Đường dẫn cho khung hình tùy chỉnh

  server.on("/detection", handleDetection);
  
  server.begin();
  delay(500);
  
  Serial.setDebugOutput(true);
  mySerial.begin(9600, SERIAL_8N1, RX_PIN, TX_PIN); // Bắt đầu giao tiếp serial với tốc độ 9600 bps
  myDFPlayer.begin(mySerial); // Bắt đầu sử dụng DFPlayer Mini với đối tượng Serial đã khởi tạo
  myDFPlayer.volume(30);  // Đặt mức âm lượng (0~30).
}


void loop()
{
  server.handleClient();
  if ((millis() - timer > 3000) && (result.length() > 0))
  {
    playSongByName(result.c_str());
    timer = millis();
    result = ""; // Gán chuỗi rỗng cho result
  }
}