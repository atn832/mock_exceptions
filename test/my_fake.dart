import 'package:mock_exceptions/mock_exceptions.dart';

class MyFake {
  String _name = 'name';

  String get name {
    maybeThrowException(this, Invocation.getter(#name));
    return _name;
  }

  set name(String value) {
    maybeThrowException(this, Invocation.setter(#name, value));
    _name = value;
  }

  String get description {
    maybeThrowException(this, Invocation.getter(#description));
    return 'description';
  }

  String doSomething(String input) {
    maybeThrowException(this, Invocation.method(#doSomething, [input]));
    return 'it works';
  }

  int add({required int i1, required int i2}) {
    maybeThrowException(
        this, Invocation.method(#add, null, {#i1: i1, #i2: i2}));
    return i1 + i2;
  }

  List<T> makeList<T>() {
    maybeThrowException(this, Invocation.genericMethod(#makeList, [T], null));
    return List<T>.empty();
  }
}
