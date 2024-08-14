const std = @import("std");
const zigimg = @import("zigimg");

const shapes = @import("shapes.zig");
const Shape = shapes.Shape;
const Ray = shapes.Ray;

const vec3 = @import("vec3.zig");
const Point = vec3.Point;

const image_width = 1920;
const image_height = 1080;

const plane_width: f64 = 2 * (if (image_width <= image_height) 1 else divFloat(
    image_width,
    image_height,
));
const plane_height: f64 = 2 * (if (image_height <= image_width) 1 else divFloat(
    image_height,
    image_width,
));
const origin: Point = .{ .x = 0, .y = 0, .z = 0 };

const Color = @Vector(1, u8);

const shapes_list: [2]Shape = .{
    .{ .sphere = .{ .center = .{ .x = 0, .y = 1, .z = 0 }, .radius = 0.5 } },
    .{ .box = .{
        .corner_min = .{ .x = -0.9, .y = 0, .z = -0.9 },
        .corner_max = .{ .x = 0, .y = 2, .z = -0.89 },
    } },
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer {
        const status = gpa.deinit();
        if (status == .leak) @panic("Memory leak detected!");
    }
    const allocator = gpa.allocator();

    var pixels = [_]u8{0x00} ** (image_height * image_width);

    for (0..pixels.len) |i| {
        const r: i32 = @intCast(i / image_width);
        const c: i32 = @intCast(i % image_width);
        pixels[i] = getPixel(c, r)[0];
    }

    var image = try zigimg.Image.fromRawPixels(
        allocator,
        image_width,
        image_height,
        &pixels,
        .grayscale8,
    );
    defer image.deinit();

    try image.writeToFilePath("image.png", .{ .png = .{} });
}

fn getPixel(x: i32, y: i32) Color {
    const plane_point: Point = .{
        .x = plane_width * divFloat(x, image_width) - plane_width / 2,
        .y = 1,
        .z = -(plane_height * divFloat(y, image_height) - plane_height / 2),
    };

    const camera_ray: Ray = .{
        .origin = origin,
        .direction = plane_point.subtract(origin),
    };

    for (shapes_list) |shape| {
        if (shape.hits(camera_ray)) return .{0x00};
    }

    return .{0xAA};
}

inline fn divFloat(a: anytype, b: anytype) f64 {
    return @as(f64, @floatFromInt(a)) / b;
}
