# mock_exceptions

Provides a mechanism to throw exceptions on certain calls. This is useful when working with a Fake and we still want to occasionally make it throw exceptions.

## Features

- supports regular matchers.

## Usage

1. In your Fake method implementation, add `maybeThrowException` at the beginning:
1. In your unit test, set up an expectation, then verify your expectations as usual.

### Before

Your Fake method might look like this. It does some real work.

```dart
class MyFake {
  String doSomething(String input) {
    return 'it works';
  }
}
```

Your unit test might even check that it works.

```dart
final fake = MyFake();
expect(fake.doSomething('yes'), 'it works');
```

### After

Your Fake method checks for possible exceptions before doing the work.

```dart
class MyFake {
  String doSomething(String input) {
    maybeThrowException(this, Invocation.method(#doSomething, [input]));
    return 'it works';
  }
}
```

You can now forcefully throw exceptions and test for them.

```dart
final fake = MyFake();
whenCalling(Invocation.method(#doSomething, [equals('fun')]))
    .on(fake)
    .thenThrowException(Exception());
expect(() => fake.doSomething('fun'), throwsException);
```

## Design considerations

- Instead of `whenCalling(Invocation.method(#doSomething, [equals('fun')])).on(fake).thenThrowException(Exception());`,
why not reimplement Mockito's API so that I can do `when(fake.doSomething('fun')).thenThrow(Exception())`?
  - Implementing Mockito's API requires relying on the `noSuchMethod` trick to detect the Invocation. As of writing, the whole thing takes 1200 lines of code while ours takes around 60. Even if we pare Mockito's down to the minimum (excluding verifications, captures), it'd still take around 500 lines of code.
  - It also requires the Fakes to extend a pre-defined class with that behavior. In some projects such as Fake Cloud Firestore ([example](https://github.com/atn832/fake_cloud_firestore/blob/ac1d536f43048a152f78e643315f3f9326722d3e/lib/src/mock_collection_reference.dart#L16)), this is not a luxury we have.