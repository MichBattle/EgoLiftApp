import Foundation

class Note: Identifiable {
    var id = UUID()
    var content: String
    
    init(content: String) {
        self.content = content
    }
}
