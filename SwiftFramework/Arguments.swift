import Foundation

struct Arguments {
    var destination: String?
    var projectName: String?
    var authorName: String?
    var authorEmail: String?
    var githubURL: String?
    var organizationName: String?
    var repositoryURL: URL?
    var forceEnabled: Bool = false
    
    init(commandLineArguments arguments: [String]) {
        for (index, argument) in arguments.enumerated() {
            switch argument.lowercased() {
            case "--destination", "-d":
                destination = arguments.element(after: index)
            case "--project", "-p":
                projectName = arguments.element(after: index)
            case "--name", "-n":
                authorName = arguments.element(after: index)
            case "--email", "-e":
                authorEmail = arguments.element(after: index)
            case "--url", "-u":
                githubURL = arguments.element(after: index)
            case "--organization", "-o":
                organizationName = arguments.element(after: index)
            case "--repo", "-r":
                if let urlString = arguments.element(after: index) {
                    repositoryURL = URL(string: urlString)
                }
            case "--force", "-f":
                forceEnabled = true
            default:
                break
            }
        }
    }
}
