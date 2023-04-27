import 'dart:async';

import './either.dart';

extension FutureEither<L, R> on Future<Either<L, R>> {
  /// Represents the left side of [Either] class which by convention is a "Failure".
  Future<bool> get isLeft => this.then((either) => either.isLeft);

  /// Represents the right side of [Either] class which by convention is a "Success"
  Future<bool> get isRight => this.then((either) => either.isRight);

  /// Transform values of [Left] and [Right]
  Future<Either<TL, TR>> either<TL, TR>(
          TL Function(L left) fnL, TR Function(R right) fnR) =>
      this.then((either) => either.either(fnL, fnR));

  /// Transform value of [Right]
  Future<Either<L, TR>> mapRight<TR>(FutureOr<TR> Function(R right) fnR) =>
      this.then((either) => either.mapAsync(fnR));

  /// Transform value of [Left]
  Future<Either<TL, R>> mapLeft<TL>(FutureOr<TL> Function(L left) fnL) =>
      this.then((either) => either.mapLeftAsync(fnL));

  /// Transform value of [Right] when transformation may be finished with an error
  @Deprecated('Should use thenRight')
  Future<Either<L, TR>> thenRightSync<TR>(
          Either<L, TR> Function(R right) fnR) =>
      this.then((either) => either.then(fnR));

  /// Transform value of [Left] when transformation may be finished with an [Right]
  @Deprecated('Should use thenLeft')
  Future<Either<TL, R>> thenLeftSync<TL>(Either<TL, R> Function(L left) fnL) =>
      this.then((either) => either.thenLeft(fnL));

  /// Async transform value of [Right]
  @Deprecated('Should use mapRight')
  Future<Either<L, TR>> mapRightAsync<TR>(Future<TR> Function(R right) fnR) =>
      this.then((either) => either.mapAsync(fnR));

  /// Async transform value of [Left]
  @Deprecated('Should use mapLeft')
  Future<Either<TL, R>> mapLeftAsync<TL>(Future<TL> Function(L left) fnL) =>
      this.then((either) => either.mapLeftAsync(fnL));

  /// Async transform value of [Right] when transformation may be finished with an error
  Future<Either<L, TR>> thenRight<TR>(
          FutureOr<Either<L, TR>> Function(R right) fnR) =>
      this.then((either) => either.thenAsync(fnR));

  /// Async transform value of [Left] when transformation may be finished with an [Right]
  Future<Either<TL, R>> thenLeft<TL>(
          FutureOr<Either<TL, R>> Function(L left) fnL) =>
      this.then((either) => either.thenLeftAsync(fnL));

  /// Fold [Left] and [Right] into the value of one type
  Future<T> fold<T>(
    FutureOr<T> Function(L left) fnL,
    FutureOr<T> Function(R right) fnR,
  ) {
    return this.then((either) => either.fold(fnL, fnR));
  }

  /// Swap [Left] and [Right]
  Future<Either<R, L>> swap() =>
      this.fold<Either<R, L>>((left) => Right(left), (right) => Left(right));
}
