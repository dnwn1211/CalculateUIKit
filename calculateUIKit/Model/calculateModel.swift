import Foundation

class CalculatorModel {
    private var inputValue: String = "0" // 현재 입력 값
    var historyText: String = "" // 계산 진행사항
    
    var displayText: String {
        return inputValue
    }
    
    func updateDisplayText(with input: String) {
        if let _ = Double(input) {
            // 숫자 입력 처리
            if inputValue == "0" || inputValue == "" {
                inputValue = input
            } else {
                inputValue += input
            }
        } else if input == "=" {
            // 계산 결과 처리
            finalizeResult()
        } else if isOperator(input) {
            // 연산자 처리
            handleOperator(input)
        } else {
            // 잘못된 입력은 무시
            return
        }
        
        // 계산 진행사항 업데이트
        if input != "=" {
            historyText += input + " "
        }
    }
    
    private func handleOperator(_ operatorSymbol: String) {
        // 연산자를 추가하면서 입력값을 업데이트
        if inputValue.last?.isNumber == true {
            inputValue += " \(operatorSymbol) "
        }
    }
    
    private func finalizeResult() {
        do {
            // `NSExpression`을 사용해 수식을 계산
            let result = try calculate(expression: inputValue)
            inputValue = String(result)
            historyText = "" // 계산 완료 후 진행사항 초기화
        } catch {
            inputValue = "Error"
            historyText = "Invalid Expression"
        }
    }
    
    private func calculate(expression: String) throws -> Double {
        // `NSExpression`을 사용하여 수식을 평가
        let formattedExpression = NSExpression(format: expression)
        if let result = formattedExpression.expressionValue(with: nil, context: nil) as? Double {
            return result
        } else {
            throw NSError(domain: "CalculatorError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid expression"])
        }
    }
    
    private func isOperator(_ input: String) -> Bool {
        return input == "+" || input == "-" || input == "*" || input == "/"
    }
    
    func clear() {
        inputValue = "0"
        historyText = ""
    }
}
