import React, { forwardRef } from 'react';
import { cn } from '../../lib/utils';

export const Button = forwardRef(
  (
    {
      children,
      className,
      variant = 'primary',
      size = 'md',
      disabled = false,
      type = 'button',
      onClick,
      ...props
    },
    ref
  ) => {
    const baseStyles =
      'inline-flex items-center justify-center font-medium transition-colors select-none rounded-[8px] focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-accent focus-visible:ring-offset-2 disabled:opacity-50 disabled:pointer-events-none active:scale-[0.98]';

    const variants = {
      primary:
        'bg-accent text-paper font-semibold hover:bg-accent-hover shadow-subtle',
      secondary:
        'bg-surface text-ink border border-line hover:bg-line/20 shadow-subtle',
      outline:
        'bg-transparent text-ink border border-line hover:bg-surface hover:border-ink/20',
      ghost:
        'bg-transparent text-ink hover:bg-surface/80 hover:text-ink',
      danger:
        'bg-owed text-white hover:bg-owed/90 shadow-subtle',
    };

    const sizes = {
      sm: 'h-[36px] px-3 text-xs min-w-[36px]',
      md: 'min-h-[44px] px-4 py-2 text-sm min-w-[44px]',
      lg: 'min-h-[48px] px-6 py-3 text-base min-w-[48px]',
      icon: 'min-h-[44px] min-w-[44px] p-2',
    };

    return (
      <button
        ref={ref}
        type={type}
        disabled={disabled}
        onClick={onClick}
        className={cn(baseStyles, variants[variant], sizes[size], className)}
        {...props}
      >
        {children}
      </button>
    );
  }
);

Button.displayName = 'Button';
