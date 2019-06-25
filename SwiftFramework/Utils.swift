import Foundation

func performCommand(description: String, command: () throws -> Void) rethrows {
    print("👉  \(description)...")
    try command()
    print("✅  Done")
}

func printError(_ message: String) {
    print("👮  \(message)")
}

func askForRequiredInfo(question: String, errorMessage errorMessageClosure: @autoclosure () -> String) -> String {
    print(question)
    
    guard let info = readLine()?.nonEmpty else {
        printError("\(errorMessageClosure()). Try again.")
        return askForRequiredInfo(question: question, errorMessage: errorMessageClosure())
    }
    
    return info
}

func askForOptionalInfo(question: String, questionSuffix: String = "You may leave this empty.") -> String? {
    print("\(question) \(questionSuffix)")
    return readLine()?.nonEmpty
}

func askForBooleanInfo(question: String) -> Bool {
    let errorMessage = "Please enter Y/y (yes) or N/n (no)"
    let answerString = askForRequiredInfo(question: "\(question) (Y/N)", errorMessage: errorMessage)
    
    switch answerString.lowercased() {
    case "y":
        return true
    case "n":
        return false
    default:
        printError("\(errorMessage). Try again.")
        return askForBooleanInfo(question: question)
    }
}

func askForDestination() -> String {
    let destination = askForOptionalInfo(
        question: "📦  Where would you like to generate a project?",
        questionSuffix: "(Leave empty to use current directory)"
    )
    
    let fileManager = FileManager.default
    
    if let destination = destination {
        guard fileManager.fileExists(atPath: destination) else {
            printError("That path doesn't exist. Try again.")
            return askForDestination()
        }
        
        return destination
    }
    
    return fileManager.currentDirectoryPath
}

func askForProjectName(destination: String) -> String {
    let projectFolderName = destination.withoutSuffix("/").components(separatedBy: "/").last!
    
    let projectName = askForOptionalInfo(
        question: "📛  What's the name of your project?",
        questionSuffix: "(Leave empty to use the name of the project folder: \(projectFolderName))"
    )
    
    return projectName ?? projectFolderName
}

func askForAuthorName() -> String {
    let gitName = Process().gitConfigValue(forKey: "user.name")
    let question = "👶  What's your name?"
    
    if let gitName = gitName {
        let authorName = askForOptionalInfo(question: question, questionSuffix: "(Leave empty to use your git config name: \(gitName))")
        return authorName ?? gitName
    }
    
    return askForRequiredInfo(question: question, errorMessage: "Your name cannot be empty")
}

func askForAuthorEmail() -> String? {
    let gitEmail = Process().gitConfigValue(forKey: "user.email")
    let question = "📫  What's your email address (for Podspec)?"
    
    if let gitEmail = gitEmail {
        let authorEmail = askForOptionalInfo(question: question, questionSuffix: "(Leave empty to use your git config email: \(gitEmail))")
        return authorEmail ?? gitEmail
    }
    
    return askForOptionalInfo(question: question)
}

func askForGitHubURL(destination: String) -> String? {
    let gitURL = Process().launchBash(withCommand: "cd \(destination) && git remote get-url origin")?
        .trimmingCharacters(in: .whitespacesAndNewlines)
        .withoutSuffix(".git")
    
    let question = "🌍  Any GitHub URL that you'll be hosting this project at (for Podspec)?"
    
    if let gitURL = gitURL {
        let gitHubURL = askForOptionalInfo(question: question, questionSuffix: "(Leave empty to use the remote URL of your repo: \(gitURL))")
        return gitHubURL ?? gitURL
    }
    
    return askForOptionalInfo(question: question)
}
