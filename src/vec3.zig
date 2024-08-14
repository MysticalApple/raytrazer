//! This module provides a Vec3 type with utility functions.
pub const Vec3 = struct {
    x: f64,
    y: f64,
    z: f64,

    pub fn dot(self: Vec3, other: Vec3) f64 {
        return self.x * other.x + self.y * other.y + self.z * other.z;
    }

    pub fn multS(self: Vec3, scalar: f64) Vec3 {
        return Vec3{
            .x = self.x * scalar,
            .y = self.y * scalar,
            .z = self.z * scalar,
        };
    }

    pub fn multV(self: Vec3, other: Vec3) Vec3 {
        return Vec3{
            .x = self.x * other.x,
            .y = self.y * other.y,
            .z = self.z * other.z,
        };
    }

    pub fn add(self: Vec3, other: Vec3) Vec3 {
        return Vec3{
            .x = self.x + other.x,
            .y = self.y + other.y,
            .z = self.z + other.z,
        };
    }

    pub fn subtract(self: Vec3, other: Vec3) Vec3 {
        return self.add(other.multS(-1));
    }

    pub fn magnitude(self: Vec3) f64 {
        return @sqrt(self.dot(self));
    }

    pub fn normalize(self: Vec3) Vec3 {
        return self.multS(1 / self.magnitude());
    }

    pub fn reciprocal(self: Vec3) Vec3 {
        return Vec3{
            .x = 1 / self.x,
            .y = 1 / self.y,
            .z = 1 / self.z,
        };
    }
};

pub const Point = Vec3;
