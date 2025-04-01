public struct Assert<T> {
    private(set) var values: [T] = []
    public var wasCalled: Bool { !values.isEmpty }
    public var wasNotCalled: Bool { !wasCalled }
    public var callsCount: Int { values.count }
    public var wasCalledOnce: Bool { values.count == 1 }
    public var currentValue: T? { values.last }
    public mutating func call(_ value: T) { values.append(value) }
    public init() {}
}
