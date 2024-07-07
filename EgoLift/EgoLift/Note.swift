import Foundation

class Note: Identifiable, ObservableObject {
    var id = UUID()
    @Published var content: String
    
    init(content: String) {
        self.content = content
    }
}
