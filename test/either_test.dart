import 'package:test/test.dart';

import 'package:either_dart/either.dart';

void main() {
  test('right generic is right', () {
    final maybe = Right<String, bool>(true);
    expect(maybe.isRight, true);
    expect(maybe.isLeft, false);
    expect(() => maybe.left, throwsA(isException));
    expect(maybe.right, true);
  });

  test('left generic is left', () {
    final maybe = Left<String, bool>("true");
    expect(maybe.isLeft, true);
    expect(maybe.isRight, false);
    expect(() => maybe.right, throwsA(isException));
    expect(maybe.left, "true");
  });

  test('map right', () {
    final maybe = Right<String, bool>(true);
    maybe.either((left) => expect(false, true), (right) => expect(right, true));

    maybe
        .map((right) => false)
        .either((left) => expect(false, true), (right) => expect(right, false));

    maybe.either((left) => expect(false, true), (right) => expect(right, true));
  });

  test('map left', () {
    final maybe = Left<bool, String>(true);
    maybe.either((left) => expect(left, true), (right) => expect(false, true));

    maybe
        .map((right) => false)
        .either((left) => expect(left, true), (right) => expect(true, false));
    ;
  });

  test('mapLeft right', () {
    final maybe = Right<String, bool>(true);

    maybe
        .mapLeft((left) => false)
        .either((left) => expect(false, true), (right) => expect(right, true));
  });

  test('mapLeft left', () {
    final maybe = Left<bool, String>(true);

    maybe
        .mapLeft((left) => false)
        .either((left) => expect(left, false), (right) => expect(true, false));
  });

  test('fold', () {
    expect(
        Left<String, String>("").fold<bool>((left) => true, (right) => false),
        true);
    expect(
        Right<String, String>("").fold<bool>((left) => true, (right) => false),
        false);
  });

  test('cond', () {
    expect(Either.cond(true, "left", "right").isRight, true);
    expect(Either.cond(false, "left", "right").isLeft, true);
    expect(
        Either.condLazy(true, () => throw Exception("not lazy"), () => "right")
            .isRight,
        true);
    expect(
        Either.condLazy(false, () => "left", () => throw Exception("not lazy"))
            .isLeft,
        true);
  });

  test('swap', () {
    final maybe = Right<String, bool>(true).swap();
    expect(maybe.isRight, false);
    expect(maybe.isLeft, true);

    final maybe2 = Left<bool, String>(true).swap();
    expect(maybe2.isRight, true);
    expect(maybe2.isLeft, false);

    final maybe3 = maybe.swap();
    expect(maybe3.isRight, true);
    expect(maybe3.isLeft, false);
  });

  test('tryCatch', () {
    expect(
        Either.tryCatch<bool, String, Exception>(
            (err) => true, () => throw Exception("not right")).isLeft,
        true);
    expect(
        Either.tryCatch<bool, String, Exception>((err) => false, () => "right")
            .isRight,
        true);
  });

  group('equal', () {
    test('Left and Left', () {
      final x = Left('test');
      final z = Left('test');
      expect(x, z);
      expect(x.hashCode, z.hashCode);
      expect(x == z, true);
      expect(x != z, false);
      expect(Left('1111'), isNot(equals(Left('2222'))));
      expect(Left('1111'), equals(Left('1111')));
      expect(Left(null), Left(null));
      expect(Left(null).hashCode, Left(null).hashCode);
    });

    test('Right and Left', () {
      final x = Right('test');
      final z = Left('test');
      expect(x != z, true);
      expect(x == z, false);

      expect(Left('1111'), isNot(equals(Right('2222'))));
      expect(Left('1111'), isNot(equals(Right('1111'))));
      expect(Right('1111'), isNot(equals(Left('2222'))));
      expect(Right('1111'), isNot(equals(Left('1111'))));
      expect(Left(null), isNot(equals(Right(null))));
      expect(Right(null), isNot(equals(Left(null))));
    });

    test('Right and Right', () {
      final x = Right('test');
      final z = Right('test');

      expect(x, z);
      expect(x.hashCode, z.hashCode);
      expect(x == z, true);
      expect(x != z, false);
      expect(Right('1111'), isNot(equals(Right('2222'))));
      expect(Right('1111'), equals(Right('1111')));
      expect(Right(null), Right(null));
      expect(Right(null).hashCode, Right(null).hashCode);
    });
  });
  group('pattern matching', () {
    test('base', () {
      final Either either = Left<String, String>("");

      late bool ok;
      switch (either) {
        case Left():
          ok = true;
        case Right():
          ok = false;
      }

      expect(ok, true);

      final Either either2 = Right<String, String>("");

      switch (either2) {
        case Left():
          ok = false;
        case Right():
          ok = true;
      }

      expect(ok, true);
    });

    test('extract left', () {
      final either = Either.cond(false, 'left', 'right');

      switch (either) {
        case Left(value: final value):
          expect(value, 'left');
        case Right(value: final _):
          fail('newer been right');
      }
    });
    
    test('extract right', () {
      final either = Either.cond(true, 'left', 'right');

      switch (either) {
        case Left(value: final _):
          fail('newer been left');
        case Right(value: final value):
          expect(value, 'right');
      }
    });
  });
}
