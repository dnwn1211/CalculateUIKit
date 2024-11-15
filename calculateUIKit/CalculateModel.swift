import Foundation

class CalculatorModel {
    private var inputValue: String = "0" // 현재 입력 중인 숫자
    private var previousValue: Double? = nil // 이전에 입력된 값
    private var currentOperator: String? = nil // 현재 선택된 연산자
    var displayText: String {
        return inputValue
    }
    
    // 숫자 또는 연산자를 추가하는 메서드
    func updateDisplayText(with input: String) {
        if let _ = Double(input) {
            // 숫자 입력일 경우
            if inputValue == "0" {
                inputValue = input
            } else {
                inputValue += input
            }
        } else if input == "=" {
            calculateResult()
        } else {
            // 연산자 입력일 경우
            handleOperator(input)
        }
    }
    
    // 사칙연산 결과를 계산하는 메서드
    private func calculateResult() {
        guard let operatorSymbol = currentOperator,
              let previous = previousValue,
              let current = Double(inputValue) else { return }
        
        let result: Double
        
        switch operatorSymbol {
        case "+":
            result = previous + current
        case "-":
            result = previous - current
        case "*":
            result = previous * current
        case "/":
            result = previous / current
        default:
            return
        }
        
        inputValue = String(result)
        previousValue = nil
        currentOperator = nil
    }
    
    // 연산자를 처리하는 메서드
    private func handleOperator(_ operatorSymbol: String) {
        if let current = Double(inputValue) {
            previousValue = current
            inputValue = "0"
        }
        currentOperator = operatorSymbol
    }
    
    // AC 버튼이 눌릴 때 초기화하는 메서드
    func clear() {
        inputValue = "0"
        previousValue = nil
        currentOperator = nil
    }
}
