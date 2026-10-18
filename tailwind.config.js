/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  darkMode: 'class',
  theme: {
    extend: {
      colors: {
        paper: 'var(--color-paper)',
        surface: 'var(--color-surface)',
        ink: {
          DEFAULT: 'var(--color-ink)',
          muted: 'var(--color-ink-muted)',
          faint: 'var(--color-ink-faint)',
        },
        accent: {
          DEFAULT: 'var(--color-accent)',
          hover: 'var(--color-accent-hover)',
          subtle: 'var(--color-accent-subtle)',
        },
        profit: {
          DEFAULT: 'var(--color-profit)',
          subtle: 'var(--color-profit-subtle)',
        },
        owed: {
          DEFAULT: 'var(--color-owed)',
          subtle: 'var(--color-owed-subtle)',
        },
        info: {
          DEFAULT: 'var(--color-info)',
          subtle: 'var(--color-info-subtle)',
        },
        line: {
          DEFAULT: 'var(--color-line)',
          subtle: 'var(--color-line-subtle)',
        },
      },
      fontFamily: {
        heading: ['Fraunces', 'serif'],
        sans: ['"Instrument Sans"', 'system-ui', 'sans-serif'],
        mono: ['"Geist Mono"', 'ui-monospace', 'monospace'],
      },
      borderRadius: {
        DEFAULT: '8px',
        md: '8px',
      },
      boxShadow: {
        subtle: '0 1px 2px 0 rgba(0, 0, 0, 0.05)',
        stamp: '0 1px 3px 0 rgba(0, 0, 0, 0.08)',
        dropdown: '0 4px 12px 0 rgba(0, 0, 0, 0.08)',
      },
      minHeight: {
        touch: '44px',
      },
      minWidth: {
        touch: '44px',
      },
    },
  },
  plugins: [],
}

