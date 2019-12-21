import Foundation

class EncryptionService {
    // SHA1 the given string
    static SHA1(string: String) -> String {
        var encryptedString: String = string
        


        return encryptedString
    }

    // Create a unique random and ecrypted salt
    static func SALT() {
        return EncryptionService.SHA1(string: UUID().uuidString)
    }
}
