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
 * First `n` colors of a categorical palette, for series / category colors.
 * Throws above `chart.maxCategories` (7).
 */
export function categoricalColors(n: number, name: 'main' | 'mixed' = 'main'): string[] {
  if (n > chart.maxCategories) {
    throw new Error(`Can't use more than ${chart.maxCategories} category colors (got ${n}). Group smaller categories into "Other".`);
  }
  return getPalette(name).slice(0, Math.max(0, n));
}
