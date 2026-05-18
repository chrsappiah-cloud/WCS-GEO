import Foundation
import Observation

@Observable
final class AppSession {
    var isSignedIn = false
    var selectedOrganization: Organization?
    var selectedProject: Project?

    var isReadyForMainApp: Bool {
        isSignedIn && selectedOrganization != nil
    }

    func signIn() {
        isSignedIn = true
    }

    func signOut() {
        isSignedIn = false
        selectedOrganization = nil
        selectedProject = nil
    }

    func selectOrganization(_ organization: Organization) {
        selectedOrganization = organization
        selectedProject = organization.projects.first
    }
}

struct Organization: Identifiable, Hashable {
    let id: String
    let name: String
    let projects: [Project]

    static let demo = Organization(
        id: "org-wcs-demo",
        name: "World Class Scholars — Demo",
        projects: [.kalgoorlieGold]
    )
}

struct Project: Identifiable, Hashable {
    let id: String
    let name: String
    let commodity: String
    let region: String

    static let kalgoorlieGold = Project(
        id: "proj-kalgoorlie",
        name: "Kalgoorlie Gold",
        commodity: "Au",
        region: "Western Australia"
    )
}
