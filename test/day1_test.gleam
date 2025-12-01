import day1

pub fn example_test() {
  let input =
    "L68
L30
R48
L5
R60
L55
L1
L99
R14
L82"

  let assert Ok(output) = day1.solve(input, False)
  assert output == 3
}

pub fn no_ticks_test() {
  let input = "R5"
  let assert Ok(output) = day1.solve(input, False)
  assert output == 0
}

pub fn one_right_test() {
  let input = "R50"
  let assert Ok(output) = day1.solve(input, False)
  assert output == 1
}

pub fn one_left_test() {
  let input = "L50"
  let assert Ok(output) = day1.solve(input, False)
  assert output == 1
}

pub fn two_test() {
  let input =
    "L50
L100"
  let assert Ok(output) = day1.solve(input, False)
  assert output == 2
}

pub fn example_part2_test() {
  let input =
    "L68
L30
R48
L5
R60
L55
L1
L99
R14
L82"

  let assert Ok(output) = day1.solve(input, True)
  assert output == 6
}

pub fn twice_part2_test() {
  let input = "L200"

  let assert Ok(output) = day1.solve(input, True)
  assert output == 2
}

pub fn twice_each_way_part2_test() {
  let input =
    "L200
R200"

  let assert Ok(output) = day1.solve(input, True)
  assert output == 4
}

pub fn edge_to_edge_part2_test() {
  let input =
    "L50
R100"

  let assert Ok(output) = day1.solve(input, True)
  assert output == 2
}

pub fn past_edge_right_part2_test() {
  let input =
    "L50
R1"

  let assert Ok(output) = day1.solve(input, True)
  assert output == 1
}

pub fn past_edge_left_part2_test() {
  let input =
    "R50
L1"

  let assert Ok(output) = day1.solve(input, True)
  assert output == 1
}
