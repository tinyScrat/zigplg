const std = @import("std");
const expect = std.testing.expect;

pub fn main() !void {
    std.debug.print("Hello, {s}!\n", .{"Zig"});
}

test "Always Succeeded" {
    try std.testing.expect(true);
}

test "Assignment" {
    // const/var identifier: type = value;

    const constant: i32 = 5;
    var variable: u32 = 3;

    variable = @as(u32, constant);

    // type can be inferred
    const inferred = 3;
    const inferred2 = @as(i32, 34);

    _ = inferred;
    _ = inferred2;

    // variable must be assigned before using
    // undefined can be coerced to any type
    const gg: i32 = undefined;
    var hh: u32 = undefined;

    _ = gg;
    hh = 3;

    try std.testing.expect(variable == 5);
}

test "Array" {
    // array is denoted by [N]T, where N is the number of element
    // and T is the type of element, array can contains the value
    // of same type

    const a1 = [3]i32{ 1, 2, 3 };

    const a2 = [_]u8{ 'a', 'b', 'c' }; // use _ to replace length if elements is known

    try std.testing.expect(a1.len == a2.len);
}

test "if statement" {
    // using if as statement
    const a = true;
    var b: u16 = 0;
    if (a) {
        b += 1;
    } else {
        b += 2;
    }

    try std.testing.expect(b == 1);
}

test "if expression" {
    // if as expression to return value

    const a = true;
    var c: u32 = 1;
    c += if (a) 1 else 2;

    try std.testing.expect(c == 2);
}

test "while" {
    var a: u8 = 1;
    while (a < 100) {
        a *= 2;
    }

    try std.testing.expect(a == 128);
}

test "while 2" {
    var sum: u8 = 0;
    var i: u8 = 1;
    while (i <= 10) : (i += 1) {
        sum += i;
    }

    try std.testing.expect(sum == 55);
}

test "while 3" {
    var sum: u8 = 0;
    var i: u8 = 1;
    while (i <= 3) : (i += 1) {
        if (i == 2) continue;
        sum += i;
    }

    try std.testing.expect(sum == 4);
}

test "while 4" {
    var sum: u8 = 0;
    var i: u8 = 1;
    while (i <= 3) : (i += 1) {
        if (i == 2) break;
        sum += i;
    }

    try std.testing.expect(sum == 1);
}

test "for" {
    const string = [_]u8{ 'h', 'e', 'l', 'l', 'o' };

    for (string, 0..) |character, index| {
        _ = character;
        _ = index;
    }

    for (string) |character| {
        _ = character;
    }

    for (string, 0..) |_, index| {
        _ = index;
    }

    for (string) |_| {}
}

fn addFive(a: i32) i32 {
    return a + 5;
}

test "function" {
    const y = addFive(0);
    try std.testing.expect(@TypeOf(y) == i32);
    try std.testing.expect(y == 5);
}

fn fibonacci(n: u32) u32 {
    if (n == 0 or n == 1) return n;
    return fibonacci(n - 1) + fibonacci(n - 2);
}

test "test recursion" {
    const n = fibonacci(10);
    try std.testing.expect(n == 55);
}

test "defer" {
    var n: i16 = 5;
    {
        defer n += 1;
        try std.testing.expect(n == 5);
    }

    try std.testing.expect(n == 6);
}

test "defer2" {
    var n: f32 = 5;
    {
        defer n += 1;
        defer n /= 2;
    }

    try std.testing.expect(n == 3.5);
}

const FileOpenError = error{
    AccessDeined,
    OutOfMemory,
    FileNotFound,
};

const AllocationError = error{OutOfMemory};

test "coerce error from subset to superset" {
    const oom: FileOpenError = AllocationError.OutOfMemory;
    try std.testing.expect(oom == FileOpenError.OutOfMemory);
}

test "error union" {
    const maybe_err: AllocationError!u16 = 10;
    const no_err = maybe_err catch 0; // catch provide fallback if the value is error

    try std.testing.expect(@TypeOf(no_err) == u16);
    try std.testing.expect(no_err == 10);
}

fn failingFunction() error{Oops}!void {
    return error.Oops;
}

test "returning an error" {
    failingFunction() catch |err| {
        try std.testing.expect(err == error.Oops);
        return;
    };
}

fn failFn() error{Oops}!i32 {
    try failingFunction(); // try is a shorthand for x catch |err| return err;
    return 12;
}

test "try" {
    const n = failFn() catch |err| {
        try std.testing.expect(err == error.Oops);
        return;
    };

    try std.testing.expect(n == 12); // never reach
}

var problems: u32 = 98;

fn failFnCounter() error{Oops}!void {
    errdefer problems += 1; // run only if the current block return error
    try failingFunction();
}

test "failing counter" {
    failFnCounter() catch |err| {
        try std.testing.expect(err == error.Oops);
        try std.testing.expect(problems == 99);
        return;
    };
}

fn createFile() !void { // error set can be inferred, which is the set of all possible error returned by the function
    return error.AccessDeined;
}

test "omit error set" {
    const err: error{AccessDeined}!void = createFile();

    _ = err catch {}; // ignore error union value
}

// error set can be merged
const A = error{ Failed1, Failed2 };
const B = error{ Failed3, Failed4 };
const C = A || B;

test "switch statement" {
    var x: i8 = 10;
    switch (x) {
        -1...1 => {
            x = -x;
        },
        10, 100 => {
            x = @divExact(x, 10);
        },
        else => {},
    }

    try std.testing.expect(x == 1);
}

test "switch expression" {
    var x: i8 = 10;
    x = switch (x) {
        -1...1 => -x,
        10, 100 => @divExact(x, 10),
        else => x,
    };

    try expect(x == 1);
}
