import 'package:test/test.dart';

import 'package:either_dart/either.dart';

void main() {
  test('right generic is right', () {
    final maybe = Right<String, bool>(true);
    expect(maybe.isRight, true);
    expect(maybe.isLeft, false);
  });

  test('left generic is left', () {
    final maybe = Left<String, bool>("true");
    expect(maybe.isLeft, true);
    expect(maybe.isRight, false);
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
    expect(Either.cond(true, "right", "left").isRight, true);
    expect(Either.cond(false, "right", "left").isLeft, true);
  });
}
