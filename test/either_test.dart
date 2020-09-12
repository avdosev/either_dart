import 'package:flutter_test/flutter_test.dart';

import 'package:either/either.dart';

void main() {
  test('right generic is right', () {
    final maybe = Right<String, bool>(true);
    expect(maybe.isRight, true);
  });
}
