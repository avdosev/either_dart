/// Represents a value of one of two possible types.
/// Instances of [Either] are either an instance of [Left] or [Right].
///
/// [Left] is used for "failure".
/// [Right] is used for "success".
abstract class Either<L, R> {
  /// Represents the left side of [Either] class which by convention is a "Failure".
  bool get isLeft => this is Left<L, R>;

  /// Represents the right side of [Either] class which by convention is a "Success"
  bool get isRight => this is Right<L, R>;

  L get left => this.unite<L>(
      (value) => value,
      (right) => throw Exception(
          'Illegal use. You should check isLeft() before calling'));

  R get right => this.unite<R>(
      (left) => throw Exception(
          'Illegal use. You should check isRight() before calling'),
      (value) => value);

  /// Transform values of [Left] or [Right]
  Either<TL, TR> either<TL, TR>(TL Function(L) fnL, TR Function(R) fnR);

  /// Transform value of [Right] when transformation may be finished with an error
  Either<L, TR> then<TR>(Either<L, TR> Function(R) fnR);

  /// Transform value of [Right]
  Either<L, TR> map<TR>(TR Function(R) fnR);

  /// Unite [Left] and [Right] into the value of one type
  T unite<T>(T Function(L) fnL, T Function(R) fnR);
}

/// Used for "failure"
class Left<L, R> extends Either<L, R> {
  final L value;
  Left(this.value);

  @override
  Either<TL, TR> either<TL, TR>(TL Function(L) fnL, TR Function(R) fnR) {
    return Left<TL, TR>(fnL(value));
  }

  @override
  Either<L, TR> then<TR>(Either<L, TR> Function(R) fnR) {
    return Left<L, TR>(value);
  }

  @override
  Either<L, TR> map<TR>(TR Function(R) fnR) {
    return Left<L, TR>(value);
  }

  @override
  T unite<T>(T Function(L) fnL, T Function(R) fnR) {
    return fnL(value);
  }
}

/// Used for "success"
class Right<L, R> extends Either<L, R> {
  final R value;
  Right(this.value);

  @override
  Either<TL, TR> either<TL, TR>(TL Function(L) fnL, TR Function(R) fnR) {
    return Right<TL, TR>(fnR(value));
  }

  @override
  Either<L, TR> then<TR>(Either<L, TR> Function(R) fnR) {
    return fnR(value);
  }

  @override
  Either<L, TR> map<TR>(TR Function(R) fnR) {
    return Right<L, TR>(fnR(value));
  }

  @override
  T unite<T>(T Function(L) fnL, T Function(R) fnR) {
    return fnR(value);
  }
}
