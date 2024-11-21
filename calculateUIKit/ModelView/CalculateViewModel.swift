import Foundation

// CalculatorViewModel: View와 Model 사이를 연결하는 역할을 하는 클래스
class CalculatorViewModel {
    // CalculatorModel 인스턴스 생성 (Model 부분)
    private var model = CalculatorModel()
    
    // 클로저를 사용하여 View의 UI를 업데이트
    var updateDisplay: ((String, String) -> Void)?
    
    // 초기화 메서드
    init() {
        // 초기화 시, Model의 초기 상태를 View에 전달
        updateDisplay?(model.displayText, model.historyText)
    }
    
    // 버튼이 눌렸을 때 호출되는 메서드
    func buttonTapped(_ title: String) {
        if title == "AC" {
            // "AC" 버튼이 눌리면 계산기 0으로 초기화
            model.clear()
        } else {
            // 그 외의 버튼이 눌리면 해당 입력값을 Model에 전달
            model.updateDisplayText(with: title)
        }
        
        // Model에서 변경된 값(View에 표시할 값)을 클로저를 통해 View에 전달
        updateDisplay?(model.displayText, model.historyText)
    }
}
