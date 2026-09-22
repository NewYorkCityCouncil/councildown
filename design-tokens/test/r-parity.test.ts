// Compares the TypeScript ports with councildown's R output
// (test/fixtures/r-reference.json, regenerate with `npm run fixtures:r`).
import { describe, expect, it } from 'vitest';
import fixtures from './fixtures/r-reference.json';
import { colorBin, colorDiverging, pretty, rampPalette, type DivergingOptions, type PaletteOption } from '../src';
import { arr, channelDiff, LAB_TOLERANCE } from './helpers';


describe('rampPalette matches scale_nycc(palette)(n)', () => {
  for (const { palette, n, colors } of fixtures.ramps) {
    it(`${palette}, n = ${n}`, () => {
      expect(rampPalette(palette as PaletteOption, n)).toEqual(arr(colors));
    });
  }
});

describe('pretty matches R pretty()', () => {
  for (const { range, n, breaks } of fixtures.pretty) {
    it(`[${range}], n = ${n}`, () => {
      const got = pretty(range, n);
      const want = arr(breaks);
      expect(got).toHaveLength(want.length);
      got.forEach((b, i) => expect(b).toBeCloseTo(want[i]!, 9));
    });
  }
});

interface RDivergingArgs {
  color_low?: string;
  color_mid?: string;
  color_high?: string;
  low?: number;
  mid?: string | number;
  high?: number;
}

describe('colorDiverging matches R colorDiverging()', () => {
  for (const { name, domain, args, x, colors } of fixtures.diverging) {
    it(name, () => {
      const a: RDivergingArgs = args;
      const scale = colorDiverging(domain, {
        colorLow: a.color_low,
        colorMid: a.color_mid,
        colorHigh: a.color_high,
        low: a.low,
        mid: a.mid as DivergingOptions['mid'],
        high: a.high,
      });
      x.forEach((v, i) => {
        const want = colors[i]!;
        const got = scale(v);
        expect(channelDiff(got, want), `x = ${v}: got ${got}, R ${want}`).toBeLessThanOrEqual(LAB_TOLERANCE);
      });
    });
  }
});

describe('colorBin matches councildown colorBin()', () => {
  for (const { domain, bins, palette, x, breaks, colors } of fixtures.bin) {
    it(`${palette}, [${domain}], bins = ${JSON.stringify(bins)}`, () => {
      const scale = colorBin(domain, { palette: palette as PaletteOption, bins });
      scale.breaks.forEach((b, i) => expect(b).toBeCloseTo(breaks[i]!, 9));
      x.forEach((v, i) => {
        const want = colors[i]!;
        const got = scale(v);
        expect(channelDiff(got, want), `x = ${v}: got ${got}, R ${want}`).toBeLessThanOrEqual(LAB_TOLERANCE);
      });
    });
  }
});
