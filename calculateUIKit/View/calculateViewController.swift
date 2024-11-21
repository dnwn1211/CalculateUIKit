import UIKit

class ViewController: UIViewController {
    
    // 현재 입력된 값(결과)을 표시하는 레이블
    private let formulaLabel = UILabel()
    
    // 계산 진행사항(기록)을 표시하는 레이블
    private let historyLabel = UILabel()
    
    // ViewModel 인스턴스: View와 Model을 연결
    private var viewModel: CalculatorViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ViewModel 초기화
        viewModel = CalculatorViewModel()
        
        // ViewModel에서 값이 변경될 때 UI를 업데이트하는 클로저 설정
        viewModel.updateDisplay = { [weak self] displayText, historyText in
            // 결과 값과 진행 기록을 각각 레이블에 반영
            self?.formulaLabel.text = displayText
            self?.historyLabel.text = historyText
        }
        
        // UI 설정
        setupUI()
    }
    
    // UI 설정 함수
    private func setupUI() {
        // 계산 진행사항 레이블 설정
        historyLabel.backgroundColor = .black
        historyLabel.textColor = .lightGray
        historyLabel.text = "" // 초기 값 비움
        historyLabel.textAlignment = .right
        historyLabel.font = UIFont.systemFont(ofSize: 20)
        view.addSubview(historyLabel)
        
        // 결과 레이블 설정
        formulaLabel.backgroundColor = .black
        formulaLabel.textColor = .white
        formulaLabel.text = "0" // 초기 값 설정
        formulaLabel.textAlignment = .right
        formulaLabel.font = UIFont.boldSystemFont(ofSize: 60)
        view.addSubview(formulaLabel)
        
        // AutoLayout 설정 (계산 진행사항 레이블)
        historyLabel.translatesAutoresizingMaskIntoConstraints = false
        formulaLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            historyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            historyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            historyLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            historyLabel.heightAnchor.constraint(equalToConstant: 30),
            
            formulaLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            formulaLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            formulaLabel.topAnchor.constraint(equalTo: historyLabel.bottomAnchor, constant: 10),
            formulaLabel.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        // 버튼 배열 정의 (각 행의 버튼 레이아웃)
        let buttonTitles = [
            ["7", "8", "9", "+"],
            ["4", "5", "6", "-"],
            ["1", "2", "3", "*"],
            ["AC", "0", "=", "/"]
        ]
        
        // 수직 스택뷰 생성 (버튼 레이아웃 그룹화)
        let verticalStackView = UIStackView()
        verticalStackView.axis = .vertical // 수직 방향
        verticalStackView.spacing = 10 // 각 행 간 간격
        verticalStackView.distribution = .fillEqually // 버튼 크기 균등 배분
        
        // 행 단위로 버튼 생성 및 스택뷰에 추가
        for row in buttonTitles {
            let horizontalStackView = UIStackView()
            horizontalStackView.axis = .horizontal // 수평 방향
            horizontalStackView.spacing = 10 // 버튼 간 간격
            horizontalStackView.distribution = .fillEqually // 버튼 크기 균등 배분
            
            for title in row {
                let button = createButton(withTitle: title) // 버튼 생성
                horizontalStackView.addArrangedSubview(button) // 행에 버튼 추가
            }
            
            verticalStackView.addArrangedSubview(horizontalStackView) // 행을 수직 스택뷰에 추가
        }
        
        // 수직 스택뷰를 View에 추가 및 AutoLayout 설정
        view.addSubview(verticalStackView)
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            verticalStackView.widthAnchor.constraint(equalToConstant: 350), // 너비 고정
            verticalStackView.topAnchor.constraint(equalTo: formulaLabel.bottomAnchor, constant: 180), // 위치
            verticalStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor), // 화면 중앙 정렬
            verticalStackView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: 0) // 하단 제약 조건
        ])
    }
    
    // 버튼 생성 및 스타일링 함수
    private func createButton(withTitle title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal) // 버튼 제목 설정
        button.titleLabel?.font = .boldSystemFont(ofSize: 30) // 제목 폰트 설정
        button.setTitleColor(.white, for: .normal) // 제목 색상 설정
        
        // 버튼 색상 설정 (연산자 및 "AC", "=" 버튼은 오렌지색, 나머지는 회색)
        if ["+", "-", "*", "/", "AC", "="].contains(title) {
            button.backgroundColor = UIColor.orange
        } else {
            button.backgroundColor = UIColor.gray
        }
        
        // 버튼 크기 및 모서리 스타일
        button.widthAnchor.constraint(equalToConstant: 80).isActive = true
        button.heightAnchor.constraint(equalToConstant: 80).isActive = true
        button.layer.cornerRadius = 40 // 둥근 버튼
        button.clipsToBounds = true // 버튼 외곽 클리핑
        
        // 버튼 클릭 시 `buttonTapped(_:)` 호출
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        return button
    }
    
    // 버튼 클릭 시 호출되는 메서드
    @objc private func buttonTapped(_ sender: UIButton) {
        // 버튼 제목 가져오기
        guard let title = sender.title(for: .normal) else { return }
        // ViewModel에 버튼 제목 전달
        viewModel.buttonTapped(title)
    }
}
