import gleam/bool
import gleam/float
import gleam/function
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import gleam/string_tree
import gleam/yielder

import atto
import atto/ops
import atto/text
import atto/text_util
import stdin

fn range() {
  use start <- atto.do(text_util.decimal())
  use _ <- atto.do(atto.token("-"))
  use end <- atto.do(text_util.decimal())
  atto.pure(#(start, end))
}

fn ranges() {
  ops.sep(range(), by: atto.token(","))
}

pub fn int_power(base base: Int, power power: Int) {
  list.repeat(base, power) |> int.product
}

/// Only accepts positive numbers
pub fn num_digits(n: Int) {
  // Bad, floating point error makes 1000 have 3 digits
  // let assert Ok(ln10) = float.logarithm(10.0)
  // int.to_float(n)
  // |> float.logarithm
  // |> result.try(float.divide(_, ln10))
  // |> result.map(float.floor)
  // |> result.map(float.add(_, 1.0))
  // |> result.map(float.truncate)
  n |> int.absolute_value |> int.to_string |> string.length
}

pub fn is_silly_part1(n: Int) {
  // use digits <- result.try(num_digits(n))
  let digits = num_digits(n)
  let divisor = int_power(10, digits / 2)
  let base = n / divisor

  Ok(base * divisor + base == n)
}

pub fn is_silly_part2(n: Int) {
  // use digits <- result.try(num_digits(n))
  let digits = num_digits(n)
  use <- bool.guard(digits <= 1, Ok(False))

  Ok(
    list.range(1, digits / 2)
    |> list.filter(fn(split) { digits % split == 0 })
    |> list.any(fn(split_by) {
      let num_splits = digits / split_by
      // e.g. if groups of 2 digits, 1212 % 100 == 12
      let modulus = int_power(10, split_by)

      // e.g. 100, 10000, 1000000
      list.range(0, num_splits - 1)
      |> list.map(int.multiply(_, split_by))
      |> list.map(int_power(10, _))
      // 121212 -> 12, 12, 12
      |> list.map(fn(divisor) { { n / divisor } % modulus })
      // it's silly if all adjacent digit groups are equal
      |> list.window_by_2
      |> list.all(fn(pair) {
        let #(a, b) = pair
        a == b
      })
    }),
  )
}

fn silly_value(n: Int, part2: Bool) {
  let is_silly = case part2 {
    False -> is_silly_part1
    True -> is_silly_part2
  }
  use silly <- result.try(is_silly(n))
  case silly {
    True -> Ok(n)
    False -> Ok(0)
  }
}

fn sum_silly(range: #(Int, Int), part2: Bool) {
  case range {
    #(start, end) if start == end -> silly_value(start, part2)
    #(start, end) -> {
      use current_value <- result.try(silly_value(start, part2))
      use rest_value <- result.try(sum_silly(#(start + 1, end), part2))
      Ok(current_value + rest_value)
    }
  }
}

pub fn solve(input: String, part2: Bool) -> Result(Int, Nil) {
  use parsed <- result.try(
    atto.run(ranges(), text.new(input), Nil)
    |> result.map_error(fn(_) { Nil }),
  )
  use sum <- result.try(
    parsed
    |> list.try_map(sum_silly(_, part2))
    |> result.map(int.sum),
  )
  Ok(sum)
}

pub fn main() -> Nil {
  let input =
    stdin.read_lines()
    |> yielder.to_list
    |> list.map(string_tree.from_string)
    |> string_tree.join("")
    |> string_tree.to_string

  let assert Ok(part1_result) = solve(input, False)
  io.println("Part 1: " <> int.to_string(part1_result))

  let assert Ok(part2_result) = solve(input, True)
  io.println("Part 2: " <> int.to_string(part2_result))

  Nil
}
