//! https://adventofcode.com/2023/day/7
const std = @import("std");
const util = @import("utils.zig");
const fmt = std.fmt;
const mem = std.mem;

const data = @embedFile("data/input_day07.txt");

const Hand = struct {
    // Contains a number that represents the card's total value.
    // This consists of 23 bits,
    // where the high 3 bits encode the card's type (five of a kind, etc),
    // and the remaining 20 bits are divided into five groups of four bits,
    // each encoding a card's label (2-9, T, J, Q, K, A).
    value: u32,
    bid: usize,

    const Self = @This();

    const Label = enum {
        joker,
        two,
        three,
        four,
        five,
        six,
        seben,
        eight,
        nine,
        ten,
        jack,
        queen,
        king,
        ace,
    };

    const Type = enum {
        highCard,
        onePair,
        twoPair,
        threeOfAKind,
        FullHouse,
        FourOfAKind,
        FiveOfAKind,

        pub fn calculate(input: []const u8, part: u8) @This() {
            var sorted_hand: [5]u8 = undefined;
            std.mem.copyForwards(u8, &sorted_hand, input);
            std.sort.heap(u8, &sorted_hand, {}, std.sort.asc(u8));

            var counts = [_]u8{0} ** 5;
            var prev: ?u8 = null;
            var num_j_cards: u8 = 0;
            var i: u8 = 0;
            for (sorted_hand) |card| {
                if (prev != null and card != prev) i += 1;
                prev = card;
                if (part == 2 and card == 'J') {
                    num_j_cards += 1;
                } else {
                    counts[i] += 1;
                }
            }

            std.sort.heap(u8, &counts, {}, std.sort.asc(u8));
            if (part == 2) counts[4] += num_j_cards;

            if (counts[4] == 5) return .FiveOfAKind;
            if (counts[4] == 4) return .FourOfAKind;
            if (counts[4] == 3 and counts[3] == 2) return .FullHouse;
            if (counts[4] == 3) return .threeOfAKind;
            if (counts[4] == 2 and counts[3] == 2) return .twoPair;
            if (counts[4] == 2) return .onePair;
            return .highCard;
        }
    };

    pub fn new(input: []const u8, bid: usize, part: u8) !Hand {
        if (input.len != 5) return error.InvalidCardCount;
        // Calculate the label values, and pack them together in a single u32, for faster comparison.
        var value: u32 = 0;
        for (input) |card| {
            const label: Label = switch (card) {
                '2'...'9' => @enumFromInt(card - '0' - 1),
                'T' => .ten,
                'J' => if (part == 1) .jack else .joker,
                'Q' => .queen,
                'K' => .king,
                'A' => .ace,
                else => return error.BadCardLabel,
            };
            value = (value << 4) | @intFromEnum(label);
        }

        value = (@as(u32, @intFromEnum(Type.calculate(input, part))) << 20) | value;

        return Self{
            .value = value,
            .bid = bid,
        };
    }

    pub fn lessThan(_: void, self: Self, other: Self) bool {
        return self.value < other.value;
    }
};

fn solve(is_part2: bool, read_buff: []const u8) !usize {
    return (if (is_part2 == true) try part2(read_buff) else try part1(read_buff));
}

pub fn main() !void {
    util.printday(7);

    var timer = try std.time.Timer.start();
    std.debug.print("[Part 1] result total : {d} | Timer : {any}ms \n", .{ try solve(false, data), timer.read() });
    timer.reset();
    std.debug.print("[Part 2] result total : {d} | Timer : {any}ms\n", .{ try solve(true, data), timer.read() });
}

fn part1(input: []const u8) !usize {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer if (gpa.deinit() == .leak) @panic("Leak!");
    const allocator = gpa.allocator();
    var hands = std.ArrayList(Hand).init(allocator);
    defer hands.deinit();

    var lines_it = std.mem.tokenizeScalar(u8, input, '\n');
    while (lines_it.next()) |line| {
        var hand_it = std.mem.tokenizeScalar(u8, line, ' ');
        const hand = hand_it.next() orelse return error.BadHand;
        const bid_str = hand_it.next() orelse return error.BadBid;
        const bid = try std.fmt.parseInt(usize, bid_str, 10);
        try hands.append(try Hand.new(hand, bid, 1));
    }

    std.sort.heap(Hand, hands.items, {}, Hand.lessThan);
    var sum: usize = 0;
    for (hands.items, 1..) |hand, i| sum += hand.bid * i;

    return sum;
}

fn part2(input: []const u8) !usize {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer if (gpa.deinit() == .leak) @panic("Leak!");
    const allocator = gpa.allocator();
    var hands = std.ArrayList(Hand).init(allocator);
    defer hands.deinit();

    var lines_it = std.mem.tokenizeScalar(u8, input, '\n');
    while (lines_it.next()) |line| {
        var hand_it = std.mem.tokenizeScalar(u8, line, ' ');
        const hand = hand_it.next() orelse return error.BadHand;
        const bid_str = hand_it.next() orelse return error.BadBid;
        const bid = try std.fmt.parseInt(usize, bid_str, 10);
        try hands.append(try Hand.new(hand, bid, 2));
    }

    std.sort.heap(Hand, hands.items, {}, Hand.lessThan);
    var sum: usize = 0;
    for (hands.items, 1..) |hand, i| sum += hand.bid * i;

    return sum;
}
