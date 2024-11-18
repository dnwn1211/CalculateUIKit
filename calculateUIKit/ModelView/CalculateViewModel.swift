import Foundation

class CalculatorViewModel {
    private var model = CalculatorModel()
    
    // UI 업데이트를 위한 클로저
    var updateDisplay: ((String) -> Void)?
    
    init() {
        updateDisplay?(model.displayText)
    }
    
    func buttonTapped(_ title: String) {
        if title == "AC" {
            model.clear()
        } else {
            model.updateDisplayText(with: title)
        }
        
        // ViewController로 결과를 업데이트
        updateDisplay?(model.displayText)
    }
}
