import day2

pub fn example_test() {
  let input =
    "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124"

  let assert Ok(output) = day2.solve(input, False)
  assert output == 1_227_775_554
}

pub fn simple_example_test() {
  let assert Ok(output) = day2.solve("11-22", False)
  assert output == 33
}

pub fn three_digit_test() {
  let assert Ok(output) = day2.solve("111-999", False)
  assert output == 0
}

pub fn four_digit_test() {
  let assert Ok(output) = day2.solve("1010-1111", False)
  assert output == 1010 + 1111
}

pub fn simple_null_test() {
  let assert Ok(output) = day2.solve("12-21", False)
  assert output == 0
}

pub fn longer_null_test() {
  let assert Ok(output) = day2.solve("12-21,1000-1009", False)
  assert output == 0
}

pub fn silly_test() {
  assert day2.is_silly_part1(1010) == Ok(True)
  assert day2.is_silly_part1(123) == Ok(False)
  assert day2.is_silly_part1(10) == Ok(False)
}

pub fn silly2_test() {
  assert day2.is_silly_part2(1010) == Ok(True)
  assert day2.is_silly_part2(121_212) == Ok(True)
  assert day2.is_silly_part2(123_123) == Ok(True)

  assert day2.is_silly_part2(1011) == Ok(False)
  assert day2.is_silly_part2(121_213) == Ok(False)
  assert day2.is_silly_part2(121_211) == Ok(False)

  assert day2.is_silly_part2(123) == Ok(False)
  assert day2.is_silly_part2(10) == Ok(False)
}

pub fn example_part2_test() {
  let input =
    "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124"

  let assert Ok(output) = day2.solve(input, True)
  assert output == 4_174_379_265
}

pub fn part2_1000_silly_test() {
  assert day2.is_silly_part2(1) == Ok(False)
  assert day2.is_silly_part2(10) == Ok(False)
  assert day2.is_silly_part2(100) == Ok(False)
  assert day2.is_silly_part2(1000) == Ok(False)
  assert day2.is_silly_part2(10_000) == Ok(False)
  assert day2.is_silly_part2(100_000) == Ok(False)
}
