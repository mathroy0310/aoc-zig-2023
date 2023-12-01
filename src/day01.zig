const util = @import("utils.zig");

const data = @embedFile("data/day01.txt");

const word_digit = [_][]const u8{ "one", "two", "three", "four", "five", "six", "seven", "eight", "nine" };

fn search(is_part2: bool, input: []const u8) ?u8 {
    return util.fmt.charToDigit(input[0], 10) catch blk: {
        if (is_part2 == false) break :blk null;
        if (input.len < word_digit[0].len) break :blk null;

        for (word_digit, 1..) |term, i| {
            if (input.len < term.len) continue;

            if (util.mem.eql(u8, input[0..term.len], term))
                break :blk @intCast(i);
        }
        break :blk null;
    };
}

fn solve(is_part2: bool, read_buff: []const u8) u32 {
    var it = util.mem.split(u8, read_buff, "\n");

    var total_sum: u32 = 0;
    while (it.next()) |line| {
        const first_digit, const last_digit = blk: {
            var first_digit: ?u32 = null;
            var last_digit: ?u32 = null;

            for (0..line.len) |i| {
                const digit = search(is_part2, line[i..]) orelse continue;

                if (first_digit == null) first_digit = digit;
                last_digit = digit;
            }

            break :blk .{ first_digit.?, last_digit.? };
        };
        total_sum += (first_digit * 10) + last_digit;
    }
    return (total_sum);
}

pub fn main() !void {
    util.printday(1);

    util.std.debug.print("[Part 1] result total : {d}\n", .{solve(false, data)});
    util.std.debug.print("[Part 2] result total : {d}\n", .{solve(true, data)});
}
