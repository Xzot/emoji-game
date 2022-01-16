//
//  DependencyProvider.swift
//  emoji-game
//
//  Created by Vlad Shchuka on 19.12.2021.
//

import Swinject

// MARK: - DependencyAssembly class
final class DependencyAssembly {
    func assemble(in container: Container) {
        container.register(
            GASProvider.self,
            factory: { _ in
                GASProvider()
            }
        )
            .inObjectScope(.container)
        
        container.register(
            HapticService.self,
            factory: { resolver in
                HapticService(
                    gameStateProvider: resolver.resolve(GASProvider.self)!
                )
            }
        )
            .inObjectScope(.container)
        
        container.register(
            AppAdService.self,
            factory: { _ in
                AppAdService()
            }
        )
            .inObjectScope(.container)
        
        container.register(
            GameScoreHandler.self,
            factory: { _ in
                GameScoreHandler(
                    config: .init(addedPoints: 10, takenAwayPoints: 25)
                )
            }
        )
            .inObjectScope(.container)
        
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
        
        container.register(
            TimeUpdater.self,
            factory: { _ in
                TimeUpdater()
            }
        )
        
        container.register(
            GameDataService.self,
            factory: { resolver in
                GameDataService(
                    modelsProvider: resolver.resolve(GameModelsProvider.self)!
                )
            }
        )
            .inObjectScope(.container)
        
        container.register(
            GameModelsProvider.self,
            factory: { resolver in
                GameModelsProvider(
                    hypoProvider: resolver.resolve(HypothesisProvider.self)!,
                    gModelsFactory: resolver.resolve(GameModelFactory.self)!,
                    emojiImageLoader: resolver.resolve(EmojiImageLoader.self)!,
                    emojiModelsProvider: resolver.resolve(EmojiModelsProvider.self)!
                )
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
        
        container.register(
            GameModelFactory.self,
            factory: { resolver in
                GameModelFactory(
                    emojisList: resolver.resolve(EmojiModelsProvider.self)!
                )
            }
        )
        
        container.register(
            EmojiImageLoader.self,
            factory: { resolver in
                EmojiImageLoader(
                    imageDataLoader: resolver.resolve(ImageDataLoader.self)!
                )
            }
        )
        
        container.register(
            ImageDataLoader.self,
            factory: { _ in
                ImageDataLoader()
            }
        )
    }
}

// MARK: - DependencyProvider final class
final class DependencyProvider {
    private let container = Container()
    private let assembly: DependencyAssembly
    
    var applicationObservableServices: [ApplicationObservable] {
//        [
//            get(UserInfoProvider.self)
//        ]
        fatalError()
    }
    
    init(assembly: DependencyAssembly) {
        self.assembly = assembly
        assembly.assemble(in: container)
    }
    
    func get<Service>(_ serviceType: Service.Type) -> Service {
        return container.resolve(serviceType)!
    }
}

// MARK: - API
extension DependencyProvider {
    static var standart: DependencyProvider {
        .init(
            assembly: DependencyAssembly()
        )
    }
}
