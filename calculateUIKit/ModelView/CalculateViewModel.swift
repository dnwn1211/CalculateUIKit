import Foundation

class CalculatorViewModel {
    private var model = CalculatorModel()
    var updateDisplay: ((String, String) -> Void)?
    
    init() {
        updateDisplay?(model.displayText, model.historyText)
    }
    
    func buttonTapped(_ title: String) {
        if title == "AC" {
            model.clear()
        } else {
            model.updateDisplayText(with: title)
        }
        
        updateDisplay?(model.displayText, model.historyText)
    }
}
