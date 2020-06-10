# geojson

This shard is meant to provide a simple interface for creating, reading, and
writing geoJSON strings and objects that represent them, based on the
[GeoJSON specification](https://tools.ietf.org/html/rfc7946).

## Installation

1. Add the dependency to your `shard.yml`:
```yaml
dependencies:
  geojson:
    github: respitesage/crgeojson
```
2. Run `shards install`

## Usage

```crystal
require "geojson"
```

Once you've required the library, you can use the `GeoJSON` module to create
a geometry and a feature, like so:

```crystal
point = GeoJSON::Point.new longitude: -91.343, latitude: 0.018

feature = GeoJSON::Feature.new geometry: point, id: "Galapagos"
```

Note that this library (like the GeoJSON specification) uses positions of the
form [longitude, latitude(, optional altitude/elevation)]. This is particularly
important when not using named arguments to specify points and positions.
Additionally, the `id` field above is optional. Refer to the documentation of
`Feature.new` for more information.

Now that we have our feature, we can serialize it to GeoJSON:

```crystal
feature.to_json # => %({"type": "Feature",
                #       "geometry": {"type": "Point", "coordinates": [-91.343, 0.018]},
                #       "id": "Galapagos"})
```

If we instead had that string and wanted to deserialize it into a feature, we
could do so like this:

```crystal
json_string = %({"type": "Feature",
                 "geometry": {"type": "Point", "coordinates": [-91.343, 0.018]},
                 "id": "Galapagos"})

feature = GeoJSON::Feature.from_json json_string
```

This library currently conforms with almost all of the GeoJSON Specification, so
you can also serialize, deserialize, and programmatically manipulate
FeatureCollections, MultiPoints, LineStrings, MultiLineStrings, Polygons,
MultiPolygons, and GeometryCollections.

## Development

Features still to be developed can be found in `TODO.md`. Make sure to add specs
for any new features.

## Contributing

1. Create a fork of this repository
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request from your branch to this repository

## Contributors

- Benjamin Wade - creator and maintainer
