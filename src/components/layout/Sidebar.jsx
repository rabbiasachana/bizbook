import React from 'react';
import { NavLink } from 'react-router-dom';
import {
  LayoutDashboard,
  TableProperties,
  Layers,
  Users,
  LineChart,
  UserCheck,
  History,
  ArrowUpDown,
  ShieldCheck,
  HelpCircle,
  BookOpen,
} from 'lucide-react';
import { cn } from '../../lib/utils';

export const navItems = [
  { name: 'Dashboard', path: '/app/dashboard', icon: LayoutDashboard },
  { name: 'Orders & Sheets', path: '/app/orders/current', icon: TableProperties },
  { name: 'Customer Ledger', path: '/app/customers', icon: Users },
  { name: 'Templates', path: '/app/templates', icon: Layers },
  { name: 'Analytics', path: '/app/analytics', icon: LineChart },
  { name: 'Team & Access', path: '/app/employees', icon: UserCheck },
  { name: 'Activity Log', path: '/app/activity', icon: History },
  { name: 'Import / Export', path: '/app/import-export', icon: ArrowUpDown },
  { name: 'Security', path: '/app/security', icon: ShieldCheck },
  { name: 'How It Works', path: '/how-it-works', icon: BookOpen },
  { name: 'Public Templates', path: '/templates', icon: Layers },
  { name: 'Help & Docs', path: '/app/help', icon: HelpCircle },
];

export function Sidebar({ className }) {
  return (
    <aside
      className={cn(
        'hidden md:flex flex-col w-64 border-r border-line bg-surface shrink-0 h-[calc(100vh-4rem)] sticky top-16',
        className
      )}
    >
      <div className="flex-1 overflow-y-auto p-4 space-y-1">
        <div className="px-3 py-2 text-[11px] font-mono font-semibold uppercase tracking-wider text-ink-muted">
          Main Workspace
        </div>
        {navItems.slice(0, 5).map((item) => (
          <SidebarLink key={item.path} item={item} />
        ))}

        <div className="pt-4 px-3 py-2 text-[11px] font-mono font-semibold uppercase tracking-wider text-ink-muted">
          Operations & Settings
        </div>
        {navItems.slice(5, 9).map((item) => (
          <SidebarLink key={item.path} item={item} />
        ))}

        <div className="pt-4 px-3 py-2 text-[11px] font-mono font-semibold uppercase tracking-wider text-ink-muted">
          Resources
        </div>
        {navItems.slice(9).map((item) => (
          <SidebarLink key={item.path} item={item} />
        ))}
      </div>

      {/* Footer Profile snapshot */}
      <div className="p-4 border-t border-line bg-paper/50">
        <NavLink
          to="/app/profile"
          className="flex items-center gap-3 p-2 rounded-[8px] hover:bg-surface transition-colors"
        >
          <div className="h-9 w-9 rounded-full bg-accent/20 border border-accent/40 flex items-center justify-center font-bold text-accent">
            TB
          </div>
          <div className="overflow-hidden">
            <p className="text-sm font-semibold text-ink truncate">My Business</p>
            <p className="text-xs text-ink-muted truncate">Owner • Edit Profile</p>
          </div>
        </NavLink>
      </div>
    </aside>
  );
}

function SidebarLink({ item }) {
  const Icon = item.icon;
  return (
    <NavLink
      to={item.path}
      className={({ isActive }) =>
        cn(
          'flex items-center gap-3 px-3 py-2.5 rounded-[8px] text-sm font-medium transition-colors min-h-[44px]',
          isActive
            ? 'bg-accent-subtle text-accent-hover font-semibold border border-accent/30'
            : 'text-ink-muted hover:bg-paper hover:text-ink'
        )
      }
    >
      <Icon className="h-4 w-4 shrink-0" />
      <span>{item.name}</span>
    </NavLink>
  );
}
