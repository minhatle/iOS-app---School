//
//  ViewController.swift
//  MinhLe_WeatherAPI
//
//  Created by Minh Le on 2021-04-03.
//

import UIKit
import Combine

class ViewController: UIViewController{

    @IBOutlet var countryLabel : UILabel!
    @IBOutlet var weatherLabel : UILabel!
    @IBOutlet var temperatureLabel : UILabel!
    @IBOutlet var feelslikeLabel : UILabel!
    @IBOutlet var wind_kphLabel : UILabel!
    @IBOutlet var wind_dirLabel : UILabel!
    @IBOutlet var uvLabel : UILabel!
    
    @IBOutlet weak var pkrCountry : UIPickerView!
    let countryList = ["Canada", "America", "England", "China", "Vietnam", "Russia", "Japan", "France", "Brazil", "Italy"]
    
    var selectedCountry : String = ""
    
    private let launchesFetcher = LaunchesFetcher.getInstance()
    private var weatherList : Weather = Weather()
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.pkrCountry.dataSource = self
        self.pkrCountry.delegate = self
        
        countryLabel.text = "simple weather"
        weatherLabel.text = ""
        temperatureLabel.text = ""
        feelslikeLabel.text = ""
        wind_kphLabel.text = ""
        wind_dirLabel.text = ""
        uvLabel.text = ""
 
    }

    private func receiveChanges(){
        self.launchesFetcher.$weatherList.receive(on: RunLoop.main)
            .sink{(launch) in
            print(#function, "Received Launch: ", launch)
                
                self.temperatureLabel.text = "\(launch.current_temp_c)"
                self.feelslikeLabel.text = "\(launch.current_feelslike_c)"
                self.wind_kphLabel.text = "\(launch.current_wind_kph)"
                self.wind_dirLabel.text = "\(launch.current_wind_dir)"
                self.uvLabel.text = "\(launch.current_uv)"
            }
            .store(in: &cancellables)
        
        countryLabel.text = "\(self.selectedCountry)"
        
    }
    
    @IBAction func confirmButton(){
        self.launchesFetcher.fetchDataFromAPI(country: selectedCountry)
        self.receiveChanges()
    }
}

extension ViewController : UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.countryList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.countryList[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(#function, "Selected Country: \(self.countryList[row])")
        selectedCountry = self.countryList[row]
    }
}
