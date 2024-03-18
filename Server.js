const express = require('express');
const bodyParser = require('body-parser');

const app = express();

// Sử dụng bodyParser để phân tích dữ liệu từ POST request
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

let locationData = []; // Biến để lưu trữ dữ liệu vị trí

app.post('/update_location', (req, res) => {
    const { latitude, longitude } = req.body;
    console.log('Received location data:', { latitude, longitude });

    // Lưu dữ liệu vị trí vào biến locationData
    locationData.push({ latitude, longitude });

    // Phản hồi với mã trạng thái 200 (OK)
    res.status(200).send('Location data received successfully');
});

app.get('/get_location', (req, res) => {
    // Trả về dữ liệu vị trí đã lưu
    res.status(200).json(locationData);
});

const PORT = 3000
app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});
