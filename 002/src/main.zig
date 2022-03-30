const std = @import("std");

pub fn main() anyerror!void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    var allocator = arena.allocator();

    var coefs = std.ArrayList(f64).init(allocator);
    defer coefs.deinit();

    var it = try std.process.argsWithAllocator(allocator);
    _ = it.skip();

    while (it.next()) |arg| try coefs.append(try std.fmt.parseFloat(f64, arg));
    if (coefs.items.len == 0) try coefs.append(0.0);

    var stdout = std.io.getStdOut().writer();

    var i: usize = 0;
    while (i < 5) : (i += 1) {
        const x = @intToFloat(f64, i + 1);
        const p = horner(x, coefs.items);
        try stdout.print("f({d:8.6})={d:<.5}\n", .{ x, p });
    }
}

pub fn horner(x: f64, coefs: []f64) f64 {
    var rslt = coefs[0];
    for (coefs[1..]) |a| rslt = rslt * x + a;
    return rslt;
}
