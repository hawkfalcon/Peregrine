import Cocoa

extension CGColor {
    static let gistLightGray = CGColor(
        red: 60 / 255.0, green: 64 / 255.0, blue: 68 / 255.0,
        alpha: 1.0
    )

    static let gistGray = CGColor(
        red: 36.0 / 255.0, green: 41.0 / 255.0, blue: 46.0 / 255.0,
        alpha: 1.0
    )
}

extension NSColor {
    static let gistLightGray = NSColor(cgColor: .gistLightGray)!
    static let gistGray = NSColor(cgColor: .gistGray)!
}
