import React from 'react';
import { describe, it, expect, beforeEach } from 'vitest';
import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { ThemeProvider } from '../src/hooks/useTheme';
import { Topbar } from '../src/components/layout/Topbar';

describe('Theme Toggle & Persistence', () => {
  beforeEach(() => {
    localStorage.clear();
    document.documentElement.className = '';
  });

  it('renders theme toggle button with initial light mode', () => {
    render(
      <ThemeProvider>
        <Topbar />
      </ThemeProvider>
    );

    const toggleBtn = screen.getByTestId('theme-toggle-btn');
    expect(toggleBtn).toBeInTheDocument();
    expect(screen.getByTestId('moon-icon')).toBeInTheDocument();
    expect(document.documentElement.classList.contains('dark')).toBe(false);
  });

  it('toggles to dark mode when clicked and persists in localStorage', async () => {
    const user = userEvent.setup();
    render(
      <ThemeProvider>
        <Topbar />
      </ThemeProvider>
    );

    const toggleBtn = screen.getByTestId('theme-toggle-btn');
    await user.click(toggleBtn);

    expect(document.documentElement.classList.contains('dark')).toBe(true);
    expect(localStorage.getItem('tallybook-theme')).toBe('dark');
    expect(screen.getByTestId('sun-icon')).toBeInTheDocument();

    // Toggle back to light
    await user.click(toggleBtn);
    expect(document.documentElement.classList.contains('dark')).toBe(false);
    expect(localStorage.getItem('tallybook-theme')).toBe('light');
    expect(screen.getByTestId('moon-icon')).toBeInTheDocument();
  });

  it('respects saved dark theme from localStorage on initial load', () => {
    localStorage.setItem('tallybook-theme', 'dark');

    render(
      <ThemeProvider>
        <Topbar />
      </ThemeProvider>
    );

    expect(document.documentElement.classList.contains('dark')).toBe(true);
    expect(screen.getByTestId('sun-icon')).toBeInTheDocument();
  });
});
