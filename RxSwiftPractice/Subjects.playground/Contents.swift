import UIKit
import RxSwift
import RxCocoa

public func example(of description: String, action: () -> Void) {
    print("\n--- Example of:", description, "---")
    action()
}

enum MyError: Error {
    case anError
}

// MARK: - PublishSubject
example(of: "PublishSubject") {
    let subject = PublishSubject<String>()
    
    subject.onNext("Is anyone listening?")
    
    let subscriptionOne = subject.subscribe(onNext: { string in
        print(string)
    })
    
    subject.on(.next("1"))
    subject.onNext("2")
    
    let subscriptionTwo = subject.subscribe { event in
        print("2)", event.element ?? event)
    }
    
    subject.onNext("3")
    
    subscriptionOne.dispose()
    subject.onNext("4")
    
    print("before")
    subject.onCompleted()
    print("after")
    
    subject.onNext("5")
    
    subscriptionTwo.dispose()
    
    let disposeBag = DisposeBag()
    
    subject.subscribe {
        print("3)", $0.element ?? $0)
    }.disposed(by: disposeBag)
    
    subject.onNext("?")
}

// MARK: - BehaviorSubject
func print<T: CustomStringConvertible>(label: String, event: Event<T>) {
    print(label, (event.element ?? event.error) ?? event)
}

example(of: "Behavior") {
    let subject = BehaviorSubject(value: "Initial value")
    let dispostBag = DisposeBag()
    
    subject.onNext("X")
    
    subject.subscribe {
        print(label: "1)", event: $0)
    }.disposed(by: dispostBag)
    
    subject.onError(MyError.anError)
    
    subject.subscribe {
        print(label: "2)", event: $0)
    }.disposed(by: dispostBag)
}


// MARK: - ReplaySubject
example(of: "ReplaySubject") {
    let subject = ReplaySubject<String>.create(bufferSize: 2)
    let disposeBag = DisposeBag()
    
    subject.onNext("1")
    subject.onNext("2")
    subject.onNext("3")
    
    subject.subscribe {
        print(label: "1)", event: $0)
    }.disposed(by: disposeBag)
    
    subject.subscribe {
        print(label: "2)", event: $0)
    }.disposed(by: disposeBag)
    
    subject.onNext("4")
    
    subject.onError(MyError.anError)
    subject.dispose()
    
    subject.subscribe {
        print(label: "3)", event: $0)
    }.disposed(by: disposeBag)
}


// MARK: - PublishRelay

example(of: "PublishRelay") {
    let relay = PublishRelay<String>()
    let disposeBag = DisposeBag()
    
    relay.accept("Knock knock, anyone home?")
    relay.subscribe(onNext: {
        print($0)
    }).disposed(by: disposeBag)
    
    relay.accept("1")
}

// MARK: - BehaviorRelay

example(of: "BehaviorRelay") {
    let relay = BehaviorRelay(value: "Initial value")
    let disposeBag = DisposeBag()
    
    relay.accept("New initial value")
    
    relay.subscribe {
        print(label: "1)", event: $0)
    }.disposed(by: disposeBag)
    
    relay.accept("1")
    
    relay.subscribe {
        print(label: "2)", event: $0)
    }.disposed(by: disposeBag)
    
    relay.accept("2")
    
    print("relay value: \(relay.value)")
}
