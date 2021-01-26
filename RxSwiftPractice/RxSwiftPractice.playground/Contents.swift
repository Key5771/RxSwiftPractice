import UIKit
import RxSwift

public func example(of description: String, action: () -> Void) {
    print("\n--- Example of:", description, "---")
    action()
}

example(of: "just, of, from") {
    let one = 1
    let two = 2
    let three = 3
    
    let observable: Observable<Int> = Observable<Int>.just(one)
    
    let observable2 = Observable.of(one, two, three)
    
    let observable3 = Observable.of([one, two, three])
    
    let observable4 = Observable.from([one, two, three])
}

example(of: "subscribe") {
    let one = 1
    let two = 2
    let three = 3
    
    let observable = Observable.of(one, two, three)
//    observable.subscribe { event in
//        print(event) // next(1), next(2), next(3) 출력
//        if let element = event.element {
//            print(element) // 1, 2, 3 출력
//        }
//    }
    
    observable.subscribe(onNext: { element in
        print(element)
    })
}
