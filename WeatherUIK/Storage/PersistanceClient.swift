//
//  PersistanceClient.swift
//  WeatherUIK
//
//  Created by Paweł Michalak on 17/09/2023.
//

import Foundation

struct PersistanceClient {
    
    enum PersisstanceError: Error {
        case encodingError, decodingError
    }
    
    private enum Keys {
        static let recents = "recents"
    }
    
    let defaults = UserDefaults.standard
    
    func getRecents() throws -> [CityData] {
        guard let recentsData = defaults.object(forKey: Keys.recents) as? Data else {
            return []
        }
        
        let recents = try JSONDecoder().decode([CityData].self, from: recentsData)
        return recents
    }
    
    func add(cityData: CityData) {
        guard var recents = try? getRecents() else { return }
        
        recents.removeAll { $0 == cityData }
        recents.insert(cityData, at: 0)
        if recents.count > 10 { recents.removeLast() }
        
        if let error = save(recents: recents) {
            print("Error with saving data: ", error.localizedDescription)
        }
    }
        
    func save(recents: [CityData]) -> PersisstanceError? {
        do {
            let encodedRecents = try JSONEncoder().encode(recents)
            defaults.set(encodedRecents, forKey: Keys.recents)
            return nil
        } catch {
            return .encodingError
        }
    }
}
