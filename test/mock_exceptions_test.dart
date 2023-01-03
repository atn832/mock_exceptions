import 'package:mock_exceptions/mock_exceptions.dart';
import 'package:test/test.dart';

void main() {
  test('mockable exception', () {
    final f = MyFake();
    expect(() => f.doSomething('no'), returnsNormally);

    whenCalling(Invocation.method(#doSomething, [equals('fun')]))
        .on(f)
        .thenThrowException(Exception());
    expect(() => f.doSomething('fun'), throwsException);
    expect(() => f.doSomething('no fun'), returnsNormally);
  });
}

class MyFake {
  String doSomething(String input) {
    maybeThrowException(this, Invocation.method(#doSomething, [input]));
    return 'it works';
  }
}
