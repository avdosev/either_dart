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
    maybe.either(
        (left) => expect(false, true), 
        (right) => expect(right, true));
    
    maybe
      .map((right) => false)
      .either(
        (left) => expect(false, true), 
        (right) => expect(right, false));

    maybe.either(
        (left) => expect(false, true), 
        (right) => expect(right, true));
  });

  test('map left', () {
    final maybe = Left<bool, String>(true);
    maybe.either(
        (left) => expect(left, true), 
        (right) => expect(false, true));
    
    maybe
      .map((right) => false)
      .either(
        (left) => expect(left, true), 
        (right) => expect(true, false));;
  });

  test('unite', () {
    expect(Left<String, String>("").unite<bool>((left) => true, (right) => false), true);
    expect(Right<String, String>("").unite<bool>((left) => true, (right) => false), false);
  });

  test('cond', () {
    expect(Either.cond(true,  "left", "right").isRight, true);
    expect(Either.cond(false, "left", "right").isLeft, true);
    expect(Either.condLazy(true,  () => throw Exception("not lazy"), () => "right").isRight, true);
    expect(Either.condLazy(false, () => "left", () => throw Exception("not lazy")).isLeft, true);
  });
}
