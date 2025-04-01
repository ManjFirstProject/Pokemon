import XCTest
import Networking
import TestingSupport
@testable import PokemonGame

final class PokemonViewModelTests: XCTestCase {
    private var underTest: PokemonViewModel!
    private var assert: Assert<Void>!

    override func setUp() {
        super.setUp()
        assert = .init()
    }

    @MainActor
    func testGetPokemonsSuccess() async {
        underTest = makeUnderTest(result: .success(.stub()))

        // WHEN
        await underTest.getPokemons()

        // THEN
        XCTAssertTrue(assert.wasCalledOnce)
    }

    @MainActor
    func testGetPokemonsFailure() async {
        underTest = makeUnderTest(result: .failure(API.Error.server))

        // WHEN
        await underTest.getPokemons()

        // THEN
        XCTAssertTrue(assert.wasCalledOnce)
    }

    // MARK: - Helpers
    private func makeUnderTest(
        result: Result<PokemonResponse, Error> = .success(.stub())
    ) -> PokemonViewModel {
        return .init(
            repository: .mock(
                fetch: {
                    self.assert.call(())
                    switch result {
                    case let .success(response): return response
                    case let .failure(error): throw error
                    }
                }
            )
        )
    }
}
