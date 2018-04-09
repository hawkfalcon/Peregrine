import Cocoa

extension CGColor {
    static let gistLightGray = CGColor.init(
        red: 90.0 / 255.0, green: 94.0 / 255.0, blue: 98.0 / 255.0,
        alpha: 1.0
    )
    
    static let gistMediumGray = CGColor.init(
        red: 60 / 255.0, green: 64 / 255.0, blue: 68 / 255.0,
        alpha: 1.0
    )

    static let gistGray = CGColor.init(
        red: 36.0 / 255.0, green: 41.0 / 255.0, blue: 46.0 / 255.0,
        alpha: 1.0
    )
}

extension NSColor {
    static let gistLightGray = NSColor.init(cgColor: .gistLightGray)!
    static let gistMediumGray = NSColor.init(cgColor: .gistMediumGray)!
    static let gistGray = NSColor.init(cgColor: .gistGray)!
}
