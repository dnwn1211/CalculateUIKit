import UIKit

class ViewController: UIViewController {
    
    private let formulaLabel = UILabel()
    private let historyLabel = UILabel() // 계산 진행사항 표시용 레이블
    private var viewModel: CalculatorViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ViewModel 초기화
        viewModel = CalculatorViewModel()
        
        // ViewModel의 UI 업데이트 클로저 설정
        viewModel.updateDisplay = { [weak self] displayText, historyText in
            self?.formulaLabel.text = displayText
            self?.historyLabel.text = historyText
        }
        
        setupUI()
    }
    
    private func setupUI() {
        // 계산 진행사항 레이블 생성 및 설정
        historyLabel.backgroundColor = .black
        historyLabel.textColor = .lightGray
        historyLabel.text = ""
        historyLabel.textAlignment = .right
        historyLabel.font = UIFont.systemFont(ofSize: 20)
        view.addSubview(historyLabel)
        
        // 결과 레이블 생성 및 설정
        formulaLabel.backgroundColor = .black
        formulaLabel.textColor = .white
        formulaLabel.text = "0"
        formulaLabel.textAlignment = .right
        formulaLabel.font = UIFont.boldSystemFont(ofSize: 60)
        view.addSubview(formulaLabel)
        
        // 레이블 AutoLayout 설정
        historyLabel.translatesAutoresizingMaskIntoConstraints = false
        formulaLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            // 계산 진행사항 레이블
            historyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            historyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            historyLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            historyLabel.heightAnchor.constraint(equalToConstant: 30),
            
            // 결과 레이블
            formulaLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            formulaLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            formulaLabel.topAnchor.constraint(equalTo: historyLabel.bottomAnchor, constant: 10),
            formulaLabel.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        // 버튼 타이틀 배열
        let buttonTitles = [
            ["7", "8", "9", "+"],
            ["4", "5", "6", "-"],
            ["1", "2", "3", "*"],
            ["AC", "0", "=", "/"]
        ]
        
        // 수직 스택뷰 생성
        let verticalStackView = UIStackView()
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 10
        verticalStackView.distribution = .fillEqually
        
        for row in buttonTitles {
            let horizontalStackView = UIStackView()
            horizontalStackView.axis = .horizontal
            horizontalStackView.spacing = 10
            horizontalStackView.distribution = .fillEqually
            
            for title in row {
                let button = createButton(withTitle: title)
                horizontalStackView.addArrangedSubview(button)
            }
            
            verticalStackView.addArrangedSubview(horizontalStackView)
        }
        
        view.addSubview(verticalStackView)
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            verticalStackView.widthAnchor.constraint(equalToConstant: 350),
            verticalStackView.topAnchor.constraint(equalTo: formulaLabel.bottomAnchor, constant: 180),
            verticalStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            verticalStackView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: 0)
        ])
    }
    
    private func createButton(withTitle title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 30)
        button.setTitleColor(.white, for: .normal)
        
        if ["+", "-", "*", "/", "AC", "="].contains(title) {
            button.backgroundColor = UIColor.orange
        } else {
            button.backgroundColor = UIColor.gray
        }
        
        button.widthAnchor.constraint(equalToConstant: 80).isActive = true
        button.heightAnchor.constraint(equalToConstant: 80).isActive = true
        button.layer.cornerRadius = 40
        button.clipsToBounds = true
        
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        return button
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        guard let title = sender.title(for: .normal) else { return }
        viewModel.buttonTapped(title)
    }
}
