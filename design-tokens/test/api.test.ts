import { describe, expect, it } from 'vitest';
import { categoricalColors, colorBin, colorDiverging, colors, getPalette, palettes } from '../src';
import { channelDiff, LAB_TOLERANCE } from './helpers';

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
  it('uses council defaults at the ends and midpoint', () => {
    // Expected values from R: colorDiverging(c(0, 50, 100))(c(0, 50, 100)).
    const scale = colorDiverging([0, 50, 100]);
    expect(channelDiff(scale(0), '#7F0000')).toBeLessThanOrEqual(LAB_TOLERANCE);
    expect(channelDiff(scale(50), '#E5E5E5')).toBeLessThanOrEqual(LAB_TOLERANCE);
    expect(channelDiff(scale(100), '#22407D')).toBeLessThanOrEqual(LAB_TOLERANCE);
  });

  it('returns the NA color for missing and out-of-range values', () => {
    const scale = colorDiverging([0, 50, 100], { naColor: '#000000' });
    expect(scale(null)).toBe('#000000');
    expect(scale(Number.NaN)).toBe('#000000');
    expect(scale(101)).toBe('#000000');
  });

  it('validates low < mid < high', () => {
    expect(() => colorDiverging([1, 2, 3], { mid: 0 })).toThrow(/low can't be/);
  });
});

describe('colorBin', () => {
  it('exposes breaks and colors for legends', () => {
    const scale = colorBin([0, 100], { bins: [0, 25, 50, 75, 100] });
    expect(scale.breaks).toEqual([0, 25, 50, 75, 100]);
    expect(scale.colors).toHaveLength(4);
    expect(scale(0)).toBe(scale.colors[0]);
    expect(scale(25)).toBe(scale.colors[1]);
    expect(scale(100)).toBe(scale.colors[3]);
    expect(scale(null)).toBe(colors.white);
  });

  it('caps at 7 bins', () => {
    expect(() => colorBin([0, 1], { bins: 8 })).toThrow(/more than 7 bins/);
  });
});
