import { lab, rgb, type LabColor, type RGBColor } from 'd3-color';

type Channels = [number, number, number];

function parse(color: string): RGBColor {
  const c = rgb(color);
  if (Number.isNaN(c.r)) throw new Error(`Invalid color: ${color}`);
  return c;
}

// R's rgb(..., maxColorValue = 255) truncates; leaflet/farver rounds.
function toHex([r, g, b]: Channels, toInt: (v: number) => number = Math.round): string {
  const channel = (v: number) => toInt(Math.min(255, Math.max(0, v))).toString(16).padStart(2, '0');
  return `#${channel(r)}${channel(g)}${channel(b)}`.toUpperCase();
}

// Positions 0..1 computed the way R's seq.int(0, 1, length.out = n) does.
function seq01(n: number): number[] {
  if (n === 1) return [0];
  const by = 1 / (n - 1);
  return Array.from({ length: n }, (_, i) => (i === n - 1 ? 1 : i * by));
}

// Piecewise-linear interpolation over evenly spaced stops, like R's approx().
function ramp(stops: Channels[]): (t: number) => Channels {
  const xs = seq01(stops.length);
  return (t) => {
    const v = Math.min(1, Math.max(0, t));
    if (stops.length === 1) return stops[0]!;
    let i = 0;
    while (i < stops.length - 2 && v > xs[i + 1]!) i++;
    if (v === xs[i]) return stops[i]!;
    if (v === xs[i + 1]) return stops[i + 1]!;
    const f = (v - xs[i]!) / (xs[i + 1]! - xs[i]!);
    const a = stops[i]!;
    const b = stops[i + 1]!;
    return [0, 1, 2].map((k) => a[k]! + (b[k]! - a[k]!) * f) as Channels;
  };
}

const rgbChannels = (c: string): Channels => {
  const { r, g, b } = parse(c);
  return [r / 255, g / 255, b / 255];
};
const labChannels = (c: string): Channels => {
  const { l, a, b }: LabColor = lab(parse(c));
  return [l, a, b];
};
const labToRgb = ([l, a, b]: Channels): Channels => {
  const c = lab(l, a, b).rgb();
  return [c.r, c.g, c.b];
};

function checkColors(colors: readonly string[], fn: string): void {
  if (colors.length === 0) throw new Error(`${fn} needs at least one color`);
}

/** `n` colors interpolated linearly in RGB. Same as R's `colorRampPalette(colors)(n)`. */
export function rgbRamp(colors: readonly string[], n: number): string[] {
  checkColors(colors, 'rgbRamp');
  const f = ramp(colors.map(rgbChannels));
  return seq01(Math.max(0, n)).map((t) => toHex(f(t).map((v) => v * 255) as Channels, Math.trunc));
}

/** `n` colors interpolated in CIELAB. Same as R's `colorRampPalette(colors, space = "Lab")(n)`. */
export function labColors(colors: readonly string[], n: number): string[] {
  checkColors(colors, 'labColors');
  const f = ramp(colors.map(labChannels));
  return seq01(Math.max(0, n)).map((t) => toHex(labToRgb(f(t)), Math.trunc));
}

/** Continuous ramp through `colors` in CIELAB, like `scales::colour_ramp` used by leaflet. */
export function labRamp(colors: readonly string[]): (t: number) => string {
  checkColors(colors, 'labRamp');
  const f = ramp(colors.map(labChannels));
  return (t) => toHex(labToRgb(f(t)));
}
