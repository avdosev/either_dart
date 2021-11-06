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

Also, i can use `Either.cond` and `Either.condLazy` for simple cases. Like this:

```dart
  return Either.condLazy(cities.contains(code), 
    () => cities[code]!, 
    () => MyError(
      key: AppError.NotFound, 
      message: '[getCityNameByCode] can`t convert code:$code to city name',
    ),
  );
```

Further, there will be intermediate transformations. 
Either has the following methods:
| name | result | description |
| --- | --- | --- |
| `either<TL, TR>(TL fnL(L left), TR fnR(R right))` | `Either<TL, TR>` | Transform values of Left and Right
| `fold<T>(T fnL(L left), T fnR(R right))` | `T` | Fold Left and Right into the value of one type
| `map<TR>(TR fnR(R right))` | `Either<L, TR>` | Transform value of Right
| `mapAsync<TR>(Future<TR> fnR(R right))` | `Future<Either<L, TR>>` | Transform value of Right
| `mapLeft<TL>(TL fnL(L left))` | `Either<TL, R>` | Transform value of Left
| `mapLeftAsync<TL>(Future<TL> fnL(L left))` | `Future<Either<TL, R>>` | Transform value of Left
| `swap()` | `Either<R, L>` | Swap Left and Right
| `then<TR>(Either<L, TR> fnR(R right))` | `Either<L, TR>` | Transform value of Right when transformation may be finished with an error
| `thenAsync<TR>(Future<Either<L, TR>> fnR(R right))` | `Future<Either<L, TR>>` | Transform value of Right when transformation may be finished with an error
| `thenLeft<TL>(Either<TL, R> fnL(L left))` | `Either<TL, R>` | Transform value of Left when transformation may be finished with an Right
| `thenLeftAsync<TL>(Future<Either<TL, R>> fnL(L left))` | `Future<Either<TL, R>>` | Transform value of Left when transformation may be finished with an Right

