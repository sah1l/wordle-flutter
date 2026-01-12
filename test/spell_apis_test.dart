import 'package:flutter_test/flutter_test.dart';
import 'package:wordle/utils/spell_apis.dart';

void main() {
  group('SpellApis', () {
    test('getDailyWord rotates when days exceed word list', () {
      // Setup mock data
      SpellApis.dailyWords = ['WORD1', 'WORD2', 'WORD3'];
      final startDate = DateTime(2022, 2, 9);
      final api = SpellApis();

      // Day 0 -> Index 0
      expect(api.getDailyWord(date: startDate), 'WORD1');

      // Day 1 -> Index 1
      expect(api.getDailyWord(date: startDate.add(const Duration(days: 1))),
          'WORD2');

      // Day 2 -> Index 2
      expect(api.getDailyWord(date: startDate.add(const Duration(days: 2))),
          'WORD3');

      // Day 3 -> Index 0 (Rotation)
      expect(api.getDailyWord(date: startDate.add(const Duration(days: 3))),
          'WORD1');

      // Day 4 -> Index 1 (Rotation)
      expect(api.getDailyWord(date: startDate.add(const Duration(days: 4))),
          'WORD2');
    });

    test('getDailyWord returns fallback if list empty', () {
      SpellApis.dailyWords = [];
      expect(SpellApis().getDailyWord(), 'HELLO');
    });
  });
}
