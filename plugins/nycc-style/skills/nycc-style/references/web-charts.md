# Web charts

Rules come from councildown's `theme_nycc()`; follow them in any chart library.

## Style

- All chart text uses `chart.fontFamily` (Georgia).
- Size hierarchy (ggplot points; px ≈ pt × 4/3): title 16 > subtitle, caption,
  axis title 12 > axis text 11 > legend 9. `chart.fontSize.*`.
- **No gridlines. No axis ticks.** Axis lines only, in `chart.axisLine` (medium grey).
- Plain white background, no panel border. Small multiples get a
  `chart.panelBorder` (dark grey) border and no strip background.
- Legend on the right.
- Always include a title and a source line (caption).
- Missing values: `chart.naFill`.

## Colors

```ts
import { categoricalColors, rampPalette, palettes, chart } from '@nycc/design';

const seriesColors = categoricalColors(series.length); // throws above 7
const oneSeries = categoricalColors(1)[0];
const ordinal = rampPalette('nycc_blue', 5);           // 5 steps light -> dark
```

## Recharts

```tsx
import { BarChart, Bar, XAxis, YAxis, Tooltip, Legend } from 'recharts';
import { categoricalColors, chart } from '@nycc/design';

const colors = categoricalColors(keys.length);
const axisProps = {
  stroke: chart.axisLine,
  tickLine: false,
  tick: { fontFamily: chart.fontFamily, fontSize: chart.fontSize.axisText * (4 / 3) },
};

<BarChart data={data}>
  {/* no <CartesianGrid /> */}
  <XAxis dataKey="borough" {...axisProps} />
  <YAxis {...axisProps} />
  <Tooltip />
  <Legend layout="vertical" align="right" verticalAlign="middle" />
  {keys.map((k, i) => <Bar key={k} dataKey={k} fill={colors[i]} />)}
</BarChart>
```

## D3

```ts
import { scaleOrdinal } from 'd3-scale';
import { categoricalColors } from '@nycc/design';

const color = scaleOrdinal<string>().domain(groups).range(categoricalColors(groups.length));
```

For continuous encodings, use `colorBin` or `colorDiverging` from `@nycc/design`
rather than d3 interpolators, so web output matches R.

## Other libraries (Plotly, Nivo, ECharts, Chart.js, MUI X)

Same rules: pass Council colors explicitly (the library's default color scheme
must never show), set fonts from `fonts`/`chart`, turn off gridlines and ticks.
