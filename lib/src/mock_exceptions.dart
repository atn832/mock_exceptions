import 'package:matcher/matcher.dart';

Map<Object, Map<Invocation, Exception>> expectations = {};

void register(Object o, Invocation i, Exception e) {
  expectations.putIfAbsent(o, () => {});
  expectations[o]![i] = e;
}

/// To be used within Fakes. The method calls this to throw an exception if a
/// matching invocation has been registered. If not, the method can behave
/// normally.
void maybeThrowException(Object o, Invocation i) {
  // check the registry. Throw an error, or nothing.
  if (!expectations.containsKey(o)) {
    return;
  }
  for (final expectation in (expectations[o] ?? {}).entries) {
    if (_matches(expectation.key, i)) {
      throw expectation.value;
    }
  }
}

bool _matches(
    Invocation invocationWithMatchers, Invocation concreteInvocation) {
  return invocationWithMatchers.isMethod == concreteInvocation.isMethod &&
      invocationWithMatchers.isGetter == concreteInvocation.isGetter &&
      invocationWithMatchers.isSetter == concreteInvocation.isSetter &&
      invocationWithMatchers.memberName == concreteInvocation.memberName &&
      equals(invocationWithMatchers.positionalArguments)
          .matches(concreteInvocation.positionalArguments, {}) &&
      equals(invocationWithMatchers.namedArguments)
          .matches(concreteInvocation.namedArguments, {}) &&
      equals(invocationWithMatchers.typeArguments)
          .matches(concreteInvocation.typeArguments, {});
}

/// Named differently from Mockito's `when` to prevent conflicts.
PostWhenCalling whenCalling(Invocation i) {
  return PostWhenCalling(i);
}

class PostWhenCalling<T> {
  PostWhenCalling(this.i);

  final Invocation i;

  PostOn<T> on(Object o) {
    return PostOn<T>(o, i);
  }
}

class PostOn<T> {
  PostOn(this.o, this.i);

  final Object o;
  final Invocation i;

  thenThrowException(Exception e) {
    // o i e, literally Oh yeah.
    register(o, i, e);
  }
}
