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
}
