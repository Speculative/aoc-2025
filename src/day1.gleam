import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string_tree
import gleam/yielder

import atto
import atto/ops
import atto/text
import atto/text_util
import stdin

type Rotation {
  Left(Int)
  Right(Int)
}

fn rotation() {
  use dir <- atto.do(ops.choice([atto.token("L"), atto.token("R")]))
  use amount <- atto.do(text_util.decimal())
  case dir {
    "L" -> atto.pure(Left(amount))
    "R" -> atto.pure(Right(amount))
    _ -> atto.pure(Left(-1000))
  }
}

fn rotation_list() {
  ops.sep(rotation(), by: text_util.newline())
}

fn update_dial_part1(
  dial dial: Int,
  rotate_by rotate_by: Int,
  times_at_0 times_at_0: Int,
) -> #(Int, Int) {
  let new_dial = { dial + rotate_by } % 100
  case new_dial {
    0 -> #(new_dial, times_at_0 + 1)
    _ -> #(new_dial, times_at_0)
  }
}

fn update_dial_part2(
  dial dial: Int,
  rotate_by rotate_by: Int,
  times_at_0 times_at_0: Int,
) -> #(Int, Int) {
  // Part 2: Count passing 0 mid-rotation
  let assert Ok(whole_rotations) =
    int.floor_divide(int.absolute_value(rotate_by), 100)
  let times_at_0 = times_at_0 + whole_rotations
  let remaining_rotation = rotate_by % 100

  // Last rotation
  let assert Ok(new_dial) = int.modulo(dial + remaining_rotation, 100)
  case dial, remaining_rotation, new_dial {
    // If there's no remaining rotation
    _, 0, _ -> #(new_dial, times_at_0)
    // If the dial just arrived at 0
    _, _, 0 -> #(new_dial, times_at_0 + 1)
    // If the dial started at 0, it was counted when it got there
    0, _, _ -> #(new_dial, times_at_0)
    // Otherwise, see if we passed 0
    d, r, _ if r > 0 && d + r > 100 -> #(new_dial, times_at_0 + 1)
    d, r, _ if r < 0 && d + r < 0 -> #(new_dial, times_at_0 + 1)
    _, _, _ -> #(new_dial, times_at_0)
  }
}

fn update_dial(
  dial dial: Int,
  rotate_by rotate_by: Int,
  times_at_0 times_at_0: Int,
  part2 part2: Bool,
) -> #(Int, Int) {
  let #(new_dial, new_times_at_0) = case part2 {
    False -> update_dial_part1(dial:, rotate_by:, times_at_0:)
    True -> update_dial_part2(dial:, rotate_by:, times_at_0:)
  }
  #(new_dial, new_times_at_0)
}

fn track_rotations(
  rotations: List(Rotation),
  dial dial: Int,
  times_at_0 times_at_0: Int,
  part2 part2: Bool,
) {
  case rotations {
    [] -> times_at_0
    [Left(amount), ..rest] -> {
      let #(new_dial, new_times_at_0) =
        update_dial(dial:, rotate_by: -amount, times_at_0:, part2:)
      track_rotations(rest, new_dial, new_times_at_0, part2:)
    }
    [Right(amount), ..rest] -> {
      let #(new_dial, new_times_at_0) =
        update_dial(dial:, rotate_by: amount, times_at_0:, part2:)
      track_rotations(rest, new_dial, new_times_at_0, part2:)
    }
  }
}

pub fn solve(
  input: String,
  part2: Bool,
) -> Result(Int, atto.ParseError(a, String)) {
  use parsed <- result.try(atto.run(rotation_list(), text.new(input), Nil))
  Ok(track_rotations(parsed, dial: 50, times_at_0: 0, part2:))
}

pub fn main() -> Nil {
  let input =
    stdin.read_lines()
    |> yielder.to_list
    |> list.map(string_tree.from_string)
    |> string_tree.join("")
    |> string_tree.to_string

  let assert Ok(part1_result) = solve(input, False)
  io.println("Part 1:" <> int.to_string(part1_result))

  let assert Ok(part2_result) = solve(input, True)
  io.println("Part 2:" <> int.to_string(part2_result))

  Nil
}
