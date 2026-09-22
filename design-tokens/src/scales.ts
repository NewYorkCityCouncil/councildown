import { labColors, labRamp } from './color';
import { getPalette, type PaletteOption } from './palettes';
import { colors, map } from './generated/tokens';
import { pretty } from './pretty';

export type Value = number | null | undefined;

/** Maps a value to a hex color; missing or out-of-range values get the NA color. */
export type ColorScale = (value: Value) => string;

const isNumber = (v: Value): v is number => typeof v === 'number' && Number.isFinite(v);

function median(xs: number[]): number {
  const s = [...xs].sort((a, b) => a - b);
  const m = s.length >> 1;
  return s.length % 2 ? s[m]! : (s[m - 1]! + s[m]!) / 2;
}

// R's round() rounds halves to even.
function roundHalfEven(x: number): number {
  const r = Math.round(x);
  return Math.abs(x % 1) === 0.5 && r % 2 !== 0 ? r - 1 : r;
}

export interface DivergingOptions {
  colorLow?: string;
  colorMid?: string;
  colorHigh?: string;
  /** Low end: `"min"` of the data or a number. */
  low?: 'min' | number;
  /** Midpoint: `"median"`, `"mean"` or a number. */
  mid?: 'median' | 'mean' | number;
  /** High end: `"max"` of the data or a number. */
  high?: 'max' | number;
  /** Color for missing / out-of-range values (leaflet default). */
  naColor?: string;
}

/**
 * Diverging scale centered on a midpoint (median by default).
 * Port of `colorDiverging()` in councildown.
 */
export function colorDiverging(domain: readonly Value[], options: DivergingOptions = {}): ColorScale {
  const {
    colorLow = colors.maroon,
    colorMid = colors.lightGrey,
    colorHigh = colors.darkBlue,
    low = 'min',
    mid = 'median',
    high = 'max',
    naColor = '#808080',
  } = options;

  const values = domain.filter(isNumber);
  if (values.length === 0) throw new Error('domain has no numeric values');

  const lowVal = low === 'min' ? Math.min(...values) : low;
  const highVal = high === 'max' ? Math.max(...values) : high;
  const midVal =
    mid === 'median' ? median(values) : mid === 'mean' ? values.reduce((a, b) => a + b, 0) / values.length : mid;

  if (lowVal >= midVal) throw new Error("low can't be greater than or equal to mid");
  if (midVal >= highVal) throw new Error("mid can't be greater than or equal to high");

  // Same 100-color ramp as the R version, split at the midpoint's percentile.
  const midScaled = roundHalfEven(((midVal - lowVal) / (highVal - lowVal)) * 100);
  if (midScaled === 100) throw new Error("need to pick a lower value for mid, it's basically equal to max");
  if (midScaled === 0) throw new Error("need to pick a higher value for mid, it's basically equal to min");

  const ramp = labRamp([
    ...labColors([colorLow, colorMid], midScaled),
    ...labColors([colorMid, colorHigh], 100 - midScaled),
  ]);

  return (v) => {
    if (!isNumber(v) || v < lowVal || v > highVal) return naColor;
    return ramp((v - lowVal) / (highVal - lowVal));
  };
}

export interface BinOptions {
  /** Palette name or explicit colors. Default `"nycc_blue"`. */
  palette?: PaletteOption | readonly string[];
  /** Approximate bin count (breaks chosen like R's `pretty()`), or explicit break points. Default 7. */
  bins?: number | readonly number[];
  /** Color for missing / out-of-range values. Default white. */
  naColor?: string;
}

export interface BinScale extends ColorScale {
  /** Break points; bin i is [breaks[i], breaks[i + 1]), last bin closed. */
  breaks: number[];
  /** One color per bin, for legends. */
  colors: string[];
}

/**
 * Binned color scale for choropleths. Port of `colorBin()` in councildown
 * (a wrapper around `leaflet::colorBin`).
 */
export function colorBin(domain: readonly Value[], options: BinOptions = {}): BinScale {
  const { palette = 'nycc_blue', bins = map.maxBins, naColor = map.naFill } = options;

  if ((typeof bins === 'number' && bins > map.maxBins) || (typeof bins !== 'number' && bins.length > map.maxBins)) {
    throw new Error(`Can't create color mapping with more than ${map.maxBins} bins`);
  }
  if (typeof bins === 'number' && bins < 2) throw new Error(`bin count must be at least 2 (got ${bins})`);

  const breaks = typeof bins === 'number' ? pretty(domain.filter(isNumber), bins) : [...bins].sort((a, b) => a - b);
  if (breaks.length < 2) throw new Error('need at least 2 break points');

  const pal = typeof palette === 'string' ? getPalette(palette as PaletteOption) : [...palette];
  const ramp = labRamp(pal);
  const nBins = breaks.length - 1;
  const binColors = Array.from({ length: nBins }, (_, i) => ramp(nBins === 1 ? 0.5 : i / (nBins - 1)));

  const scale = ((v: Value) => {
    if (!isNumber(v) || v < breaks[0]! || v > breaks[nBins]!) return naColor;
    let i = 0;
    while (i < nBins - 1 && v >= breaks[i + 1]!) i++;
    return binColors[i]!;
  }) as BinScale;
  scale.breaks = breaks;
  scale.colors = binColors;
  return scale;
}
