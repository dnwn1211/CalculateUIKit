import Foundation

struct CalculatorModel {
    var displayText: String = "0"
    
    mutating func updateDisplayText(with input: String) {
        if displayText == "0" {
            displayText = input
        } else {
            displayText.append(input)
        }
    }
    
    mutating func clear() {
        displayText = "0"
    }
}
