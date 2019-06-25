# Project To-Do List

## Necessary
- Add methods to check if the LinearRings of a Polygon properly follow the
  right-hand rule and by default enforce this requirement ONLY on Polygons being
  created from the Crystal side
- Add methods for building geometries, features, and feature collections incrementally
- Find a better name for LineStringCoordinates
- Add optional "bbox" (bounding box) property to all GeoJSON objects
- Allow extra "foreign" json members and find a way to give easy access to them
- Add testing to make sure that the library properly deserializes unordered
  GeoJSON strings
- Implement antimeridian cutting of existing Geometry objects
- Handle coordinates around the poles

## Potential
- Allow geometries with empty coordinate arrays
