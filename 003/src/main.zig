const std = @import("std");

pub fn main() anyerror!void {
    const stdout = std.io.getStdOut().writer();
    const N: u32 = 12;

    var n: u32 = 0;
    while (n <= N) : (n += 1) {
        var t: u32 = 0;
        while (t < (N - n) * 3) : (t += 1) try stdout.writeByte(' ');
        var r: u32 = 0;
        while (r <= n) : (r += 1) try stdout.print("{d:^3}   ", .{combi(n, r)});
        try stdout.writeByte('\n');
    }
}

pub fn combi(n: u32, r: u32) u32 {
    var p: u32 = 1;
    var i: u32 = 1;
    while (i <= r) : (i += 1) p = p * (n - i + 1) / i;
    return p;
}
