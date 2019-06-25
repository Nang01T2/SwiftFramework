import Foundation

print("Welcome to the SwiftFramework project generator 🐣")

let arguments = Arguments(commandLineArguments: CommandLine.arguments)
let destination = arguments.destination ?? askForDestination()
let projectName = arguments.projectName ?? askForProjectName(destination: destination)
let authorName = arguments.authorName ?? askForAuthorName()
let authorEmail = arguments.authorEmail ?? askForAuthorEmail()
let gitHubURL = arguments.githubURL ?? askForGitHubURL(destination: destination)
let organizationName = arguments.organizationName ?? askForOptionalInfo(question: "🏢  What's your organization name?")

print("---------------------------------------------------------------------")
print("SwiftFramework will now generate a project with the following parameters:")
print("📦  Destination: \(destination)")
print("📛  Name: \(projectName)")
print("👶  Author: \(authorName)")

if let authorEmail = authorEmail {
    print("📫  Author email: \(authorEmail)")
}

if let gitHubURL = gitHubURL {
    print("🌍  GitHub URL: \(gitHubURL)")
}

if let organizationName = organizationName {
    print("🏢  Organization Name: \(organizationName)")
}

print("---------------------------------------------------------------------")

if !arguments.forceEnabled {
    if !askForBooleanInfo(question: "Proceed? ✅") {
        exit(0)
    }
}

print("🚀  Starting to generate project \(projectName)...")

do {
    let fileManager = FileManager.default
    let temporaryDirectoryPath = destination + "/Temp"
    let gitClonePath = "\(temporaryDirectoryPath)/SwiftFramework"
    let templatePath = "\(gitClonePath)/Template"
    
    performCommand(description: "Removing any previous temporary folder") {
        try? fileManager.removeItem(atPath: temporaryDirectoryPath)
    }
    
    try performCommand(description: "Making temporary folder (\(temporaryDirectoryPath))") {
        try fileManager.createDirectory(atPath: temporaryDirectoryPath, withIntermediateDirectories: false, attributes: nil)
    }
    
    performCommand(description: "Making a local clone of the SwiftFramework repo") {
        let repositoryURL = arguments.repositoryURL ?? URL(string: "https://github.com/Nang01T2/SwiftFramework.git")!
        Process().launchBash(withCommand: "git clone \(repositoryURL.absoluteString) '\(gitClonePath)' -q")
    }
    
    try performCommand(description: "Copying template folder") {
        let ignorableItems: Set<String> = ["readme.md", "license"]
        let ignoredItems = try fileManager.contentsOfDirectory(atPath: destination).map {
            $0.lowercased()
            }.filter {
                ignorableItems.contains($0)
        }
        
        for itemName in try fileManager.contentsOfDirectory(atPath: templatePath) {
            let originPath = templatePath + "/" + itemName
            let destinationPath = destination + "/" + itemName
            
            let lowercasedItemName = itemName.lowercased()
            guard ignoredItems.contains(lowercasedItemName) == false && lowercasedItemName != ".ds_store" else {
                continue
            }
            
            try fileManager.copyItem(atPath: originPath, toPath: destinationPath)
        }
    }
    
    try performCommand(description: "Removing temporary folder") {
        try fileManager.removeItem(atPath: temporaryDirectoryPath)
    }

    try performCommand(description: "Filling in template") {
        let replacer = StringReplacer(
            projectName: projectName,
            authorName: authorName,
            authorEmail: authorEmail,
            gitHubURL: gitHubURL,
            organizationName: organizationName
        )

        try replacer.process(filesInFolderWithPath: destination)
    }
    
    print("All done! 🎉  Good luck with your project! 🚀")
} catch {
    print("An error was encountered 🙁")
    print("Error: \(error)")
}
