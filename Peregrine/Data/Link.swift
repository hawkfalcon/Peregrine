import Cocoa

struct Link: Codable {
    static let key = "linksKey"

    let url: URL
    let description: String
}
