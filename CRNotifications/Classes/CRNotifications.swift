//
//  CRNotifications.swift
//  CRNotifications
//
//  Created by Casper Riboe on 21/03/2017.
//  LICENSE : MIT
//

import UIKit

public protocol CRNotificationDelegate {
    func onNotificationTap(type: CRNotificationType, title: String?, message: String?)
}

public class CRNotifications {
    
    // MARK: - Static notification types
    
    public static let success: CRNotificationType = CRNotificationTypeDefinition(textColor: UIColor.white, backgroundColor: UIColor.flatGreen, image: UIImage(named: "success", in: CRNotificationResources.resourceBundle, compatibleWith: nil), borderColor: UIColor.flatGreen)
    public static let error: CRNotificationType = CRNotificationTypeDefinition(textColor: UIColor.white, backgroundColor: UIColor.flatRed, image: UIImage(named: "error", in: CRNotificationResources.resourceBundle, compatibleWith: nil), borderColor: UIColor.flatRed)
    public static let info: CRNotificationType = CRNotificationTypeDefinition(textColor: UIColor.white, backgroundColor: UIColor.flatGray, image: UIImage(named: "info", in: CRNotificationResources.resourceBundle, compatibleWith: nil), borderColor: UIColor.flatGray)

    
    // MARK: - Init
    
    public init(){}
    
    
    // MARK: - Helpers
    
    /** Shows a CRNotification.
        Returns the CRNotification that is displayed. Returns nil if the keyWindow is not present.
     **/
    @discardableResult
    public static func showNotification(textColor: UIColor, backgroundColor: UIColor, image: UIImage?, borderColor: UIColor, title: String, message: String, dismissDelay: TimeInterval, delegate: CRNotificationDelegate? = nil, completion: @escaping () -> () = {}) -> CRNotification? {
        let notificationDefinition = CRNotificationTypeDefinition(textColor: textColor, backgroundColor: backgroundColor, image: image, borderColor: borderColor)
        return showNotification(type: notificationDefinition, title: title, message: message, dismissDelay: dismissDelay, delegate: delegate, completion: completion)
    }
    
    /** Shows a CRNotification from a CRNotificationType.
        Returns the CRNotification that is displayed. Returns nil if the keyWindow is not present.
     **/
    @discardableResult
    public static func showNotification(type: CRNotificationType, title: String, message: String, dismissDelay: TimeInterval, font: UIFont? = nil, delegate: CRNotificationDelegate? = nil, completion: @escaping () -> () = {}) -> CRNotification? {
        let view = CRNotificationView(type: type)
        
        view.setTitle(title: title)
        view.setMessage(message: message)
        view.setDismisTimer(delay: dismissDelay)
		view.setCompletionBlock(completion)
        view.delegate = delegate
        view.setTitleFont(font: font)
        
        guard let window = UIApplication.shared.keyWindow else {
            print("Failed to show CRNotification. No keywindow available.")
            return nil
        }
        
        window.addSubview(view)
        view.showNotification()
        
        return view
    }
}

public struct CRNotificationTypeDefinition: CRNotificationType {
    public var textColor: UIColor
    public var backgroundColor: UIColor
    public var image: UIImage?
    public var borderColor: UIColor
}
