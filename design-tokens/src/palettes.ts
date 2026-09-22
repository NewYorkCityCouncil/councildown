import { rgbRamp } from './color';
import { chart, palettes, type PaletteName } from './generated/tokens';

/** A named palette, or `"single"` / `"double"` for the first one / two colors of `main`. */
export type PaletteOption = PaletteName | 'single' | 'double';

export interface PaletteOptions {
  reverse?: boolean;
}

/** Colors of a named palette. Same as `pal_nycc()` in councildown. */
export function getPalette(name: PaletteOption = 'main', { reverse = false }: PaletteOptions = {}): string[] {
  let pal: readonly string[];
  if (name === 'single') pal = palettes.main.slice(0, 1);
  else if (name === 'double') pal = palettes.main.slice(0, 2);
  else if (Object.hasOwn(palettes, name)) pal = palettes[name];
  else throw new Error(`Unknown palette "${name}". Options: ${Object.keys(palettes).join(', ')}, single, double`);
  return reverse ? [...pal].reverse() : [...pal];
}

/**
 * `n` colors spread evenly across a palette, interpolating between its colors
 * when needed. Same as the discrete ggplot scales in councildown
 * (`scale_nycc(palette)(n)`), so it will blend colors for some `n`. For
 * distinct category colors use `categoricalColors()`.
 */
export function rampPalette(name: PaletteOption, n: number, options: PaletteOptions = {}): string[] {
  return rgbRamp(getPalette(name, options), n);
}

/**
 * First `n` colors of a categorical palette, for series / category colors.
 * Throws above `chart.maxCategories` (7), matching the councildown limit.
 */
export function categoricalColors(n: number, name: 'main' | 'mixed' = 'main'): string[] {
  if (n > chart.maxCategories) {
    throw new Error(`Can't use more than ${chart.maxCategories} category colors (got ${n}). Group smaller categories into "Other".`);
  }
  return getPalette(name).slice(0, Math.max(0, n));
}
