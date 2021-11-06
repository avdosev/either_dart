# either dart &middot; ![build status](https://github.com/avdosev/either_dart/workflows/unittests/badge.svg)


The library for error handling and railway oriented programming.

This library supports async "map" and async "then" hiding the boilerplate of working with asynchronous computations Future\[Either\].

## Installation

Add on pubspec.yml:

```
dependencies:
  either_dart: ... // latest package version
```

## Documentation

https://pub.dev/documentation/either_dart/latest/either/either-library.html

## Pub dev

https://pub.dev/packages/either_dart

## How to use it?


I created two entities for example, you can use your own abstractions for your project.

```dart
enum AppError {
  NotFound;
}

class MyError {
  final AppError key;
  final String? message;

  const MyError({
    required this.key, 
    this.message,
  });
}
```

Start use.

```dart
Either<MyError, String> getCityNameByCode(int code) {
  const cities = <int, String>{
    /// some cities
  };

  if (cities.contains(code)) {
    return Right(cities[code]);
  } else {
    return Left(
      key: AppError.NotFound, 
      message: '[getCityNameByCode] can`t convert code:$code to city name',
    );
  }
}
```

Also, i can use Either.cond and Either.condLazy for simple cases. Like this:

```dart
  return Either.condLazy(cities.contains(code), 
    () => cities[code]!, 
    () => MyError(
      key: AppError.NotFound, 
      message: '[getCityNameByCode] can`t convert code:$code to city name',
    ),
  );
```

