import 'package:mock_exceptions/mock_exceptions.dart';
import 'package:test/test.dart';

void main() {
  test('mockable exception', () {
    final f = MyFake();
    whenCalling(Invocation.method(#doSomething, [anything]))
        .on(f)
        .thenThrowException(Exception());
    expect(() => f.doSomething('fun'), throwsException);
  });
}

class MyFake {
  String doSomething(String input) {
    // Throw an exception if a relevant Invocation matcher has been registered.
    maybeThrowException(this, Invocation.method(#doSomething, [input]));
    // Do regular work.
    return 'it works';
  }
}
