import torch
import numpy as np
import cv2
from time import time
import requests
from ultralytics import YOLO
import supervision as sv
import urequests
import json
class ObjectDetection:

    def __init__(self, url=None):
        self.url = url
        self.device = 'cuda' if torch.cuda.is_available() else 'cpu'
        print("Using Device: ", self.device)
        self.model = self.load_model()
        self.CLASS_NAMES_DICT = self.model.model.names
        self.box_annotator = sv.BoxAnnotator(sv.ColorPalette.default(), thickness=3, text_thickness=3, text_scale=1.5)
    
    def load_model(self):
        model = YOLO("F:\\PBL5\\best.pt")  
        model.fuse()
        return model

    def predict(self, frame):
        results = self.model(frame)
        return results
    
    def plot_bboxes(self, results, frame):
        xyxys = []
        confidences = []
        class_ids = [] 
        
        # Extract detections for person class
        for result in results:
            boxes = result.boxes.cpu().numpy()
            if len(boxes) > 0:
                class_id = boxes.cls[0]
                conf = boxes.conf[0]
                xyxy = boxes.xyxy[0]

                if class_id == 0.0:
                    xyxys.append(result.boxes.xyxy.cpu().numpy())
                    confidences.append(result.boxes.conf.cpu().numpy())
                    class_ids.append(result.boxes.cls.cpu().numpy().astype(int))
            
        # Setup detections for visualization
        detections = sv.Detections(
            xyxy=results[0].boxes.xyxy.cpu().numpy(),
            confidence=results[0].boxes.conf.cpu().numpy(),
            class_id=results[0].boxes.cls.cpu().numpy().astype(int),
        )
    
        # Format custom labels
        self.labels = [f"{self.CLASS_NAMES_DICT[class_id]} {confidence:0.2f}"
                       for confidence, class_id in zip(detections.confidence, detections.class_id)]
        print(self.labels)
        send_detection_result(self.labels)
        # Annotate and display frame
        frame = self.box_annotator.annotate(scene=frame, detections=detections, labels=self.labels)
        return frame
    
    def __call__(self):
        if self.url:
            while True:
                start_time = time()
                response = requests.get(self.url)
                if response.status_code == 200:
                    byte_data = response.content
                    nparr = np.frombuffer(byte_data, np.uint8)
                    frame = cv2.imdecode(nparr, cv2.IMREAD_COLOR)
                    results = self.predict(frame)
                    frame = self.plot_bboxes(results, frame)
                    end_time = time()
                    fps = 1/np.round(end_time - start_time, 2)
                    cv2.putText(frame, f'FPS: {int(fps)}', (20,70), cv2.FONT_HERSHEY_SIMPLEX, 1.5, (0,255,0), 2)
                    cv2.imshow('Object Detection', frame)
                    if cv2.waitKey(5) & 0xFF == 27:
                        break
                else:
                    print("Failed to fetch frame.")
                    break
        else:
            raise ValueError("URL must be provided.")


# Hàm gửi kết quả nhận dạng về ESP32
def send_detection_result(results):
    # Danh sách các nhãn cần lọc
    labels_to_filter = ["table","sharps","person","stair","carriage","door","chair","wall"]
    
    # Lọc chỉ những nhãn thuộc danh sách cần lọc
    filtered_results = [result.split(' ')[0] for result in results if any(label in result for label in labels_to_filter)]

    # Địa chỉ IP của ESP32
    server_address = "http://192.168.1.5/detection"
    print(filtered_results)
    result={"result":filtered_results}
    try:
        response = requests.get(server_address, params=result)
        print("HTTP Response code:", response.status_code)
    except Exception as e:
        print("Error:", e)



# Sử dụng ESP32-CAM qua URL
url = 'http://192.168.43.179/cam-custom.jpg'  # Đường link ảnh từ ESP32
detector = ObjectDetection(url=url)
detector()

