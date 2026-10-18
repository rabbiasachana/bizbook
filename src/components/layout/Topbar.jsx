import React, { useState } from 'react';
import { Sun, Moon, Search, Menu } from 'lucide-react';
import { useTheme } from '../../hooks/useTheme';
import { Dialog, Input, Button } from '../ui';

export function Topbar({ onMobileMenuToggle }) {
  const { theme, toggleTheme } = useTheme();
  const [isSearchOpen, setIsSearchOpen] = useState(false);
  const [searchQuery, setSearchQuery] = useState('');

  return (
    <header className="sticky top-0 z-30 flex h-16 w-full items-center justify-between border-b border-line bg-surface/90 px-4 md:px-6 backdrop-blur-sm">
      <div className="flex items-center gap-3">
        {onMobileMenuToggle && (
          <button
            type="button"
            onClick={onMobileMenuToggle}
            className="flex md:hidden h-11 w-11 items-center justify-center rounded-[8px] text-ink hover:bg-paper transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-accent"
            aria-label="Toggle navigation menu"
          >
            <Menu className="h-5 w-5" />
          </button>
        )}
        <div className="flex items-center gap-2">
          <span className="font-heading font-bold text-xl tracking-tight text-ink">
            Tallybook
          </span>
          <span className="hidden sm:inline-block text-[10px] uppercase font-mono tracking-wider px-1.5 py-0.5 rounded bg-accent/20 text-accent font-bold">
            Preview
          </span>
        </div>
      </div>

      <div className="flex items-center gap-2">
        {/* Search trigger button */}
        <button
          type="button"
          onClick={() => setIsSearchOpen(true)}
          className="flex min-h-[44px] items-center gap-2 rounded-[8px] border border-line bg-paper px-3 py-2 text-sm text-ink-muted hover:border-ink/20 hover:text-ink transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-accent"
          aria-label="Search orders and sheets"
        >
          <Search className="h-4 w-4" />
          <span className="hidden sm:inline text-xs">Search...</span>
          <kbd className="hidden sm:inline-block rounded border border-line bg-surface px-1.5 text-[10px] font-mono text-ink-muted">
            ⌘K
          </kbd>
        </button>

        {/* Theme Toggle Button */}
        <button
          type="button"
          data-testid="theme-toggle-btn"
          onClick={toggleTheme}
          aria-label={theme === 'dark' ? 'Switch to light mode' : 'Switch to dark mode'}
          className="flex h-11 w-11 items-center justify-center rounded-[8px] border border-line bg-paper text-ink hover:bg-surface transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-accent"
        >
          {theme === 'dark' ? (
            <Sun className="h-5 w-5 text-accent" data-testid="sun-icon" />
          ) : (
            <Moon className="h-5 w-5 text-ink-muted" data-testid="moon-icon" />
          )}
        </button>
      </div>

      {/* Quick Search Dialog modal */}
      <Dialog
        isOpen={isSearchOpen}
        onClose={() => setIsSearchOpen(false)}
        title="Search Tallybook"
        description="Search across orders, customers, and sheets"
      >
        <div className="space-y-4 pt-2">
          <div className="relative">
            <Input
              autoFocus
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              placeholder="Search by customer name, order #, or note..."
            />
          </div>
          <div className="py-6 text-center text-sm text-ink-muted">
            {searchQuery ? (
              <p>No results found for "{searchQuery}". Connect database in Phase 2.</p>
            ) : (
              <p>Type to search recent orders, customers, or templates.</p>
            )}
          </div>
          <div className="flex justify-end">
            <Button variant="secondary" onClick={() => setIsSearchOpen(false)}>
              Close
            </Button>
          </div>
        </div>
      </Dialog>
    </header>
  );
}
