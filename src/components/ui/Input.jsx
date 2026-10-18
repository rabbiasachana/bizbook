import React, { forwardRef } from 'react';
import { cn } from '../../lib/utils';

export const Input = forwardRef(
  ({ className, type = 'text', error, ...props }, ref) => {
    return (
      <div className="w-full">
        <input
          type={type}
          ref={ref}
          className={cn(
            'flex w-full min-h-[44px] rounded-[8px] border border-line bg-surface px-3 py-2 text-sm text-ink placeholder:text-ink-faint shadow-subtle transition-colors',
            'focus-visible:outline-none focus-visible:border-accent focus-visible:ring-1 focus-visible:ring-accent',
            'disabled:cursor-not-allowed disabled:opacity-50',
            error && 'border-owed focus-visible:border-owed focus-visible:ring-owed',
            className
          )}
          {...props}
        />
        {error && <p className="mt-1 text-xs text-owed">{error}</p>}
      </div>
    );
  }
);

Input.displayName = 'Input';
