//! This module provides various shape types.
const vec3_module = @import("vec3.zig");
const Vec3 = vec3_module.Vec3;
const Point = vec3_module.Point;

pub const Ray = struct {
    origin: Point,
    direction: Vec3,
};

pub const Shape = union(enum) {
    sphere: Sphere,
    box: Box,

    pub fn hits(self: Shape, ray: Ray) bool {
        switch (self) {
            inline else => |s| return s.hits(ray),
        }
    }
};

pub const Sphere = struct {
    center: Point,
    radius: f64,

    pub fn hits(self: Sphere, ray: Ray) bool {
        const oc = self.center.subtract(ray.origin);
        const a = ray.direction.dot(ray.direction);
        const b = -2.0 * ray.direction.dot(oc);
        const c = oc.dot(oc) - self.radius * self.radius;
        const discriminant = b * b - 4 * a * c;

        return discriminant >= 0;
    }
};

pub const Box = struct {
    corner_min: Point,
    corner_max: Point,

    pub fn hits(self: Box, ray: Ray) bool {
        const dir_frac = ray.direction.reciprocal()
            .multS(ray.direction.magnitude());

        const t1 = self.corner_min.subtract(ray.origin).multV(dir_frac);
        const t2 = self.corner_max.subtract(ray.origin).multV(dir_frac);

        const t_min = @max(
            @min(t1.x, t2.x),
            @min(t1.y, t2.y),
            @min(t1.z, t2.z),
        );

        const t_max = @min(
            @max(t1.x, t2.x),
            @max(t1.y, t2.y),
            @max(t1.z, t2.z),
        );

        if (t_max < 0) return false;
        if (t_min > t_max) return false;

        return true;
    }
};
