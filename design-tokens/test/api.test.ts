import { describe, expect, it } from 'vitest';
import { categoricalColors, colorBin, colorDiverging, colors, getPalette, map, palettes } from '../src';

describe('getPalette', () => {
  it('returns palettes, single, double and reversed', () => {
    expect(getPalette('warm')).toEqual([...palettes.warm]);
    expect(getPalette('single')).toEqual([palettes.main[0]]);
    expect(getPalette('double')).toEqual(palettes.main.slice(0, 2));
    expect(getPalette('cool', { reverse: true })[0]).toBe(palettes.cool[6]);
  });

  it('rejects unknown names', () => {
    expect(() => getPalette('nope' as never)).toThrow(/Unknown palette/);
  });
});

describe('categoricalColors', () => {
  it('takes the first n colors without blending', () => {
    expect(categoricalColors(5)).toEqual(palettes.main.slice(0, 5));
    expect(categoricalColors(3, 'mixed')).toEqual(palettes.mixed.slice(0, 3));
  });

  it('caps at 7', () => {
    expect(() => categoricalColors(8)).toThrow(/more than 7/);
  });
});

describe('colorDiverging', () => {
  const same = (a: string, b: string) => expect(a.toLowerCase()).toBe(b.toLowerCase());

  it('uses council colors at the ends and the median', () => {
    const scale = colorDiverging([0, 10, 20, 100]); // median 15
    same(scale(0), colors.maroon);
    same(scale(15), colors.lightGrey);
    same(scale(100), colors.darkBlue);
  });

  it('supports mean and fixed low / mid / high', () => {
    same(colorDiverging([0, 30, 90], { mid: 'mean' })(40), colors.lightGrey);
    const scale = colorDiverging([-3, 4], { low: -10, mid: 0, high: 10 });
    same(scale(-10), colors.maroon);
    same(scale(0), colors.lightGrey);
    same(scale(10), colors.darkBlue);
  });

  it('returns the NA color for missing and out-of-range values', () => {
    const scale = colorDiverging([0, 50, 100], { naColor: '#000000' });
    expect(scale(null)).toBe('#000000');
    expect(scale(Number.NaN)).toBe('#000000');
    expect(scale(101)).toBe('#000000');
  });

  it('validates low < mid < high', () => {
    expect(() => colorDiverging([1, 2, 3], { mid: 0 })).toThrow(/low can't be/);
    expect(() => colorDiverging([1, 2, 3], { mid: 5 })).toThrow(/mid can't be/);
  });
});

describe('colorBin', () => {
  it('picks round breaks covering the data, max 7 bins', () => {
    for (const [lo, hi] of [
      [0, 100],
      [3.2, 87.9],
      [0.001, 0.047],
      [-35, 120],
      [1200, 98000],
    ] as const) {
      const { breaks } = colorBin([lo, hi, (lo + hi) / 2]);
      expect(breaks[0]).toBeLessThanOrEqual(lo);
      expect(breaks.at(-1)).toBeGreaterThanOrEqual(hi);
      expect(breaks.length - 1).toBeLessThanOrEqual(map.maxBins);
      expect(breaks.length - 1).toBeGreaterThanOrEqual(2);
    }
  });

  it('uses exact palette colors, light to dark', () => {
    const scale = colorBin([0, 100], { bins: [0, 25, 50, 75, 100] });
    for (const c of scale.colors) expect(palettes.nycc_blue).toContain(c);
    expect(scale.colors[0]).toBe(palettes.nycc_blue[0]);
    expect(scale.colors.at(-1)).toBe(palettes.nycc_blue[6]);

    const seven = colorBin([0, 70], { bins: [0, 10, 20, 30, 40, 50, 60, 70], palette: 'warm' });
    expect(seven.colors).toEqual([...palettes.warm]);
  });

  it('interpolates only when a custom palette has fewer colors than bins', () => {
    const scale = colorBin([0, 100], { bins: [0, 25, 50, 75, 100], palette: ['#ffffff', '#000000'] });
    expect(scale.colors).toHaveLength(4);
    expect(scale.colors[0]).toBe('#ffffff');
    expect(scale.colors[3]).toBe('#000000');
  });

  it('bins values [a, b) with the last bin closed', () => {
    const scale = colorBin([0, 100], { bins: [0, 25, 50, 75, 100] });
    expect(scale.breaks).toEqual([0, 25, 50, 75, 100]);
    expect(scale(0)).toBe(scale.colors[0]);
    expect(scale(24.9)).toBe(scale.colors[0]);
    expect(scale(25)).toBe(scale.colors[1]);
    expect(scale(100)).toBe(scale.colors[3]);
  });

  it('uses white for missing and out-of-range values', () => {
    const scale = colorBin([0, 100]);
    expect(scale(null)).toBe(map.naFill);
    expect(scale(-1)).toBe(map.naFill);
    expect(scale(1000)).toBe(map.naFill);
  });

  it('caps at 7 bins', () => {
    expect(() => colorBin([0, 1], { bins: 8 })).toThrow(/more than 7 bins/);
    expect(() => colorBin([0, 1], { bins: [0, 1, 2, 3, 4, 5, 6, 7, 8] })).toThrow(/more than 7 bins/);
  });
});
