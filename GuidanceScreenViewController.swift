import UIKit


protocol GuidanceScreenViewProtocol where Self: UIViewController {
}

final class GuidanceScreenViewController: UIViewController, GuidanceScreenViewProtocol {
    
    private let viewModel: GuidanceScreenViewModelProtocol
    private let proceedButton = UIButton()
    
    init(viewModel: GuidanceScreenViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    private func setupUI() {
        view.backgroundColor = .white
        
        // Aadhaar Logo
        let logoImageView = UIImageView(image: UIImage(named: "aadhaar_icon"))
        logoImageView.contentMode = .scaleAspectFit
        view.addSubview(logoImageView)

        // Title
        let titleLabel = UILabel()
        titleLabel.attributedText = "Face Authentication Advisories".attributed(by: .manropeBold18(color: .black))
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)

        // Subtitle
        let subtitleLabel = UILabel()
        subtitleLabel.attributedText = "PLEASE READ THE INSTRUCTIONS CAREFULLY".attributed(by: .manropeCapsBold10(color: .gray))
        subtitleLabel.textAlignment = .center
        view.addSubview(subtitleLabel)

        // Instructions StackView
        let instructionsStack = UIStackView()
        instructionsStack.axis = .vertical
        instructionsStack.spacing = 16  // Equal spacing for all items
        instructionsStack.alignment = .leading
        view.addSubview(instructionsStack)

        // Instructions with Icons
        let instruction1 = createInstructionView(icon: "advisory_icon", text: "Keep your face centered within\nthe circle and stay still for capture")
        let instruction2 = createInstructionView(icon: "lighting", text: "Ensure good lighting on your face and avoid backlight")
        let instruction3 = createInstructionView(icon: "sunglass", text: "Remove tinted glasses and keep your face fully visible")
        let instruction4 = createInstructionView(icon: "blink", text: "Blink when prompted; you may need to blink several times.")

        instructionsStack.addArrangedSubview(instruction1)
        instructionsStack.addArrangedSubview(instruction2)
        instructionsStack.addArrangedSubview(instruction3)
        instructionsStack.addArrangedSubview(instruction4)

        // Checkbox Button
        // Checkbox Button
        let checkbox = UIButton(type: .custom)
        checkbox.setImage(UIImage(named: "checkbox_unchecked"), for: .normal)
        checkbox.setImage(UIImage(named: "checkbox_checked"), for: .selected)
        checkbox.addTarget(self, action: #selector(toggleCheckbox), for: .touchUpInside)
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        checkbox.widthAnchor.constraint(equalToConstant: 20).isActive = true
        checkbox.heightAnchor.constraint(equalToConstant: 24).isActive = true

        // Checkbox Label
        let checkboxLabel = UILabel()
        checkboxLabel.numberOfLines = 0
        checkboxLabel.attributedText = "I have read and understood these\nadvisories and need not be shown again".attributed(by: .manropeRegular12(color: .darkGray))

        // StackView for Checkbox & Label
        let checkboxStack = UIStackView(arrangedSubviews: [checkbox, checkboxLabel])
        checkboxStack.axis = .horizontal
        checkboxStack.spacing = 12
        checkboxStack.alignment = .center
        checkboxStack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(checkboxStack)
        
        


        // Buttons
        let cancelButton = UIButton(type: .system)
        cancelButton.setAttributedTitle("Cancel".attributed(by: .manropeBold15(color: .brown)), for: .normal)
        cancelButton.setTitleColor(.brown, for: .normal)
        cancelButton.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        cancelButton.layer.cornerRadius = 25

        let proceedButton = UIButton(type: .system)
        proceedButton.setAttributedTitle("Proceed".attributed(by: .manropeBold15(color: .white)), for: .normal)
        proceedButton.setTitleColor(.white, for: .normal)
        proceedButton.backgroundColor = .brown
        proceedButton.layer.cornerRadius = 25
        proceedButton.addTarget(self, action: #selector(proceedButtonTapped), for: .touchUpInside)
        

        let buttonsStack = UIStackView(arrangedSubviews: [cancelButton, proceedButton])
        buttonsStack.axis = .horizontal
        buttonsStack.spacing = 16
        buttonsStack.distribution = .fillEqually
        view.addSubview(buttonsStack)

        // Footer
        let footerLabel = UILabel()
        footerLabel.attributedText = "AADHAAR AUTH  V1.2.0".attributed(by: .manropeCapsExtraBold12(color: .lightGray))
        footerLabel.textAlignment = .center
        view.addSubview(footerLabel)

        // Constraints
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        instructionsStack.translatesAutoresizingMaskIntoConstraints = false
        checkboxStack.translatesAutoresizingMaskIntoConstraints = false
        buttonsStack.translatesAutoresizingMaskIntoConstraints = false
        footerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let divider = UIView()
        divider.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        view.addSubview(divider)
        
        
        let checkboxDivider = UIView()
               checkboxDivider.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
               checkboxDivider.translatesAutoresizingMaskIntoConstraints = false
               view.addSubview(checkboxDivider)

    
        
        NSLayoutConstraint.activate([
            // Logo
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 100),
            logoImageView.heightAnchor.constraint(equalToConstant: 100),

            // Title
            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            // Subtitle
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),


            instructionsStack.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 40),
            instructionsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            instructionsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            
            // Checkbox Stack
            checkboxStack.topAnchor.constraint(equalTo: instructionsStack.bottomAnchor, constant: 24),
            checkboxStack.leadingAnchor.constraint(equalTo: instructionsStack.leadingAnchor, constant: 32),
            checkboxStack.trailingAnchor.constraint(equalTo: instructionsStack.trailingAnchor, constant: -16),

            // Checkbox Divider
            checkboxDivider.topAnchor.constraint(equalTo: checkboxStack.bottomAnchor, constant: -8),
            checkboxDivider.leadingAnchor.constraint(equalTo: instructionsStack.leadingAnchor),
            checkboxDivider.trailingAnchor.constraint(equalTo: instructionsStack.trailingAnchor),
            checkboxDivider.heightAnchor.constraint(equalToConstant: 1),

            // Buttons
            buttonsStack.topAnchor.constraint(equalTo: checkboxStack.bottomAnchor, constant: 24),
            buttonsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            buttonsStack.heightAnchor.constraint(equalToConstant: 50),

            // Footer
            footerLabel.topAnchor.constraint(equalTo: buttonsStack.bottomAnchor, constant: 16),
            footerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            footerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            footerLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    
    func createInstructionView(icon: String, text: String) -> UIView {
        // Icon Container
        let iconContainer = UIView()
        iconContainer.translatesAutoresizingMaskIntoConstraints = false
        iconContainer.widthAnchor.constraint(equalToConstant: 46).isActive = true
        iconContainer.heightAnchor.constraint(equalToConstant: 46).isActive = true
        iconContainer.layer.cornerRadius = 23
        iconContainer.clipsToBounds = true
        iconContainer.backgroundColor = UIColor(fromHex: "#BDA886", alpha: 0.1)
        iconContainer.layer.borderColor = UIColor(fromHex: "#BDA886", alpha: 0.2).cgColor
        iconContainer.layer.borderWidth = 2

        let imageView = UIImageView(image: UIImage(named: icon))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        iconContainer.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 24),
            imageView.heightAnchor.constraint(equalToConstant: 24)
        ])

        // Instruction Text
        let label = UILabel()
        label.numberOfLines = 0
        label.attributedText = text.attributed(by: .manropeRegular12(color: .black))


        // StackView for icon and text
        let stackView = UIStackView(arrangedSubviews: [iconContainer, label])
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .center

        let divider = UIView()
        divider.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true

        // **Container to wrap instruction with proper spacing**
        let containerView = UIView()
        containerView.addSubview(stackView)
        containerView.addSubview(divider)

        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // StackView Constraints
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 14),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),

            // Divider Line (Positioned Below the Text)
            divider.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 13),
            divider.leadingAnchor.constraint(equalTo: label.leadingAnchor), // Aligned with text
            divider.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            divider.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 13)
        ])

        return containerView
    }
 
    @objc private func proceedButtonTapped(_ sender : UIButton){
        viewModel.handleProceedButtonTapped()
    }

    @objc private func toggleCheckbox(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
}
