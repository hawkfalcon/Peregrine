//
//  GitHubLoader.swift
//  OAuth2App
//
//  Modified from Pascal Pfiffner on 11/12/14.
//  CC0, Public Domain
//

import Foundation
import p2_OAuth2


/**
	Simple class handling authorization and data requests with GitHub.
 */
class GitHubLoader: OAuth2DataLoader, DataLoader {
	
	let baseURL = URL(string: "https://api.github.com")!
	
	public init() {
		let oauth = OAuth2CodeGrant(settings: [
			"client_id": "bd91222a9b0b2a53c8e0",
			"client_secret": "59579575178c862303e560c84f16813decfbb1c6",
			"authorize_uri": "https://github.com/login/oauth/authorize",
			"token_uri": "https://github.com/login/oauth/access_token",
			"scope": "read:user gist",
			"redirect_uris": ["owl://oauth/callback"], // app has registered this scheme
			"secret_in_body": true,
			"verbose": true,
		])
		super.init(oauth2: oauth)
        oauth2.authConfig.authorizeEmbedded = true
	}
	
	/** Perform a request against the GitHub API and return decoded JSON or an NSError. */
    func request(path: String, body: Data, type: String,
        callback: @escaping ((OAuth2JSON?, Error?) -> Void)) {
        let url = baseURL.appendingPathComponent(path)
        
        var request = oauth2.request(forURL: url)
        request.httpMethod = type
        request.httpBody = body
		request.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
		
		perform(request: request) { response in
			do {
				let dict = try response.responseJSON()
				DispatchQueue.main.async() {
					callback(dict, nil)
				}
			}
			catch let error {
				DispatchQueue.main.async() {
					callback(nil, error)
				}
			}
		}
	}
    
    func getGists(callback: @escaping ((_ dict: OAuth2JSON?, _ error: Error?) -> Void)) {
        request(path: "gists", body: Data(), type: "GET", callback: callback)
    }
    
    func postGist(content: String, filename: String, description: String, secret: Bool, oauth: Bool,
        callback: @escaping ((_ dict: OAuth2JSON?, _ error: Error?) -> Void)) {

        let params: [String : Any] = [
            "description": description,
            "public": !secret,
            "files": [filename: ["content": content]]
            ]
        let paramsJson = try! JSONSerialization.data(withJSONObject: params, options: [])
       
        request(path: "gists", body: paramsJson, type: "POST", callback: callback)
    }
	
	func requestUserdata(
        callback: @escaping ((_ dict: OAuth2JSON?, _ error: Error?) -> Void)) {
        request(path: "user", body: Data(), type: "GET", callback: callback)
	}
}
