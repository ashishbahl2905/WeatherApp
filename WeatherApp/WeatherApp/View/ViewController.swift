//
//  ViewController.swift
//  WeatherApp
//
//  Created by Ashish Bahl on 28/07/25.
//

import UIKit
import CoreLocation

// MARK: Protocols

protocol WeatherServiceProtocol {
    func fetchWeather(for city: String) async throws -> WeatherResponse
    func fetchWeatherByCoordinates(lat: Double, lon: Double) async throws -> WeatherResponse
}

class ViewController: UIViewController {
    
    // MARK: Variables
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let cityTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = Constants.ENTER_CITY
        textField.borderStyle = .none
        textField.clearButtonMode = .whileEditing
        if let clearButton = textField.value(forKey: "_clearButton") as? UIButton {
            clearButton.tintColor = .darkGray
            clearButton.setImage(clearButton.image(for: .normal)?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
        textField.backgroundColor = .clear
        textField.textColor = .black
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: 29, width: UIScreen.main.bounds.width - 80, height: 1)
        bottomLine.backgroundColor = UIColor.lightGray.cgColor
        textField.layer.addSublayer(bottomLine)
        return textField
    }()

    private let locationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "location.circle.fill"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let getWeatherButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constants.GET_WEATHER, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let weatherInfoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let weatherIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let refreshControl = UIRefreshControl()
    private let scrollView = UIScrollView()
    private let viewModel = WeatherViewModel()
    private let locationManager = CLLocationManager()

    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        loadLastSearchedCity()
        getWeatherButton.addTarget(self, action: #selector(getWeatherTapped), for: .touchUpInside)
        locationButton.addTarget(self, action: #selector(requestLocation), for: .touchUpInside)
        locationManager.delegate = self
    }
    
    // MARK: Setup UI
    private func setupUI() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        scrollView.addGestureRecognizer(tapGesture)
        scrollView.isUserInteractionEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        scrollView.refreshControl = refreshControl
        view.addSubview(scrollView)
        scrollView.addSubview(backgroundImageView)
        scrollView.addSubview(cityTextField)
        scrollView.addSubview(locationButton)
        scrollView.addSubview(getWeatherButton)
        scrollView.addSubview(weatherIcon)
        scrollView.addSubview(weatherInfoLabel)
        cityTextField.delegate = self
        backgroundImageView.image = UIImage(named: "Default")
        refreshControl.addTarget(self, action: #selector(refreshWeather), for: .valueChanged)
        scrollView.bringSubviewToFront(refreshControl)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            cityTextField.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 40),
            cityTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cityTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),

            locationButton.centerYAnchor.constraint(equalTo: cityTextField.centerYAnchor),
            locationButton.leadingAnchor.constraint(equalTo: cityTextField.trailingAnchor, constant: 8),
            locationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            locationButton.widthAnchor.constraint(equalToConstant: 30),
            locationButton.heightAnchor.constraint(equalToConstant: 30),

