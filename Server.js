const express = require('express');
const bodyParser = require('body-parser');
const http = require('http');
const WebSocket = require('ws');

const app = express();
const server = http.createServer(app);
const wss = new WebSocket.Server({ server });

let locationData = null;
let ipData = null;
app.use(bodyParser.urlencoded({ extended: true }));

// Lắng nghe sự kiện kết nối mới từ client
wss.on('connection', (ws) => {
    // Gửi dữ liệu vị trí hiện tại cho client mới kết nối
     const combinedData = {
         location: locationData,
         ip: ipData // Assuming ipData is an object with 'ip' property
    };
    console.log(combinedData);
     ws.send(JSON.stringify(combinedData));

    // console.log("Chưa gửi")

    // Lắng nghe sự kiện đóng kết nối từ client
    ws.on("close", () => {
        console.log("Client disconnected");
    });
});

// Hàm gửi dữ liệu mới đến tất cả các client thông qua WebSocket
function sendLocationUpdate() {
        const combinedData = {
            location: locationData,
            ip: ipData, // Assuming ipData is an object with 'ip' property
    };
    console.log(combinedData)
}

app.post('/send_ip_esp', (req, res) => {
    const {ip} = req.body;
    console.log('Received ip data:', {ip});
    ipData = { ip }
    // // Gửi thông báo cập nhật đến tất cả các client
    // sendLocationUpdate();
    res.status(200).send('ip data received successfully');
});

app.post('/send_location', (req, res) => {
    const { latitude, longitude} = req.body;
    console.log('Received location data:', { latitude, longitude});
    locationData = { latitude, longitude };
    // console.log(locationData)
    // Gửi thông báo cập nhật đến tất cả các client
    sendLocationUpdate();
    res.status(200).send('Location data received successfully');
});

app.get('/get_location', (req, res) => {
    res.status(200).json(locationData);
});

const PORT = 3000;
server.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});
