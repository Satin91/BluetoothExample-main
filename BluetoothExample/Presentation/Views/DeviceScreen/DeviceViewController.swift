//
//  DeviceViewController.swift
//  BluetoothExample
//
//  Created by Артур on 25.02.22.
//

import UIKit

class DeviceViewController: UIViewController {
    
    let deviceScreenView = DeviceScreenView()
    var deviceViewModel: DeviceViewModel!
    private var flickerSpeed: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(deviceScreenView)
        self.deviceScreenView.frame = self.view.bounds
        setupButton()
        setupSlider()
        setText(device: deviceViewModel.device)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        deviceViewModel.viewDidLoad()
    }
    
    func setText(device: Device) {
        deviceScreenView.nameLabel.text = device.name
    }
    
    func setupSlider() {
        deviceScreenView.slider.addTarget(self, action: #selector(sliderDidChangeValue(_:)), for: .valueChanged)
    }
    
    @objc func sliderDidChangeValue(_ sender: UISlider) {
        
        let value = UInt8(sender.value * 255)
        deviceScreenView.setSliderValueLabelText(value: value)
        deviceScreenView.setImageAlpha(value: sender.value)
        deviceViewModel.sendCommand(data: value)
    }
    
    func setupButton() {
        deviceScreenView.turnOnDiodeButton.addTarget(self, action: #selector(onButtonTapped(_:)), for: .touchUpInside)
        deviceScreenView.turnOffDiodeButton.addTarget(self, action: #selector(offButtonTapped(_:)), for: .touchUpInside)
    }
    
    @objc func onButtonTapped(_ sender: UIButton) {
        self.deviceScreenView.slider.setValue(1, animated: false)
        deviceScreenView.setImageAlpha(value: 1)
        deviceScreenView.setSliderValueLabelText(value: 255)
        deviceViewModel.sendCommand(data: 255)
    }
    
    @objc func offButtonTapped(_ sender: UIButton) {
        self.deviceScreenView.slider.setValue(0, animated: false)
        deviceScreenView.setImageAlpha(value: 0)
        deviceScreenView.setSliderValueLabelText(value: 0)
        deviceViewModel.sendCommand(data: 0)
    }
    
    func createConstraints() {
        self.deviceScreenView.addConstraints(to: self.view)
    }
    
    deinit {
        deviceViewModel.disconnect()
    }
}

class DeviceScreenView: UIView {
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black.withAlphaComponent(0.7)
        label.font = .systemFont(ofSize: 26, weight: .black)
        label.textAlignment = .center
        return label
    }()
    
    let sliderValueLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textColor = .black.withAlphaComponent(0.7)
        label.font = .systemFont(ofSize: 28, weight: .regular)
        label.textAlignment = .center
        return label
    }()
    
    let bulbOffImageView = UIImageView()
    let bulbOnImageView = UIImageView()
    
    let turnOnDiodeButton  = RectangleButton(type: .on)
    let turnOffDiodeButton = RectangleButton(type: .off)
    let presetButton       = RectangleButton(type: .preset)
    let slider = UISlider()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupLabels()
        setupButtons()
        setupSlider()
        setupImageViews()
    }
    
    func setupButtons() {
        self.addSubview(turnOnDiodeButton)
        self.turnOnDiodeButton.frame.origin.x = 20
        self.turnOnDiodeButton.frame.origin.y = 200
        
        self.addSubview(turnOffDiodeButton)
        self.turnOffDiodeButton.frame.origin.x = 240
        self.turnOffDiodeButton.frame.origin.y = 200
        
        
    }
    
    func setupSlider() {
        addSubview(slider)
        slider.frame = CGRect(x: 130, y: 450, width: 280 , height: 40)
        slider.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
    }
    
    func setupImageViews() {
        self.addSubview(bulbOffImageView)
        bulbOffImageView.image = UIImage(named: "bulbOff")
        bulbOffImageView.frame = CGRect(x: 20, y: 300, width: 80, height: 116)
        
        bulbOffImageView.addSubview(self.bulbOnImageView)
        bulbOnImageView.image = UIImage(named: "bulbOn")
        bulbOnImageView.alpha = 0.0
        
    }
    
    func setSliderValueLabelText(value: UInt8) {
        self.sliderValueLabel.text = String(value)
    }
    
    func setImageAlpha(value: Float) {
        self.bulbOnImageView.alpha = CGFloat(value)
    }
    
    func setupLabels() {
        self.addSubview(nameLabel)
        self.addSubview(sliderValueLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //imageViews
        bulbOffImageView.center.x = self.center.x
        bulbOffImageView.center.y = self.center.y + 120
        bulbOnImageView.frame     = bulbOffImageView.bounds
        
        //labels
        nameLabel.frame        = CGRect(x: 0, y: 60, width: self.bounds.width, height: 120)
        sliderValueLabel.frame = CGRect(x: 0, y: 200 + 60, width: self.bounds.width, height: 120)
        
        
    }
    
    
}
