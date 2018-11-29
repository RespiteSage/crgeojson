# Project To-Do List

- Implement Features and FeatureCollections
- Add methods to check if the LinearRings of a Polygon properly follow the
  right-hand rule and by default enforce this requirement ONLY on Polygons being
  created from the Crystal side
- Add methods for building geometries incrementally
- Find a better name for LineStringCoordinates
- Add optional "bbox" (bounding box) property to all GeoJSON objects
- Allow extra "foreign" json members and find a way to give easy access to them
- Add testing to make sure that the library properly deserializes unordered
  GeoJSON strings
- Consider whether GeometryCollection should be a Geometry; the GeoJSON
  specification stipulates that a GeometryCollection SHOULD not contain another
  GeometryCollection, not that it MUST not
- Implement antimeridian cutting of existing Geometry objects
- Handle coordinates around the poles
