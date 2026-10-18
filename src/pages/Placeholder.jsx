import React from 'react';
import { EmptyState } from '../components/ui';

export function createPlaceholderPage(title, description, icon) {
  return function PlaceholderPage() {
    return (
      <div className="flex flex-col items-center justify-center min-h-[50vh] p-4">
        <EmptyState
          icon={icon}
          title={title}
          description={description || `This is the ${title} page. Full functionality will be connected in subsequent phases.`}
        />
      </div>
    );
  };
}
