import 'dart:async';

import 'package:test/test.dart';

import 'package:either_dart/either.dart';

extension XFuture<T> on FutureOr<T> {
  Future<T> get future => Future.value(this);
}

extension XValue<T> on T {
  Future<T> get future => Future.value(this);
}

void main() {
  test('right generic is right', () async {
    final maybe = Right<String, bool>(true).future;
    expect(await maybe.isRight, true);
    expect(await maybe.isLeft, false);
  });

  test('left generic is left', () async {
    final maybe = Left<String, bool>("true").future;
    expect(await maybe.isLeft, true);
    expect(await maybe.isRight, false);
  });

  test('map right', () async {
    final maybe = Right<String, bool>(true).future;
    await maybe.either(
        (left) => expect(false, true), (right) => expect(right, true));

    await maybe
        .mapRight((right) => false)
        .either((left) => expect(false, true), (right) => expect(right, false));

    await maybe.either(
        (left) => expect(false, true), (right) => expect(right, true));
  });

  test('map left', () async {
    final maybe = Left<bool, String>(true).future;
    await maybe.either(
        (left) => expect(left, true), (right) => expect(false, true));

    await maybe
        .mapRight((right) => false)
        .either((left) => expect(left, true), (right) => expect(true, false));
    ;
  });

  test('mapLeft right', () async {
    final maybe = Right<String, bool>(true).future;

    await maybe
        .mapLeft((left) => false)
        .either((left) => expect(false, true), (right) => expect(right, true));
  });

  test('mapLeft left', () async {
    final maybe = Left<bool, String>(true).future;

    await maybe
        .mapLeft((left) => false)
        .either((left) => expect(left, false), (right) => expect(true, false));
  });

  test('fold', () async {
    expect(
        await Left<String, String>("").future.fold<bool>(
              (left) => true,
              (right) => false,
            ),
        true);
    expect(
        await Right<String, String>("").future.fold<bool>(
              (left) => true,
              (right) => false,
            ),
        false);
  });

  test('swap', () async {
    final maybe = Right<String, bool>(true).future.swap();
    expect(await maybe.isRight, false);
    expect(await maybe.isLeft, true);

    final maybe2 = Left<bool, String>(true).future.swap();
    expect(await maybe2.isRight, true);
    expect(await maybe2.isLeft, false);

    final maybe3 = maybe.swap();
    expect(await maybe3.isRight, true);
    expect(await maybe3.isLeft, false);
  });
}
