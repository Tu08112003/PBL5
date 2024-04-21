const express = require('express');
const bodyParser = require('body-parser');
const http = require('http');
const WebSocket = require('ws');

const app = express();
const server = http.createServer(app);
const wss = new WebSocket.Server({ server });

let locationData = null;

app.use(bodyParser.urlencoded({ extended: true }));

// Lắng nghe sự kiện kết nối mới từ client
wss.on('connection', (ws) => {
    // Gửi dữ liệu vị trí hiện tại cho client mới kết nối
    if (locationData !== null) {
        ws.send(JSON.stringify(locationData));
    }

    // Lắng nghe sự kiện đóng kết nối từ client
    ws.on('close', () => {
        console.log('Client disconnected');
    });
});

// Hàm gửi dữ liệu mới đến tất cả các client thông qua WebSocket
function sendLocationUpdate() {
    wss.clients.forEach(function each(client) {
        if (client.readyState === WebSocket.OPEN) {
            client.send(JSON.stringify(locationData));
        }
    });
}

app.post('/send_location', (req, res) => {
    const { latitude, longitude } = req.body;
    console.log('Received location data:', { latitude, longitude });
    locationData = { latitude, longitude };
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
