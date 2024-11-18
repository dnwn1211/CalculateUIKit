import Foundation

class CalculatorModel {
    private var inputValue: String = "0"
    private var previousValue: Double? = nil
    private var currentOperator: String? = nil
    var historyText: String = "" // 계산 진행사항
    
    var displayText: String {
        return inputValue
    }
    
    func updateDisplayText(with input: String) {
        if let _ = Double(input) {
            // 숫자 입력 처리
            if inputValue == "0" {
                inputValue = input
            } else {
                inputValue += input
            }
        } else if input == "=" {
            // "=" 입력 시 결과 계산
            calculateResult()
        } else {
            // 연산자 처리
            handleOperator(input)
        }
        
        // 계산 진행사항 업데이트
        if input != "=" {
            historyText += input + " "
        }
    }
    
    private func calculateResult() {
        guard let operatorSymbol = currentOperator,
              let previous = previousValue,
              let current = Double(inputValue) else { return }
        
        let result: Double
        
        // 사칙연산 처리
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
        
        // 결과 갱신
        inputValue = String(result)
        previousValue = result // 결과를 이전 값으로 저장
        currentOperator = nil // 현재 연산자 초기화
    }
    
    private func handleOperator(_ operatorSymbol: String) {
        if let current = Double(inputValue) {
            if let _ = previousValue {
                // 이전 값이 있을 경우 중간 계산 실행
                calculateResult()
            } else {
                // 이전 값이 없으면 현재 값을 저장
                previousValue = current
            }
        }
        currentOperator = operatorSymbol // 새로운 연산자를 저장
        inputValue = "0" // 새로운 입력을 위해 초기화
    }
    
    func clear() {
        inputValue = "0"
        previousValue = nil
        currentOperator = nil
        historyText = ""
    }
}
