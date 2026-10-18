import React from 'react';
import { cn } from '../../lib/utils';

export function Skeleton({ className, ...props }) {
  return (
    <div
      className={cn(
        'animate-pulse rounded-[8px] bg-line/50 dark:bg-line/30',
        className
      )}
      {...props}
    />
  );
}
