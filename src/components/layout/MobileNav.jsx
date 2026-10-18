import React from 'react';
import { NavLink } from 'react-router-dom';
import { LayoutDashboard, TableProperties, Users, Layers, ShieldCheck } from 'lucide-react';
import { cn } from '../../lib/utils';

export function MobileNav() {
  const tabs = [
    { name: 'Dashboard', path: '/app/dashboard', icon: LayoutDashboard },
    { name: 'Orders', path: '/app/orders/current', icon: TableProperties },
    { name: 'Customers', path: '/app/customers', icon: Users },
    { name: 'Templates', path: '/app/templates', icon: Layers },
    { name: 'Security', path: '/app/security', icon: ShieldCheck },
  ];

  return (
    <nav className="md:hidden fixed bottom-0 left-0 right-0 z-40 flex h-16 border-t border-line bg-surface/95 backdrop-blur-md px-2 py-1 items-center justify-around">
      {tabs.map((tab) => {
        const Icon = tab.icon;
        return (
          <NavLink
            key={tab.path}
            to={tab.path}
            className={({ isActive }) =>
              cn(
                'flex flex-col items-center justify-center min-w-[56px] min-h-[44px] rounded-[8px] px-2 py-1 text-[11px] font-medium transition-colors',
                isActive
                  ? 'text-accent font-semibold'
                  : 'text-ink-muted hover:text-ink'
              )
            }
          >
            <Icon className="h-5 w-5 mb-0.5" />
            <span>{tab.name}</span>
          </NavLink>
        );
      })}
    </nav>
  );
}
