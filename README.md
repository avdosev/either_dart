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

Sections:
* [Basic usage](#basic-usage)
* [Case - Solution](#case---solution)

### Basic usage

Create two entities for example, you can use your own abstractions for your project.

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
    return Right(cities[code]!);
  } else {
    return Left(
      key: AppError.NotFound, 
      message: '[getCityNameByCode] can`t convert code:$code to city name',
    );
  }
}
```

Too, you can use `Either.cond` and `Either.condLazy` for simple cases. Like this:

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

***disclaimer:*** \
L - current `Left` type \
TL - new generic `Left` type \
R - current `Right` type \
TR - new generic `Right` type


| name | result | description |
| --- | --- | --- |
| `isLeft` | `bool` | Represents the left side of Either class which by convention is a "Failure". |
| `isRight` | `bool` | Represents the right side of Either class which by convention is a "Success" |
| `left` | `L` | Get Left value, may throw an exception when the value is Right. **read-only** |
| `right` | `R` | Get Right value, may throw an exception when the value is Left. **read-only** |
| `either<TL, TR>(TL fnL(L left), TR fnR(R right))` | `Either<TL, TR>` | Transform values of Left and Right
| `fold<T>(T fnL(L left), T fnR(R right))` | `T` | Fold Left and Right into the value of one type
| `map<TR>(TR fnR(R right))` | `Either<L, TR>` | Transform value of Right
| `mapLeft<TL>(TL fnL(L left))` | `Either<TL, R>` | Transform value of Left
| `mapAsync<TR>(Future<TR> fnR(R right))` | `Future<Either<L, TR>>` | Transform value of Right
| `mapLeftAsync<TL>(Future<TL> fnL(L left))` | `Future<Either<TL, R>>` | Transform value of Left
| `swap()` | `Either<R, L>` | Swap Left and Right
| `then<TR>(Either<L, TR> fnR(R right))` | `Either<L, TR>` | Transform value of Right when transformation may be finished with an error
| `thenLeft<TL>(Either<TL, R> fnL(L left))` | `Either<TL, R>` | Transform value of Left when transformation may be finished with an Right
| `thenAsync<TR>(Future<Either<L, TR>> fnR(R right))` | `Future<Either<L, TR>>` | Transform value of Right when transformation may be finished with an error
| `thenLeftAsync<TL>(Future<Either<TL, R>> fnL(L left))` | `Future<Either<TL, R>>` | Transform value of Left when transformation may be finished with an Right

### Case - Solution

* How i can use value of `Either`?

You can use right or left getters, but you should check what value is stored inside (`isLeft` or `isRight`)

Also, my favorite methods `fold`, `either`

* `fold` - used when you need transform two rails to one type
* `either` - used for two situation: 1. when you need transform left and right. 2. when you need use stored value with out next usage (see example). 

Example: 
```dart
/// either method
showNotification(Either<MyError, String> value) {
  return value.either(
    (left) => showWarning(left.message ?? left.key.toString()),
    (right) => showInfo(right.toString()),
  );
  /// equal
  if (value.isLeft) {
    final left = value.left;
    showWarning(left.message ?? left.key.toString()
  } else {
    final right = value.right;
    showInfo(right.toString())
  }
}
```
```dart
/// fold method
class MyWidget {
  final Either<MyError, List<String>> value;

  const MyWidget(this.value);

  Widget build(BuildContext context) {
    return Text(
      value.fold(
        (left) => left.message, 
        (right) => right.join(', ')),
    );
    /// or
    return value.fold(
      (left) => _buildSomeErrorWidget(context, left),
      (right) => _buildSomeRightWidget(context, right),
    );
  }
}
```
