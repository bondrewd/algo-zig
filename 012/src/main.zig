const std = @import("std");

pub fn main() anyerror!void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    var allocator = arena.allocator();

    const cpu_count = try std.Thread.getCpuCount();

    var args_arr = try allocator.alloc(CountPointArgs, cpu_count);
    defer allocator.free(args_arr);
    std.mem.set(CountPointArgs, args_arr, .{ .num = 100000000 });

    var threads = try allocator.alloc(std.Thread, cpu_count);
    defer allocator.free(threads);

    for (threads[0..]) |*thread, i| thread.* = try std.Thread.spawn(.{}, countPoints, .{&args_arr[i]});
    for (threads[0..]) |*thread| thread.join();

    var total_acc: u64 = 0;
    var total_num: u64 = 0;
    for (args_arr) |args| {
        total_acc += args.acc;
        total_num += args.num;
    }
    var pi = 4 * @intToFloat(f32, total_acc) / @intToFloat(f32, total_num);
    try std.io.getStdOut().writer().print("π = {d}\n", .{pi});
}

pub const CountPointArgs = struct {
    acc: u64 = 0,
    num: u64 = 0,
};

pub fn countPoints(args: *CountPointArgs) void {
    var prng = std.rand.DefaultPrng.init(blk: {
        var seed: u64 = undefined;
        std.os.getrandom(std.mem.asBytes(&seed)) catch unreachable;
        break :blk seed;
    });
    const rand = prng.random();

    var i: usize = 0;
    while (i < args.num) : (i += 1) {
        const x = rand.float(f32);
        const y = rand.float(f32);
        if (x * x + y * y <= 1) args.acc += 1;
    }
}
