import Foundation

class CalculatorViewModel {
    private var model = CalculatorModel()
    
    // ViewController에서 구독할 수 있는 UI 업데이트 클로저
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
        
        // ViewController로 결과를 보내기
        updateDisplay?(model.displayText)
    }
}
