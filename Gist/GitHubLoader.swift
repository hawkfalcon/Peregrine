//
//  GitHubLoader.swift
//  OAuth2App
//
//  Created by Pascal Pfiffner on 11/12/14.
//  CC0, Public Domain
//

import Foundation
import OAuth2


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
			"redirect_uris": ["owl://oauth/callback"],            // app has registered this scheme
			"secret_in_body": true,
			"verbose": true,
		])
		super.init(oauth2: oauth)
	}
	
	
	/** Perform a request against the GitHub API and return decoded JSON or an NSError. */
	func request(path: String, callback: @escaping ((OAuth2JSON?, Error?) -> Void)) {
		oauth2.logger = OAuth2DebugLogger(.trace)
		let url = baseURL.appendingPathComponent(path)
		var req = oauth2.request(forURL: url)
		req.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
		
		perform(request: req) { response in
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
	
	func requestUserdata(callback: @escaping ((_ dict: OAuth2JSON?, _ error: Error?) -> Void)) {
		request(path: "user", callback: callback)
	}
}

