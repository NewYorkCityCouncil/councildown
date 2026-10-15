import { nice, ticks } from 'd3-array';
import { rgb } from 'd3-color';
import { interpolateLab } from 'd3-interpolate';
import { getPalette, type PaletteOption } from './palettes';
import { colors, map } from './generated/tokens';

export type Value = number | null | undefined;

/** Maps a value to a hex color; missing or out-of-range values get the NA color. */
export type ColorScale = (value: Value) => string;

const isNumber = (v: Value): v is number => typeof v === 'number' && Number.isFinite(v);
const hex = (c: string) => rgb(c).formatHex();

function median(xs: number[]): number {
  const s = [...xs].sort((a, b) => a - b);
  const m = s.length >> 1;
  return s.length % 2 ? s[m]! : (s[m - 1]! + s[m]!) / 2;
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
  /** Color for missing / out-of-range values. */
  naColor?: string;
}

/**
 * Diverging scale centered on a midpoint (median by default): maroon -> light
 * grey -> dark blue, like `colorDiverging()` in councildown.
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

  const lowToMid = interpolateLab(colorLow, colorMid);
  const midToHigh = interpolateLab(colorMid, colorHigh);

  return (v) => {
    if (!isNumber(v) || v < lowVal || v > highVal) return naColor;
    return hex(v <= midVal ? lowToMid((v - lowVal) / (midVal - lowVal)) : midToHigh((v - midVal) / (highVal - midVal)));
  };
}

export interface BinOptions {
  /** Palette name or explicit colors. Default `"nycc_blue"`. */
  palette?: PaletteOption | readonly string[];
  /** Target bin count (breaks are rounded to nice numbers), or explicit break points. Default 7. */
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

// Round breaks covering the data, with at most maxBins bins.
function niceBreaks(values: number[], target: number): number[] {
  const lo = Math.min(...values);
  const hi = Math.max(...values);
  if (lo === hi) return [lo, hi];
  for (let count = target; count >= 1; count--) {
    const [a, b] = nice(lo, hi, count);
    const t = ticks(a, b, count);
    if (t.length >= 2 && t.length - 1 <= map.maxBins) return t;
  }
  return [lo, hi];
}

// n colors from a palette: evenly spaced exact steps when it has enough colors,
// otherwise interpolated between them.
function binColors(pal: readonly string[], n: number): string[] {
  if (n === 1) return [pal[Math.floor((pal.length - 1) / 2)]!];
  if (n <= pal.length) return Array.from({ length: n }, (_, i) => pal[Math.round((i * (pal.length - 1)) / (n - 1))]!);
  return Array.from({ length: n }, (_, i) => {
    const pos = (i * (pal.length - 1)) / (n - 1);
    const j = Math.min(Math.floor(pos), pal.length - 2);
    return hex(interpolateLab(pal[j]!, pal[j + 1]!)(pos - j));
  });
}

/**
 * Binned color scale for choropleths: `nycc_blue` by default, at most 7 bins,
 * white for missing values. Like `colorBin()` in councildown.
 */
export function colorBin(domain: readonly Value[], options: BinOptions = {}): BinScale {
  const { palette = 'nycc_blue', bins = map.maxBins, naColor = map.naFill } = options;

  const nBinsAsked = typeof bins === 'number' ? bins : bins.length - 1;
  if (nBinsAsked > map.maxBins) throw new Error(`Can't create color mapping with more than ${map.maxBins} bins`);
  if (nBinsAsked < 1) throw new Error('need at least 1 bin');

  const values = domain.filter(isNumber);
  if (typeof bins === 'number' && values.length === 0) throw new Error('domain has no numeric values');

  const breaks = typeof bins === 'number' ? niceBreaks(values, bins) : [...bins].sort((a, b) => a - b);
  const nBins = breaks.length - 1;
  const pal = typeof palette === 'string' ? getPalette(palette) : [...palette];
  const scaleColors = binColors(pal, nBins);

  const scale = ((v: Value) => {
    if (!isNumber(v) || v < breaks[0]! || v > breaks[nBins]!) return naColor;
    let i = 0;
    while (i < nBins - 1 && v >= breaks[i + 1]!) i++;
    return scaleColors[i]!;
  }) as BinScale;
  scale.breaks = breaks;
  scale.colors = scaleColors;
  return scale;
}
