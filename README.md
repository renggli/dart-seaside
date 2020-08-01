This is the code accompanying the blog articles 

1. [Seaside in under 100 lines of Dart code](https://www.lukas-renggli.ch/blog/seaside-dart), and
2. [Adding call/answer in under 35 lines of Dart code](https://www.lukas-renggli.ch/blog/call-answer-dart).

To try locally, [install Dart](https://dart.dev/) and execute the following commands:

```
git clone https://github.com/renggli/dart-seaside.git
cd dart-seaside

pub update
pub run bin/server.dart 
```

In your browser navigate to the example applications at:

- [http://localhost:8080/calculator-cc]()
- [http://localhost:8080/calculator-cps]()
- [http://localhost:8080/counter]()
- [http://localhost:8080/hello-world]()
- [http://localhost:8080/multi-counter]()
- [http://localhost:8080/number-guessing]()
- [http://localhost:8080/tabbed-counter]()

As always, this is under the [MIT License](https://raw.githubusercontent.com/renggli/dart-seaside/master/LICENSE).