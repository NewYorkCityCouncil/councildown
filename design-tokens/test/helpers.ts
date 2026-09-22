// jsonlite unboxes length-1 vectors.
export const arr = <T>(x: T | T[]): T[] => (Array.isArray(x) ? x : [x]);

/** Max per-channel difference between two hex colors. */
export function channelDiff(a: string, b: string): number {
  const ch = (h: string, i: number) => parseInt(h.slice(1 + 2 * i, 3 + 2 * i), 16);
  return Math.max(...[0, 1, 2].map((i) => Math.abs(ch(a, i) - ch(b, i))));
}

// R and d3 convert to CIELAB slightly differently; allow a small rounding gap.
export const LAB_TOLERANCE = 2;
