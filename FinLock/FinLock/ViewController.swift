//
//  ViewController.swift
//  FinLock
//
//  Created by Vardhan Chopada on 10/7/23.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var countries: [Country] = []
    var cities: [String] = []
    var cityCache: [String: [String]] = [:]
    let activityIndicator = UIActivityIndicatorView(style: .large)
    
    
    @IBOutlet weak var doneButtonA: UIButton!
    @IBOutlet weak var doneButtonB: UIButton!
    @IBOutlet weak var countryPickerView: UIPickerView!
    @IBOutlet weak var cityPickerView: UIPickerView!
    
    @IBAction func doneButton1(_ sender: Any) {
        let selectedRow = countryPickerView.selectedRow(inComponent: 0)
        countryPickerView.selectRow(selectedRow, inComponent: 0, animated: false)
        countryPickerView.delegate?.pickerView?(countryPickerView, didSelectRow: selectedRow, inComponent: 0)
        activityIndicator.startAnimating()
        cityPickerView.reloadAllComponents()
    }
    @IBAction func doneButton2(_ sender: Any) {
        print("Done")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countryPickerView.dataSource = self
        countryPickerView.delegate = self
        cityPickerView.dataSource = self
        cityPickerView.delegate = self
        
        countryPickerView.isHidden = true
        cityPickerView.isHidden = true
        doneButtonA.isHidden = true
        doneButtonB.isHidden = true
        
        
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        
        CountryService().fetchCountries { [weak self] countries in
            if let countries = countries {
                self?.countries = countries
                DispatchQueue.main.async {
                    self?.countryPickerView.reloadAllComponents()
                    self?.activityIndicator.stopAnimating()
                    self?.countryPickerView.isHidden = false
                    self?.doneButtonA.isHidden = false
                    
                }
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == countryPickerView {
            return countries.count
        } else if pickerView == cityPickerView {
            return cities.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == countryPickerView {
            return countries[row].country
        } else if pickerView == cityPickerView {
            return cities[row]
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == countryPickerView {
            let selectedCountry = countries[row].country
            activityIndicator.startAnimating()

            if let cachedCities = cityCache[selectedCountry] {
                cities = cachedCities
                cityPickerView.reloadAllComponents()
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
                cityPickerView.isHidden = false
                doneButtonB.isHidden = false
            } else {
                CountryService().fetchCitiesForCountry(selectedCountry) { [weak self] (cities) in
                    if let cities = cities {
                        self?.cities = cities
                        
                        self?.cityCache[selectedCountry] = cities
                        
                        DispatchQueue.main.async {
                            self?.cityPickerView.reloadAllComponents()
                            self?.activityIndicator.stopAnimating()
                            self?.cityPickerView.isHidden = false
                            self?.doneButtonB.isHidden = false
                        }
                    }
                }
            }
        }
    }
    
    
}

