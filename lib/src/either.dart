import 'dart:async';

typedef Lazy<T> = T Function();

/// Represents a value of one of two possible types.
/// Instances of [Either] are either an instance of [Left] or [Right].
///
/// [Left] is used for "failure".
/// [Right] is used for "success".
sealed class Either<L, R> {
  const Either();

  /// Represents the left side of [Either] class which by convention is a "Failure".
  bool get isLeft => this is Left<L, R>;

  /// Represents the right side of [Either] class which by convention is a "Success"
  bool get isRight => this is Right<L, R>;

  /// Get [Left] value, may throw an exception when the value is [Right]
  L get left => this.fold<L>(
      (value) => value,
      (right) => throw Exception(
          'Illegal use. You should check isLeft before calling'));

  /// Get [Right] value, may throw an exception when the value is [Left]
  R get right => this.fold<R>(
      (left) => throw Exception(
          'Illegal use. You should check isRight before calling'),
      (value) => value);

  /// Transform values of [Left] and [Right]
  Either<TL, TR> either<TL, TR>(
      TL Function(L left) fnL, TR Function(R right) fnR);

  /// Transform value of [Right] when transformation may be finished with an error
  Either<L, TR> then<TR>(Either<L, TR> Function(R right) fnR);

  /// Transform value of [Right] when transformation may be finished with an error
  Future<Either<L, TR>> thenAsync<TR>(
      FutureOr<Either<L, TR>> Function(R right) fnR);

  /// Transform value of [Left] when transformation may be finished with an [Right]
  Either<TL, R> thenLeft<TL>(Either<TL, R> Function(L left) fnL);

  /// Transform value of [Left] when transformation may be finished with an [Right]
  Future<Either<TL, R>> thenLeftAsync<TL>(
      FutureOr<Either<TL, R>> Function(L left) fnL);

  /// Transform value of [Right]
  Either<L, TR> map<TR>(TR Function(R right) fnR);

  /// Transform value of [Left]
  Either<TL, R> mapLeft<TL>(TL Function(L left) fnL);

  /// Transform value of [Right]
  Future<Either<L, TR>> mapAsync<TR>(FutureOr<TR> Function(R right) fnR);

  /// Transform value of [Left]
  Future<Either<TL, R>> mapLeftAsync<TL>(FutureOr<TL> Function(L left) fnL);

  /// Fold [Left] and [Right] into the value of one type
  T fold<T>(T Function(L left) fnL, T Function(R right) fnR);

  /// Swap [Left] and [Right]
  Either<R, L> swap() => fold((left) => Right(left), (right) => Left(right));

  /// Constructs a new [Either] from a function that might throw
  static Either<L, R> tryCatch<L, R, Err extends Object>(
      L Function(Err err) onError, R Function() fnR) {
    try {
      return Right(fnR());
    } on Err catch (e) {
      return Left(onError(e));
    }
  }

  /// Constructs a new [Either] from a function that might throw
  /// 
  /// simplified version of [Either.tryCatch]
  ///
  /// ```dart
  /// final fileOrError = Either.tryExcept<FileError>(() => /* maybe throw */);
  /// ```
  static Either<Err, R> tryExcept<Err extends Object, R>(R Function() fnR) {
    try {
      return Right(fnR());
    } on Err catch (e) {
      return Left(e);
    }
  }

  /// If the condition is true then return [rightValue] in [Right] else [leftValue] in [Left]
  static Either<L, R> cond<L, R>(bool test, L leftValue, R rightValue) =>
      test ? Right(rightValue) : Left(leftValue);

  /// If the condition is true then return [rightValue] in [Right] else [leftValue] in [Left]
  static Either<L, R> condLazy<L, R>(
          bool test, Lazy<L> leftValue, Lazy<R> rightValue) =>
      test ? Right(rightValue()) : Left(leftValue());

  @override
  bool operator ==(Object obj) {
    return this.fold(
      (left) => obj is Left && left == obj.value,
      (right) => obj is Right && right == obj.value,
    );
  }

  @override
  int get hashCode => fold((left) => left.hashCode, (right) => right.hashCode);
}

/// Used for "failure"
class Left<L, R> extends Either<L, R> {
  final L value;

  const Left(this.value);

  @override
  Either<TL, TR> either<TL, TR>(
      TL Function(L left) fnL, TR Function(R right) fnR) {
    return Left<TL, TR>(fnL(value));
  }

  @override
  Either<L, TR> then<TR>(Either<L, TR> Function(R right) fnR) {
    return Left<L, TR>(value);
  }

  @override
  Future<Either<L, TR>> thenAsync<TR>(
      FutureOr<Either<L, TR>> Function(R right) fnR) {
    return Future.value(Left<L, TR>(value));
  }

  @override
  Either<TL, R> thenLeft<TL>(Either<TL, R> Function(L left) fnL) {
    return fnL(value);
  }

  @override
  Future<Either<TL, R>> thenLeftAsync<TL>(
      FutureOr<Either<TL, R>> Function(L left) fnL) {
    return Future.value(fnL(value));
  }

  @override
  Either<L, TR> map<TR>(TR Function(R right) fnR) {
    return Left<L, TR>(value);
  }

  @override
  Either<TL, R> mapLeft<TL>(TL Function(L left) fnL) {
    return Left<TL, R>(fnL(value));
  }

  @override
  Future<Either<L, TR>> mapAsync<TR>(FutureOr<TR> Function(R right) fnR) {
    return Future.value(Left<L, TR>(value));
  }

  @override
  Future<Either<TL, R>> mapLeftAsync<TL>(FutureOr<TL> Function(L left) fnL) {
    return Future.value(fnL(value)).then((value) => Left<TL, R>(value));
  }

  @override
  T fold<T>(T Function(L left) fnL, T Function(R right) fnR) {
    return fnL(value);
  }
}

/// Used for "success"
class Right<L, R> extends Either<L, R> {
  final R value;

  const Right(this.value);

  @override
  Either<TL, TR> either<TL, TR>(
      TL Function(L left) fnL, TR Function(R right) fnR) {
    return Right<TL, TR>(fnR(value));
  }

  @override
  Either<L, TR> then<TR>(Either<L, TR> Function(R right) fnR) {
    return fnR(value);
  }

  @override
  Future<Either<L, TR>> thenAsync<TR>(
      FutureOr<Either<L, TR>> Function(R right) fnR) {
    return Future.value(fnR(value));
  }

  @override
  Either<TL, R> thenLeft<TL>(Either<TL, R> Function(L left) fnL) {
    return Right<TL, R>(value);
  }

  @override
  Future<Either<TL, R>> thenLeftAsync<TL>(
      FutureOr<Either<TL, R>> Function(L left) fnL) {
    return Future.value(Right<TL, R>(value));
  }

  @override
  Either<L, TR> map<TR>(TR Function(R right) fnR) {
    return Right<L, TR>(fnR(value));
  }

  @override
  Either<TL, R> mapLeft<TL>(TL Function(L left) fnL) {
    return Right<TL, R>(value);
  }

  @override
  Future<Either<L, TR>> mapAsync<TR>(FutureOr<TR> Function(R right) fnR) {
    return Future.value(fnR(value)).then((value) => Right<L, TR>(value));
  }

  @override
  Future<Either<TL, R>> mapLeftAsync<TL>(FutureOr<TL> Function(L left) fnL) {
    return Future.value(Right<TL, R>(value));
  }

  @override
  T fold<T>(T Function(L left) fnL, T Function(R right) fnR) {
    return fnR(value);
  }
}
