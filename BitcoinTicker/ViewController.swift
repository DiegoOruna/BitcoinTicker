import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    
    var baseURLBitcoin = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    var baseURLEthereum = "https://apiv2.bitcoinaverage.com/indices/global/ticker/ETH"
    //Default
    var baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    @objc var baseURL2 = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let currencySymbol = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    var currencySelected = "AUD"
    var moneySelected = ""
    var finalURL = ""

    //Pre-setup IBOutlets
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var segmented: UISegmentedControl!
    
    @IBAction func segmentedControl(_ sender: UISegmentedControl) {
        let selected = segmented.selectedSegmentIndex
        print(selected)
        if selected == 0 {
            baseURL = baseURLBitcoin + currencySelected
            getBitcoinData(url: baseURL)
            print(baseURL)
        }else{
            baseURL = baseURLEthereum + currencySelected
            getBitcoinData(url: baseURL)
            print(baseURL)
        }
        
    }
    
    //IBLabels
    @IBOutlet weak var Last: UILabel!
    @IBOutlet weak var Ask: UILabel!
    @IBOutlet weak var Bid: UILabel!
    @IBOutlet weak var High: UILabel!
    @IBOutlet weak var Low: UILabel!
    
    @IBOutlet weak var firstUIView: UIView!
    @IBOutlet weak var secondUIView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
        getBitcoinData(url: "\(baseURLBitcoin)AUD")
        setupUI()
        
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        finalURL = baseURL2 + currencyArray[row]
        getBitcoinData(url: finalURL)
        
        //Get Current Positions
        currencySelected = currencyArray[row]
        moneySelected = currencySymbol[row]
        
        print(finalURL)
    }
    
    func getBitcoinData(url:String){
        Alamofire.request(url, method : .get).responseJSON { response in
            if response.result.isSuccess {
                let bitcoinResults:JSON = JSON(response.result.value!)
                print("\(response.result.value!)")
                self.updateBitcoinData(json: bitcoinResults)
            }else{
                print("There was an error in getBitcoinData")
            }
        }
    }
    
    func updateBitcoinData(json:JSON) {
        if let bitcoinResult = json["last"].double {
            Last.text = moneySelected + String(bitcoinResult.rounded(toPlaces: 1).withCommas())
        }else{
            
        }
        if let bitcoinResult = json["ask"].double {
            Ask.text = moneySelected + String(bitcoinResult.rounded(toPlaces: 1).withCommas())
        }else{
            
        }
        if let bitcoinResult = json["bid"].double {
            Bid.text = moneySelected + String(bitcoinResult.rounded(toPlaces: 1).withCommas())
        }else{
            
        }
        if let bitcoinResult = json["high"].double {
            High.text = moneySelected + String(bitcoinResult.rounded(toPlaces: 1).withCommas())
        }else{
            
        }
        if let bitcoinResult = json["low"].double {
            Low.text = moneySelected + String(bitcoinResult.rounded(toPlaces: 1).withCommas())
        }else{
            
        }
    }
    
    func setupUI(){
        firstUIView.layer.shadowColor = UIColor.black.cgColor
        firstUIView.layer.shadowOpacity = 1
        firstUIView.layer.shadowOffset = CGSize.zero
        firstUIView.layer.shadowRadius = 10
        
        //        firstUIView.layer.borderColor = UIColor.black.cgColor
        //        firstUIView.layer.borderWidth  = 1.0
        //        firstUIView.layer.cornerRadius = 5;
        //        firstUIView.layer.masksToBounds = true;
        secondUIView.layer.shadowColor = UIColor.black.cgColor
        secondUIView.layer.shadowOpacity = 1
        secondUIView.layer.shadowOffset = CGSize.zero
        secondUIView.layer.shadowRadius = 10
    }

}

extension Double {
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        return numberFormatter.string(from: NSNumber(value:self))!
    }
    
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