            getWeatherButton.topAnchor.constraint(equalTo: cityTextField.bottomAnchor, constant: 20),
            getWeatherButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),

            weatherIcon.topAnchor.constraint(equalTo: getWeatherButton.bottomAnchor, constant: 40),
            weatherIcon.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            weatherIcon.heightAnchor.constraint(equalToConstant: 100),
            weatherIcon.widthAnchor.constraint(equalToConstant: 100),

            weatherInfoLabel.topAnchor.constraint(equalTo: weatherIcon.bottomAnchor, constant: 20),
            weatherInfoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            weatherInfoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            weatherInfoLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20)
        ])
    }

    // MARK: Get weather tap
    @objc private func getWeatherTapped() {
        guard let city = cityTextField.text, !city.isEmpty else {
            showAlert(message: Constants.EMPTY_CITY_NAME)
            return
        }
        fetchWeather(for: city)
    }

    // MARK: Refresh weather
    @objc private func refreshWeather() {
        guard let city = cityTextField.text, !city.isEmpty else {
            refreshControl.endRefreshing()
            return
        }
        fetchWeather(for: city)
    }

    // MARK: Fetch Weather
    private func fetchWeather(for city: String) {
        Task {
            do {
                let weather = try await viewModel.fetchWeather(for: city)
                Task { [weak self] in
                    guard let self else { return }
                    UserDefaults.standard.set(city, forKey: Constants.LAST_SEARCHED_CITY)
                    weatherInfoLabel.text = "\(weather.name)\nTemp: \(Int(weather.main.temp))°C\nCondition: \(weather.weather.first?.main ?? "N/A")"
                    if let icon = weather.weather.first?.icon {
                        do {
                            try await weatherIcon.loadImage(from: Constants.IMAGE_BASE_URL + "\(icon)@2x.png")
                        } catch {
                            print("Image loading error: \(error)")
                        }
                        guard let imageDesc = weather.weather.first?.main.description else { return }
                        if imageDesc == "Clear" || imageDesc == "Sunny" {
                            weatherIcon.isHidden = true
                        } else {
                            weatherIcon.isHidden = false
                        }
                        setupBackground(weatherType: imageDesc)
                        setupColor(weatherType: imageDesc)
                    }
                    refreshControl.endRefreshing()
                }
            } catch {
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                    self.showAlert(message: error.localizedDescription)
                }
            }
        }
    }

    // MARK: Fetch Weather with co-ords
    private func fetchWeatherByCoordinates(lat: Double, lon: Double) {
        Task {
            do {
                let weather = try await viewModel.fetchWeatherByCoordinates(lat: lat, lon: lon)
                Task {
                    self.cityTextField.text = weather.name
                    self.weatherInfoLabel.text = "\(weather.name)\nTemp: \(Int(weather.main.temp))°C\nCondition: \(weather.weather.first?.main ?? "N/A")"
                    if let icon = weather.weather.first?.icon {
                        do {
                            try await weatherIcon.loadImage(from: Constants.IMAGE_BASE_URL + "\(icon)@2x.png")
                        } catch {
                            print("Image loading error: \(error)")
                        }
                        self.setupBackground(weatherType: weather.weather.first?.main.description ?? "")
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.showAlert(message: error.localizedDescription)
                }
            }
        }
    }

    // MARK: Set backgroundimage
    private func setupBackground(weatherType: String) {
        if let type = WeatherType(rawValue: weatherType) {
            backgroundImageView.image = UIImage(named: type.imageName)
        }
    }
    
    // MARK: Set color
    private func setupColor(weatherType: String) {
        if let type = WeatherType(rawValue: weatherType),
           let clearButton = cityTextField.value(forKey: "_clearButton") as? UIButton {
            weatherInfoLabel.textColor = type.textColor
            cityTextField.textColor = type.textColor
            getWeatherButton.tintColor = type.textColor
            let attributes = [NSAttributedString.Key.foregroundColor: type.textColor]
            refreshControl.attributedTitle = NSAttributedString(string: Constants.PULL_TO_REFRESH_TEXT, attributes: attributes)
            refreshControl.tintColor = type.textColor
            cityTextField.attributedPlaceholder = NSAttributedString(
                string: Constants.ENTER_CITY,
                attributes: [NSAttributedString.Key.foregroundColor: type.textColor]
            )
            clearButton.tintColor = type.textColor
            clearButton.setImage(clearButton.image(for: .normal)?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
    }
    
    // MARK: Request Location
    @objc private func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        locationManager.startUpdatingLocation()
    }

    // MARK: Tap gesture
    @objc private func handleTapGesture() {
        view.endEditing(true)
    }
    
    // MARK: Load last searched city
    private func loadLastSearchedCity() {
        if let lastCity = UserDefaults.standard.string(forKey: Constants.LAST_SEARCHED_CITY) {
            cityTextField.text = lastCity
            fetchWeather(for: lastCity)
        }
    }

    // MARK: Show alert
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first,
        let text = cityTextField.text else { return }
        if let lastCity = UserDefaults.standard.string(forKey: Constants.LAST_SEARCHED_CITY) {
            if text == lastCity {
                return
            }
        }
        fetchWeatherByCoordinates(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        showAlert(message: Constants.FAILED_TO_GET_LOCATION + "\(error.localizedDescription)")
    }
}

// MARK: UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        guard let text = textField.text else { return false }
        fetchWeather(for: text)
        return true
    }
}
