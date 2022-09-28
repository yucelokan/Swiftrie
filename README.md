
# Swiftrie

First thing first, what is a [Trie](https://en.wikipedia.org/wiki/Trie).?

> In computer science, a trie, also called digital tree or prefix tree, is a kind of search tree —an ordered tree data structure used to store a dynamic set or associative array where the keys are usually strings. [...] All the descendants of a node have a common prefix of the string associated with that node, and the root is associated with the empty string. Keys tend to be associated with leaves, though some inner nodes may correspond to keys of interest. Hence, keys are not necessarily associated with every node.

This library provides all requirements about Trie implementation on Swift. 

What does this library offer:

* First of all everything; `Swiftrie works with Codables`, not only with words. Every final node stores a JSON string for itself. It means you can use it with Codables.

* Suit for all data models. Just implement `Swiftriable Interface` and that's all you need to make your model suit for Swiftrie.

* A new item can be `insertable`/`removable`.

* `Cancelable searches`. Swiftrie does it automatically. If you call the searching method again while the algorithm is searching a prefix, Swiftrie cancels the last search. 

* Also you can add `throttle`/`delay` while searching in Swiftrie to prevent unnecessary searches. `Default is 0`. Because `Swiftrie can show results in 0.001 seconds in 209k data for an entered character`.  Because Swiftrie does not wait for all nodes that will be visited. Check the following topic.

* Swiftrie provides showing results part by part. No need waiting for until the algorithm visits all nodes. It returns the results while visiting the nodes. To manage this logic just use `.gradually`.  Default is `case indexable(_ index: 3)` index 3 means, the find method will return the response that it found at every 3 nodes without waiting for all nodes that will be visited.

* Everything in a `custom queue`. QoS is `.userInitiated`. And it is `concurrent`.

* Inserting and removing an item executes with `.barrier` in the custom queue. It means searching/getting will wait for inserting/removing and the algorithm will show correct results always.

* Unit tests have provided.

## Codes
```swift
let trie = Swiftrie(swiftriables: response.cities)

trie.gradually = .indexable(3)

trie.removeItem(/* a swiftriable item */)

trie.insertItem(/* a swiftriable item */)

let cities: [City] = trie.getAllItems()

trie.findItems(prefix: "istanbu", throttle: 0, type: City.self) { result in
    print(result)
}

trie.cancelSearch()
```

### Swift Package Manager

To install CustomNavigationBar using [Swift Package Manager](https://github.com/apple/swift-package-manager)  you can follow the [tutorial published by Apple](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app) using the URL for the Swiftrie repo with the current version:

1. In Xcode, select “File” → “Swift Packages” → “Add Package Dependency”
1. Enter https://github.com/yucelokan/Swiftrie.git
