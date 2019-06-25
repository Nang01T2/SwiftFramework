import Foundation

class StringReplacer {
    private let projectName: String
    private let authorName: String
    private let authorEmail: String
    private let gitHubURL: String
    private let year: String
    private let today: String
    private let organizationName: String
    
    init(projectName: String, authorName: String, authorEmail: String?, gitHubURL: String?, organizationName: String?) {
        self.projectName = projectName
        self.authorName = authorName
        self.authorEmail = authorEmail ?? ""
        self.gitHubURL = gitHubURL ?? ""
        self.organizationName = organizationName ?? projectName
        
        
        let yearFormatter = DateFormatter()
        yearFormatter.dateFormat = "yyyy"
        self.year = yearFormatter.string(from: Date())
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        self.today = dateFormatter.string(from: Date())
    }
    
    private var dateString: String {
        return DateFormatter.localizedString(
            from: Date(),
            dateStyle: DateFormatter.Style.medium,
            timeStyle: DateFormatter.Style.none
        )
    }
    
    func process(string: String) -> String {
        return string.replacingOccurrences(of: "{PROJECT}", with: projectName)
            .replacingOccurrences(of: "{AUTHOR}", with: authorName)
            .replacingOccurrences(of: "{EMAIL}", with: authorEmail)
            .replacingOccurrences(of: "{URL}", with: gitHubURL)
            .replacingOccurrences(of: "{YEAR}", with: year)
            .replacingOccurrences(of: "{TODAY}", with: today)
            .replacingOccurrences(of: "{DATE}", with: dateString)
            .replacingOccurrences(of: "{ORGANIZATION}", with: organizationName)
            .replacingOccurrences(of: "-PROJECT-", with: projectName)
            .replacingOccurrences(of: "-ORGANIZATION-", with: organizationName)
    }
    
    func process(filesInFolderWithPath folderPath: String) throws {
        let fileManager = FileManager.default
        let currentFileName = URL.init(fileURLWithPath: #file).lastPathComponent
        
        for itemName in try fileManager.contentsOfDirectory(atPath: folderPath) {
            //print("Processing....: \(itemName)")
            if itemName.hasPrefix(".") || itemName == currentFileName {
                continue
            }
            
            let itemPath = folderPath + "/" + itemName
            let newItemPath = folderPath + "/" + process(string: itemName)
            
            if fileManager.isFolder(atPath: itemPath) {
                try process(filesInFolderWithPath: itemPath)
                try fileManager.moveItem(atPath: itemPath, toPath: newItemPath)
                continue
            }
            
            let fileContents = try String(contentsOfFile: itemPath)
            try process(string: fileContents).write(toFile: newItemPath, atomically: false, encoding: .utf8)
            
            if newItemPath != itemPath {
                try fileManager.removeItem(atPath: itemPath)
            }
        }
    }
}
