const std = @import("std");

pub fn combi(n: u64, r: u64) u64 {
    var i: usize = 1;
    var p: u64 = 1;
    while (i <= r) : (i += 1) p = p * (n - i + 1) / i;
    return p;
}

pub fn main() anyerror!void {
    const stdout = std.io.getStdOut().writer();

    var n: u64 = 0;
    while (n <= 5) : (n += 1) {
        var r: u64 = 0;
        while (r <= n) : (r += 1) {
            try stdout.print("{d}C{d}={d:<2}", .{ n, r, combi(n, r) });
            if (r < n) try stdout.writeByte(' ') else try stdout.writeByte('\n');
        }
    }
}

test "basic test" {
    try std.testing.expectEqual(@as(u64, 1), combi(0, 0));
    try std.testing.expectEqual(combi(5, 0), combi(5, 5));
    try std.testing.expectEqual(combi(9, 0), combi(9, 9));
    try std.testing.expectEqual(combi(9, 3), combi(9, 6));
}
