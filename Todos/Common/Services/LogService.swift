import Foundation
import OSLog

final class LogService {
    private let logger = Logger()
    
    func displayInfo(_ text: String) {
        logger.info("\(text)")
    }
    
    func displayError(_ text: String) {
        logger.error("\(text)")
    }
}
