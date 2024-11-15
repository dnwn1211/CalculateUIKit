import UIKit

class ViewController: UIViewController {
    
    private let formulaLabel = UILabel()
    private var viewModel: CalculatorViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ViewModel 초기화
        viewModel = CalculatorViewModel()
        
        // ViewModel의 UI 업데이트 클로저 설정
        viewModel.updateDisplay = { [weak self] displayText in
            self?.formulaLabel.text = displayText
        }
        
        setupUI()
    }
    
    private func setupUI() {
        // UILabel 생성 및 설정
        formulaLabel.backgroundColor = .black
        formulaLabel.textColor = .white
        formulaLabel.text = "0"
        formulaLabel.textAlignment = .right
        formulaLabel.font = UIFont.boldSystemFont(ofSize: 60)
        
        // UILabel을 뷰에 추가
        view.addSubview(formulaLabel)
        
        // AutoLayout 설정
        formulaLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            formulaLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            formulaLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            formulaLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            formulaLabel.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        // 버튼 타이틀을 4x4 그리드 순서로 배열
        let buttonTitles = [
            ["7", "8", "9", "+"],
            ["4", "5", "6", "-"],
            ["1", "2", "3", "*"],
            ["AC", "0", "=", "/"]
        ]
        
        // 수평 스택뷰 배열을 담을 수직 스택뷰 생성
        let verticalStackView = UIStackView()
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 10
        verticalStackView.distribution = .fillEqually
        verticalStackView.backgroundColor = .black
        
        // 각 행별로 수평 스택뷰 생성 및 버튼 추가
        for row in buttonTitles {
            let horizontalStackView = UIStackView()
            horizontalStackView.axis = .horizontal
            horizontalStackView.spacing = 10
            horizontalStackView.distribution = .fillEqually
            
            for title in row {
                // 버튼 생성 및 설정을 함수로 처리
                let button = createButton(withTitle: title)
                horizontalStackView.addArrangedSubview(button)
            }
            
            // 수직 스택뷰에 수평 스택뷰 추가
            verticalStackView.addArrangedSubview(horizontalStackView)
        }
        
        // 수직 스택뷰를 뷰에 추가하고 AutoLayout 설정
        view.addSubview(verticalStackView)
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            verticalStackView.widthAnchor.constraint(equalToConstant: 350),
            verticalStackView.topAnchor.constraint(equalTo: formulaLabel.bottomAnchor, constant: 200),
            verticalStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            verticalStackView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: 0)
        ])
    }
    
    // 버튼을 생성하는 함수
    private func createButton(withTitle title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 30)
        button.setTitleColor(.white, for: .normal)
        
        // 숫자와 연산자 버튼을 구분하여 배경색 설정
        if ["+", "-", "*", "/", "AC", "="].contains(title) {
            // 연산자 버튼 색상
            button.backgroundColor = UIColor.orange
        } else {
            // 숫자 버튼 색상	
            button.backgroundColor = UIColor(.gray)
        }
        
        // 버튼을 둥글게 만들기 위해 크기와 코너 반경 설정
        button.widthAnchor.constraint(equalToConstant: 80).isActive = true
        button.heightAnchor.constraint(equalToConstant: 80).isActive = true
        button.layer.cornerRadius = 40
        button.clipsToBounds = true
        
        // 버튼 클릭 시 ViewModel에 전달
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        return button
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        guard let title = sender.title(for: .normal) else { return }
        viewModel.buttonTapped(title)
    }
}
