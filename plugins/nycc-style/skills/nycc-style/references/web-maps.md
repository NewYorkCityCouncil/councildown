# Web maps

Rules come from councildown's `addCouncilStyle()`, `colorBin()`,
`addSourceText()` and `councilPopup()`.

## Defaults

- Start view: `map.view.lat`, `map.view.lng`, zoom `map.view.zoom`; limit zoom to
  `map.view.minZoom`–`map.view.maxZoom`.
- White background (`map.background`). Zoom control top-right.
- Light basemap by default (CartoDB Positron).
- Council district outlines: `map.district.outlineColor`, weight
  `map.district.outlineWeight`, opacity `map.district.outlineOpacity`, no fill.
- District number labels: `map.district.labelColor`, `map.district.labelFont`,
  bold, `map.district.labelSize` px. Highlighted districts use
  `map.district.labelHighlight`.
- Source text bottom right: `map.sourceText.color`, `map.sourceText.size` px.
- Popups: headings in `map.popup.headingFont`, body in `map.popup.bodyFont`.

## Choropleths

```ts
import { colorBin } from '@nycc/design';

const fill = colorBin(features.map((f) => f.properties.rate)); // nycc_blue, ≤ 7 bins, white for NA
// legend: fill.breaks (bin edges) and fill.colors (one per bin)
```

- Default palette `nycc_blue`. Max 7 bins; `colorBin` throws above that.
- Pass explicit breaks when they have meaning: `colorBin(values, { bins: [0, 10, 25, 50, 100] })`.
- Diverging data (change, above/below citywide rate): `colorDiverging(values, { mid: citywide })`.
- Polygon borders on choropleths: weight 0 (councildown's `addPolygons` default).

## react-leaflet

```tsx
import { MapContainer, TileLayer, GeoJSON, ZoomControl } from 'react-leaflet';
import { colorBin, map } from '@nycc/design';

const fill = colorBin(values);

<MapContainer
  center={[map.view.lat, map.view.lng]}
  zoom={map.view.zoom}
  minZoom={map.view.minZoom}
  maxZoom={map.view.maxZoom}
  zoomControl={false}
  style={{ background: map.background }}
>
  <TileLayer url="https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png" attribution="&copy; OpenStreetMap &copy; CARTO" />
  <ZoomControl position="topright" />
  <GeoJSON data={tracts} style={(f) => ({ fillColor: fill(f?.properties.rate), fillOpacity: 1, weight: 0 })} />
  <GeoJSON
    data={districts}
    style={{
      fill: false,
      color: map.district.outlineColor,
      weight: map.district.outlineWeight,
      opacity: map.district.outlineOpacity,
    }}
  />
</MapContainer>
```

## MapLibre GL

Style expressions can't call JS functions. Precompute colors onto features
(`feature.properties.fill = fill(value)`) and use `['get', 'fill']`, or build a
`step` expression from `fill.breaks` and `fill.colors`.
