//
//  CRNotification.swift
//  CRNotifications
//
//  Created by Casper Riboe on 21/03/2017.
//  LICENSE : MIT
//

import UIKit

public protocol CRNotification {
    func hide() -> Void
}

public class CRNotificationView: UIView, CRNotification {
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = .white
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.numberOfLines = 3
        label.textColor = .white
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .white
        label.numberOfLines = 2
        return label
	}()
	
    private var completion: () -> () = {}
    private var type: CRNotificationType
    public var delegate: CRNotificationDelegate?
    
    // MARK: - Init
	
    required internal init?(coder aDecoder:NSCoder) { fatalError("Not implemented.") }
    
    internal init(type: CRNotificationType) {
		let deviceWidth = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        let widthFactor: CGFloat = DeviceManager.value(iPhone35: 0.9, iPhone40: 0.9, iPhone47: 0.9, iPhone55: 0.85, iPhone58: 0.9, iPhone61: 0.9, iPadSmall: 0.5, iPadMedium: 0.45, iPadBig: 0.4)
        let heightFactor: CGFloat = DeviceManager.value(iPhone35: 0.22, iPhone40: 0.22, iPhone47: 0.2, iPhone55: 0.2, iPhone58: 0.18, iPhone61: 0.18, iPadSmall: 0.18, iPadMedium: 0.17, iPadBig: 0.17)

        let width = deviceWidth * widthFactor
        let height = width * heightFactor
        self.type = type
        
        super.init(frame: CGRect(x: 0, y: -height, width: width, height: height))
        center.x = UIScreen.main.bounds.width/2
        setupLayer()
        setupSubviews()
        setupConstraints()
        setupTargets()
        
        // setup type attributes
        self.setBackgroundColor(color: type.backgroundColor)
        self.setTextColor(color: type.textColor)
        self.setImage(image: type.image)
        self.setBorder(borderWidth: 1.0, borderColor: type.borderColor)
    }
    
    
    // MARK: - Setup
    
    private func setupLayer() {
        layer.cornerRadius = 5
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.25
        layer.shadowColor = UIColor.lightGray.cgColor
    }
    
    private func setupSubviews() {
        addSubview(imageView)
        addSubview(titleLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: imageView.superview!.leadingAnchor, constant: 12),
            imageView.centerYAnchor.constraint(equalTo: imageView.superview!.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 30),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
        ])
		
		NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: titleLabel.superview!.trailingAnchor, constant: -8),
            titleLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ])
		
    }
    
    private func setupTargets() {
        NotificationCenter.default.addObserver(self, selector: #selector(didRotate), name: UIDevice.orientationDidChangeNotification, object: nil)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissNotificationOnTap))
        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.dismissNotification))
        swipeRecognizer.direction = .up
        
        addGestureRecognizer(tapRecognizer)
        addGestureRecognizer(swipeRecognizer)
	}
    
    
    // MARK: - Helpers
    
    @objc internal func didRotate() {
        UIView.animate(withDuration: 0.2) {
            self.center.x = UIScreen.main.bounds.width / 2
            self.center.y = self.topInset() + 10 + self.frame.height / 2
        }
    }
    
    /** Sets the background color of the notification **/
    internal func setBackgroundColor(color: UIColor) {
        backgroundColor = color
    }
    
    /** Sets the background color of the notification **/
    internal func setTextColor(color: UIColor) {
        titleLabel.textColor = color
        messageLabel.textColor = color
    }
    
    /** Sets the title of the notification **/
    internal func setTitle(title: String) {
        titleLabel.text = title
    }
    
    /** Sets the message of the notification **/
    internal func setMessage(message: String) {
        messageLabel.text = message
    }

    internal func setTitleFont(font: UIFont?) {
        guard let _ = font else {
            return
        }

        titleLabel.font = font!
    }
    
    /** Sets the image of the notification **/
    internal func setImage(image: UIImage?) {
        imageView.image = image
    }

    internal func setBorder(borderWidth: Double, borderColor: UIColor) {
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = CGFloat(borderWidth)
    }
    
    /** Sets the completion block of the notification for when it is dismissed **/
    internal func setCompletionBlock(_ completion: @escaping () -> ()) {
        self.completion = completion
    }
    
    /** Dismisses the notification with a delay > 0 **/
    internal func setDismisTimer(delay: TimeInterval) {
        if delay > 0 {
            Timer.scheduledTimer(timeInterval: Double(delay), target: self, selector: #selector(dismissNotification), userInfo: nil, repeats: false)
        }
    }
    
    /** Animates in the notification **/
    internal func showNotification() {
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.68, initialSpringVelocity: 0.1, options: UIView.AnimationOptions(), animations: {
            self.frame.origin.y = self.topInset() + 10
        })
    }
    
    @objc internal func dismissNotificationOnTap() {
        delegate?.onNotificationTap(type: type,title: titleLabel.text, message: messageLabel.text)
        self.dismissNotification()
    }
    
    /** Animates out the notification **/
    @objc internal func dismissNotification() {
        hide()
    }
    
    private func topInset() -> CGFloat {
        let iPhoneXInset: CGFloat
        switch UIApplication.shared.statusBarOrientation {
        case .landscapeLeft, .landscapeRight:
            iPhoneXInset = 0
        case .portrait, .portraitUpsideDown, .unknown:
            iPhoneXInset = 44
        @unknown default:
            iPhoneXInset = 0
        }
        
        let statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height
        return DeviceManager.value(iPhoneX: statusBarHeight == 0 ? iPhoneXInset : statusBarHeight, other: statusBarHeight)
    }
    
    
    // MARK: - Public
    
    public func hide() {
        UIView.animate(withDuration: 0.1, animations: {
            self.frame.origin.y = self.frame.origin.y + 5
        }, completion: {
            (complete: Bool) in
            UIView.animate(withDuration: 0.25, animations: {
                self.center.y = -self.frame.height
            }, completion: { [weak self] (complete) in
                self?.completion()
                self?.removeFromSuperview()
            })
        })
    }
    
}
