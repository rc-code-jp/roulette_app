import 'dart:math';

double generateRandomNumber(double min, double max) {
  Random random = Random();
  return min + random.nextDouble() * (max - min);
}
