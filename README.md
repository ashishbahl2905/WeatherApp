# 🌦 WeatherApp (UIKit + MVVM)

A beautiful and functional weather app built using UIKit, MVVM architecture, and OpenWeatherMap API. This app allows users to search for current weather by city name or fetch weather data based on their current location.

---

## 📱 Features

- 🔍 Search for weather by city
- 📍 Fetch weather using current location
- 🔄 Pull-to-refresh
- 💾 Auto-load last searched city (UserDefaults)
- 📡 Asynchronous networking with Swift concurrency (async/await)
- 🎨 Fully programmatic UIKit UI with modern design
- ❌ Clear text field button and animated weather icons
- 🧪 Includes unit tests with mocks for ViewModel and Service layers

---

## 📸 Screenshots
<img width="828px" height="1792px" alt="IMG_7180" src="https://github.com/user-attachments/assets/1c8e77b9-e280-4b5f-9e2c-03d01653ef4d" />
<img width="828px" height="1792px" alt="IMG_7181" src="https://github.com/user-attachments/assets/e4000e6e-e78b-4c41-858d-5cf337a2fa25" />
<img width="828px" height="1792px" alt="IMG_7184" src="https://github.com/user-attachments/assets/00833abc-a849-4bcb-8683-443fe5023cca" />
<img width="828px" height="1792px" alt="IMG_7185" src="https://github.com/user-attachments/assets/7cc6ef92-08bf-47e9-a828-80c5b25954ce" />
<img width="828px" height="1792px" alt="IMG_7186" src="https://github.com/user-attachments/assets/fc8f4831-b29c-4816-afed-7a9e17c8d361" />
<img width="828px" height="1792px" alt="IMG_7189" src="https://github.com/user-attachments/assets/8166f057-68dd-464c-a262-d0c959039338" />

---

## 🧑‍💻 Technologies Used

- Swift
- UIKit
- MVVM Architecture
- URLSession + async/await
- CoreLocation
- XCTest

---

## 🔧 Setup Instructions

1. **Clone the Repository**

```bash
git clone https://github.com/ashishbahl2905/WeatherApp.git
cd WeatherApp
```

2. **Open in Xcode**

```bash
open WeatherApp.xcodeproj
```

3. **Insert Your API Key** Replace the API_KEY in `Constants.swift` with your OpenWeatherMap API key:

```swift
public static let API_KEY = "Enter your api key"
```
[Get your API key here](https://openweathermap.org/api)

4. **Run the App** Choose a simulator or physical device and hit ⌘ + R

---

## 🧪 Running Tests

- Open the `WeatherApp.xcodeproj`
- Select the test target `WeatherAppTests`
- Press ⌘ + U to run all unit tests

---

## 📦 Folder Structure

```
WeatherApp/
├── Controllers/
├── Models/
├── Services/
├── ViewModels/
├── Views/
├── Extensions/
├── Tests/
└── Resources/
```
---

## 📄 License

MIT License © 2025 Ashish Bahl

---

## 🙋‍♂️ Author

Ashish Bahl\
GitHub: [@ashishbahl](https://github.com/ashishbahl2905)

---

Happy coding! 🚀

