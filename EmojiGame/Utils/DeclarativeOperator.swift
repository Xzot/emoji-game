
postfix operator &>

postfix func &> <Value>(value: Value) -> Wrapper<Value> {
    .init(value: value)
}

struct Wrapper<Value> {
    let value: Value

    @discardableResult
    func `do`(_ applier: (Value) -> Void) -> Value where Value: AnyObject {
        applier(value)
        return value
    }

    func modify(_ modifier: (inout Value) -> Void) {
        var pointer = value
        modifier(&pointer)
    }
}
