import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:computed_value_notifier/computed_value_notifier.dart';

void main() {
  test('compute at the initialization of computed value', () {
    final counter = ValueNotifier(2);

    final counterDouble = ComputedValueNotifier(
      listenable: counter,
      compute: () => counter.value * 2,
    );

    expect(4, counterDouble.value);

    counterDouble.dispose();
    counter.dispose();
  });

  test('recompute computed value when listenable notifies', () {
    final counter = ValueNotifier(2);

    final counterDouble = ComputedValueNotifier(
      listenable: counter,
      compute: () => counter.value * 2,
    );
    counter.value = 5;

    expect(10, counterDouble.value);

    counterDouble.dispose();
    counter.dispose();
  });

  test('computed value reacting to listenable notifications', () {
    final counter = ValueNotifier(2);

    var temp = 0;

    final counterDouble = ComputedValueNotifier(
      listenable: counter,
      compute: () => counter.value * 2,
    );

    counterDouble.addListener(() => temp = counterDouble.value);

    expect(temp, 0);

    counter.value = 5;

    expect(counterDouble.value, temp);

    counterDouble.dispose();
    counter.dispose();
  });

  test('multi listenable', () {
    final counter1 = ValueNotifier(3);
    final counter2 = ValueNotifier(4);

    final summation = ComputedValueNotifier(
      listenable: Listenable.merge([counter1, counter2]),
      compute: () => counter1.value + counter2.value,
    );

    expect(7, summation.value);
    counter1.value = 4;
    expect(8, summation.value);
    counter2.value = 5;

    expect(9, summation.value);

    summation.dispose();
    counter1.dispose();
    counter2.dispose();
  });

  test('computed value reacting to multi listenable notifications', () {
    final counter1 = ValueNotifier(3);
    final counter2 = ValueNotifier(4);

    var temp = 0;

    final summation = ComputedValueNotifier(
      listenable: Listenable.merge([counter1, counter2]),
      compute: () => counter1.value + counter2.value,
    );

    summation.addListener(() => temp = summation.value);

    expect(temp, 0);

    counter1.value = 4;
    expect(8, temp);

    counter2.value = 5;
    expect(9, temp);

    summation.dispose();
    counter1.dispose();
    counter2.dispose();
  });

  test('only notifiy when computed value changes', () {
    final name = ValueNotifier('car');

    var notificationCounter = 0;

    final nameLength = ComputedValueNotifier(
      listenable: name,
      compute: () => name.value.length,
    );

    nameLength.addListener(() => notificationCounter++);

    expect(0, notificationCounter);

    name.value = 'zoo';

    expect(0, notificationCounter);

    name.value = 'farm';

    expect(1, notificationCounter);

    nameLength.dispose();
    name.dispose();
  });
}
