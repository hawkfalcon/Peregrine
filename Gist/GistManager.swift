import Cocoa

class GistManager {
    let gistCreateUrl = "https://api.github.com/gists"
    let gistFileName = "gist"

    func createGist(content: String) {
        let params = ["files": [gistFileName: ["content": content]]]
        let paramsJson = try! JSONSerialization.data(withJSONObject: params, options: [])
        
        var request = URLRequest(url: URL(string: gistCreateUrl)!)
        request.httpMethod = "POST"
        request.httpBody = paramsJson
        
        URLSession.shared.dataTask(with: request) {data, response, err in
            if let json = try! JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject] {
                if let htmlUrl = json["html_url"], let content = htmlUrl as? String {
                    self.paste(content: content)
                }
            }
        }.resume()
    }
    
    func paste(content: String) {
        let paste = NSPasteboard.general
        paste.clearContents()
        paste.setString(content, forType: .string)
    }
}
