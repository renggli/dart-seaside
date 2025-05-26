import 'dart:math';

final _generator = Random.secure();
const _keySpace =
    'abcdefghijklmnopqrstuvwxyz'
    'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    '0123456789_-';

String _createKey(int length) => List.generate(
  length,
  (index) => _keySpace[_generator.nextInt(_keySpace.length)],
).join();

// Session

const sessionParam = '_s';

String createSessionKey() => _createKey(24);

// Continuation

const continuationParam = '_k';

String createContinuationKey() => _createKey(16);
