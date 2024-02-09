
import Foundation
import Combine
import SwiftUI // To use UIImage

// Enumeration to represent the state of registration
enum RegistrationStateEnum {
    case successful
    case failed(error: Error)
    case na
}

// Protocol defining the requirements for a Registration ViewModel
protocol RegistrationViewModel {
    var service: RegistrationService { get }
    var state: RegistrationStateEnum { get }
    var userDetails: UserRegistrationInfo { get }
    var profileImage: UIImage? { get }
    var hasError: Bool { get }

    func register()
    init(service: RegistrationService)
}
final class RegistrationViewModelController: RegistrationViewModel, ObservableObject {
    @Published var hasError: Bool = false
    @Published var state: RegistrationStateEnum = .na
    @Published var userDetails: UserRegistrationInfo = UserRegistrationInfo(email: "", password: "", firstName: "", lastName: "", username: "")
    @Published var profileImage: UIImage? = nil // Add a property for the profile image
    
    let service: RegistrationService
    private var subscriptions = Set<AnyCancellable>()
    
    init(service: RegistrationService) {
        self.service = service
        setupErrorSubscriptions()
    }
    
    func register() {
        service.register(with: userDetails, profileImage: profileImage ?? UIImage())
            .sink { [weak self] res in
                switch res {
                case .failure(let err):
                    self?.state = .failed(error: err)
                default: break
                }
            } receiveValue: { [weak self] in
                self?.state = .successful
            }
            .store(in: &subscriptions)
    }
}

private extension RegistrationViewModelController {
    
    // Observing if the value for $state changes, we are going to map it to $hasError
    // depending on whether it was successful/ na or if the state is currently set to failed, meaning
    // that some error has occured, such as the registration details not being filled in, email vice versa.
    func setupErrorSubscriptions() {
        $state
            .map { state -> Bool in
                switch state {
                case .successful,
                        .na:
                    return false
                case .failed:
                    return true
                }
            }
            .assign(to: &$hasError)
    }
}

// REFERENCES:
// FIREBASE: https://www.youtube.com/watch?v=6b2WAePdiqA&ab_channel=LoganKoshenka
// FIREBASE, COMBINE: https://www.youtube.com/watch?v=5gIuYHn9nOc&list=LL&index=27&ab_channel=tundsdev
