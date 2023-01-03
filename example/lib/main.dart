import 'package:mock_exceptions/mock_exceptions.dart';
import 'package:test/test.dart';

void main() {
  test('mockable exception', () {
    final f = MyFake();
    whenCalling(Invocation.method(#doSomething, null))
        .on(f)
        .thenThrowException(Exception());
    expect(() => f.doSomething(), throwsException);
  });
}

class MyFake {
  String doSomething() {
    // Throw an exception if a relevant Invocation matcher has been registered.
    maybeThrowException(this, Invocation.method(#doSomething, null));
    // Do regular work.
    return 'it works';
  }
}
