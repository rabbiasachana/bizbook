import React from 'react';
import { cn } from '../../lib/utils';

export function Chip({
  children,
  variant = 'default',
  rotated = false,
  className,
  ...props
}) {
  // Styled like rubber stamps: uppercase, bold, border, slight rotation optional (off by default)
  const variants = {
    default: 'border-line text-ink bg-surface',
    profit: 'border-profit text-profit bg-profit-subtle',
    owed: 'border-owed text-owed bg-owed-subtle',
    accent: 'border-accent text-accent-hover bg-accent-subtle',
    info: 'border-info text-info bg-info-subtle',
  };

  return (
    <span
      className={cn(
        'inline-flex items-center px-2.5 py-0.5 rounded-[4px] border font-mono text-xs font-bold tracking-wider uppercase select-none transition-transform shadow-stamp',
        variants[variant],
        rotated && '-rotate-1 hover:rotate-0 transition-transform duration-150',
        className
      )}
      {...props}
    >
      {children}
    </span>
  );
}

