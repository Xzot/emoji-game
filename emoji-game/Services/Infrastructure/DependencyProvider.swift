//
//  DependencyProvider.swift
//  emoji-game
//
//  Created by Vlad Shchuka on 19.12.2021.
//

import Swinject

// MARK: - Assembly protocol
protocol Assembly {
    func assemble(in container: Container)
}

// MARK: - ProductionAssmebly class
class ProductionAssmebly: Assembly {
    func assemble(in container: Container) {
        container.register(
            EmojiModelsProvider.self,
            factory: { _ in
                EmojiModelsProvider()
            }
        )
            .inObjectScope(.container)
        container.register(
            HypothesisProvider.self,
            factory: { resolver in
                HypothesisProvider(
                    emojisProvider: resolver.resolve(EmojiModelsProvider.self)!
                )
            }
        )
    }
}

// MARK: - DebugAssmebly class
class DebugAssmebly: ProductionAssmebly {
    override func assemble(in container: Container) {
        super.assemble(in: container)
    }
}

// MARK: - DependencyProvider final class
final class DependencyProvider {
    private let container = Container()
    private let assembly: Assembly
    
    var applicationObservableServices: [ApplicationObservable] {
//        [
//            get(UserInfoProvider.self)
//        ]
        fatalError()
    }
    
    init(assembly: Assembly) {
        self.assembly = assembly
        assembly.assemble(in: container)
    }
    
    func get<Service>(_ serviceType: Service.Type) -> Service {
        return container.resolve(serviceType)!
    }
}
