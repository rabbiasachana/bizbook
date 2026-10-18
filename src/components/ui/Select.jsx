import React, { forwardRef } from 'react';
import { cn } from '../../lib/utils';
import { ChevronDown } from 'lucide-react';

export const Select = forwardRef(
  ({ className, children, error, ...props }, ref) => {
    return (
      <div className="relative w-full">
        <select
          ref={ref}
          className={cn(
            'flex w-full min-h-[44px] appearance-none rounded-[8px] border border-line bg-surface px-3 py-2 pr-8 text-sm text-ink shadow-subtle transition-colors cursor-pointer',
            'focus-visible:outline-none focus-visible:border-accent focus-visible:ring-1 focus-visible:ring-accent',
            'disabled:cursor-not-allowed disabled:opacity-50',
            error && 'border-owed focus-visible:border-owed focus-visible:ring-owed',
            className
          )}
          {...props}
        >
          {children}
        </select>
        <ChevronDown className="pointer-events-none absolute right-3 top-1/2 h-4 w-4 -translate-y-1/2 text-ink-muted" />
        {error && <p className="mt-1 text-xs text-owed">{error}</p>}
      </div>
    );
  }
);

Select.displayName = 'Select';
