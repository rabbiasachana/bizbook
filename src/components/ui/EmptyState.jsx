import React from 'react';
import { cn } from '../../lib/utils';
import { Button } from './Button';

export function EmptyState({
  icon: Icon,
  title,
  description,
  actionLabel,
  onAction,
  className,
  children,
}) {
  return (
    <div
      className={cn(
        'flex flex-col items-center justify-center text-center p-8 rounded-[8px] border border-dashed border-line bg-surface/50 max-w-md mx-auto my-6',
        className
      )}
    >
      {Icon && (
        <div className="flex h-12 w-12 items-center justify-center rounded-[8px] bg-paper text-accent border border-line mb-4">
          <Icon className="h-6 w-6" />
        </div>
      )}
      {title && (
        <h3 className="font-heading text-lg font-semibold text-ink mb-1">
          {title}
        </h3>
      )}
      {description && (
        <p className="text-sm text-ink-muted mb-5 max-w-xs">{description}</p>
      )}
      {actionLabel && onAction && (
        <Button variant="primary" onClick={onAction}>
          {actionLabel}
        </Button>
      )}
      {children}
    </div>
  );
}

